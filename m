Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420Ab1CDKNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 05:13:55 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:52756 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759144Ab1CDKNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 05:13:54 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX18zQ3plvyIzrwKdtWVlV+cKvo3B/wl5ydiVj/Sx+O
	siZ/fpZ2TuXH+M
Date: Fri, 4 Mar 2011 11:13:49 +0100
From: torbenh <torbenh@gmx.de>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, richard.cochran@omicron.at,
        johnstul@us.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH 3/3] Check for write permission on FD based posix-clocks
Message-ID: <20110304101349.GA3237@siel.b>
Mail-Followup-To: Richard Cochran <richardcochran@gmail.com>,
	linux-kernel@vger.kernel.org, richard.cochran@omicron.at,
	johnstul@us.ibm.com, tglx@linutronix.de
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
 <1299173174-348-4-git-send-email-torbenh@gmx.de>
 <20110304072239.GA8957@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304072239.GA8957@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 08:22:39AM +0100, Richard Cochran wrote:
> On Thu, Mar 03, 2011 at 06:26:14PM +0100, Torben Hohn wrote:
> > pc_clock_settime() and pc_clock_adjtime() did not check
> > whether the fd was opened in write mode.
> > 
> > It was possible to set a clock, when we only had read
> > permissions.
> > 
> > for completeness, we would also need to check for Read permissions
> > on the read operations. but that would be a bit paranoid, probably.
> 
> I have no objection to this form of clock access control, but I would
> like to get agreement about it from the list.
> 
> > diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
> > index 04498cb..25028dd 100644
> > --- a/kernel/time/posix-clock.c
> > +++ b/kernel/time/posix-clock.c
> > @@ -287,11 +287,16 @@ static int pc_clock_adjtime(clockid_t id, struct timex *tx)
> >  	if (err)
> >  		return err;
> >  
> > +	if ((cd.fp->f_mode & FMODE_WRITE) == 0) {
> > +		err = -EACCES;
> 
> Looks like clock_settime and adjtimex are supposed to return EPERM in
> this case.

well... this is more similar to calling write(2) on an fd not opened
with FMODE_WRITE... 


ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
		   unsigned long vlen, loff_t *pos)
{
	if (!(file->f_mode & FMODE_WRITE))
		return -EBADF;
	if (!file->f_op || (!file->f_op->aio_write && !file->f_op->write))
		return -EINVAL;

	return do_readv_writev(WRITE, file, vec, vlen, pos);
}

so probably -EBADF is also a candidate :)
however, since the syscall is not really fd based, EPERM is probably
closer to the current man page.


-- 
torben Hohn
