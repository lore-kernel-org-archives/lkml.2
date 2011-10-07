Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1JGTC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 15:02:28 -0400
Received: from nm26-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.230]:34219 "HELO
	nm26-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753703Ab1JGTC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 15:02:26 -0400
X-Yahoo-Newman-Id: 383444.60533.bm@omp1025.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: m6J8ZWAVM1nTuAsbdfJeQ5VFa_5intDnSiNA5C9R1hy3epk
 dbbETIYBNQqxonFptpRpNFmr3T.tjStuFaX0VVlm..wIW4bfxuZzP8iBL9ui
 yO.Pzd9qrQCAomcu4m3.1lNKLh2N8MbXtuF4JN2aUGiRFNR4g9cn8AYZOQ_E
 qU6.OIp.AbNXvRMN5gt5E8RXBQJp0ZdXrdX.ocMO1nVJeMNOEnMrvSpHG.Fi
 f.1SpY_CRVs.T.hk5zJMWvYu2H_MuDkxH__QU3xa_7NYIsvprTYuNIYzqzPH
 2KMF3aY6Gw3NK9I7yLRCmktmGa5.HTtRi38CAiefAczNq9ZiQ0jFiOoCDK0e
 a4IeTPrEWakCZeoqMm9NAlbDYr62hU4zwXxVnnjkrFcIJQNAXVKuOxWo34yX
 Dhqw3HQcY9cQZMUQckMc_telHmOhd7rB4gN8vDgAG5ROEGwhfkOY0woiqwqz
 NHGYyAAR1h.oW4DHpOuiTJ41EkXgEQH4zeYaHZ4o2btuk5SdFVudVtA4IhrU
 NlxdP1Q--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4E8F4CC0.8020504@schaufler-ca.com>
Date: Fri, 07 Oct 2011 12:02:24 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Smack: domain transition protections (v3)
References: <1317709746-8303-1-git-send-email-jarkko.sakkinen@intel.com>
In-Reply-To: <1317709746-8303-1-git-send-email-jarkko.sakkinen@intel.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/2011 11:29 PM, Jarkko Sakkinen wrote:
> Protections for domain transition:
>
> - BPRM unsafe flags
> - Secureexec
> - Clear unsafe personality bits.
> - Clear parent death signal
>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>

Applied after minor merge conflict to
    git://gitorious.org/smack-next/kernel.git


> ---
>  security/smack/smack_lsm.c |   59 +++++++++++++++++++++++++++++++++++--------
>  1 files changed, 48 insertions(+), 11 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 2e71c3f..f1ef41c 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -5,12 +5,13 @@
>   *
>   *  Authors:
>   *	Casey Schaufler <casey@schaufler-ca.com>
> - *	Jarkko Sakkinen <ext-jarkko.2.sakkinen@nokia.com>
> + *	Jarkko Sakkinen <jarkko.sakkinen@intel.com>
>   *
>   *  Copyright (C) 2007 Casey Schaufler <casey@schaufler-ca.com>
>   *  Copyright (C) 2009 Hewlett-Packard Development Company, L.P.
>   *                Paul Moore <paul@paul-moore.com>
>   *  Copyright (C) 2010 Nokia Corporation
> + *  Copyright (C) 2011 Intel Corporation.
>   *
>   *	This program is free software; you can redistribute it and/or modify
>   *	it under the terms of the GNU General Public License version 2,
> @@ -441,11 +442,17 @@ static int smack_sb_umount(struct vfsmount *mnt, int flags)
>   * BPRM hooks
>   */
>  
> +/**
> + * smack_bprm_set_creds - Smack exec that handles the domain transfer.
> + * @bprm: binprm for exec
> + *
> + * Returns 0 on success.
> + */
>  static int smack_bprm_set_creds(struct linux_binprm *bprm)
>  {
> -	struct task_smack *tsp = bprm->cred->security;
> +	struct inode *inode = bprm->file->f_path.dentry->d_inode;
> +	struct task_smack *bsp = bprm->cred->security;
>  	struct inode_smack *isp;
> -	struct dentry *dp;
>  	int rc;
>  
>  	rc = cap_bprm_set_creds(bprm);
> @@ -455,20 +462,48 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
>  	if (bprm->cred_prepared)
>  		return 0;
>  
> -	if (bprm->file == NULL || bprm->file->f_dentry == NULL)
> +	isp = inode->i_security;
> +	if (isp->smk_task == NULL || isp->smk_task == bsp->smk_task)
>  		return 0;
>  
> -	dp = bprm->file->f_dentry;
> +	if (bprm->unsafe)
> +		return -EPERM;
> +
> +	bsp->smk_task = isp->smk_task;
> +	bprm->per_clear |= PER_CLEAR_ON_SETID;
>  
> -	if (dp->d_inode == NULL)
> -		return 0;
> +	return 0;
> +}
>  
> -	isp = dp->d_inode->i_security;
> +/**
> + * smack_bprm_committing_creds - Prepare to install the new credentials
> + * from bprm.
> + *
> + * @bprm: binprm for exec
> + */
> +static void smack_bprm_committing_creds(struct linux_binprm *bprm)
> +{
> +	struct task_smack *bsp = bprm->cred->security;
>  
> -	if (isp->smk_task != NULL)
> -		tsp->smk_task = isp->smk_task;
> +	if (bsp->smk_task != bsp->smk_forked)
> +		current->pdeath_signal = 0;
> +}
>  
> -	return 0;
> +/**
> + * smack_bprm_secureexec - Return the decision to use secureexec.
> + * @bprm: binprm for exec
> + *
> + * Returns 0 on success.
> + */
> +static int smack_bprm_secureexec(struct linux_binprm *bprm)
> +{
> +	struct task_smack *tsp = current_security();
> +	int ret = cap_bprm_secureexec(bprm);
> +
> +	if (!ret && (tsp->smk_task != tsp->smk_forked))
> +		ret = 1;
> +
> +	return ret;
>  }
>  
>  /*
> @@ -3452,6 +3487,8 @@ struct security_operations smack_ops = {
>  	.sb_umount = 			smack_sb_umount,
>  
>  	.bprm_set_creds =		smack_bprm_set_creds,
> +	.bprm_committing_creds =	smack_bprm_committing_creds,
> +	.bprm_secureexec =		smack_bprm_secureexec,
>  
>  	.inode_alloc_security = 	smack_inode_alloc_security,
>  	.inode_free_security = 		smack_inode_free_security,

