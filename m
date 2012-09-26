Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab2IZXiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 19:38:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56675 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2IZXiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 19:38:51 -0400
Date: Wed, 26 Sep 2012 16:35:56 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>
Subject: Re: [PATCH] pstore: avoid recursive spinlocks in the
 oops_in_progress case
Message-ID: <20120926233553.GA7203@lizard>
References: <1347903824.29767.15.camel@cliu38-desktop-build>
 <20120920225727.GD29721@lizard>
 <3908561D78D1C84285E8C5FCA982C28F19D43812@ORSMSX108.amr.corp.intel.com>
 <20120920232536.GB8209@lizard>
 <3908561D78D1C84285E8C5FCA982C28F19D43892@ORSMSX108.amr.corp.intel.com>
 <20120921003706.GB14399@lizard>
 <3908561D78D1C84285E8C5FCA982C28F19D4404F@ORSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D4404F@ORSMSX108.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 03:02:35PM +0000, Luck, Tony wrote:
> > And my plan was to get rid of the fact that backends touch pstore->buf
> > directly. Backends would always receive anonymous 'buf' pointer (we
> > already have write_buf callback that does exactly this), and thus it
> 
> It feels like we are just shuffling the lock problem from one place
> to another.  In the panic case we have to use a pre-allocated buffer
> (hoping that we can allocate one seems to be a foolish plan).

Yes, we definitely need some buffer pre-allocated for panics, so I have no
plans to get rid of the 'buf' -- both 'buf' and 'buf_lock' are going to
stay. But it will not be multi-purpose anymore (which I see as an
improvement).

The thing is, what I dislike is the whole console_write routine:

static void pstore_console_write(struct console *con, const char *s, unsigned c)
{
	const char *e = s + c;

	while (s < e) {
		unsigned long flags;

		if (c > psinfo->bufsize)
			c = psinfo->bufsize;
		spin_lock_irqsave(&psinfo->buf_lock, flags);
		memcpy(psinfo->buf, s, c);
		psinfo->write(PSTORE_TYPE_CONSOLE, 0, NULL, 0, c, psinfo);
		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
		s += c;
		c = e - s;
	}
}

It's bad not because of the locks, but because we unnecessary copy things
around -- and that's the only reason why we need the lock in the first
place.

With write_buf, the above would turn into just:

static void pstore_console_write(struct console *con, const char *s, unsigned c)
{
	psinfo->write_buf(PSTORE_TYPE_CONSOLE, 0, NULL, 0, s, c, psinfo);
}

Of course, this assumes that write_buf does its own hw/driver-specific
protection, but only if necessary: for ram backend no locks would be
necessary at all.

And as it appears, both erst and efivars drivers do their own locks in the
->write callback anyways. (Btw, efi pstore backend just grabs its lock w/o
trying it first, is it in trouble?)


But for panic case, we will use buf and buf_lock:

pstore_dump()
{
	lock(buf_lock);
	...
	psinfo->write_buf(PSTORE_TYPE_DMESG, ..., psinfo->buf, ...);
	...
	unlock(buf_lock);
}

So, we will use them, but only when necessary (for dumping). We can think
of them as dump_buf and dump_buf_lock, because that's the only when this
stuff will be needed, actually.

Thanks,
Anton.
