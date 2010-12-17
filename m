Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0LQKEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 05:04:14 -0500
Received: from www.tglx.de ([62.245.132.106]:52093 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab0LQKEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 05:04:12 -0500
Date: Fri, 17 Dec 2010 11:03:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH V7 4/8] posix clocks: hook dynamic clocks into system
 calls
In-Reply-To: <20101217070450.GB2982@riccoc20.at.omicron.at>
Message-ID: <alpine.LFD.2.00.1012171010160.12146@localhost6.localdomain6>
References: <cover.1292512461.git.richard.cochran@omicron.at> <6241238a1df55033e50b151ec9d35ba957e43d53.1292512461.git.richard.cochran@omicron.at> <alpine.LFD.2.00.1012162156580.12146@localhost6.localdomain6> <20101217070450.GB2982@riccoc20.at.omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010, Richard Cochran wrote:
> On Fri, Dec 17, 2010 at 12:20:44AM +0100, Thomas Gleixner wrote:
> > > +static inline bool clock_is_static(const clockid_t id)
> > > +{
> > > +	if (0 == (id & ~CLOCKFD_MASK))
> > > +		return true;
> > > +	if (CLOCKFD == (id & CLOCKFD_MASK))
> > > +		return false;
> > 
> > Please use the usual kernel notation.
>
> Sorry, what do you mean?

  if (!id & ~CLOCKFD_MASK)
  if ((id & CLOCKFD_MASK) == CLOCKFD)

Not a real problem. I just always stumble over that coding style.

> The code in the patch set is modeled after a USB driver, namely
> drivers/usb/class/usbtmc.c. Alan Cox had brought up the example of a
> PTP Hardware Clock appearing as a USB device. So the device might
> suddenly disappear, and the zombie field is supposed to cover the case
> where the hardware no longer exists, but the file pointer is still
> valid.

Hmm ok, so you use clk->mutex to prevent the underlying device from
going away while you call a function and clk->zombie indicates that
it's gone and clk just kept around for an open file descriptor. Now it
makes sense, but that wants a big fat comment in the code. :)

Doesn't the same problem exist for the file operations of patch 3? I
think you want the very same protection there unless you want to do
the same magic in your USB driver as well.

So you could do the following:

static int get_fd_clk(struct posix_clock_descr *cd, struct file *fp)
{
	cd->fp = fp;
	cd->clk = fp->private_data;
	mutex_lock(&cd->clk->mutex);
	if (!cd->clk->zombie)
		return 0;
	mutex_unlock(&cd->clk->mutex);
	return -ENODEV;
}

static void put_fd_clk(struct posix_clock_descr *cd)
{
	mutex_unlock(&cd->clk->mutex);
}

static int get_posix_clock(const clockid_t id, struct posix_clock_descr *cd)
{
	struct file *fp = fget(CLOCKID_TO_FD(id));
	int ret;

	if (!fp || fp->f_op->open != posix_clock_open || !fp->private_data)
	   	return -ENODEV;
	ret = get_fd_clk(cd, fp);
	if (ret)
		fput(fp);
	return ret;
}

static void put_posix_clock(struct posix_clock_descr *cd)
{
	put_fd_clk(cd);
	fput(cd->fp);
}

So your fops would call get_fd_clk() and put_fd_clk() and the pc_timer
ones get_posix_clock() and put_posix_clock() or whatever sensible
function names you come up with.

Thoughts ?

> I would summarize the discussion like this:
> 
> Alan Cox was strongly in favor of using a regular file descriptor as
> the reference to the dynamic clock.
> 
> John Stultz thought it wouldn't be too bad to cycle though a number of
> static ids, being careful not to every assign the same static id (in
> series) to two different clocks.
> 
> I implemented Alan's idea, since it seemed like maintaining the
> mapping between clocks and static ids would be extra work, but without
> any real benefit.

Yes, he's right. Was too tired to think about the clock ids assingment
when devices are removed and plugged. The fd mapping makes that all go
away.

Thanks,

	tglx
