Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab1AQQVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 11:21:39 -0500
Received: from smtp107.prem.mail.sp1.yahoo.com ([98.136.44.62]:49110 "HELO
	smtp107.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753236Ab1AQQVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 11:21:36 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: NER0L3UVM1mfBFjDk.ZZ4sc8ZpFPLRs9LHwElsn6.itPdbG
 5ETL36LuAwVxqhFQODJiLAjiQfpyk4q15MEOydvbMCjIbcaas91pir9cG0ZQ
 ebBm_NJI7Z0IDawMqtp1CGcAXjukxaGnpboZuU_Nzi_k0tsVHA2ATiRI5swz
 GUpQp_3qTOpGwljO_SkWILTxHPgUiLidKt.535fnW4yev0xqarZ1_vRJapio
 KkPNMeZmjVa5IWwo1SBLe5VkFgDA13g.rG3lZO4_c0r3HByNK3dZMhJErH9r
 nIYkPWivLHIBey5pQKgtQQw9WqLnF0XjyT55VIqLV
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4D346C8E.3080408@schaufler-ca.com>
Date: Mon, 17 Jan 2011 08:21:34 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "Sakkinen Jarkko.2 \(EXT-Tieto/Tampere\)" 
	<ext-jarkko.2.sakkinen@nokia.com>,
        Janne Karhunen <Janne.Karhunen@nokia.com>,
        "Reshetova Elena \(Nokia-D/Helsinki\)" <elena.reshetova@nokia.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Subject: [PATCH] Smack: mmap controls for library containment
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] Smack: mmap controls for library containment

  Applied to master branch of:

    git://gitorious.org/smack-next/kernel.git

  James, would you please pull for security-testing#next?
  
  In the embedded world there are often situations
  where libraries are updated from a variety of sources,
  for a variety of reasons, and with any number of
  security characteristics. These differences
  might include privilege required for a given library
  provided interface to function properly, as occurs
  from time to time in graphics libraries. There are
  also cases where it is important to limit use of
  libraries based on the provider of the library and
  the security aware application may make choices
  based on that criteria.

  These issues are addressed by providing an additional
  Smack label that may optionally be assigned to an object,
  the SMACK64MMAP attribute. An mmap operation is allowed
  if there is no such attribute.

  If there is a SMACK64MMAP attribute the mmap is permitted
  only if a subject with that label has all of the access
  permitted a subject with the current task label.

  Security aware applications may from time to time
  wish to reduce their "privilege" to avoid accidental use
  of privilege. One case where this arises is the
  environment in which multiple sources provide libraries
  to perform the same functions. An application may know
  that it should eschew services made available from a
  particular vendor, or of a particular version.

  In support of this a secondary list of Smack rules has
  been added that is local to the task. This list is
  consulted only in the case where the global list has
  approved access. It can only further restrict access.
  Unlike the global last, if no entry is found on the
  local list access is granted. An application can add
  entries to its own list by writing to /smack/load-self.

  The changes appear large as they involve refactoring
  the list handling to accomodate there being more
  than one rule list.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 include/linux/xattr.h         |    2 +
 security/smack/smack.h        |    9 +-
 security/smack/smack_access.c |   52 ++++--
 security/smack/smack_lsm.c    |  269 +++++++++++++++++++++++++-----
 security/smack/smackfs.c      |  370 ++++++++++++++++++++++++++++-------------
 5 files changed, 524 insertions(+), 178 deletions(-)
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index e6131ef..6050783 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -42,11 +42,13 @@
 #define XATTR_SMACK_IPOUT "SMACK64IPOUT"
 #define XATTR_SMACK_EXEC "SMACK64EXEC"
 #define XATTR_SMACK_TRANSMUTE "SMACK64TRANSMUTE"
+#define XATTR_SMACK_MMAP "SMACK64MMAP"
 #define XATTR_NAME_SMACK XATTR_SECURITY_PREFIX XATTR_SMACK_SUFFIX
 #define XATTR_NAME_SMACKIPIN	XATTR_SECURITY_PREFIX XATTR_SMACK_IPIN
 #define XATTR_NAME_SMACKIPOUT	XATTR_SECURITY_PREFIX XATTR_SMACK_IPOUT
 #define XATTR_NAME_SMACKEXEC	XATTR_SECURITY_PREFIX XATTR_SMACK_EXEC
 #define XATTR_NAME_SMACKTRANSMUTE XATTR_SECURITY_PREFIX XATTR_SMACK_TRANSMUTE
+#define XATTR_NAME_SMACKMMAP XATTR_SECURITY_PREFIX XATTR_SMACK_MMAP
 
 #define XATTR_CAPS_SUFFIX "capability"
 #define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
diff --git a/security/smack/smack.h b/security/smack/smack.h
index 129c4eb..e365d45 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -52,13 +52,16 @@ struct socket_smack {
 struct inode_smack {
 	char		*smk_inode;	/* label of the fso */
 	char		*smk_task;	/* label of the task */
+	char		*smk_mmap;	/* label of the mmap domain */
 	struct mutex	smk_lock;	/* initialization lock */
 	int		smk_flags;	/* smack inode flags */
 };
 
 struct task_smack {
-	char		*smk_task;	/* label used for access control */
-	char		*smk_forked;	/* label when forked */
+	char			*smk_task;	/* label for access control */
+	char			*smk_forked;	/* label when forked */
+	struct list_head	smk_rules;	/* per task access rules */
+	struct mutex		smk_rules_lock;	/* lock for the rules */
 };
 
 #define	SMK_INODE_INSTANT	0x01	/* inode is instantiated */
@@ -202,7 +205,7 @@ struct inode_smack *new_inode_smack(char *);
 /*
  * These functions are in smack_access.c
  */
-int smk_access_entry(char *, char *);
+int smk_access_entry(char *, char *, struct list_head *);
 int smk_access(char *, char *, int, struct smk_audit_info *);
 int smk_curacc(char *, u32, struct smk_audit_info *);
 int smack_to_cipso(const char *, struct smack_cipso *);
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 7ba8478..86453db 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -70,10 +70,11 @@ int log_policy = SMACK_AUDIT_DENIED;
  * smk_access_entry - look up matching access rule
  * @subject_label: a pointer to the subject's Smack label
  * @object_label: a pointer to the object's Smack label
+ * @rule_list: the list of rules to search
  *
  * This function looks up the subject/object pair in the
- * access rule list and returns pointer to the matching rule if found,
- * NULL otherwise.
+ * access rule list and returns the access mode. If no
+ * entry is found returns -ENOENT.
  *
  * NOTE:
  * Even though Smack labels are usually shared on smack_list
@@ -85,13 +86,13 @@ int log_policy = SMACK_AUDIT_DENIED;
  * will be on the list, so checking the pointers may be a worthwhile
  * optimization.
  */
-int smk_access_entry(char *subject_label, char *object_label)
+int smk_access_entry(char *subject_label, char *object_label,
+			struct list_head *rule_list)
 {
-	u32 may = MAY_NOT;
+	int may = -ENOENT;
 	struct smack_rule *srp;
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(srp, &smack_rule_list, list) {
+	list_for_each_entry_rcu(srp, rule_list, list) {
 		if (srp->smk_subject == subject_label ||
 		    strcmp(srp->smk_subject, subject_label) == 0) {
 			if (srp->smk_object == object_label ||
@@ -101,7 +102,6 @@ int smk_access_entry(char *subject_label, char *object_label)
 			}
 		}
 	}
-	rcu_read_unlock();
 
 	return may;
 }
@@ -129,7 +129,7 @@ int smk_access_entry(char *subject_label, char *object_label)
 int smk_access(char *subject_label, char *object_label, int request,
 	       struct smk_audit_info *a)
 {
-	u32 may = MAY_NOT;
+	int may = MAY_NOT;
 	int rc = 0;
 
 	/*
@@ -181,13 +181,14 @@ int smk_access(char *subject_label, char *object_label, int request,
 	 * Beyond here an explicit relationship is required.
 	 * If the requested access is contained in the available
 	 * access (e.g. read is included in readwrite) it's
-	 * good.
-	 */
-	may = smk_access_entry(subject_label, object_label);
-	/*
-	 * This is a bit map operation.
+	 * good. A negative response from smk_access_entry()
+	 * indicates there is no entry for this pair.
 	 */
-	if ((request & may) == request)
+	rcu_read_lock();
+	may = smk_access_entry(subject_label, object_label, &smack_rule_list);
+	rcu_read_unlock();
+
+	if (may > 0 && (request & may) == request)
 		goto out_audit;
 
 	rc = -EACCES;
@@ -212,12 +213,27 @@ out_audit:
  */
 int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
 {
+	struct task_smack *tsp = current_security();
+	char *sp = smk_of_task(tsp);
+	int may;
 	int rc;
-	char *sp = smk_of_current();
 
+	/*
+	 * Check the global rule list
+	 */
 	rc = smk_access(sp, obj_label, mode, NULL);
-	if (rc == 0)
-		goto out_audit;
+	if (rc == 0) {
+		/*
+		 * If there is an entry in the task's rule list
+		 * it can further restrict access.
+		 */
+		may = smk_access_entry(sp, obj_label, &tsp->smk_rules);
+		if (may < 0)
+			goto out_audit;
+		if ((mode & may) == mode)
+			goto out_audit;
+		rc = -EACCES;
+	}
 
 	/*
 	 * Return if a specific label has been designated as the
@@ -228,7 +244,7 @@ int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
 		goto out_audit;
 
 	if (capable(CAP_MAC_OVERRIDE))
-		return 0;
+		rc = 0;
 
 out_audit:
 #ifdef CONFIG_AUDIT
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 533bf32..123a499 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -84,6 +84,56 @@ struct inode_smack *new_inode_smack(char *smack)
 	return isp;
 }
 
+/**
+ * new_task_smack - allocate a task security blob
+ * @smack: a pointer to the Smack label to use in the blob
+ *
+ * Returns the new blob or NULL if there's no memory available
+ */
+static struct task_smack *new_task_smack(char *task, char *forked, gfp_t gfp)
+{
+	struct task_smack *tsp;
+
+	tsp = kzalloc(sizeof(struct task_smack), gfp);
+	if (tsp == NULL)
+		return NULL;
+
+	tsp->smk_task = task;
+	tsp->smk_forked = forked;
+	INIT_LIST_HEAD(&tsp->smk_rules);
+	mutex_init(&tsp->smk_rules_lock);
+
+	return tsp;
+}
+
+/**
+ * smk_copy_rules - copy a rule set
+ * @nhead - new rules header pointer
+ * @ohead - old rules header pointer
+ *
+ * Returns 0 on success, -ENOMEM on error
+ */
+static int smk_copy_rules(struct list_head *nhead, struct list_head *ohead,
+				gfp_t gfp)
+{
+	struct smack_rule *nrp;
+	struct smack_rule *orp;
+	int rc = 0;
+
+	INIT_LIST_HEAD(nhead);
+
+	list_for_each_entry_rcu(orp, ohead, list) {
+		nrp = kzalloc(sizeof(struct smack_rule), gfp);
+		if (nrp == NULL) {
+			rc = -ENOMEM;
+			break;
+		}
+		*nrp = *orp;
+		list_add_rcu(&nrp->list, nhead);
+	}
+	return rc;
+}
+
 /*
  * LSM hooks.
  * We he, that is fun!
@@ -102,23 +152,17 @@ static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
 {
 	int rc;
 	struct smk_audit_info ad;
-	char *sp, *tsp;
+	char *tsp;
 
 	rc = cap_ptrace_access_check(ctp, mode);
 	if (rc != 0)
 		return rc;
 
-	sp = smk_of_current();
 	tsp = smk_of_task(task_security(ctp));
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, ctp);
 
-	/* we won't log here, because rc can be overriden */
-	rc = smk_access(sp, tsp, MAY_READWRITE, NULL);
-	if (rc != 0 && capable(CAP_MAC_OVERRIDE))
-		rc = 0;
-
-	smack_log(sp, tsp, MAY_READWRITE, rc, &ad);
+	rc = smk_curacc(tsp, MAY_READWRITE, &ad);
 	return rc;
 }
 
@@ -134,23 +178,17 @@ static int smack_ptrace_traceme(struct task_struct *ptp)
 {
 	int rc;
 	struct smk_audit_info ad;
-	char *sp, *tsp;
+	char *tsp;
 
 	rc = cap_ptrace_traceme(ptp);
 	if (rc != 0)
 		return rc;
 
+	tsp = smk_of_task(task_security(ptp));
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, ptp);
 
-	sp = smk_of_current();
-	tsp = smk_of_task(task_security(ptp));
-	/* we won't log here, because rc can be overriden */
-	rc = smk_access(tsp, sp, MAY_READWRITE, NULL);
-	if (rc != 0 && has_capability(ptp, CAP_MAC_OVERRIDE))
-		rc = 0;
-
-	smack_log(tsp, sp, MAY_READWRITE, rc, &ad);
+	rc = smk_curacc(tsp, MAY_READWRITE, &ad);
 	return rc;
 }
 
@@ -474,7 +512,7 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 {
 	char *isp = smk_of_inode(inode);
 	char *dsp = smk_of_inode(dir);
-	u32 may;
+	int may;
 
 	if (name) {
 		*name = kstrdup(XATTR_SMACK_SUFFIX, GFP_KERNEL);
@@ -483,14 +521,17 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 	}
 
 	if (value) {
-		may = smk_access_entry(smk_of_current(), dsp);
+		rcu_read_lock();
+		may = smk_access_entry(smk_of_current(), dsp, &smack_rule_list);
+		rcu_read_unlock();
 
 		/*
 		 * If the access rule allows transmutation and
 		 * the directory requests transmutation then
 		 * by all means transmute.
 		 */
-		if (((may & MAY_TRANSMUTE) != 0) && smk_inode_transmutable(dir))
+		if (may > 0 && ((may & MAY_TRANSMUTE) != 0) &&
+		    smk_inode_transmutable(dir))
 			isp = dsp;
 
 		*value = kstrdup(isp, GFP_KERNEL);
@@ -716,7 +757,8 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
 	if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
 	    strcmp(name, XATTR_NAME_SMACKIPIN) == 0 ||
 	    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0 ||
-	    strcmp(name, XATTR_NAME_SMACKEXEC) == 0) {
+	    strcmp(name, XATTR_NAME_SMACKEXEC) == 0 ||
+	    strcmp(name, XATTR_NAME_SMACKMMAP) == 0) {
 		if (!capable(CAP_MAC_ADMIN))
 			rc = -EPERM;
 		/*
@@ -773,6 +815,12 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
 			isp->smk_task = nsp;
 		else
 			isp->smk_task = smack_known_invalid.smk_known;
+	} else if (strcmp(name, XATTR_NAME_SMACKMMAP) == 0) {
+		nsp = smk_import(value, size);
+		if (nsp != NULL)
+			isp->smk_mmap = nsp;
+		else
+			isp->smk_mmap = smack_known_invalid.smk_known;
 	} else if (strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0)
 		isp->smk_flags |= SMK_INODE_TRANSMUTE;
 
@@ -815,7 +863,8 @@ static int smack_inode_removexattr(struct dentry *dentry, const char *name)
 	    strcmp(name, XATTR_NAME_SMACKIPIN) == 0 ||
 	    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0 ||
 	    strcmp(name, XATTR_NAME_SMACKEXEC) == 0 ||
-	    strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0) {
+	    strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0 ||
+	    strcmp(name, XATTR_NAME_SMACKMMAP)) {
 		if (!capable(CAP_MAC_ADMIN))
 			rc = -EPERM;
 	} else
@@ -829,6 +878,7 @@ static int smack_inode_removexattr(struct dentry *dentry, const char *name)
 	if (rc == 0) {
 		isp = dentry->d_inode->i_security;
 		isp->smk_task = NULL;
+		isp->smk_mmap = NULL;
 	}
 
 	return rc;
@@ -1060,6 +1110,113 @@ static int smack_file_fcntl(struct file *file, unsigned int cmd,
 }
 
 /**
+ * smk_mmap_list_check - the mmap check
+ * @sub: subject label
+ * @obj: object label
+ * @access: access mode
+ * @local: the task specific rule list
+ *
+ * Returns 0 if acces is permitted, -EACCES otherwise
+ */
+static int smk_mmap_list_check(char *sub, char *obj, int access,
+				struct list_head *local)
+{
+	int may;
+
+	/*
+	 * If there is not a global rule that
+	 * allows access say no.
+	 */
+	may = smk_access_entry(sub, obj, &smack_rule_list);
+	if (may == -ENOENT || (may & access) != access)
+		return -EACCES;
+	/*
+	 * If there is a task local rule that
+	 * denies access say no.
+	 */
+	may = smk_access_entry(sub, obj, local);
+	if (may != -ENOENT && (may & access) != access)
+		return -EACCES;
+
+	return 0;
+}
+
+/**
+ * smack_file_mmap :
+ * Check permissions for a mmap operation.  The @file may be NULL, e.g.
+ * if mapping anonymous memory.
+ * @file contains the file structure for file to map (may be NULL).
+ * @reqprot contains the protection requested by the application.
+ * @prot contains the protection that will be applied by the kernel.
+ * @flags contains the operational flags.
+ * Return 0 if permission is granted.
+ */
+static int smack_file_mmap(struct file *file,
+			   unsigned long reqprot, unsigned long prot,
+			   unsigned long flags, unsigned long addr,
+			   unsigned long addr_only)
+{
+	struct smack_rule *srp;
+	struct task_smack *tsp;
+	char *sp;
+	char *msmack;
+	struct inode_smack *isp;
+	struct dentry *dp;
+	int rc;
+
+	/* do DAC check on address space usage */
+	rc = cap_file_mmap(file, reqprot, prot, flags, addr, addr_only);
+	if (rc || addr_only)
+		return rc;
+
+	if (file == NULL || file->f_dentry == NULL)
+		return 0;
+
+	dp = file->f_dentry;
+
+	if (dp->d_inode == NULL)
+		return 0;
+
+	isp = dp->d_inode->i_security;
+	if (isp->smk_mmap == NULL)
+		return 0;
+	msmack = isp->smk_mmap;
+
+	tsp = current_security();
+	sp = smk_of_current();
+	rc = 0;
+
+	rcu_read_lock();
+	/*
+	 * For each Smack rule associated with the subject
+	 * label verify that the SMACK64MMAP also has access
+	 * to that rule's object label.
+	 *
+	 * Because neither of the labels comes
+	 * from the networking code it is sufficient
+	 * to compare pointers.
+	 */
+	list_for_each_entry_rcu(srp, &smack_rule_list, list) {
+		if (srp->smk_subject != sp)
+			continue;
+		/*
+		 * Matching labels always allows access.
+		 */
+		if (msmack == srp->smk_object)
+			continue;
+
+		rc = smk_mmap_list_check(msmack, srp->smk_object,
+					 srp->smk_access, &tsp->smk_rules);
+		if (rc != 0)
+			break;
+	}
+
+	rcu_read_unlock();
+
+	return rc;
+}
+
+/**
  * smack_file_set_fowner - set the file security blob value
  * @file: object in question
  *
@@ -1095,6 +1252,7 @@ static int smack_file_send_sigiotask(struct task_struct *tsk,
 	 * struct fown_struct is never outside the context of a struct file
 	 */
 	file = container_of(fown, struct file, f_owner);
+
 	/* we don't log here as rc can be overriden */
 	rc = smk_access(file->f_security, tsp, MAY_WRITE, NULL);
 	if (rc != 0 && has_capability(tsk, CAP_MAC_OVERRIDE))
@@ -1145,9 +1303,14 @@ static int smack_file_receive(struct file *file)
  */
 static int smack_cred_alloc_blank(struct cred *cred, gfp_t gfp)
 {
-	cred->security = kzalloc(sizeof(struct task_smack), gfp);
-	if (cred->security == NULL)
+	struct task_smack *tsp;
+
+	tsp = new_task_smack(NULL, NULL, gfp);
+	if (tsp == NULL)
 		return -ENOMEM;
+
+	cred->security = tsp;
+
 	return 0;
 }
 
@@ -1156,13 +1319,24 @@ static int smack_cred_alloc_blank(struct cred *cred, gfp_t gfp)
  * smack_cred_free - "free" task-level security credentials
  * @cred: the credentials in question
  *
- * Smack isn't using copies of blobs. Everyone
- * points to an immutable list. The blobs never go away.
- * There is no leak here.
  */
 static void smack_cred_free(struct cred *cred)
 {
-	kfree(cred->security);
+	struct task_smack *tsp = cred->security;
+	struct smack_rule *rp;
+	struct list_head *l;
+	struct list_head *n;
+
+	if (tsp == NULL)
+		return;
+	cred->security = NULL;
+
+	list_for_each_safe(l, n, &tsp->smk_rules) {
+		rp = list_entry(l, struct smack_rule, list);
+		list_del(&rp->list);
+		kfree(rp);
+	}
+	kfree(tsp);
 }
 
 /**
@@ -1178,13 +1352,16 @@ static int smack_cred_prepare(struct cred *new, const struct cred *old,
 {
 	struct task_smack *old_tsp = old->security;
 	struct task_smack *new_tsp;
+	int rc;
 
-	new_tsp = kzalloc(sizeof(struct task_smack), gfp);
+	new_tsp = new_task_smack(old_tsp->smk_task, old_tsp->smk_task, gfp);
 	if (new_tsp == NULL)
 		return -ENOMEM;
 
-	new_tsp->smk_task = old_tsp->smk_task;
-	new_tsp->smk_forked = old_tsp->smk_task;
+	rc = smk_copy_rules(&new_tsp->smk_rules, &old_tsp->smk_rules, gfp);
+	if (rc != 0)
+		return rc;
+
 	new->security = new_tsp;
 	return 0;
 }
@@ -1203,6 +1380,11 @@ static void smack_cred_transfer(struct cred *new, const struct cred *old)
 
 	new_tsp->smk_task = old_tsp->smk_task;
 	new_tsp->smk_forked = old_tsp->smk_task;
+	mutex_init(&new_tsp->smk_rules_lock);
+	INIT_LIST_HEAD(&new_tsp->smk_rules);
+
+
+	/* cbs copy rule list */
 }
 
 /**
@@ -2419,6 +2601,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 			}
 		}
 		isp->smk_task = smk_fetch(XATTR_NAME_SMACKEXEC, inode, dp);
+		isp->smk_mmap = smk_fetch(XATTR_NAME_SMACKMMAP, inode, dp);
 
 		dput(dp);
 		break;
@@ -2478,6 +2661,7 @@ static int smack_getprocattr(struct task_struct *p, char *name, char **value)
 static int smack_setprocattr(struct task_struct *p, char *name,
 			     void *value, size_t size)
 {
+	int rc;
 	struct task_smack *tsp;
 	struct task_smack *oldtsp;
 	struct cred *new;
@@ -2513,13 +2697,16 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 	new = prepare_creds();
 	if (new == NULL)
 		return -ENOMEM;
-	tsp = kzalloc(sizeof(struct task_smack), GFP_KERNEL);
+
+	tsp = new_task_smack(newsmack, oldtsp->smk_forked, GFP_KERNEL);
 	if (tsp == NULL) {
 		kfree(new);
 		return -ENOMEM;
 	}
-	tsp->smk_task = newsmack;
-	tsp->smk_forked = oldtsp->smk_forked;
+	rc = smk_copy_rules(&tsp->smk_rules, &oldtsp->smk_rules, GFP_KERNEL);
+	if (rc != 0)
+		return rc;
+
 	new->security = tsp;
 	commit_creds(new);
 	return size;
@@ -3221,6 +3408,7 @@ struct security_operations smack_ops = {
 	.file_ioctl = 			smack_file_ioctl,
 	.file_lock = 			smack_file_lock,
 	.file_fcntl = 			smack_file_fcntl,
+	.file_mmap =			smack_file_mmap,
 	.file_set_fowner = 		smack_file_set_fowner,
 	.file_send_sigiotask = 		smack_file_send_sigiotask,
 	.file_receive = 		smack_file_receive,
@@ -3334,23 +3522,20 @@ static __init int smack_init(void)
 	struct cred *cred;
 	struct task_smack *tsp;
 
-	tsp = kzalloc(sizeof(struct task_smack), GFP_KERNEL);
+	if (!security_module_enable(&smack_ops))
+		return 0;
+
+	tsp = new_task_smack(smack_known_floor.smk_known,
+				smack_known_floor.smk_known, GFP_KERNEL);
 	if (tsp == NULL)
 		return -ENOMEM;
 
-	if (!security_module_enable(&smack_ops)) {
-		kfree(tsp);
-		return 0;
-	}
-
 	printk(KERN_INFO "Smack:  Initializing.\n");
 
 	/*
 	 * Set the security state for the initial task.
 	 */
 	cred = (struct cred *) current->cred;
-	tsp->smk_forked = smack_known_floor.smk_known;
-	tsp->smk_task = smack_known_floor.smk_known;
 	cred->security = tsp;
 
 	/* initialize the smack_know_list */
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 362d5ed..90d1bba 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -43,6 +43,7 @@ enum smk_inos {
 	SMK_NETLBLADDR	= 8,	/* single label hosts */
 	SMK_ONLYCAP	= 9,	/* the only "capable" label */
 	SMK_LOGGING	= 10,	/* logging */
+	SMK_LOAD_SELF	= 11,	/* task specific rules */
 };
 
 /*
@@ -135,104 +136,30 @@ static void smk_netlabel_audit_set(struct netlbl_audit *nap)
 #define SMK_NETLBLADDRMIN	9
 #define SMK_NETLBLADDRMAX	42
 
-/*
- * Seq_file read operations for /smack/load
- */
-
-static void *load_seq_start(struct seq_file *s, loff_t *pos)
-{
-	if (*pos == SEQ_READ_FINISHED)
-		return NULL;
-	if (list_empty(&smack_rule_list))
-		return NULL;
-	return smack_rule_list.next;
-}
-
-static void *load_seq_next(struct seq_file *s, void *v, loff_t *pos)
-{
-	struct list_head *list = v;
-
-	if (list_is_last(list, &smack_rule_list)) {
-		*pos = SEQ_READ_FINISHED;
-		return NULL;
-	}
-	return list->next;
-}
-
-static int load_seq_show(struct seq_file *s, void *v)
-{
-	struct list_head *list = v;
-	struct smack_rule *srp =
-		 list_entry(list, struct smack_rule, list);
-
-	seq_printf(s, "%s %s", (char *)srp->smk_subject,
-		   (char *)srp->smk_object);
-
-	seq_putc(s, ' ');
-
-	if (srp->smk_access & MAY_READ)
-		seq_putc(s, 'r');
-	if (srp->smk_access & MAY_WRITE)
-		seq_putc(s, 'w');
-	if (srp->smk_access & MAY_EXEC)
-		seq_putc(s, 'x');
-	if (srp->smk_access & MAY_APPEND)
-		seq_putc(s, 'a');
-	if (srp->smk_access & MAY_TRANSMUTE)
-		seq_putc(s, 't');
-	if (srp->smk_access == 0)
-		seq_putc(s, '-');
-
-	seq_putc(s, '\n');
-
-	return 0;
-}
-
-static void load_seq_stop(struct seq_file *s, void *v)
-{
-	/* No-op */
-}
-
-static const struct seq_operations load_seq_ops = {
-	.start = load_seq_start,
-	.next  = load_seq_next,
-	.show  = load_seq_show,
-	.stop  = load_seq_stop,
-};
-
-/**
- * smk_open_load - open() for /smack/load
- * @inode: inode structure representing file
- * @file: "load" file pointer
- *
- * For reading, use load_seq_* seq_file reading operations.
- */
-static int smk_open_load(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &load_seq_ops);
-}
-
 /**
  * smk_set_access - add a rule to the rule list
  * @srp: the new rule to add
+ * @rule_list: the list of rules
+ * @rule_lock: the rule list lock
  *
  * Looks through the current subject/object/access list for
  * the subject/object pair and replaces the access that was
  * there. If the pair isn't found add it with the specified
  * access.
  *
+ * Returns 1 if a rule was found to exist already, 0 if it is new
  * Returns 0 if nothing goes wrong or -ENOMEM if it fails
  * during the allocation of the new pair to add.
  */
-static int smk_set_access(struct smack_rule *srp)
+static int smk_set_access(struct smack_rule *srp, struct list_head *rule_list,
+				struct mutex *rule_lock)
 {
 	struct smack_rule *sp;
-	int ret = 0;
-	int found;
-	mutex_lock(&smack_list_lock);
+	int found = 0;
 
-	found = 0;
-	list_for_each_entry_rcu(sp, &smack_rule_list, list) {
+	mutex_lock(rule_lock);
+
+	list_for_each_entry_rcu(sp, rule_list, list) {
 		if (sp->smk_subject == srp->smk_subject &&
 		    sp->smk_object == srp->smk_object) {
 			found = 1;
@@ -241,19 +168,21 @@ static int smk_set_access(struct smack_rule *srp)
 		}
 	}
 	if (found == 0)
-		list_add_rcu(&srp->list, &smack_rule_list);
+		list_add_rcu(&srp->list, rule_list);
 
-	mutex_unlock(&smack_list_lock);
+	mutex_unlock(rule_lock);
 
-	return ret;
+	return found;
 }
 
 /**
- * smk_write_load - write() for /smack/load
+ * smk_write_load_list - write() for any /smack/load
  * @file: file pointer, not actually used
  * @buf: where to get the data from
  * @count: bytes sent
  * @ppos: where to start - must be 0
+ * @rule_list: the list of rules to write to
+ * @rule_lock: lock for the rule list
  *
  * Get one smack access rule from above.
  * The format is exactly:
@@ -263,21 +192,19 @@ static int smk_set_access(struct smack_rule *srp)
  *
  * writes must be SMK_LABELLEN+SMK_LABELLEN+SMK_ACCESSLEN bytes.
  */
-static ssize_t smk_write_load(struct file *file, const char __user *buf,
-			      size_t count, loff_t *ppos)
+static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos,
+				struct list_head *rule_list,
+				struct mutex *rule_lock)
 {
 	struct smack_rule *rule;
 	char *data;
 	int rc = -EINVAL;
 
 	/*
-	 * Must have privilege.
 	 * No partial writes.
 	 * Enough data must be present.
 	 */
-	if (!capable(CAP_MAC_ADMIN))
-		return -EPERM;
-
 	if (*ppos != 0)
 		return -EINVAL;
 	/*
@@ -372,11 +299,13 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 		goto out_free_rule;
 	}
 
-	rc = smk_set_access(rule);
-
-	if (!rc)
-		rc = count;
-	goto out;
+	rc = count;
+	/*
+	 * smk_set_access returns true if there was already a rule
+	 * for the subject/object pair, and false if it was new.
+	 */
+	if (!smk_set_access(rule, rule_list, rule_lock))
+		goto out;
 
 out_free_rule:
 	kfree(rule);
@@ -385,6 +314,108 @@ out:
 	return rc;
 }
 
+
+/*
+ * Seq_file read operations for /smack/load
+ */
+
+static void *load_seq_start(struct seq_file *s, loff_t *pos)
+{
+	if (*pos == SEQ_READ_FINISHED)
+		return NULL;
+	if (list_empty(&smack_rule_list))
+		return NULL;
+	return smack_rule_list.next;
+}
+
+static void *load_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct list_head *list = v;
+
+	if (list_is_last(list, &smack_rule_list)) {
+		*pos = SEQ_READ_FINISHED;
+		return NULL;
+	}
+	return list->next;
+}
+
+static int load_seq_show(struct seq_file *s, void *v)
+{
+	struct list_head *list = v;
+	struct smack_rule *srp =
+		 list_entry(list, struct smack_rule, list);
+
+	seq_printf(s, "%s %s", (char *)srp->smk_subject,
+		   (char *)srp->smk_object);
+
+	seq_putc(s, ' ');
+
+	if (srp->smk_access & MAY_READ)
+		seq_putc(s, 'r');
+	if (srp->smk_access & MAY_WRITE)
+		seq_putc(s, 'w');
+	if (srp->smk_access & MAY_EXEC)
+		seq_putc(s, 'x');
+	if (srp->smk_access & MAY_APPEND)
+		seq_putc(s, 'a');
+	if (srp->smk_access & MAY_TRANSMUTE)
+		seq_putc(s, 't');
+	if (srp->smk_access == 0)
+		seq_putc(s, '-');
+
+	seq_putc(s, '\n');
+
+	return 0;
+}
+
+static void load_seq_stop(struct seq_file *s, void *v)
+{
+	/* No-op */
+}
+
+static const struct seq_operations load_seq_ops = {
+	.start = load_seq_start,
+	.next  = load_seq_next,
+	.show  = load_seq_show,
+	.stop  = load_seq_stop,
+};
+
+/**
+ * smk_open_load - open() for /smack/load
+ * @inode: inode structure representing file
+ * @file: "load" file pointer
+ *
+ * For reading, use load_seq_* seq_file reading operations.
+ */
+static int smk_open_load(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &load_seq_ops);
+}
+
+/**
+ * smk_write_load - write() for /smack/load
+ * @file: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start - must be 0
+ *
+ */
+static ssize_t smk_write_load(struct file *file, const char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+
+	/*
+	 * Must have privilege.
+	 * No partial writes.
+	 * Enough data must be present.
+	 */
+	if (!capable(CAP_MAC_ADMIN))
+		return -EPERM;
+
+	return smk_write_load_list(file, buf, count, ppos, &smack_rule_list,
+					&smack_list_lock);
+}
+
 static const struct file_operations smk_load_ops = {
 	.open           = smk_open_load,
 	.read		= seq_read,
@@ -1288,6 +1319,112 @@ static const struct file_operations smk_logging_ops = {
 	.write		= smk_write_logging,
 	.llseek		= default_llseek,
 };
+
+/*
+ * Seq_file read operations for /smack/load-self
+ */
+
+static void *load_self_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct task_smack *tsp = current_security();
+
+	if (*pos == SEQ_READ_FINISHED)
+		return NULL;
+	if (list_empty(&tsp->smk_rules))
+		return NULL;
+	return tsp->smk_rules.next;
+}
+
+static void *load_self_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct task_smack *tsp = current_security();
+	struct list_head *list = v;
+
+	if (list_is_last(list, &tsp->smk_rules)) {
+		*pos = SEQ_READ_FINISHED;
+		return NULL;
+	}
+	return list->next;
+}
+
+static int load_self_seq_show(struct seq_file *s, void *v)
+{
+	struct list_head *list = v;
+	struct smack_rule *srp =
+		 list_entry(list, struct smack_rule, list);
+
+	seq_printf(s, "%s %s", (char *)srp->smk_subject,
+		   (char *)srp->smk_object);
+
+	seq_putc(s, ' ');
+
+	if (srp->smk_access & MAY_READ)
+		seq_putc(s, 'r');
+	if (srp->smk_access & MAY_WRITE)
+		seq_putc(s, 'w');
+	if (srp->smk_access & MAY_EXEC)
+		seq_putc(s, 'x');
+	if (srp->smk_access & MAY_APPEND)
+		seq_putc(s, 'a');
+	if (srp->smk_access & MAY_TRANSMUTE)
+		seq_putc(s, 't');
+	if (srp->smk_access == 0)
+		seq_putc(s, '-');
+
+	seq_putc(s, '\n');
+
+	return 0;
+}
+
+static void load_self_seq_stop(struct seq_file *s, void *v)
+{
+	/* No-op */
+}
+
+static const struct seq_operations load_self_seq_ops = {
+	.start = load_self_seq_start,
+	.next  = load_self_seq_next,
+	.show  = load_self_seq_show,
+	.stop  = load_self_seq_stop,
+};
+
+
+/**
+ * smk_open_load_self - open() for /smack/load-self
+ * @inode: inode structure representing file
+ * @file: "load" file pointer
+ *
+ * For reading, use load_seq_* seq_file reading operations.
+ */
+static int smk_open_load_self(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &load_self_seq_ops);
+}
+
+/**
+ * smk_write_load_self - write() for /smack/load-self
+ * @file: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start - must be 0
+ *
+ */
+static ssize_t smk_write_load_self(struct file *file, const char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	struct task_smack *tsp = current_security();
+
+	return smk_write_load_list(file, buf, count, ppos, &tsp->smk_rules,
+					&tsp->smk_rules_lock);
+}
+
+static const struct file_operations smk_load_self_ops = {
+	.open           = smk_open_load_self,
+	.read		= seq_read,
+	.llseek         = seq_lseek,
+	.write		= smk_write_load_self,
+	.release        = seq_release,
+};
 /**
  * smk_fill_super - fill the /smackfs superblock
  * @sb: the empty superblock
@@ -1304,23 +1441,26 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
 	struct inode *root_inode;
 
 	static struct tree_descr smack_files[] = {
-		[SMK_LOAD]	=
-			{"load", &smk_load_ops, S_IRUGO|S_IWUSR},
-		[SMK_CIPSO]	=
-			{"cipso", &smk_cipso_ops, S_IRUGO|S_IWUSR},
-		[SMK_DOI]	=
-			{"doi", &smk_doi_ops, S_IRUGO|S_IWUSR},
-		[SMK_DIRECT]	=
-			{"direct", &smk_direct_ops, S_IRUGO|S_IWUSR},
-		[SMK_AMBIENT]	=
-			{"ambient", &smk_ambient_ops, S_IRUGO|S_IWUSR},
-		[SMK_NETLBLADDR] =
-			{"netlabel", &smk_netlbladdr_ops, S_IRUGO|S_IWUSR},
-		[SMK_ONLYCAP]	=
-			{"onlycap", &smk_onlycap_ops, S_IRUGO|S_IWUSR},
-		[SMK_LOGGING]	=
-			{"logging", &smk_logging_ops, S_IRUGO|S_IWUSR},
-		/* last one */ {""}
+		[SMK_LOAD] = {
+			"load", &smk_load_ops, S_IRUGO|S_IWUSR},
+		[SMK_CIPSO] = {
+			"cipso", &smk_cipso_ops, S_IRUGO|S_IWUSR},
+		[SMK_DOI] = {
+			"doi", &smk_doi_ops, S_IRUGO|S_IWUSR},
+		[SMK_DIRECT] = {
+			"direct", &smk_direct_ops, S_IRUGO|S_IWUSR},
+		[SMK_AMBIENT] = {
+			"ambient", &smk_ambient_ops, S_IRUGO|S_IWUSR},
+		[SMK_NETLBLADDR] = {
+			"netlabel", &smk_netlbladdr_ops, S_IRUGO|S_IWUSR},
+		[SMK_ONLYCAP] = {
+			"onlycap", &smk_onlycap_ops, S_IRUGO|S_IWUSR},
+		[SMK_LOGGING] = {
+			"logging", &smk_logging_ops, S_IRUGO|S_IWUSR},
+		[SMK_LOAD_SELF] = {
+			"load-self", &smk_load_self_ops, S_IRUGO|S_IWUGO},
+		/* last one */
+			{""}
 	};
 
 	rc = simple_fill_super(sb, SMACK_MAGIC, smack_files);

