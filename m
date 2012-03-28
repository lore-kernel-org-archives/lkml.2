Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab2C1Tmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 15:42:53 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:59213 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216Ab2C1Tmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 15:42:52 -0400
Date: Wed, 28 Mar 2012 19:43:12 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [rfc] fcntl: Add F_GETOWNER_UIDS option
Message-ID: <20120328194312.GA22211@mail.hallyn.com>
References: <20120327152534.GA18478@redhat.com>
 <20120327165853.GH11875@moon>
 <20120327222923.GA31692@mail.hallyn.com>
 <20120327223420.GB9669@moon>
 <20120327224640.GA5328@mail.hallyn.com>
 <m162dpo45j.fsf@fess.ebiederm.org>
 <20120328064838.GA2286@moon>
 <m1k425mae1.fsf@fess.ebiederm.org>
 <20120328075549.GA2204@moon>
 <20120328081639.GB2286@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328081639.GB2286@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Cyrill Gorcunov (gorcunov@openvz.org):
> Something like below i think (yet untested).
> 
> 	Cyrill
> ---
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: fcntl: Add F_GETOWNER_UIDS option v2
> 
> When we restore file descriptors we would like
> them to look exactly as they were at dumping time.
> 
> With help of fcntl it's almost possible, the missing
> snippet is file owners UIDs.
> 
> To be able to read their values the F_GETOWNER_UIDS
> is introduced.
> 
> This option is valid iif CONFIG_CHECKPOINT_RESTORE
> is turned on, otherwise returning -EINVAL.
> 
> Also the call must be done from initial user-namespace
> for a while. This limitation migh be relaxed after, once
> proper [e]uids mapping between namespaces and file owners
> will be implemented.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: "Eric W. Biederman" <ebiederm@xmission.com>
> CC: "Serge E. Hallyn" <serge@hallyn.com>

Sorry to cause trouble, cause as i say it's not particularly important
right now, but note that what you're doing here only ensures that the
person doing the checkpoint is in init_user_ns.  It says nothing about
the credentials in the fown_struct.

If you want to go with this patch, it's fine by me.  If you want to
just add the struct cred to the f_owner and do proper uid conversion,
I'll support that too.  (Just grab a ref to the cred in
fs/fcntl.c:f_modown(), and drop the ref in fs/file_table.c:__fput() ).

Nit: note the indenting in the init_user_ns check below.

> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> ---
>  fs/fcntl.c                  |   32 ++++++++++++++++++++++++++++++++
>  include/asm-generic/fcntl.h |    4 ++++
>  security/selinux/hooks.c    |    1 +
>  3 files changed, 37 insertions(+)
> 
> Index: linux-2.6.git/fs/fcntl.c
> ===================================================================
> --- linux-2.6.git.orig/fs/fcntl.c
> +++ linux-2.6.git/fs/fcntl.c
> @@ -20,6 +20,7 @@
>  #include <linux/signal.h>
>  #include <linux/rcupdate.h>
>  #include <linux/pid_namespace.h>
> +#include <linux/user_namespace.h>
>  
>  #include <asm/poll.h>
>  #include <asm/siginfo.h>
> @@ -340,6 +341,34 @@ static int f_getown_ex(struct file *filp
>  	return ret;
>  }
>  
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +static int f_getowner_uids(struct file *filp, unsigned long arg)
> +{
> +	struct user_namespace *user_ns = current_user_ns();
> +	uid_t * __user dst = (void * __user)arg;
> +	uid_t src[2];
> +	int err;
> +
> +        if (user_ns != &init_user_ns)
> +                return -EINVAL;
> +
> +	read_lock(&filp->f_owner.lock);
> +	src[0] = filp->f_owner.uid;
> +	src[1] = filp->f_owner.euid;
> +	read_unlock(&filp->f_owner.lock);
> +
> +	err  = put_user(src[0], &dst[0]);
> +	err |= put_user(src[1], &dst[1]);
> +
> +	return err;
> +}
> +#else
> +static int f_getowner_uids(struct file *filp, unsigned long arg)
> +{
> +	return -EINVAL;
> +}
> +#endif
> +
>  static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
>  		struct file *filp)
>  {
> @@ -396,6 +425,9 @@ static long do_fcntl(int fd, unsigned in
>  	case F_SETOWN_EX:
>  		err = f_setown_ex(filp, arg);
>  		break;
> +	case F_GETOWNER_UIDS:
> +		err = f_getowner_uids(filp, arg);
> +		break;
>  	case F_GETSIG:
>  		err = filp->f_owner.signum;
>  		break;
> Index: linux-2.6.git/include/asm-generic/fcntl.h
> ===================================================================
> --- linux-2.6.git.orig/include/asm-generic/fcntl.h
> +++ linux-2.6.git/include/asm-generic/fcntl.h
> @@ -120,6 +120,10 @@
>  #define F_GETOWN_EX	16
>  #endif
>  
> +#ifndef F_GETOWNER_UIDS
> +#define F_GETOWNER_UIDS	17
> +#endif
> +
>  #define F_OWNER_TID	0
>  #define F_OWNER_PID	1
>  #define F_OWNER_PGRP	2
> Index: linux-2.6.git/security/selinux/hooks.c
> ===================================================================
> --- linux-2.6.git.orig/security/selinux/hooks.c
> +++ linux-2.6.git/security/selinux/hooks.c
> @@ -3138,6 +3138,7 @@ static int selinux_file_fcntl(struct fil
>  	case F_GETFL:
>  	case F_GETOWN:
>  	case F_GETSIG:
> +	case F_GETOWNER_UIDS:
>  		/* Just check FD__USE permission */
>  		err = file_has_perm(cred, file, 0);
>  		break;
