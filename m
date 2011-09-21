Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab1IURPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 13:15:38 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.65.39]:36036 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1IURPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 13:15:36 -0400
Subject: Re: [PATCH] Smack: Use secureexec with SMACK64EXEC
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
In-Reply-To: <1316522254-23193-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1316522254-23193-1-git-send-email-jarkko.sakkinen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Wed, 21 Sep 2011 13:15:30 -0400
Message-ID: <1316625330.25495.66.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 15:37 +0300, Jarkko Sakkinen wrote:
> SMACK64EXEC extended attribute allows switching to
> another security context when executing a file.
> 
> This patch enables secureexec bit in ELF auxiliary
> vector so that code cannot be injected from executers
> security context.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
> ---
>  security/smack/smack.h     |    5 +++++
>  security/smack/smack_lsm.c |   15 ++++++++++++++-
>  2 files changed, 19 insertions(+), 1 deletions(-)
> 
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index 2b6c6a5..e41fb07 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -181,6 +181,11 @@ struct smack_known {
>  #define SMK_NUM_ACCESS_TYPE 4
>  
>  /*
> + * Passed in the bprm->unsafe field
> + */
> +#define SMK_SECUREEXEC_NEEDED 0x8000
> +
> +/*
>   * Smack audit data; is empty if CONFIG_AUDIT not set
>   * to save some stack
>   */
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index b9c5e14..3ea018d 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -465,12 +465,24 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
>  
>  	isp = dp->d_inode->i_security;
>  
> -	if (isp->smk_task != NULL)
> +	if (isp->smk_task != NULL) {
>  		tsp->smk_task = isp->smk_task;
> +		bprm->unsafe = SMK_SECUREEXEC_NEEDED;
> +	}
>  
>  	return 0;
>  }
>  
> +int smack_bprm_secureexec(struct linux_binprm *bprm)
> +{
> +	int ret = cap_bprm_secureexec(bprm);
> +
> +	if (!ret && (bprm->unsafe & SMK_SECUREEXEC_NEEDED))
> +		ret = 1;
> +
> +	return ret;
> +}
> +
>  /*
>   * Inode hooks
>   */

bprm->unsafe isn't private to your security module, unlike e.g.
bprm->cred->security.  And it isn't intended to indicate that a
secureexec is being performed, but instead as an indicator that a
credential-changing exec may be unsafe.  Which you presently ignore.
Defining and setting a new flag in it will have interesting side
effects, e.g. consider cap_bprm_secureexec, not to mention being a
layering violation and a source of future conflicts.

Why can't your bprm_secureexec hook just test isp->smk_task directly?
It can reach it from the bprm.  Or if you don't like testing it twice,
then you could always add a flag to your struct referenced by
bprm->cred->security, i.e. the smack_task struct.

BTW, there is a lot more to do if you want SMACK64EXEC to be safe.

-- 
Stephen Smalley
National Security Agency

