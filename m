Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab2IQSPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 14:15:34 -0400
Received: from nm6-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.158]:47818
	"HELO nm6-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756763Ab2IQSPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 14:15:31 -0400
X-Yahoo-Newman-Id: 129323.77762.bm@smtp108.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 9S8OclEVM1mByhaVeP62X9ZOec3wZEcsrHJNkxIY6wlPUQu
 4lBYfYmH4i92lXCgM4BCBsQKZRscoA0x3mZVu7x67Ipw.b_m6Sl4iCAe6TX7
 9cdQmyc_y_8uiEWujFFvTn69RSzfeYWrbkDvqt7X5UR9EQT4rge6k.ofzfWv
 MIfb6OzPKjPxbNc7TNVHMDCOJ.WgxXB9mnYd3yt0pSkF_KblakZNRr6IAZTm
 0enXBhaTskAWTobkoGzg2mBppQ_GhBRUrnanGoo7Xoxhf902sxKosimQTfix
 73N6_Ml4ZhfAQp7yNiemxXJrj15jUMwCw5OSsaUD061NrTWr55u594HykUCR
 pFeiIBrx9feMuCIbYZNL96lbNYMPK5tmA0URzeiQ_NK5eU_miGbmaFNiXmE4
 SX15x.f18C1IB5mCb6G5181cE05.Tmvlf1AAxisGbRdzKrh.qaQVw1VszHX9
 _Ar31YgpWh6lyb0ZXr4kqcFr7i6RF5z8CVX7zYeU1S7kkDZKHHP0UjslJyZT
 CeG5RyHwz_UjiriZpSU0QnXj4Bdzy4xG5eQZpmUsT3NSafqFDD90-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <505768C3.4030205@schaufler-ca.com>
Date: Mon, 17 Sep 2012 11:15:31 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Rafal Krypa <r.krypa@samsung.com>
CC: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: add support for modification of existing rules
References: <1347894944-6866-1-git-send-email-r.krypa@samsung.com>
In-Reply-To: <1347894944-6866-1-git-send-email-r.krypa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/2012 8:15 AM, Rafal Krypa wrote:
> Rule modifications are enabled via /smack/change-rule. Format is as follows:
> "Subject Object rwaxt rwaxt"
>
> First two strings are subject and object labels up to 255 characters.
> Third string contains permissions to enable.
> Fourth string contains permissions to disable.
>
> All unmentioned permissions will be left unchanged.
> If no rule previously existed, it will be created.
>
> Targeted for git://git.gitorious.org/smack-next/kernel.git
>
> Signed-off-by: Rafal Krypa <r.krypa@samsung.com>

Nacked-by: Casey Schaufler <casey@schaufler-ca.com>

The desired behavior of this interface is that it add any
permissions in string 3 and remove any in string 4. What it
does instead is set the permissions in string three and then
remove those in string four. If you have:

    Snap Crackle rwxa

# echo 'Snap Crackle - rw' > /smack/change-rule

should result in

    Snap Crackle xa

but instead gets

    Snap Crackle -





> ---
>  Documentation/security/Smack.txt |   11 +++
>  security/smack/smackfs.c         |  152 ++++++++++++++++++++++++++++----------
>  2 files changed, 122 insertions(+), 41 deletions(-)
>
> diff --git a/Documentation/security/Smack.txt b/Documentation/security/Smack.txt
> index e68536d..ea20fa2 100644
> --- a/Documentation/security/Smack.txt
> +++ b/Documentation/security/Smack.txt
> @@ -118,6 +118,17 @@ access2
>  ambient
>  	This contains the Smack label applied to unlabeled network
>  	packets.
> +change-rule
> +	This interface allows modification of existing access control rules.
> +	The format accepted on write is:
> +		"%s %s %s %s"
> +	where the first string is the subject label, the second the
> +	object label, the third the access to allow and the fourth the
> +	access to deny. The access strings may contain only the characters
> +	"rwxat-". If a rule for a given subject and object exists it will be
> +	modified by enabling the permissions in the third string and disabling
> +	those in the fourth string. If there is no such rule it will be
> +	created using the access specified in the third and the fourth strings.
>  cipso
>  	This interface allows a specific CIPSO header to be assigned
>  	to a Smack label. The format accepted on write is:
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 99929a5..dfd9d61 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -50,6 +50,7 @@ enum smk_inos {
>  	SMK_ACCESS2	= 16,	/* make an access check with long labels */
>  	SMK_CIPSO2	= 17,	/* load long label -> CIPSO mapping */
>  	SMK_REVOKE_SUBJ	= 18,	/* set rules with subject label to '-' */
> +	SMK_CHANGE_RULE	= 19,	/* change or add rules (long labels) */
>  };
>  
>  /*
> @@ -210,10 +211,51 @@ static int smk_set_access(struct smack_rule *srp, struct list_head *rule_list,
>  }
>  
>  /**
> + * smk_perm_from_str - parse smack accesses from a text string
> + * @string: a text string that contains a Smack accesses code
> + *
> + * Returns an integer with respective bits set for specified accesses.
> + */
> +static int smk_perm_from_str(const char *string)
> +{
> +	int perm = 0;
> +	const char *cp;
> +
> +	for (cp = string; ; cp++)
> +		switch (*cp) {
> +		case '-':
> +			break;
> +		case 'r':
> +		case 'R':
> +			perm |= MAY_READ;
> +			break;
> +		case 'w':
> +		case 'W':
> +			perm |= MAY_WRITE;
> +			break;
> +		case 'x':
> +		case 'X':
> +			perm |= MAY_EXEC;
> +			break;
> +		case 'a':
> +		case 'A':
> +			perm |= MAY_APPEND;
> +			break;
> +		case 't':
> +		case 'T':
> +			perm |= MAY_TRANSMUTE;
> +			break;
> +		default:
> +			return perm;
> +		}
> +}
> +
> +/**
>   * smk_fill_rule - Fill Smack rule from strings
>   * @subject: subject label string
>   * @object: object label string
>   * @access: access string
> + * @access_remove: string with permissions to be removed
>   * @rule: Smack rule
>   * @import: if non-zero, import labels
>   * @len: label length limit
> @@ -221,9 +263,10 @@ static int smk_set_access(struct smack_rule *srp, struct list_head *rule_list,
>   * Returns 0 on success, -1 on failure
>   */
>  static int smk_fill_rule(const char *subject, const char *object,
> -				const char *access, struct smack_rule *rule,
> -				int import, int len)
> +				const char *access, const char *access_remove,
> +				struct smack_rule *rule, int import, int len)
>  {
> +	int rc = -1;
>  	const char *cp;
>  	struct smack_known *skp;
>  
> @@ -255,36 +298,11 @@ static int smk_fill_rule(const char *subject, const char *object,
>  		rule->smk_object = skp->smk_known;
>  	}
>  
> -	rule->smk_access = 0;
> -
> -	for (cp = access; *cp != '\0'; cp++) {
> -		switch (*cp) {
> -		case '-':
> -			break;
> -		case 'r':
> -		case 'R':
> -			rule->smk_access |= MAY_READ;
> -			break;
> -		case 'w':
> -		case 'W':
> -			rule->smk_access |= MAY_WRITE;
> -			break;
> -		case 'x':
> -		case 'X':
> -			rule->smk_access |= MAY_EXEC;
> -			break;
> -		case 'a':
> -		case 'A':
> -			rule->smk_access |= MAY_APPEND;
> -			break;
> -		case 't':
> -		case 'T':
> -			rule->smk_access |= MAY_TRANSMUTE;
> -			break;
> -		default:
> -			return 0;
> -		}
> -	}
> +	if (access_remove) {
> +		rule->smk_access |= smk_perm_from_str(access);
> +		rule->smk_access &= ~smk_perm_from_str(access_remove);
> +	} else
> +		rule->smk_access = smk_perm_from_str(access);
>  
>  	return 0;
>  }
> @@ -302,8 +320,8 @@ static int smk_parse_rule(const char *data, struct smack_rule *rule, int import)
>  	int rc;
>  
>  	rc = smk_fill_rule(data, data + SMK_LABELLEN,
> -			   data + SMK_LABELLEN + SMK_LABELLEN, rule, import,
> -			   SMK_LABELLEN);
> +			   data + SMK_LABELLEN + SMK_LABELLEN, NULL, rule,
> +			   import, SMK_LABELLEN);
>  	return rc;
>  }
>  
> @@ -312,15 +330,17 @@ static int smk_parse_rule(const char *data, struct smack_rule *rule, int import)
>   * @data: string to be parsed, null terminated
>   * @rule: Smack rule
>   * @import: if non-zero, import labels
> + * @change: if non-zero, data is from /smack/change-rule
>   *
>   * Returns 0 on success, -1 on failure
>   */
>  static int smk_parse_long_rule(const char *data, struct smack_rule *rule,
> -				int import)
> +				int import, int change)
>  {
>  	char *subject;
>  	char *object;
>  	char *access;
> +	char *access_remove;
>  	int datalen;
>  	int rc = -1;
>  
> @@ -337,10 +357,23 @@ static int smk_parse_long_rule(const char *data, struct smack_rule *rule,
>  	access = kzalloc(datalen, GFP_KERNEL);
>  	if (access == NULL)
>  		goto free_out_o;
> +	access_remove = kzalloc(datalen, GFP_KERNEL);
> +	if (access_remove == NULL)
> +		goto free_out_a;
> +
> +	if (change) {
> +		if (sscanf(data, "%s %s %s %s",
> +			subject, object, access, access_remove) == 4)
> +			rc = smk_fill_rule(subject, object, access,
> +				access_remove, rule, import, 0);
> +	} else {
> +		if (sscanf(data, "%s %s %s", subject, object, access) == 3)
> +			rc = smk_fill_rule(subject, object, access,
> +				NULL, rule, import, 0);
> +	}
>  
> -	if (sscanf(data, "%s %s %s", subject, object, access) == 3)
> -		rc = smk_fill_rule(subject, object, access, rule, import, 0);
> -
> +	kfree(access_remove);
> +free_out_a:
>  	kfree(access);
>  free_out_o:
>  	kfree(object);
> @@ -351,6 +384,7 @@ free_out_s:
>  
>  #define SMK_FIXED24_FMT	0	/* Fixed 24byte label format */
>  #define SMK_LONG_FMT	1	/* Variable long label format */
> +#define SMK_CHANGE_FMT	2	/* Rule modification format */
>  /**
>   * smk_write_rules_list - write() for any /smack rule file
>   * @file: file pointer, not actually used
> @@ -359,13 +393,16 @@ free_out_s:
>   * @ppos: where to start - must be 0
>   * @rule_list: the list of rules to write to
>   * @rule_lock: lock for the rule list
> - * @format: /smack/load or /smack/load2 format.
> + * @format: /smack/load or /smack/load2 or /smack/change-rule format.
>   *
>   * Get one smack access rule from above.
>   * The format for SMK_LONG_FMT is:
>   *	"subject<whitespace>object<whitespace>access[<whitespace>...]"
>   * The format for SMK_FIXED24_FMT is exactly:
>   *	"subject                 object                  rwxat"
> + * The format for SMK_CHANGE_FMT is:
> + *	"subject<whitespace>object<whitespace>
> + *	 acc_enable<whitespace>acc_disable[<whitespace>...]"
>   */
>  static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>  					size_t count, loff_t *ppos,
> @@ -417,7 +454,11 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>  		 * Be sure the data string is terminated.
>  		 */
>  		data[count] = '\0';
> -		if (smk_parse_long_rule(data, rule, 1))
> +		if (smk_parse_long_rule(data, rule, 1, 0))
> +			goto out_free_rule;
> +	} else if (format == SMK_CHANGE_FMT) {
> +		data[count] = '\0';
> +		if (smk_parse_long_rule(data, rule, 1, 1))
>  			goto out_free_rule;
>  	} else {
>  		/*
> @@ -1796,7 +1837,7 @@ static ssize_t smk_user_access(struct file *file, const char __user *buf,
>  			return -ENOMEM;
>  		memcpy(cod, data, count);
>  		cod[count] = '\0';
> -		res = smk_parse_long_rule(cod, &rule, 0);
> +		res = smk_parse_long_rule(cod, &rule, 0, 0);
>  		kfree(cod);
>  	}
>  
> @@ -2064,6 +2105,33 @@ static const struct file_operations smk_revoke_subj_ops = {
>  };
>  
>  /**
> + * smk_write_change_rule - write() for /smack/change-rule
> + * @file: file pointer
> + * @buf: data from user space
> + * @count: bytes sent
> + * @ppos: where to start - must be 0
> + */
> +static ssize_t smk_write_change_rule(struct file *file, const char __user *buf,
> +				size_t count, loff_t *ppos)
> +{
> +	/*
> +	 * Must have privilege.
> +	 */
> +	if (!capable(CAP_MAC_ADMIN))
> +		return -EPERM;
> +
> +	return smk_write_rules_list(file, buf, count, ppos, NULL, NULL,
> +				    SMK_CHANGE_FMT);
> +}
> +
> +static const struct file_operations smk_change_rule_ops = {
> +	.write		= smk_write_change_rule,
> +	.read		= simple_transaction_read,
> +	.release	= simple_transaction_release,
> +	.llseek		= generic_file_llseek,
> +};
> +
> +/**
>   * smk_fill_super - fill the /smackfs superblock
>   * @sb: the empty superblock
>   * @data: unused
> @@ -2112,6 +2180,8 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
>  		[SMK_REVOKE_SUBJ] = {
>  			"revoke-subject", &smk_revoke_subj_ops,
>  			S_IRUGO|S_IWUSR},
> +		[SMK_CHANGE_RULE] = {
> +			"change-rule", &smk_change_rule_ops, S_IRUGO|S_IWUSR},
>  		/* last one */
>  			{""}
>  	};

