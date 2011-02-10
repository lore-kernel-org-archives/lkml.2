Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab1BJNn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 08:43:29 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59528 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab1BJNn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 08:43:26 -0500
Date: Thu, 10 Feb 2011 07:43:13 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eric Paris <eparis@redhat.com>, Don Dutile <ddutile@redhat.com>,
        James Morris <jmorris@namei.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/2] security: add cred argument to security_capable()
Message-ID: <20110210134313.GA3513@localhost>
References: <1297318312-14309-1-git-send-email-chrisw@sous-sol.org>
 <1297318312-14309-2-git-send-email-chrisw@sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297318312-14309-2-git-send-email-chrisw@sous-sol.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chris Wright (chrisw@sous-sol.org):
> Expand security_capable() to include cred, so that it can be usable in a
> wider range of call sites.
> 
> Cc: James Morris <jmorris@namei.org>
> Cc: Eric Paris <eparis@redhat.com>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

Thanks for cc:ing me, Chris.

Please do cc: me on any patches which exploit this.  Sending
current_cred() is fine, but of course sending another cred
can be trickier.  Additionally, it'll affect my userns patchset,
so I'd just like to keep abreast of what's happening.

thanks,
-serge

> Cc: linux-security-module@vger.kernel.org
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
> 
>  include/linux/security.h |    6 +++---
>  kernel/capability.c      |    2 +-
>  security/security.c      |    5 ++---
>  3 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index c642bb8..b2b7f97 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1662,7 +1662,7 @@ int security_capset(struct cred *new, const struct cred *old,
>  		    const kernel_cap_t *effective,
>  		    const kernel_cap_t *inheritable,
>  		    const kernel_cap_t *permitted);
> -int security_capable(int cap);
> +int security_capable(const struct cred *cred, int cap);
>  int security_real_capable(struct task_struct *tsk, int cap);
>  int security_real_capable_noaudit(struct task_struct *tsk, int cap);
>  int security_sysctl(struct ctl_table *table, int op);
> @@ -1856,9 +1856,9 @@ static inline int security_capset(struct cred *new,
>  	return cap_capset(new, old, effective, inheritable, permitted);
>  }
>  
> -static inline int security_capable(int cap)
> +static inline int security_capable(const struct cred *cred, int cap)
>  {
> -	return cap_capable(current, current_cred(), cap, SECURITY_CAP_AUDIT);
> +	return cap_capable(current, cred, cap, SECURITY_CAP_AUDIT);
>  }
>  
>  static inline int security_real_capable(struct task_struct *tsk, int cap)
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 2f05303..9e9385f 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -306,7 +306,7 @@ int capable(int cap)
>  		BUG();
>  	}
>  
> -	if (security_capable(cap) == 0) {
> +	if (security_capable(current_cred(), cap) == 0) {
>  		current->flags |= PF_SUPERPRIV;
>  		return 1;
>  	}
> diff --git a/security/security.c b/security/security.c
> index 739e403..7b7308a 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -154,10 +154,9 @@ int security_capset(struct cred *new, const struct cred *old,
>  				    effective, inheritable, permitted);
>  }
>  
> -int security_capable(int cap)
> +int security_capable(const struct cred *cred, int cap)
>  {
> -	return security_ops->capable(current, current_cred(), cap,
> -				     SECURITY_CAP_AUDIT);
> +	return security_ops->capable(current, cred, cap, SECURITY_CAP_AUDIT);
>  }
>  
>  int security_real_capable(struct task_struct *tsk, int cap)
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
