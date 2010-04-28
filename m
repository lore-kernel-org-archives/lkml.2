Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0D1PmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:42:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186Ab0D1PmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:42:11 -0400
Date: Wed, 28 Apr 2010 17:39:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
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
Message-ID: <20100428153933.GA6610@redhat.com>
References: <20100427164139.GA7359@us.ibm.com> <20100427164517.GC7530@us.ibm.com> <20100428111749.GA27247@redhat.com> <20100428151015.GB4100@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428151015.GB4100@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28, Serge E. Hallyn wrote:
>
> Quoting Oleg Nesterov (oleg@redhat.com):
>
> > > +static ssize_t p9auth_use_write(struct file *file, const char __user *buffer,
> > > +			       size_t count, loff_t *ppos)
> > > +{
> > > +	ssize_t retval = -ENOMEM;
> > > +	char *user_buf;
> > > +
> > > +	if (mutex_lock_interruptible(&cap_mutex))
> > > +		return -EINTR;
> >
> > EINTR doesn't look exactly right here, especially if TIF_SIGPENDING is
> > spurious. Probably ERESTARTNOINTR makes more sense. Or mutex_lock_killable().
>
> Ashwin had had this as ERESTARTSYS I believe.  I'd read something about
> userspace should only see -EINTR so I changed it.

Yes, ERESTARTxxx should not be visible to the user-space. But it is OK
to return it from the syscall if signal_pending() is true, in this case
it will be changed to EINTR or the system call will be restarted.

ERESTARTNOINTR always restarts the syscall, perphaps after handling the
signal if it is really pending.

> > > +	if (copy_from_user(user_buf, buffer, count)) {
> > > +		retval = -EFAULT;
> > > +		goto out;
> > > +	}
> > > +
> > > +	retval = use_setuid_capability(user_buf);
> >
> > It seems that use_setuid_capability() pathes assume that user_buf is
> > null terminated? Say, parse_user_capability() does kstrdup(user_buf).
>
> I kzalloc()d to count+1 before, and only copy_from_user() count bytes,
> so the last byte should always be 0.

Ah, indeed, thanks.

Oleg.

