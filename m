Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab2IZR73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:59:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46858 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab2IZR70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:59:26 -0400
Date: Wed, 26 Sep 2012 12:59:21 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 11/14] userns: Convert s390 getting uid and gid system
 calls to use kuid and kgid
Message-ID: <20120926175921.GF30620@sergelap>
References: <87k3vote43.fsf@xmission.com>
 <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
 <1348187330-6616-11-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348187330-6616-11-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Convert getresuid, getresgid, getuid, geteuid, getgid, getegid
> 
> Convert struct cred kuids and kgids into userspace uids and gids when
> returning them.
> 
> These s390 system calls slipped through the cracks in my first
> round of converstions :(
> 
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  arch/s390/kernel/compat_linux.c |   36 ++++++++++++++++++++++++------------
>  1 files changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
> index d122508..73995a7 100644
> --- a/arch/s390/kernel/compat_linux.c
> +++ b/arch/s390/kernel/compat_linux.c
> @@ -131,13 +131,19 @@ asmlinkage long sys32_setresuid16(u16 ruid, u16 euid, u16 suid)
>  		low2highuid(suid));
>  }
>  
> -asmlinkage long sys32_getresuid16(u16 __user *ruid, u16 __user *euid, u16 __user *suid)
> +asmlinkage long sys32_getresuid16(u16 __user *ruidp, u16 __user *euidp, u16 __user *suidp)
>  {
> +	const struct cred *cred = current_cred();
>  	int retval;
> +	u16 ruid, euid, suid;
>  
> -	if (!(retval = put_user(high2lowuid(current->cred->uid), ruid)) &&
> -	    !(retval = put_user(high2lowuid(current->cred->euid), euid)))
> -		retval = put_user(high2lowuid(current->cred->suid), suid);
> +	ruid = high2lowuid(from_kuid_munged(cred->user_ns, cred->uid));
> +	euid = high2lowuid(from_kuid_munged(cred->user_ns, cred->euid));
> +	suid = high2lowuid(from_kuid_munged(cred->user_ns, cred->suid));
> +
> +	if (!(retval   = put_user(ruid, ruidp)) &&
> +	    !(retval   = put_user(euid, euidp)))
> +		retval = put_user(suid, suidp);
>  
>  	return retval;
>  }
> @@ -148,13 +154,19 @@ asmlinkage long sys32_setresgid16(u16 rgid, u16 egid, u16 sgid)
>  		low2highgid(sgid));
>  }
>  
> -asmlinkage long sys32_getresgid16(u16 __user *rgid, u16 __user *egid, u16 __user *sgid)
> +asmlinkage long sys32_getresgid16(u16 __user *rgidp, u16 __user *egidp, u16 __user *sgidp)
>  {
> +	const struct cred *cred = current_cred();
>  	int retval;
> +	u16 rgid, egid, sgid;
> +
> +	rgid = high2lowgid(from_kgid_munged(cred->user_ns, cred->gid));
> +	egid = high2lowgid(from_kgid_munged(cred->user_ns, cred->egid));
> +	sgid = high2lowgid(from_kgid_munged(cred->user_ns, cred->sgid));
>  
> -	if (!(retval = put_user(high2lowgid(current->cred->gid), rgid)) &&
> -	    !(retval = put_user(high2lowgid(current->cred->egid), egid)))
> -		retval = put_user(high2lowgid(current->cred->sgid), sgid);
> +	if (!(retval   = put_user(rgid, rgidp)) &&
> +	    !(retval   = put_user(egid, egidp)))
> +		retval = put_user(sgid, sgidp);
>  
>  	return retval;
>  }
> @@ -258,22 +270,22 @@ asmlinkage long sys32_setgroups16(int gidsetsize, u16 __user *grouplist)
>  
>  asmlinkage long sys32_getuid16(void)
>  {
> -	return high2lowuid(current->cred->uid);
> +	return high2lowuid(from_kuid_munged(current_user_ns(), current_uid()));
>  }
>  
>  asmlinkage long sys32_geteuid16(void)
>  {
> -	return high2lowuid(current->cred->euid);
> +	return high2lowuid(from_kuid_munged(current_user_ns(), current_euid()));
>  }
>  
>  asmlinkage long sys32_getgid16(void)
>  {
> -	return high2lowgid(current->cred->gid);
> +	return high2lowgid(from_kgid_munged(current_user_ns(), current_gid()));
>  }
>  
>  asmlinkage long sys32_getegid16(void)
>  {
> -	return high2lowgid(current->cred->egid);
> +	return high2lowgid(from_kgid_munged(current_user_ns(), current_egid()));
>  }
>  
>  /*
> -- 
> 1.7.5.4
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
