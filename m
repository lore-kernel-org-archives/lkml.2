Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab1BJQBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 11:01:22 -0500
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:33706 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756567Ab1BJQBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 11:01:20 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: eu7YZfgVM1lFUl2wP6Jcr3ejbnEcqMtlnvsWSB8DNMll_ge
 Kp33ZiKUNqMYGsVwpnoxv66jYdUHPCkh0.XEzqG2XcIOeMdFvr0IM9ChvQyS
 OCXDyAH1AHljIL.Gvb9yp1l_ou8N5UazaF.UjQtv1nYgR.gbuDNToNsRiYwT
 wNAM5vqNs92eB_Ool9L3p7JxVMEDElRlGXYyZRtcANywdpHQ4c.vL.ylc9pZ
 wkZtNCw3djvK_msFxUaXNh1OprCg2To2bMq1q5rbvUPzGBc_8AJnbcy_2cJQ
 VvY9Xo7FZTz0_CUROQz2goyKAYmOMetJmXrIGReXg
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4D540BCE.5020007@schaufler-ca.com>
Date: Thu, 10 Feb 2011 08:01:18 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eric Paris <eparis@redhat.com>, Don Dutile <ddutile@redhat.com>,
        James Morris <jmorris@namei.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 1/2] security: add cred argument to security_capable()
References: <1297318312-14309-1-git-send-email-chrisw@sous-sol.org> <1297318312-14309-2-git-send-email-chrisw@sous-sol.org>
In-Reply-To: <1297318312-14309-2-git-send-email-chrisw@sous-sol.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/9/2011 10:11 PM, Chris Wright wrote:
> Expand security_capable() to include cred, so that it can be usable in a
> wider range of call sites.

I'll bite. What to plan to use this for? I wouldn't see this getting
accepted on its own without a user. I don't see anything wrong with
the change other than that it is not used by anything.


> Cc: James Morris <jmorris@namei.org>
> Cc: Eric Paris <eparis@redhat.com>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
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

