Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2E0Vc4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 17:32:56 -0400
Received: from nm18.access.bullet.mail.mud.yahoo.com ([66.94.237.219]:32506
	"HELO nm18.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752681Ab2E0Vcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 17:32:52 -0400
X-Yahoo-Newman-Id: 539291.67137.bm@smtp101.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: OdDLssQVM1kOnYhFecQvJaWMvKKppcgV1WjqlofwIjiP3.v
 thIxl6MZ8.3kYjb.m01JgvHJB67CvibIOBjBuS6e.rYjfpMn2e.La1gzbZUw
 U3Vuo2e_h_BpBn36Slhu5q.olrOqRbOzzao4LnED7_CZqe9ul14gmqIzJ5cS
 sD6QmVUg9NnmOmJAcw2Au6Au.Sto5arcMHhLYTj6FLDawFjqMrBRsevnuAJD
 ISimSLjyVxx8yR3vcIRNoIyf.PkvXZv0FjLiglpXr0oiX7LIYS89PVDbnFhm
 bo2OMIYRkuI56COXehnutEv6jA_p5LT2biIqnVIkX_ZQfubJkxCP7KzS_Ub8
 h6lhU_OHhsXVUfitQqp6rReA..Hh2m2R39b6Rs59Z92T3cV8dDpgQqxCzNJ4
 RFYjwlVVE3jTZizDvH_zuzL97HBnTrJQjTPMmgePVT27T2zN_N4MaSyzlpYV
 lxaYrO3ffz0nH1TYGH7XP6SsYedPce.C33uH4mY3u59kA49YLsk66rOQzvyb
 7G5cWc4mZ_oclFWHIVlg6idrCLGLXJ.txw4jbahyOOLIPXrSHMHo-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4FC29D82.5040101@schaufler-ca.com>
Date: Sun, 27 May 2012 14:32:50 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Smack: fix smack_new_inode bogosities
References: <4FBD8502.4010602@schaufler-ca.com>
In-Reply-To: <4FBD8502.4010602@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/2012 5:46 PM, Casey Schaufler wrote:
> From: Casey Schaufler <casey@schaufler-ca.com>
> Subject: [PATCH] Smack: fix smack_new_inode bogosities
>
> In January of 2012 Al Viro pointed out three bits of code that
> he titled "new_inode_smack bogosities". This patch repairs these
> errors.
>
> 1. smack_sb_kern_mount() included a NULL check that is impossible.
>    The check and NULL case are removed.
> 2. smack_kb_kern_mount() included pointless locking. The locking is
>    removed. Since this is the only place that lock was used the lock
>    is removed from the superblock_smack structure.
> 3. smk_fill_super() incorrectly and unnecessarily set the Smack label
>    for the smackfs root inode. The assignment has been removed.
>
> Targeted for git://gitorious.org/smack-next/kernel.git
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>


Applied to git://gitorious.org/smack-next/kernel.git

>
> ---
>
>  security/smack/smack.h     |    1 -
>  security/smack/smack_lsm.c |    8 ++------
>  security/smack/smackfs.c   |    1 -
>  3 files changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index cc361b8..76feb31 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -43,7 +43,6 @@ struct superblock_smack {
>  	char		*smk_hat;
>  	char		*smk_default;
>  	int		smk_initialized;
> -	spinlock_t	smk_sblock;	/* for initialization */
>  };
>  
>  struct socket_smack {
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index d583c05..5a4d52c 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -251,7 +251,6 @@ static int smack_sb_alloc_security(struct super_block *sb)
>  	sbsp->smk_floor = smack_known_floor.smk_known;
>  	sbsp->smk_hat = smack_known_hat.smk_known;
>  	sbsp->smk_initialized = 0;
> -	spin_lock_init(&sbsp->smk_sblock);
>  
>  	sb->s_security = sbsp;
>  
> @@ -332,13 +331,10 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
>  	char *commap;
>  	char *nsp;
>  
> -	spin_lock(&sp->smk_sblock);
> -	if (sp->smk_initialized != 0) {
> -		spin_unlock(&sp->smk_sblock);
> +	if (sp->smk_initialized != 0)
>  		return 0;
> -	}
> +
>  	sp->smk_initialized = 1;
> -	spin_unlock(&sp->smk_sblock);
>  
>  	for (op = data; op != NULL; op = commap) {
>  		commap = strchr(op, ',');
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 1810c9a..3686db7 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -2051,7 +2051,6 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
>  	}
>  
>  	root_inode = sb->s_root->d_inode;
> -	root_inode->i_security = new_inode_smack(smack_known_floor.smk_known);
>  
>  	return 0;
>  }
>
>
>
>

