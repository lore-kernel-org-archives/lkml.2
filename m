Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab2HWQvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:51:55 -0400
Received: from nm19-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.25]:41862
	"HELO nm19-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752323Ab2HWQvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:51:43 -0400
X-Yahoo-Newman-Id: 805366.81415.bm@smtp103.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: heNTjHoVM1nD19vyRsIxnYkBa1hAjF5TbFmD2hGqZV.yYDl
 ZoQeQ1Qu7zSHWmZm9AetKLiym1OwxeEKpp99B_OSbbI4WrDxSKGVM.iyp35s
 jhABfQVavpxxGedLDTxhhjJ7l8Q3lkjkwIdIxhy1lhXREfFzlhjVTd1AXyyn
 d6Z5qU9Kz173VZaOXFAmwzr074sTLZHMu3CviO7DEwUC8AuPKy7n6UH7L6JD
 dG7FMCDs0Nsxzpc43HlcE4ENUJUnRj.EqDS2Ufz2HCRp.XEA_XNMzmZ5CBfh
 bTJmc9CWdb6qkoRwLkzwB1ts8aqWmfgyvGPBVxduepWmfDEDOu9IFD788qLb
 LCRhapbukF_W.lbKrkqDm3mEJ4ytJmBhSGJ7ZkC.NA5AaIg05wSyeWsl03Eg
 om2E_SShadrfIcpJD2utQJi5SQsgul5wIsvvvsX2b11FVHutgcP4lZo_hCYy
 FwsatdlKOJ23VqP3rOMEVO7W2nryl10vrwJ.6f1KrJfts1h6dkVayFSh3IzD
 C_133XaXWXP9hrDLayYgmxpVCQwXfu8a37uH0SymwDFe2xGduDmA-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50365F9F.7020308@schaufler-ca.com>
Date: Thu, 23 Aug 2012 09:51:43 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: LSM <linux-security-module@vger.kernel.org>
CC: Casey Schaufler <casey@schaufler-ca.com>,
        LKLM <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Smack: setprocattr memory leak fix
References: <50352873.9070706@schaufler-ca.com>
In-Reply-To: <50352873.9070706@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/22/2012 11:44 AM, Casey Schaufler wrote:

> From: Casey Schaufler <casey@schaufler-ca.com>
> Subject: [PATCH] Smack: setprocattr memory leak fix
>
> The data structure allocations being done in prepare_creds
> are duplicated in smack_setprocattr. This results in the
> structure allocated in prepare_creds being orphaned and
> never freed. The duplicate code is removed from
> smack_setprocattr.
>
> Targeted for git://git.gitorious.org/smack-next/kernel.git
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

Applied to git://git.gitorious.org/smack-next/kernel.git

 

>
> ---
>
>  security/smack/smack_lsm.c |   14 ++------------
>  1 files changed, 2 insertions(+), 12 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index ce9273a..2874c73 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -2684,9 +2684,7 @@ static int smack_getprocattr(struct task_struct *p, char *name, char **value)
>  static int smack_setprocattr(struct task_struct *p, char *name,
>  			     void *value, size_t size)
>  {
> -	int rc;
>  	struct task_smack *tsp;
> -	struct task_smack *oldtsp;
>  	struct cred *new;
>  	char *newsmack;
>  
> @@ -2716,21 +2714,13 @@ static int smack_setprocattr(struct task_struct *p, char *name,
>  	if (newsmack == smack_known_web.smk_known)
>  		return -EPERM;
>  
> -	oldtsp = p->cred->security;
>  	new = prepare_creds();
>  	if (new == NULL)
>  		return -ENOMEM;
>  
> -	tsp = new_task_smack(newsmack, oldtsp->smk_forked, GFP_KERNEL);
> -	if (tsp == NULL) {
> -		kfree(new);
> -		return -ENOMEM;
> -	}
> -	rc = smk_copy_rules(&tsp->smk_rules, &oldtsp->smk_rules, GFP_KERNEL);
> -	if (rc != 0)
> -		return rc;
> +	tsp = new->security;
> +	tsp->smk_task = newsmack;
>  
> -	new->security = tsp;
>  	commit_creds(new);
>  	return size;
>  }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
