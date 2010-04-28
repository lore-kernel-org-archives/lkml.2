Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0D1PKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:10:55 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37274 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259Ab0D1PKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:10:52 -0400
Date: Wed, 28 Apr 2010 10:10:15 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ashwin Ganti <ashwin.ganti@gmail.com>,
       David Howells <dhowells@redhat.com>, Greg KH <greg@kroah.com>,
       rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com,
       Andrew Morgan <morgan@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kyle Moffett <kyle@moffetthome.net>, Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 3/3] RFC: p9auth: add p9auth fs
Message-ID: <20100428151015.GB4100@us.ibm.com>
References: <20100427164139.GA7359@us.ibm.com>
 <20100427164517.GC7530@us.ibm.com>
 <20100428111749.GA27247@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428111749.GA27247@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 04/27, Serge E. Hallyn wrote:
> >
> > This introduces a Plan 9 style setuid capability filesystem.
> > See Documentation/p9auth.txt for a description of how to use this.
> 
> Can't comment these changes due to the lack of knowledge, just
> a couple of minor nits.

Thanks, Oleg.

> > +static ssize_t p9auth_use_write(struct file *file, const char __user *buffer,
> > +			       size_t count, loff_t *ppos)
> > +{
> > +	ssize_t retval = -ENOMEM;
> > +	char *user_buf;
> > +
> > +	if (mutex_lock_interruptible(&cap_mutex))
> > +		return -EINTR;
> 
> EINTR doesn't look exactly right here, especially if TIF_SIGPENDING is
> spurious. Probably ERESTARTNOINTR makes more sense. Or mutex_lock_killable().

Ashwin had had this as ERESTARTSYS I believe.  I'd read something about
userspace should only see -EINTR so I changed it.  Sounds like I need
to follow the caller chain some more and learn a thing or two, before
I repost.

> > +	user_buf = kzalloc(count+1, GFP_KERNEL);
> 
> Probably this is OK, but it looks a bit strange we do no check that
> count is not too large.

Yes, I should check that, thanks!

> > +	if (copy_from_user(user_buf, buffer, count)) {
> > +		retval = -EFAULT;
> > +		goto out;
> > +	}
> > +
> > +	retval = use_setuid_capability(user_buf);
> 
> It seems that use_setuid_capability() pathes assume that user_buf is
> null terminated? Say, parse_user_capability() does kstrdup(user_buf).

I kzalloc()d to count+1 before, and only copy_from_user() count bytes,
so the last byte should always be 0.

Thanks again,

-serge
