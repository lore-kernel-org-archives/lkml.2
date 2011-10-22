Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab1JVUYw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 16:24:52 -0400
Received: from tundra.namei.org ([65.99.196.166]:46203 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab1JVUYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 16:24:50 -0400
Date: Sun, 23 Oct 2011 07:24:47 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Smack: allow to access /smack/access as normal user
In-Reply-To: <4EA1BE30.5080900@schaufler-ca.com>
Message-ID: <alpine.LRH.2.00.1110230723110.11161@tundra.namei.org>
References: <1318962096-23724-1-git-send-email-jarkko.j.sakkinen@gmail.com> <4EA1BE30.5080900@schaufler-ca.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Oct 2011, Casey Schaufler wrote:

> On 10/18/2011 11:21 AM, Jarkko Sakkinen wrote:
> > Allow query access as a normal user removing the need
> > for CAP_MAC_ADMIN. Give RW access to /smack/access
> > for UGO. Do not import smack labels in access check.
> >
> > Signed-off-by: Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>
> 
> Applied to git://gitorious.org/smack-next/kernel.git#master
> 
> James, will you please pull:

Pulled, but please use git-request-pull for these requests.


> 
> commit 0e94ae17c857b3835a2b8ea46ce44b5da4e2cc5d
> Author: Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>
> Date:   Tue Oct 18 21:21:36 2011 +0300
> 
>     Smack: allow to access /smack/access as normal user
>    
>     Allow query access as a normal user removing the need
>     for CAP_MAC_ADMIN. Give RW access to /smack/access
>     for UGO. Do not import smack labels in access check.
>    
>     Signed-off-by: Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>
>     Signed-off-by: Casey Schaufler <cschaufler@cschaufler-intel.(none)>
> 
> commit d86b2b61d4dea614d6f319772a90a8f98b55ed67
> Author: Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>
> Date:   Tue Oct 18 14:34:28 2011 +0300
> 
>     Smack: fix: invalid length set for the result of /smack/access
>    
>     Forgot to update simple_transaction_set() to take terminator
>     character into account.
>    
>     Signed-off-by: Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>
>     Signed-off-by: Casey Schaufler <cschaufler@cschaufler-intel.(none)>
> 
> 
> 
> > ---
> >  security/smack/smack.h        |    1 +
> >  security/smack/smack_access.c |   27 +++++++++++++++++-------
> >  security/smack/smackfs.c      |   45 +++++++++++++++++++++++++++-------------
> >  3 files changed, 50 insertions(+), 23 deletions(-)
> >
> > diff --git a/security/smack/smack.h b/security/smack/smack.h
> > index 9da2b2d..2ad0065 100644
> > --- a/security/smack/smack.h
> > +++ b/security/smack/smack.h
> > @@ -208,6 +208,7 @@ int smk_curacc(char *, u32, struct smk_audit_info *);
> >  int smack_to_cipso(const char *, struct smack_cipso *);
> >  char *smack_from_cipso(u32, char *);
> >  char *smack_from_secid(const u32);
> > +void smk_parse_smack(const char *string, int len, char *smack);
> >  char *smk_import(const char *, int);
> >  struct smack_known *smk_import_entry(const char *, int);
> >  struct smack_known *smk_find_entry(const char *);
> > diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> > index a885f62..cc7cb6e 100644
> > --- a/security/smack/smack_access.c
> > +++ b/security/smack/smack_access.c
> > @@ -353,17 +353,13 @@ struct smack_known *smk_find_entry(const char *string)
> >  }
> >  
> >  /**
> > - * smk_import_entry - import a label, return the list entry
> > - * @string: a text string that might be a Smack label
> > + * smk_parse_smack - parse smack label from a text string
> > + * @string: a text string that might contain a Smack label
> >   * @len: the maximum size, or zero if it is NULL terminated.
> > - *
> > - * Returns a pointer to the entry in the label list that
> > - * matches the passed string, adding it if necessary.
> > + * @smack: parsed smack label, or NULL if parse error
> >   */
> > -struct smack_known *smk_import_entry(const char *string, int len)
> > +void smk_parse_smack(const char *string, int len, char *smack)
> >  {
> > -	struct smack_known *skp;
> > -	char smack[SMK_LABELLEN];
> >  	int found;
> >  	int i;
> >  
> > @@ -381,7 +377,22 @@ struct smack_known *smk_import_entry(const char *string, int len)
> >  		} else
> >  			smack[i] = string[i];
> >  	}
> > +}
> > +
> > +/**
> > + * smk_import_entry - import a label, return the list entry
> > + * @string: a text string that might be a Smack label
> > + * @len: the maximum size, or zero if it is NULL terminated.
> > + *
> > + * Returns a pointer to the entry in the label list that
> > + * matches the passed string, adding it if necessary.
> > + */
> > +struct smack_known *smk_import_entry(const char *string, int len)
> > +{
> > +	struct smack_known *skp;
> > +	char smack[SMK_LABELLEN];
> >  
> > +	smk_parse_smack(string, len, smack);
> >  	if (smack[0] == '\0')
> >  		return NULL;
> >  
> > diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> > index 381eecf..6aceef5 100644
> > --- a/security/smack/smackfs.c
> > +++ b/security/smack/smackfs.c
> > @@ -191,19 +191,37 @@ static int smk_set_access(struct smack_rule *srp, struct list_head *rule_list,
> >  }
> >  
> >  /**
> > - * smk_parse_rule - parse subject, object and access type
> > + * smk_parse_rule - parse Smack rule from load string
> >   * @data: string to be parsed whose size is SMK_LOADLEN
> > - * @rule: parsed entities are stored in here
> > + * @rule: Smack rule
> > + * @import: if non-zero, import labels
> >   */
> > -static int smk_parse_rule(const char *data, struct smack_rule *rule)
> > +static int smk_parse_rule(const char *data, struct smack_rule *rule, int import)
> >  {
> > -	rule->smk_subject = smk_import(data, 0);
> > -	if (rule->smk_subject == NULL)
> > -		return -1;
> > +	char smack[SMK_LABELLEN];
> > +	struct smack_known *skp;
> >  
> > -	rule->smk_object = smk_import(data + SMK_LABELLEN, 0);
> > -	if (rule->smk_object == NULL)
> > -		return -1;
> > +	if (import) {
> > +		rule->smk_subject = smk_import(data, 0);
> > +		if (rule->smk_subject == NULL)
> > +			return -1;
> > +
> > +		rule->smk_object = smk_import(data + SMK_LABELLEN, 0);
> > +		if (rule->smk_object == NULL)
> > +			return -1;
> > +	} else {
> > +		smk_parse_smack(data, 0, smack);
> > +		skp = smk_find_entry(smack);
> > +		if (skp == NULL)
> > +			return -1;
> > +		rule->smk_subject = skp->smk_known;
> > +
> > +		smk_parse_smack(data + SMK_LABELLEN, 0, smack);
> > +		skp = smk_find_entry(smack);
> > +		if (skp == NULL)
> > +			return -1;
> > +		rule->smk_object = skp->smk_known;
> > +	}
> >  
> >  	rule->smk_access = 0;
> >  
> > @@ -327,7 +345,7 @@ static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
> >  		goto out;
> >  	}
> >  
> > -	if (smk_parse_rule(data, rule))
> > +	if (smk_parse_rule(data, rule, 1))
> >  		goto out_free_rule;
> >  
> >  	if (rule_list == NULL) {
> > @@ -1499,14 +1517,11 @@ static ssize_t smk_write_access(struct file *file, const char __user *buf,
> >  	char *data;
> >  	int res;
> >  
> > -	if (!capable(CAP_MAC_ADMIN))
> > -		return -EPERM;
> > -
> >  	data = simple_transaction_get(file, buf, count);
> >  	if (IS_ERR(data))
> >  		return PTR_ERR(data);
> >  
> > -	if (count < SMK_LOADLEN || smk_parse_rule(data, &rule))
> > +	if (count < SMK_LOADLEN || smk_parse_rule(data, &rule, 0))
> >  		return -EINVAL;
> >  
> >  	res = smk_access(rule.smk_subject, rule.smk_object, rule.smk_access,
> > @@ -1560,7 +1575,7 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
> >  		[SMK_LOAD_SELF] = {
> >  			"load-self", &smk_load_self_ops, S_IRUGO|S_IWUGO},
> >  		[SMK_ACCESSES] = {
> > -			"access", &smk_access_ops, S_IRUGO|S_IWUSR},
> > +			"access", &smk_access_ops, S_IRUGO|S_IWUGO},
> >  		/* last one */
> >  			{""}
> >  	};
> 

-- 
James Morris
<jmorris@namei.org>
