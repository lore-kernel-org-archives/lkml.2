Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab1D1Nd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:33:29 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:47360 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab1D1NdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:33:25 -0400
Subject: Re: [RFC][PATCH 7/7] ima: added new LSM conditions in the policy
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        safford@watson.ibm.com, tyhicks@linux.vnet.ibm.com,
        kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        casey@schaufler-ca.com, eparis@redhat.com, sds@tycho.nsa.gov,
        selinux@tycho.nsa.gov, viro@zeniv.linux.org.uk
In-Reply-To: <1303907657-18366-8-git-send-email-roberto.sassu@polito.it>
References: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it>
	 <1303907657-18366-8-git-send-email-roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 09:32:38 -0400
Message-ID: <1303997558.3139.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 14:34 +0200, Roberto Sassu wrote:
> The new parameters 'fowner_user', 'fowner_role' and 'fowner_type' are new
> LSM conditions that allow to measure inodes whose opened file descriptor
> has the label given as a value.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>

Nice. I really like the 'fowner_' prefix. If you don't object, I'll
change the ima-appraisal keyword from 'owner' to 'fowner' as well.

Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

thanks,

Mimi

> ---
>  Documentation/ABI/testing/ima_policy |    7 ++++-
>  security/integrity/ima/ima.h         |    4 +-
>  security/integrity/ima/ima_api.c     |    4 +-
>  security/integrity/ima/ima_main.c    |    4 +-
>  security/integrity/ima/ima_policy.c  |   45 +++++++++++++++++++++++++++++----
>  5 files changed, 51 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
> index 6cd6dae..ee49345 100644
> --- a/Documentation/ABI/testing/ima_policy
> +++ b/Documentation/ABI/testing/ima_policy
> @@ -18,7 +18,8 @@ Description:
>  		condition:= base | lsm
>  			base:	[[func=] [mask=] [fsmagic=] [uid=]]
>  			lsm:	[[subj_user=] [subj_role=] [subj_type=]
> -				 [obj_user=] [obj_role=] [obj_type=]]
> +				 [obj_user=] [obj_role=] [obj_type=]
> +				 [fowner_user=] [fowner_role=] [fowner_type=]]
> 
>  		base: 	func:= [BPRM_CHECK][FILE_MMAP][FILE_CHECK]
>  			mask:= [MAY_READ] [MAY_WRITE] [MAY_APPEND] [MAY_EXEC]
> @@ -46,6 +47,10 @@ Description:
>  		all files mmapped executable in file_mmap, and all files
>  		open for read by root in do_filp_open.
> 
> +		LSM conditions starting with obj_ refer to security attributes
> +		of inodes while those starting with fowner_ involve file
> +		descriptors.
> +
>  		Examples of LSM specific definitions:
> 
>  		SELinux:
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index 08408bd..3a05625 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -110,7 +110,7 @@ struct ima_iint_cache {
>  };
> 
>  /* LIM API function definitions */
> -int ima_must_measure(struct inode *inode, int mask, int function);
> +int ima_must_measure(struct file *file, int mask, int function);
>  int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file);
>  void ima_store_measurement(struct ima_iint_cache *iint, struct file *file,
>  			   const unsigned char *filename);
> @@ -128,7 +128,7 @@ struct ima_iint_cache *ima_iint_find(struct inode *inode);
>  /* IMA policy related functions */
>  enum ima_hooks { FILE_CHECK = 1, FILE_MMAP, BPRM_CHECK };
> 
> -int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask);
> +int ima_match_policy(struct file *file, enum ima_hooks func, int mask);
>  void ima_init_policy(void);
>  void ima_update_policy(void);
>  ssize_t ima_parse_add_rule(char *);
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index da36d2c..d815392 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -108,11 +108,11 @@ err_out:
>   * Return 0 to measure. For matching a DONT_MEASURE policy, no policy,
>   * or other error, return an error code.
>  */
> -int ima_must_measure(struct inode *inode, int mask, int function)
> +int ima_must_measure(struct file *file, int mask, int function)
>  {
>  	int must_measure;
> 
> -	must_measure = ima_match_policy(inode, function, mask);
> +	must_measure = ima_match_policy(file, function, mask);
>  	return must_measure ? 0 : -EACCES;
>  }
> 
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 39d66dc..9eaca61 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -65,7 +65,7 @@ static void ima_rdwr_violation_check(struct file *file)
>  		goto out;
>  	}
> 
> -	rc = ima_must_measure(inode, MAY_READ, FILE_CHECK);
> +	rc = ima_must_measure(file, MAY_READ, FILE_CHECK);
>  	if (rc < 0)
>  		goto out;
> 
> @@ -127,7 +127,7 @@ static int process_measurement(struct file *file, const unsigned char *filename,
>  	if (!ima_initialized || !S_ISREG(inode->i_mode))
>  		return 0;
> 
> -	rc = ima_must_measure(inode, mask, function);
> +	rc = ima_must_measure(file, mask, function);
>  	if (rc != 0)
>  		return rc;
>  retry:
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index d661afb..115c2e7 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -27,9 +27,10 @@
> 
>  enum ima_action { UNKNOWN = -1, DONT_MEASURE = 0, MEASURE };
> 
> -#define MAX_LSM_RULES 6
> +#define MAX_LSM_RULES 9
>  enum lsm_rule_types { LSM_OBJ_USER, LSM_OBJ_ROLE, LSM_OBJ_TYPE,
> -	LSM_SUBJ_USER, LSM_SUBJ_ROLE, LSM_SUBJ_TYPE
> +	LSM_SUBJ_USER, LSM_SUBJ_ROLE, LSM_SUBJ_TYPE,
> +	LSM_FOWNER_USER, LSM_FOWNER_ROLE, LSM_FOWNER_TYPE
>  };
> 
>  struct ima_measure_rule_entry {
> @@ -96,9 +97,10 @@ __setup("ima_tcb", default_policy_setup);
>   * Returns true on rule match, false on failure.
>   */
>  static bool ima_match_rules(struct ima_measure_rule_entry *rule,
> -			    struct inode *inode, enum ima_hooks func, int mask)
> +			    struct file *file, enum ima_hooks func, int mask)
>  {
>  	struct task_struct *tsk = current;
> +	struct inode *inode = file->f_dentry->d_inode;
>  	int i;
> 
>  	if ((rule->flags & IMA_FUNC) && rule->func != func)
> @@ -112,7 +114,7 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
>  		return false;
>  	for (i = 0; i < MAX_LSM_RULES; i++) {
>  		int rc = 0;
> -		u32 osid, sid;
> +		u32 osid, sid, fsid;
> 
>  		if (!rule->lsm[i].rule)
>  			continue;
> @@ -137,6 +139,15 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
>  							Audit_equal,
>  							rule->lsm[i].rule,
>  							NULL);
> +		case LSM_FOWNER_USER:
> +		case LSM_FOWNER_ROLE:
> +		case LSM_FOWNER_TYPE:
> +			security_file_getsecid(file, &fsid);
> +			rc = security_filter_rule_match(fsid,
> +							rule->lsm[i].type,
> +							Audit_equal,
> +							rule->lsm[i].rule,
> +							NULL);
>  		default:
>  			break;
>  		}
> @@ -159,14 +170,14 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
>   * as elements in the list are never deleted, nor does the list
>   * change.)
>   */
> -int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask)
> +int ima_match_policy(struct file *file, enum ima_hooks func, int mask)
>  {
>  	struct ima_measure_rule_entry *entry;
> 
>  	list_for_each_entry(entry, ima_measure, list) {
>  		bool rc;
> 
> -		rc = ima_match_rules(entry, inode, func, mask);
> +		rc = ima_match_rules(entry, file, func, mask);
>  		if (rc)
>  			return entry->action;
>  	}
> @@ -222,6 +233,7 @@ enum {
>  	Opt_measure = 1, Opt_dont_measure,
>  	Opt_obj_user, Opt_obj_role, Opt_obj_type,
>  	Opt_subj_user, Opt_subj_role, Opt_subj_type,
> +	Opt_fowner_user, Opt_fowner_role, Opt_fowner_type,
>  	Opt_func, Opt_mask, Opt_fsmagic, Opt_uid
>  };
> 
> @@ -234,6 +246,9 @@ static match_table_t policy_tokens = {
>  	{Opt_subj_user, "subj_user=%s"},
>  	{Opt_subj_role, "subj_role=%s"},
>  	{Opt_subj_type, "subj_type=%s"},
> +	{Opt_fowner_user, "fowner_user=%s"},
> +	{Opt_fowner_role, "fowner_role=%s"},
> +	{Opt_fowner_type, "fowner_type=%s"},
>  	{Opt_func, "func=%s"},
>  	{Opt_mask, "mask=%s"},
>  	{Opt_fsmagic, "fsmagic=%s"},
> @@ -407,6 +422,24 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
>  						   LSM_SUBJ_TYPE,
>  						   AUDIT_SUBJ_TYPE);
>  			break;
> +		case Opt_fowner_user:
> +			ima_log_string(ab, "fowner_user", args[0].from);
> +			result = ima_lsm_rule_init(entry, args[0].from,
> +						   LSM_FOWNER_USER,
> +						   AUDIT_SUBJ_USER);
> +			break;
> +		case Opt_fowner_role:
> +			ima_log_string(ab, "fowner_role", args[0].from);
> +			result = ima_lsm_rule_init(entry, args[0].from,
> +						   LSM_FOWNER_ROLE,
> +						   AUDIT_SUBJ_ROLE);
> +			break;
> +		case Opt_fowner_type:
> +			ima_log_string(ab, "fowner_type", args[0].from);
> +			result = ima_lsm_rule_init(entry, args[0].from,
> +						   LSM_FOWNER_TYPE,
> +						   AUDIT_SUBJ_TYPE);
> +			break;
>  		case Opt_err:
>  			ima_log_string(ab, "UNKNOWN", p);
>  			result = -EINVAL;


