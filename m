Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab2CYI0Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 04:26:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:14929 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab2CYI0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 04:26:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="81331412"
Message-ID: <4F6ED6A3.7040603@intel.com>
Date: Sun, 25 Mar 2012 11:26:11 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120313 Thunderbird/11.0
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] Smack: recursive transmute
References: <4F6CA73F.1040703@schaufler-ca.com>
In-Reply-To: <4F6CA73F.1040703@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Casey,

Works for me. I've been testing this now for a while and
it seems to work alright so far.

On 03/23/2012 06:39 PM, Casey Schaufler wrote:
> Applied to git://gitorious.org/smack-next/kernel.git
>
> The transmuting directory feature of Smack requires that
> the transmuting attribute be explicitly set in all cases.
> It seems the users of this facility would expect that the
> transmuting attribute be inherited by subdirectories that
> are created in a transmuting directory. This does not seem
> to add any additional complexity to the understanding of
> how the system works.
>
> Signed-off-by: Casey Schaufler<casey@schaufler-ca.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>

>
> ---
>
>   security/smack/smack.h     |    1+
>   security/smack/smack_lsm.c |   44+++++++++++++++++++++++++++++++++++---------
>   2 files changed, 36 insertions(+), 9 deletions(-)
>
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index 2ad0065..49e6ee2 100644
> --- a/security/smack/smack.h
> +++  b/security/smack/smack.h
> @@ -66,6+66,7 @@ struct task_smack {
>
>   #define	SMK_INODE_INSTANT	0x01	/* inode is instantiated */
>   #define	SMK_INODE_TRANSMUTE	0x02	/* directory is transmuting */
> +#define	SMK_INODE_CHANGED	0x04	/* smack was transmuted */
>
>   /*
>    * A label access rule.
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index cd667b4..d2172d7 100644
> --- a/security/smack/smack_lsm.c
> +++  b/security/smack/smack_lsm.c
> @@ -556,6+556,7 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
>   				     void **value, size_t *len)
>   {
>   	struct smack_known *skp;
> +	struct inode_smack *issp = inode->i_security;
>   	char *csp = smk_of_current();
>   	char *isp = smk_of_inode(inode);
>   	char *dsp = smk_of_inode(dir);
> @@ -577,10+578,13 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
>   		 * If the access rule allows transmutation and
>   		 * the directory requests transmutation then
>   		 * by all means transmute.
> +		* Mark the inode as changed.
>   		 */
>   		if (may>  0&&  ((may&  MAY_TRANSMUTE) != 0)&&
> -		    smk_inode_transmutable(dir))
> +		smk_inode_transmutable(dir)) {
>   			isp = dsp;
> +			issp->smk_flags |= SMK_INODE_CHANGED;
> +		}
>
>   		*value = kstrdup(isp, GFP_KERNEL);
>   		if (*value == NULL)
> @@ -2550,6+2554,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
>   	char *final;
>   	char trattr[TRANS_TRUE_SIZE];
>   	int transflag = 0;
> +	int rc;
>   	struct dentry *dp;
>
>   	if (inode == NULL)
> @@ -2668,17+2673,38 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
>   		 */
>   		dp = dget(opt_dentry);
>   		fetched = smk_fetch(XATTR_NAME_SMACK, inode, dp);
> -		if (fetched != NULL) {
> +		if (fetched != NULL)
>   			final = fetched;
> -			if (S_ISDIR(inode->i_mode)) {
> -				trattr[0] = '\0';
> -				inode->i_op->getxattr(dp,
> +
> +		/*
> +		* Transmuting directory
> +		*/
> +		if (S_ISDIR(inode->i_mode)) {
> +			/*
> +			* If this is a new directory and the label was
> +			* transmuted when the inode was initialized
> +			* set the transmute attribute on the directory
> +			* and mark the inode.
> +			*
> +			* If there is a transmute attribute on the
> +			* directory mark the inode.
> +			*/
> +			if (isp->smk_flags&  SMK_INODE_CHANGED) {
> +				isp->smk_flags&= ~SMK_INODE_CHANGED;
> +				rc = inode->i_op->setxattr(dp,
>   					XATTR_NAME_SMACKTRANSMUTE,
> -					trattr, TRANS_TRUE_SIZE);
> -				if (strncmp(trattr, TRANS_TRUE,
> -					    TRANS_TRUE_SIZE) == 0)
> -					transflag = SMK_INODE_TRANSMUTE;
> +					TRANS_TRUE, TRANS_TRUE_SIZE,
> +					0);
> +			} else {
> +				rc = inode->i_op->getxattr(dp,
> +					XATTR_NAME_SMACKTRANSMUTE, trattr,
> +					TRANS_TRUE_SIZE);
> +				if (rc>= 0&&  strncmp(trattr, TRANS_TRUE,
> +					TRANS_TRUE_SIZE) != 0)
> +					rc = -EINVAL;
>   			}
> +			if (rc>= 0)
> +				transflag = SMK_INODE_TRANSMUTE;
>   		}
>   		isp->smk_task = smk_fetch(XATTR_NAME_SMACKEXEC, inode, dp);
>   		isp->smk_mmap = smk_fetch(XATTR_NAME_SMACKMMAP, inode, dp);
>
>
>
>
>
>

/Jarkko
