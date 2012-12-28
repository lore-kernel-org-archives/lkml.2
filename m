Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab2L1QOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 11:14:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab2L1QOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 11:14:54 -0500
Date: Fri, 28 Dec 2012 17:14:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Vagin <avagin@openvz.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 2/3] signalfd: add ability to return siginfo in a raw
	format (v2)
Message-ID: <20121228161436.GA30459@redhat.com>
References: <1356690181-1796-1-git-send-email-avagin@openvz.org> <1356690181-1796-3-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356690181-1796-3-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28, Andrey Vagin wrote:
>
> signalfd should be called with the flag SFD_RAW for that.
>
> signalfd_siginfo is not full for siginfo with a negative si_code.
> copy_siginfo_to_user() is copied a full siginfo to user-space, if
> si_code is negative.  signalfd_copyinfo() doesn't do that and can't be
> expanded, because it has not compatible format with siginfo_t.
>
> Another problem is that a constant __SI_* is removed from si_code.
> It's not a problem for usual applications, because they expect
> a defined type of siginfo (internal logic).
> When we want to dump pending signals, we can't predict a type of
> siginfo, so we should get it from kernel.
>
> The main idea of the raw format is that it should be enough for
> restoring exactly the same siginfo for the current process.
>
> This functionality is required for checkpointing pending signals.

And this should be used along with pread().

I won't argue, but perhaps we should simply postulate that pread()
always dumps siginfo in raw format and avoid the new flag?

> @@ -272,20 +311,35 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
>  	signotset(&sigmask);
>  
>  	if (ufd == -1) {
> +		struct file *file;
>  		ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
>  		if (!ctx)
>  			return -ENOMEM;
>  
>  		ctx->sigmask = sigmask;
>  
> +		ufd = get_unused_fd_flags(flags);
> +		if (ufd < 0) {
> +			kfree(ctx);
> +			goto out;
> +		}
> +
>  		/*
>  		 * When we call this, the initialization must be complete, since
>  		 * anon_inode_getfd() will install the fd.
>  		 */
> -		ufd = anon_inode_getfd("[signalfd]", &signalfd_fops, ctx,
> +		file = anon_inode_getfile("[signalfd]", &signalfd_fops, ctx,
>  				       O_RDWR | (flags & (O_CLOEXEC | O_NONBLOCK)));
> -		if (ufd < 0)
> +		if (IS_ERR(file)) {
> +			put_unused_fd(ufd);
> +			ufd = PTR_ERR(file);
>  			kfree(ctx);
> +			goto out;
> +		}
> +
> +		file->f_flags |= flags & SFD_RAW;
> +
> +		fd_install(ufd, file);

And this is needed because we want to set more bits in f_flags/f_mode.

I am wondering if we can change anon_inode_getfd/getfile somehow so
that the user can pass more flags...

Or. Currently fops->open() is never used if this file_operations is used
by anon_inode_get*. So perhaps we can change anon_inode_getfile() to call
fops->open() if it is not zero before return?

OK, this is almost off-topic, please ignore.

Oleg.

