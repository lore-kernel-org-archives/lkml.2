Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab1IMXGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 19:06:24 -0400
Received: from nm5-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.204]:45008 "HELO
	nm5-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932988Ab1IMXGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 19:06:13 -0400
X-Yahoo-Newman-Id: 514823.60896.bm@omp1008.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: juKpSIYVM1kck6PaKdaul70pTZaaV8ISY6nRbilmil2QH1o
 .bS53IiSA3odfrunNU4tq6OorKZwDplqh.lzBlVbLdlmJ6Fb9E_soUP.4289
 iZkkef60vUkoVHqV5Y438PuFKOQybeFQD8r_rAOtEqv5_iOIXNG2w1fY5tkW
 3FLnMFfpqslXxr32CwnMiKqEAgf5IiYJwJ5T_lrNXogkRE.ZnRCdSBd2eBSd
 fa_TS_MjBvBonLajwJO2L3KueGYBiEr18Tpzof3bvyPXbn4kr_iisO6ZI6Rr
 SjNPziwKK5DfAJjq4KkSKh_ose7In7n2V7pmAwwjP3ir7HWxg0dQdMBkn3Oh
 rtF8fgwS4j8zD9gDC65vzRaO6ZS6GHBojPEKAzMHD_AlOp4hDvVmVlQm9lbE
 1oiqTU1e85Ywc6NrOWgks7kbTd2RHCz7brUmZkJ28Cy6af1lo.h93g5Apr9n
 GmCWsH63zfMCrh__2NwxhpbQGS07SJFdNuIx9b3Xxm9kKB.uCXsHT54hN9kH
 YAuZR
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4E6FE1A4.7080907@schaufler-ca.com>
Date: Tue, 13 Sep 2011 16:05:08 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: check permissions from user space
References: <1314596111-2781-1-git-send-email-jarkko.sakkinen@intel.com>
In-Reply-To: <1314596111-2781-1-git-send-email-jarkko.sakkinen@intel.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/2011 10:35 PM, Jarkko Sakkinen wrote:
> Adds a new file into SmackFS called 'access'. Wanted
> Smack permission is written into /smack/access.
> After that result can be read from the opened file.
> If access applies result contains 1 and otherwise
> 0. File access is protected from race conditions
> by using simple_transaction_get()/set() API.

Applied to git://gitorious.org/smack-next/kernel.git

>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
> ---
>  security/smack/smack.h   |    1 +
>  security/smack/smackfs.c |  181 ++++++++++++++++++++++++++++++----------------
>  2 files changed, 119 insertions(+), 63 deletions(-)
>
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index 2b6c6a5..82c5a30 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -189,6 +189,7 @@ struct smk_audit_info {
>  	struct common_audit_data a;
>  #endif
>  };
> +
>  /*
>   * These functions are in smack_lsm.c
>   */
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index f934601..5a87075 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -27,6 +27,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/ctype.h>
>  #include <linux/audit.h>
> +#include <linux/smack.h>
>  #include "smack.h"
>  
>  /*
> @@ -44,6 +45,7 @@ enum smk_inos {
>  	SMK_ONLYCAP	= 9,	/* the only "capable" label */
>  	SMK_LOGGING	= 10,	/* logging */
>  	SMK_LOAD_SELF	= 11,	/* task specific rules */
> +	SMK_ACCESSES	= 12,	/* access policy */
>  };
>  
>  /*
> @@ -176,71 +178,19 @@ static int smk_set_access(struct smack_rule *srp, struct list_head *rule_list,
>  }
>  
>  /**
> - * smk_write_load_list - write() for any /smack/load
> - * @file: file pointer, not actually used
> - * @buf: where to get the data from
> - * @count: bytes sent
> - * @ppos: where to start - must be 0
> - * @rule_list: the list of rules to write to
> - * @rule_lock: lock for the rule list
> - *
> - * Get one smack access rule from above.
> - * The format is exactly:
> - *     char subject[SMK_LABELLEN]
> - *     char object[SMK_LABELLEN]
> - *     char access[SMK_ACCESSLEN]
> - *
> - * writes must be SMK_LABELLEN+SMK_LABELLEN+SMK_ACCESSLEN bytes.
> + * smk_parse_rule - parse subject, object and access type
> + * @data: string to be parsed whose size is SMK_LOADLEN
> + * @rule: parsed entities are stored in here
>   */
> -static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
> -				size_t count, loff_t *ppos,
> -				struct list_head *rule_list,
> -				struct mutex *rule_lock)
> +static int smk_parse_rule(const char *data, struct smack_rule *rule)
>  {
> -	struct smack_rule *rule;
> -	char *data;
> -	int rc = -EINVAL;
> -
> -	/*
> -	 * No partial writes.
> -	 * Enough data must be present.
> -	 */
> -	if (*ppos != 0)
> -		return -EINVAL;
> -	/*
> -	 * Minor hack for backward compatibility
> -	 */
> -	if (count < (SMK_OLOADLEN) || count > SMK_LOADLEN)
> -		return -EINVAL;
> -
> -	data = kzalloc(SMK_LOADLEN, GFP_KERNEL);
> -	if (data == NULL)
> -		return -ENOMEM;
> -
> -	if (copy_from_user(data, buf, count) != 0) {
> -		rc = -EFAULT;
> -		goto out;
> -	}
> -
> -	/*
> -	 * More on the minor hack for backward compatibility
> -	 */
> -	if (count == (SMK_OLOADLEN))
> -		data[SMK_OLOADLEN] = '-';
> -
> -	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
> -	if (rule == NULL) {
> -		rc = -ENOMEM;
> -		goto out;
> -	}
> -
>  	rule->smk_subject = smk_import(data, 0);
>  	if (rule->smk_subject == NULL)
> -		goto out_free_rule;
> +		return -1;
>  
>  	rule->smk_object = smk_import(data + SMK_LABELLEN, 0);
>  	if (rule->smk_object == NULL)
> -		goto out_free_rule;
> +		return -1;
>  
>  	rule->smk_access = 0;
>  
> @@ -252,7 +202,7 @@ static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
>  		rule->smk_access |= MAY_READ;
>  		break;
>  	default:
> -		goto out_free_rule;
> +		return -1;
>  	}
>  
>  	switch (data[SMK_LABELLEN + SMK_LABELLEN + 1]) {
> @@ -263,7 +213,7 @@ static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
>  		rule->smk_access |= MAY_WRITE;
>  		break;
>  	default:
> -		goto out_free_rule;
> +		return -1;
>  	}
>  
>  	switch (data[SMK_LABELLEN + SMK_LABELLEN + 2]) {
> @@ -274,7 +224,7 @@ static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
>  		rule->smk_access |= MAY_EXEC;
>  		break;
>  	default:
> -		goto out_free_rule;
> +		return -1;
>  	}
>  
>  	switch (data[SMK_LABELLEN + SMK_LABELLEN + 3]) {
> @@ -285,7 +235,7 @@ static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
>  		rule->smk_access |= MAY_APPEND;
>  		break;
>  	default:
> -		goto out_free_rule;
> +		return -1;
>  	}
>  
>  	switch (data[SMK_LABELLEN + SMK_LABELLEN + 4]) {
> @@ -296,9 +246,74 @@ static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
>  		rule->smk_access |= MAY_TRANSMUTE;
>  		break;
>  	default:
> -		goto out_free_rule;
> +		return -1;
>  	}
>  
> +	return 0;
> +}
> +
> +/**
> + * smk_write_load_list - write() for any /smack/load
> + * @file: file pointer, not actually used
> + * @buf: where to get the data from
> + * @count: bytes sent
> + * @ppos: where to start - must be 0
> + * @rule_list: the list of rules to write to
> + * @rule_lock: lock for the rule list
> + *
> + * Get one smack access rule from above.
> + * The format is exactly:
> + *     char subject[SMK_LABELLEN]
> + *     char object[SMK_LABELLEN]
> + *     char access[SMK_ACCESSLEN]
> + *
> + * writes must be SMK_LABELLEN+SMK_LABELLEN+SMK_ACCESSLEN bytes.
> + */
> +static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
> +				size_t count, loff_t *ppos,
> +				struct list_head *rule_list,
> +				struct mutex *rule_lock)
> +{
> +	struct smack_rule *rule;
> +	char *data;
> +	int rc = -EINVAL;
> +
> +	/*
> +	 * No partial writes.
> +	 * Enough data must be present.
> +	 */
> +	if (*ppos != 0)
> +		return -EINVAL;
> +	/*
> +	 * Minor hack for backward compatibility
> +	 */
> +	if (count < (SMK_OLOADLEN) || count > SMK_LOADLEN)
> +		return -EINVAL;
> +
> +	data = kzalloc(SMK_LOADLEN, GFP_KERNEL);
> +	if (data == NULL)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(data, buf, count) != 0) {
> +		rc = -EFAULT;
> +		goto out;
> +	}
> +
> +	/*
> +	 * More on the minor hack for backward compatibility
> +	 */
> +	if (count == (SMK_OLOADLEN))
> +		data[SMK_OLOADLEN] = '-';
> +
> +	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
> +	if (rule == NULL) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	if (smk_parse_rule(data, rule))
> +		goto out_free_rule;
> +
>  	rc = count;
>  	/*
>  	 * smk_set_access returns true if there was already a rule
> @@ -1425,6 +1440,44 @@ static const struct file_operations smk_load_self_ops = {
>  	.write		= smk_write_load_self,
>  	.release        = seq_release,
>  };
> +
> +/**
> + * smk_write_access - handle access check transaction
> + * @file: file pointer
> + * @buf: data from user space
> + * @count: bytes sent
> + * @ppos: where to start - must be 0
> + */
> +static ssize_t smk_write_access(struct file *file, const char __user *buf,
> +				size_t count, loff_t *ppos)
> +{
> +	struct smack_rule rule;
> +	char *data;
> +
> +	if (!capable(CAP_MAC_ADMIN))
> +		return -EPERM;
> +
> +	data = simple_transaction_get(file, buf, count);
> +	if (IS_ERR(data))
> +		return PTR_ERR(data);
> +
> +	if (count < SMK_LOADLEN || smk_parse_rule(data, &rule))
> +		return -EINVAL;
> +
> +	data[0] = smk_access(rule.smk_subject, rule.smk_object,
> +			     rule.smk_access, NULL) == 0;
> +
> +	simple_transaction_set(file, 1);
> +	return SMK_LOADLEN;
> +}
> +
> +static const struct file_operations smk_access_ops = {
> +	.write		= smk_write_access,
> +	.read		= simple_transaction_read,
> +	.release	= simple_transaction_release,
> +	.llseek		= generic_file_llseek,
> +};
> +
>  /**
>   * smk_fill_super - fill the /smackfs superblock
>   * @sb: the empty superblock
> @@ -1459,6 +1512,8 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
>  			"logging", &smk_logging_ops, S_IRUGO|S_IWUSR},
>  		[SMK_LOAD_SELF] = {
>  			"load-self", &smk_load_self_ops, S_IRUGO|S_IWUGO},
> +		[SMK_ACCESSES] = {
> +			"access", &smk_access_ops, S_IRUGO|S_IWUSR},
>  		/* last one */
>  			{""}
>  	};

