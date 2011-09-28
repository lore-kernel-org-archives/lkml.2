Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1I1PPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:15:14 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.65.39]:43519 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab1I1PPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:15:11 -0400
Subject: Re: [PATCH] Smack: fix domain transfer issues
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
In-Reply-To: <1317206909-24443-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1317206909-24443-1-git-send-email-jarkko.sakkinen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Wed, 28 Sep 2011 11:15:04 -0400
Message-ID: <1317222904.20139.20.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 13:48 +0300, Jarkko Sakkinen wrote:
> When domain changes, Smack should check for ptracing
> and shared state. Additionally, it should clear unsafe
> personality bits and turn on the secureexec bit. This
> patch addresses these issues.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
> ---
>  security/smack/smack.h     |    5 ++++
>  security/smack/smack_lsm.c |   46 ++++++++++++++++++++++++++++++++++---------
>  2 files changed, 41 insertions(+), 10 deletions(-)
> 
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index 174d3be..7b37615 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -187,6 +187,11 @@ struct smack_known {
>  #define SMK_NUM_ACCESS_TYPE 4
>  
>  /*
> + * Passed in the bprm->unsafe field
> + */
> +#define SMK_SECUREEXEC_NEEDED 0x8000

Did I miss something or did you find a rationale for using bprm->unsafe
in this manner?  It isn't private to your security module yet you are
claiming a bit for your own private use without reserving it in any way
globally (consider implications for any future stacking), and setting
new bits in it will have side effects on the capabilities logic.  I
already mentioned this on your first patch and you seemed to acknowledge
it then.  Pass it via bprm->cred->security if you need to pass it as a
flag, or re-test the condition in the secureexec hook otherwise.

> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 2e71c3f..b3766ac 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -455,22 +462,40 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
>  	if (bprm->cred_prepared)
>  		return 0;
>  
> -	if (bprm->file == NULL || bprm->file->f_dentry == NULL)
> -		return 0;
> -
> -	dp = bprm->file->f_dentry;
> +	isp = inode->i_security;
>  
> -	if (dp->d_inode == NULL)
> +	if (isp->smk_task == NULL || isp->smk_task == tsp->smk_task)
>  		return 0;
>  
> -	isp = dp->d_inode->i_security;
> +	if (bprm->unsafe & LSM_UNSAFE_SHARE)
> +		return -EPERM;
>  
> -	if (isp->smk_task != NULL)
> -		tsp->smk_task = isp->smk_task;
> +	if (bprm->unsafe & (LSM_UNSAFE_PTRACE | LSM_UNSAFE_PTRACE_CAP))
> +		return -EPERM;

Why not just:
	if (bprm->unsafe)
		return -EPERM;
if you aren't going to distinguish them via permission checks or
anything?

I take it you've decided you don't need any of the other checks or
sanitization applied by SELinux?

-- 
Stephen Smalley
National Security Agency

