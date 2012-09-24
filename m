Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab2IXPbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:31:19 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47606 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab2IXPbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:31:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
References: <20120924215222.8933c5557b17239552f0b1d1@canb.auug.org.au>
Date: Mon, 24 Sep 2012 08:31:07 -0700
In-Reply-To: <20120924215222.8933c5557b17239552f0b1d1@canb.auug.org.au>
	(Stephen Rothwell's message of "Mon, 24 Sep 2012 21:52:22 +1000")
Message-ID: <87txunwi84.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+kB58zrj76CgLPXuNXIIwNhl9NvDPHIt0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3687]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: 
Subject: Re: linux-next: manual merge of the userns tree with the security tree
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Eric,
>
> Today's linux-next merge of the userns tree got a conflict in
> security/integrity/ima/ima_policy.c between commit 07f6a79415d7 ("ima:
> add appraise action keywords and default rules") from the security tree
> and commit 8b94eea4bfb8 ("userns: Add user namespace support to IMA") from
> the userns tree.
>
> I fixed it up (see below) but it probably needs more and can carry the
> fix as necessary (no action is required).

Right.  To work when user namespace support is enabled fowner needs be
converted to a kuid_t as well.

When I did a trial earlier this is what I wound up with.  As long as
user namespaces are not enabled what you wound up with should be fine.

Eric

diff --cc security/integrity/ima/ima_policy.c
index c84df05,cda9031..346fe8f
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@@ -39,7 -45,8 +45,8 @@@ struct ima_rule_entry 
  	enum ima_hooks func;
  	int mask;
  	unsigned long fsmagic;
 -	uid_t uid;
 -	uid_t fowner;
 +	kuid_t uid;
++	kuid_t fowner;
  	struct {
  		void *rule;	/* LSM file metadata specific */
  		int type;	/* audit type */
@@@ -75,14 -82,28 +82,28 @@@ static struct ima_rule_entry default_ru
  	 .flags = IMA_FUNC | IMA_MASK | IMA_UID},
  };
  
- static LIST_HEAD(measure_default_rules);
- static LIST_HEAD(measure_policy_rules);
- static struct list_head *ima_measure;
+ static struct ima_rule_entry default_appraise_rules[] = {
+ 	{.action = DONT_APPRAISE,.fsmagic = PROC_SUPER_MAGIC,.flags = IMA_FSMAGIC},
+ 	{.action = DONT_APPRAISE,.fsmagic = SYSFS_MAGIC,.flags = IMA_FSMAGIC},
+ 	{.action = DONT_APPRAISE,.fsmagic = DEBUGFS_MAGIC,.flags = IMA_FSMAGIC},
+ 	{.action = DONT_APPRAISE,.fsmagic = TMPFS_MAGIC,.flags = IMA_FSMAGIC},
+ 	{.action = DONT_APPRAISE,.fsmagic = RAMFS_MAGIC,.flags = IMA_FSMAGIC},
+ 	{.action = DONT_APPRAISE,.fsmagic = DEVPTS_SUPER_MAGIC,.flags = IMA_FSMAGIC},
+ 	{.action = DONT_APPRAISE,.fsmagic = BINFMTFS_MAGIC,.flags = IMA_FSMAGIC},
+ 	{.action = DONT_APPRAISE,.fsmagic = SECURITYFS_MAGIC,.flags = IMA_FSMAGIC},
+ 	{.action = DONT_APPRAISE,.fsmagic = SELINUX_MAGIC,.flags = IMA_FSMAGIC},
+ 	{.action = DONT_APPRAISE,.fsmagic = CGROUP_SUPER_MAGIC,.flags = IMA_FSMAGIC},
 -	{.action = APPRAISE,.fowner = 0,.flags = IMA_FOWNER},
++	{.action = APPRAISE,.fowner = GLOBAL_ROOT_UID,.flags = IMA_FOWNER},
+ };
+ 
+ static LIST_HEAD(ima_default_rules);
+ static LIST_HEAD(ima_policy_rules);
+ static struct list_head *ima_rules;
  
- static DEFINE_MUTEX(ima_measure_mutex);
+ static DEFINE_MUTEX(ima_rules_mutex);
  
  static bool ima_use_tcb __initdata;
- static int __init default_policy_setup(char *str)
+ static int __init default_measure_policy_setup(char *str)
  {
  	ima_use_tcb = 1;
  	return 1;
@@@ -112,8 -141,10 +141,10 @@@ static bool ima_match_rules(struct ima_
  	if ((rule->flags & IMA_FSMAGIC)
  	    && rule->fsmagic != inode->i_sb->s_magic)
  		return false;
 -	if ((rule->flags & IMA_UID) && rule->uid != cred->uid)
 +	if ((rule->flags & IMA_UID) && !uid_eq(rule->uid, cred->uid))
  		return false;
 -	if ((rule->flags & IMA_FOWNER) && rule->fowner != inode->i_uid)
++	if ((rule->flags & IMA_FOWNER) && !uid_eq(rule->fowner, inode->i_uid))
+ 		return false;
  	for (i = 0; i < MAX_LSM_RULES; i++) {
  		int rc = 0;
  		u32 osid, sid;
@@@ -277,7 -336,8 +336,8 @@@ static int ima_parse_rule(char *rule, s
  
  	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_INTEGRITY_RULE);
  
 -	entry->uid = -1;
 -	entry->fowner = -1;
 +	entry->uid = INVALID_UID;
++	entry->fowner = INVALID_UID;
  	entry->action = UNKNOWN;
  	while ((p = strsep(&rule, " \t")) != NULL) {
  		substring_t args[MAX_OPT_ARGS];
@@@ -375,6 -459,23 +459,23 @@@
  					entry->flags |= IMA_UID;
  			}
  			break;
+ 		case Opt_fowner:
+ 			ima_log_string(ab, "fowner", args[0].from);
+ 
 -			if (entry->fowner != -1) {
++			if (uid_valid(entry->fowner)) {
+ 				result = -EINVAL;
+ 				break;
+ 			}
+ 
+ 			result = strict_strtoul(args[0].from, 10, &lnum);
+ 			if (!result) {
 -				entry->fowner = (uid_t) lnum;
 -				if (entry->fowner != lnum)
++				entry->fowner = make_kuid(current_user_ns(), (uid_t) lnum);
++				if (!uid_valid(entry->fowner) || ((uid_t)lnum != lnum))
+ 					result = -EINVAL;
+ 				else
+ 					entry->flags |= IMA_FOWNER;
+ 			}
+ 			break;
  		case Opt_obj_user:
  			ima_log_string(ab, "obj_user", args[0].from);
  			result = ima_lsm_rule_init(entry, args[0].from,

