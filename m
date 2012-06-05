Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab2FEQkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:40:37 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34462 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab2FEQkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:40:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, Oleg Nesterov <oleg@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>
References: <20120605082512.GC15171@moon> <87lik1ag71.fsf@xmission.com>
	<20120605162402.GJ15171@moon>
Date: Tue, 05 Jun 2012 09:40:25 -0700
In-Reply-To: <20120605162402.GJ15171@moon> (Cyrill Gorcunov's message of "Tue,
	5 Jun 2012 20:24:02 +0400")
Message-ID: <87haupaf0m.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/Mrq9alTS2xr9XulzlzoTtmISc5vJA8YE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Cyrill Gorcunov <gorcunov@openvz.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] fcntl: Add F_GETOWNER_UIDS option v3
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@openvz.org> writes:

> On Tue, Jun 05, 2012 at 09:14:58AM -0700, Eric W. Biederman wrote:
>> Cyrill Gorcunov <gorcunov@openvz.org> writes:
>> 
>> > When we restore file descriptors we would like
>> > them to look exactly as they were at dumping time.
>> >
>> > With help of fcntl it's almost possible, the missing
>> > snippet is file owners UIDs.
>> >
>> > To be able to read their values the F_GETOWNER_UIDS
>> > is introduced.
>> >
>> > This option is valid iif CONFIG_CHECKPOINT_RESTORE
>> > is turned on, otherwise returning -EINVAL.
>> 
>> You want to use from_kuid_munged instead of from_kuid as you are going
>> directly to userspace, and to userspace for an unmapped uid we want
>> to say 65534 aka nobody instead of -1.
>> 
>> > v3:
>> >  - rebased on Eric's kuids
>> 
>> To be clear this is based on my patchset that has been merged into
>> v3.5-rc1.
>
> Yeah, thanks Eric. Sure I must use _munged version here.
> Updated version below. Thanks!

I don't have any strong opinions about the functionality and
I don't see any bugs so: 

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> ---
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: fcntl: Add F_GETOWNER_UIDS option v4
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
> v4:
>  - rebased to use Eric's kuid_ patchset that has been
>    merged into v3.5-rc1.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: "Eric W. Biederman" <ebiederm@xmission.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: "Serge E. Hallyn" <serge@hallyn.com>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Pavel Emelyanov <xemul@parallels.com>
> ---
>  fs/fcntl.c                  |   29 +++++++++++++++++++++++++++++
>  include/asm-generic/fcntl.h |    4 ++++
>  security/selinux/hooks.c    |    1 +
>  3 files changed, 34 insertions(+)
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
> @@ -340,6 +341,31 @@ static int f_getown_ex(struct file *filp
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
> +	read_lock(&filp->f_owner.lock);
> +	src[0] = from_kuid_munged(user_ns, filp->f_owner.uid);
> +	src[1] = from_kuid_munged(user_ns, filp->f_owner.euid);
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
> @@ -396,6 +422,9 @@ static long do_fcntl(int fd, unsigned in
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
> @@ -3181,6 +3181,7 @@ static int selinux_file_fcntl(struct fil
>  	case F_GETFL:
>  	case F_GETOWN:
>  	case F_GETSIG:
> +	case F_GETOWNER_UIDS:
>  		/* Just check FD__USE permission */
>  		err = file_has_perm(cred, file, 0);
>  		break;
