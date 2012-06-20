Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab2FTWCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:02:07 -0400
Received: from nm21.access.bullet.mail.mud.yahoo.com ([66.94.237.222]:21561
	"HELO nm21.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754497Ab2FTWCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:02:05 -0400
X-Yahoo-Newman-Id: 368414.73792.bm@smtp104.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zXjw_UQVM1menk7zmzThgEphbl13dICirhASIBmXBR18bzF
 5GzSogocZtVurRHHHki7VNdLBjZNAEKVzvJtxwxFjFcP70xLnA18O8eEuGI0
 JeNcydmdOFi0p5db_FX0mgq6gVjt8kWCN2eGPkMwKC3O23R6mFrSN.SfOQa3
 Einb10508ZLA1NI6_zy5w8oT1WgH1cl0luxwPqiTBDzl3NQkAyDBSzqr3PlD
 SoXdIUdZMI4I.xKO0sZEmK8E2lyD_oQp1WRg1_0t2sMaMUs0LU.VByTq11hc
 osijkxRxS7D1Wn0SwZZzeoXBH3MjD9rVtGPFyW7l3lvgLEs3ihZfO9mZOsu_
 ny7AsNJ6ufaSI4Zqa54gU0jbuCnNKlUVlL.lw.D6vKZAt4oKXmDg.DBX6qhA
 H_Lvc7ckBx9eHNCNiVgVnq_m.vL5yLrRLnkC7Kkw4rvZz0_6vsrxR7gvGPIx
 bhx1nscCIsk8awh7olMT81yMmQYCL3PazAepYhZMKwQWYrOTWh40MR2P6X9c
 I.au28lM-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4FE2486D.9030404@schaufler-ca.com>
Date: Wed, 20 Jun 2012 15:02:21 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] Smack: user access check bounds
References: <4FDFDD80.9010007@schaufler-ca.com>
In-Reply-To: <4FDFDD80.9010007@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/2012 7:01 PM, Casey Schaufler wrote:
> From: Casey Schaufler <casey@schaufler-ca.com>
> Subject: [PATCH] Smack: user access check bounds
>
> Some of the bounds checking used on the /smack/access
> interface was lost when support for long labels was
> added. No kernel access checks are affected, however
> this is a case where /smack/access could be used
> incorrectly and fail to detect the error. This patch
> reintroduces the original checks.
>
> Targeted for git://git.gitorious.org/smack-next/kernel.git
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

Applied to git://git.gitorious.org/smack-next/kernel.git
 
>
> ---
>
>  security/smack/smackfs.c |   26 ++++++++++++--------------
>  1 files changed, 12 insertions(+), 14 deletions(-)
>
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 2152965..29b760d 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -215,28 +215,27 @@ static int smk_set_access(struct smack_rule *srp, struct list_head *rule_list,
>   * @access: access string
>   * @rule: Smack rule
>   * @import: if non-zero, import labels
> + * @len: label length limit
>   *
>   * Returns 0 on success, -1 on failure
>   */
>  static int smk_fill_rule(const char *subject, const char *object,
>  				const char *access, struct smack_rule *rule,
> -				int import)
> +				int import, int len)
>  {
> -	int rc = -1;
> -	int done;
>  	const char *cp;
>  	struct smack_known *skp;
>  
>  	if (import) {
> -		rule->smk_subject = smk_import(subject, 0);
> +		rule->smk_subject = smk_import(subject, len);
>  		if (rule->smk_subject == NULL)
>  			return -1;
>  
> -		rule->smk_object = smk_import(object, 0);
> +		rule->smk_object = smk_import(object, len);
>  		if (rule->smk_object == NULL)
>  			return -1;
>  	} else {
> -		cp = smk_parse_smack(subject, 0);
> +		cp = smk_parse_smack(subject, len);
>  		if (cp == NULL)
>  			return -1;
>  		skp = smk_find_entry(cp);
> @@ -245,7 +244,7 @@ static int smk_fill_rule(const char *subject, const char *object,
>  			return -1;
>  		rule->smk_subject = skp->smk_known;
>  
> -		cp = smk_parse_smack(object, 0);
> +		cp = smk_parse_smack(object, len);
>  		if (cp == NULL)
>  			return -1;
>  		skp = smk_find_entry(cp);
> @@ -257,7 +256,7 @@ static int smk_fill_rule(const char *subject, const char *object,
>  
>  	rule->smk_access = 0;
>  
> -	for (cp = access, done = 0; *cp && !done; cp++) {
> +	for (cp = access; *cp != '\0'; cp++) {
>  		switch (*cp) {
>  		case '-':
>  			break;
> @@ -282,13 +281,11 @@ static int smk_fill_rule(const char *subject, const char *object,
>  			rule->smk_access |= MAY_TRANSMUTE;
>  			break;
>  		default:
> -			done = 1;
> -			break;
> +			return 0;
>  		}
>  	}
> -	rc = 0;
>  
> -	return rc;
> +	return 0;
>  }
>  
>  /**
> @@ -304,7 +301,8 @@ static int smk_parse_rule(const char *data, struct smack_rule *rule, int import)
>  	int rc;
>  
>  	rc = smk_fill_rule(data, data + SMK_LABELLEN,
> -			   data + SMK_LABELLEN + SMK_LABELLEN, rule, import);
> +			   data + SMK_LABELLEN + SMK_LABELLEN, rule, import,
> +			   SMK_LABELLEN);
>  	return rc;
>  }
>  
> @@ -340,7 +338,7 @@ static int smk_parse_long_rule(const char *data, struct smack_rule *rule,
>  		goto free_out_o;
>  
>  	if (sscanf(data, "%s %s %s", subject, object, access) == 3)
> -		rc = smk_fill_rule(subject, object, access, rule, import);
> +		rc = smk_fill_rule(subject, object, access, rule, import, 0);
>  
>  	kfree(access);
>  free_out_o:
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


