Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab0LGWbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 17:31:47 -0500
Received: from smtp106.prem.mail.sp1.yahoo.com ([98.136.44.61]:31467 "HELO
	smtp106.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754215Ab0LGWbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 17:31:45 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: fQy_AbEVM1lv6OPBd5ZQS1tPAVdAsIAIy5PPUz0XrG04LOY
 scWb5uWu_VSnRy8cTHXtHfd_6M3zffLBRYjX30i3LLsMlQcHn3T9AvpuW7Cm
 nP2_BnFyEwaq30W1XJLrh4evX.WDNo0YoFR.ELmTuQtGsYgp5Q_oF.GPlZo8
 jBU_e.lmqdRuaYufW78uijV7XqOSdlYwXHHRWTgWdPWSj7K.Y.ZrrjGSoCvx
 abeObizivi8vJ1rQUMNL5_i4McMCCHvdZCs.gH7o.gFvI60kGyfnrXxXoCMp
 FHu9PtxfmU1xjh0MP9aetDCgV2gjx4GnIB4stxJMm
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4CFEB5CF.5060205@schaufler-ca.com>
Date: Tue, 07 Dec 2010 14:31:43 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: Transmute labels on specified directories
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] Smack: Transmute labels on specified directories

Applied to master branch of:

  git://gitorious.org/smack-next/kernel.git

James, would you please pull for security-testing#next?
I believe that the sign-off is correct. 

In a situation where Smack access rules allow processes
with multiple labels to write to a directory it is easy
to get into a situation where the directory gets cluttered
with files that the owner can't deal with because while
they could be written to the directory a process at the
label of the directory can't write them. This is generally
the desired behavior, but when it isn't it is a real
issue.

This patch introduces a new attribute SMACK64TRANSMUTE that
instructs Smack to create the file with the label of the directory
under certain circumstances.

A new access mode, "t" for transmute, is made available to
Smack access rules, which are expanded from "rwxa" to "rwxat".
If a file is created in a directory marked as transmutable
and if access was granted to perform the operation by a rule
that included the transmute mode, then the file gets the
Smack label of the directory instead of the Smack label of the
creating process.

Note that this is equivalent to creating an empty file at the
label of the directory and then having the other process write
to it. The transmute scheme requires that both the access rule
allows transmutation and that the directory be explicitly marked.


Signed-off-by: Jarkko Sakkinen <ext-jarkko.2.sakkinen@nokia.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 include/linux/xattr.h         |    2 +
 security/smack/smack.h        |   17 +++++++++-
 security/smack/smack_access.c |   54 ++++++++++++++++++++++-------
 security/smack/smack_lsm.c    |   74 +++++++++++++++++++++++++++-------------
 security/smack/smackfs.c      |   37 +++++++++++++++++---
 5 files changed, 141 insertions(+), 43 deletions(-)

diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index 351c790..e6131ef 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -41,10 +41,12 @@
 #define XATTR_SMACK_IPIN "SMACK64IPIN"
 #define XATTR_SMACK_IPOUT "SMACK64IPOUT"
 #define XATTR_SMACK_EXEC "SMACK64EXEC"
+#define XATTR_SMACK_TRANSMUTE "SMACK64TRANSMUTE"
 #define XATTR_NAME_SMACK XATTR_SECURITY_PREFIX XATTR_SMACK_SUFFIX
 #define XATTR_NAME_SMACKIPIN	XATTR_SECURITY_PREFIX XATTR_SMACK_IPIN
 #define XATTR_NAME_SMACKIPOUT	XATTR_SECURITY_PREFIX XATTR_SMACK_IPOUT
 #define XATTR_NAME_SMACKEXEC	XATTR_SECURITY_PREFIX XATTR_SMACK_EXEC
+#define XATTR_NAME_SMACKTRANSMUTE XATTR_SECURITY_PREFIX XATTR_SMACK_TRANSMUTE
 
 #define XATTR_CAPS_SUFFIX "capability"
 #define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
diff --git a/security/smack/smack.h b/security/smack/smack.h
index a2e2cdf..129c4eb 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -62,6 +62,7 @@ struct task_smack {
 };
 
 #define	SMK_INODE_INSTANT	0x01	/* inode is instantiated */
+#define	SMK_INODE_TRANSMUTE	0x02	/* directory is transmuting */
 
 /*
  * A label access rule.
@@ -167,6 +168,10 @@ struct smack_known {
 #define SMACK_CIPSO_MAXCATNUM           239     /* CIPSO 2.2 standard */
 
 /*
+ * Flag for transmute access
+ */
+#define MAY_TRANSMUTE	64
+/*
  * Just to make the common cases easier to deal with
  */
 #define MAY_ANY		(MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
@@ -197,6 +202,7 @@ struct inode_smack *new_inode_smack(char *);
 /*
  * These functions are in smack_access.c
  */
+int smk_access_entry(char *, char *);
 int smk_access(char *, char *, int, struct smk_audit_info *);
 int smk_curacc(char *, u32, struct smk_audit_info *);
 int smack_to_cipso(const char *, struct smack_cipso *);
@@ -240,6 +246,15 @@ static inline void smack_catset_bit(int cat, char *catsetp)
 }
 
 /*
+ * Is the directory transmuting?
+ */
+static inline int smk_inode_transmutable(const struct inode *isp)
+{
+	struct inode_smack *sip = isp->i_security;
+	return (sip->smk_flags & SMK_INODE_TRANSMUTE) != 0;
+}
+
+/*
  * Present a pointer to the smack label in an inode blob.
  */
 static inline char *smk_of_inode(const struct inode *isp)
@@ -265,7 +280,7 @@ static inline char *smk_of_forked(const struct task_smack *tsp)
 }
 
 /*
- * Present a pointer to the smack label in the curren task blob.
+ * Present a pointer to the smack label in the current task blob.
  */
 static inline char *smk_of_current(void)
 {
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 42becbc..7ba8478 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -67,6 +67,46 @@ static u32 smack_next_secid = 10;
 int log_policy = SMACK_AUDIT_DENIED;
 
 /**
+ * smk_access_entry - look up matching access rule
+ * @subject_label: a pointer to the subject's Smack label
+ * @object_label: a pointer to the object's Smack label
+ *
+ * This function looks up the subject/object pair in the
+ * access rule list and returns pointer to the matching rule if found,
+ * NULL otherwise.
+ *
+ * NOTE:
+ * Even though Smack labels are usually shared on smack_list
+ * labels that come in off the network can't be imported
+ * and added to the list for locking reasons.
+ *
+ * Therefore, it is necessary to check the contents of the labels,
+ * not just the pointer values. Of course, in most cases the labels
+ * will be on the list, so checking the pointers may be a worthwhile
+ * optimization.
+ */
+int smk_access_entry(char *subject_label, char *object_label)
+{
+	u32 may = MAY_NOT;
+	struct smack_rule *srp;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(srp, &smack_rule_list, list) {
+		if (srp->smk_subject == subject_label ||
+		    strcmp(srp->smk_subject, subject_label) == 0) {
+			if (srp->smk_object == object_label ||
+			    strcmp(srp->smk_object, object_label) == 0) {
+				may = srp->smk_access;
+				break;
+			}
+		}
+	}
+	rcu_read_unlock();
+
+	return may;
+}
+
+/**
  * smk_access - determine if a subject has a specific access to an object
  * @subject_label: a pointer to the subject's Smack label
  * @object_label: a pointer to the object's Smack label
@@ -90,7 +130,6 @@ int smk_access(char *subject_label, char *object_label, int request,
 	       struct smk_audit_info *a)
 {
 	u32 may = MAY_NOT;
-	struct smack_rule *srp;
 	int rc = 0;
 
 	/*
@@ -144,18 +183,7 @@ int smk_access(char *subject_label, char *object_label, int request,
 	 * access (e.g. read is included in readwrite) it's
 	 * good.
 	 */
-	rcu_read_lock();
-	list_for_each_entry_rcu(srp, &smack_rule_list, list) {
-		if (srp->smk_subject == subject_label ||
-		    strcmp(srp->smk_subject, subject_label) == 0) {
-			if (srp->smk_object == object_label ||
-			    strcmp(srp->smk_object, object_label) == 0) {
-				may = srp->smk_access;
-				break;
-			}
-		}
-	}
-	rcu_read_unlock();
+	may = smk_access_entry(subject_label, object_label);
 	/*
 	 * This is a bit map operation.
 	 */
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 7e19afe..05dc4da 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3,12 +3,14 @@
  *
  *  This file contains the smack hook function implementations.
  *
- *  Author:
+ *  Authors:
  *	Casey Schaufler <casey@schaufler-ca.com>
+ *	Jarkko Sakkinen <ext-jarkko.2.sakkinen@nokia.com>
  *
  *  Copyright (C) 2007 Casey Schaufler <casey@schaufler-ca.com>
  *  Copyright (C) 2009 Hewlett-Packard Development Company, L.P.
  *                Paul Moore <paul.moore@hp.com>
+ *  Copyright (C) 2010 Nokia Corporation
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License version 2,
@@ -35,6 +37,9 @@
 
 #define task_security(task)	(task_cred_xxx((task), security))
 
+#define TRANS_TRUE	"TRUE"
+#define TRANS_TRUE_SIZE	4
+
 /**
  * smk_fetch - Fetch the smack label from a file.
  * @ip: a pointer to the inode
@@ -468,6 +473,8 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 				     char **name, void **value, size_t *len)
 {
 	char *isp = smk_of_inode(inode);
+	char *dsp = smk_of_inode(dir);
+	u32 may;
 
 	if (name) {
 		*name = kstrdup(XATTR_SMACK_SUFFIX, GFP_KERNEL);
@@ -476,6 +483,16 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 	}
 
 	if (value) {
+		may = smk_access_entry(smk_of_current(), dsp);
+
+		/*
+		 * If the access rule allows transmutation and
+		 * the directory requests transmutation then
+		 * by all means transmute.
+		 */
+		if (((may & MAY_TRANSMUTE) != 0) && smk_inode_transmutable(dir))
+			isp = dsp;
+
 		*value = kstrdup(isp, GFP_KERNEL);
 		if (*value == NULL)
 			return -ENOMEM;
@@ -709,6 +726,12 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
 		if (size == 0 || size >= SMK_LABELLEN ||
 		    smk_import(value, size) == NULL)
 			rc = -EINVAL;
+	} else if (strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0) {
+		if (!capable(CAP_MAC_ADMIN))
+			rc = -EPERM;
+		if (size != TRANS_TRUE_SIZE ||
+		    strncmp(value, TRANS_TRUE, TRANS_TRUE_SIZE) != 0)
+			rc = -EINVAL;
 	} else
 		rc = cap_inode_setxattr(dentry, name, value, size, flags);
 
@@ -735,35 +758,23 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
 static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
 				      const void *value, size_t size, int flags)
 {
-	struct inode_smack *isp;
 	char *nsp;
-
-	/*
-	 * Not SMACK or SMACKEXEC
-	 */
-	if (strcmp(name, XATTR_NAME_SMACK) &&
-	    strcmp(name, XATTR_NAME_SMACKEXEC))
-		return;
-
-	isp = dentry->d_inode->i_security;
-
-	/*
-	 * No locking is done here. This is a pointer
-	 * assignment.
-	 */
-	nsp = smk_import(value, size);
+	struct inode_smack *isp = dentry->d_inode->i_security;
 
 	if (strcmp(name, XATTR_NAME_SMACK) == 0) {
+		nsp = smk_import(value, size);
 		if (nsp != NULL)
 			isp->smk_inode = nsp;
 		else
 			isp->smk_inode = smack_known_invalid.smk_known;
-	} else {
+	} else if (strcmp(name, XATTR_NAME_SMACKEXEC) == 0) {
+		nsp = smk_import(value, size);
 		if (nsp != NULL)
 			isp->smk_task = nsp;
 		else
 			isp->smk_task = smack_known_invalid.smk_known;
-	}
+	} else if (strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0)
+		isp->smk_flags |= SMK_INODE_TRANSMUTE;
 
 	return;
 }
@@ -803,7 +814,8 @@ static int smack_inode_removexattr(struct dentry *dentry, const char *name)
 	if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
 	    strcmp(name, XATTR_NAME_SMACKIPIN) == 0 ||
 	    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0 ||
-	    strcmp(name, XATTR_NAME_SMACKEXEC) == 0) {
+	    strcmp(name, XATTR_NAME_SMACKEXEC) == 0 ||
+	    strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0) {
 		if (!capable(CAP_MAC_ADMIN))
 			rc = -EPERM;
 	} else
@@ -2274,6 +2286,8 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 	char *csp = smk_of_current();
 	char *fetched;
 	char *final;
+	char trattr[TRANS_TRUE_SIZE];
+	int transflag = 0;
 	struct dentry *dp;
 
 	if (inode == NULL)
@@ -2392,10 +2406,19 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 		 */
 		dp = dget(opt_dentry);
 		fetched = smk_fetch(XATTR_NAME_SMACK, inode, dp);
-		if (fetched != NULL)
+		if (fetched != NULL) {
 			final = fetched;
-		isp->smk_task = smk_fetch(XATTR_NAME_SMACKEXEC, inode,
-					  dp);
+			if (S_ISDIR(inode->i_mode)) {
+				trattr[0] = '\0';
+				inode->i_op->getxattr(dp,
+					XATTR_NAME_SMACKTRANSMUTE,
+					trattr, TRANS_TRUE_SIZE);
+				if (strncmp(trattr, TRANS_TRUE,
+					    TRANS_TRUE_SIZE) == 0)
+					transflag = SMK_INODE_TRANSMUTE;
+			}
+		}
+		isp->smk_task = smk_fetch(XATTR_NAME_SMACKEXEC, inode, dp);
 
 		dput(dp);
 		break;
@@ -2406,7 +2429,7 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 	else
 		isp->smk_inode = final;
 
-	isp->smk_flags |= SMK_INODE_INSTANT;
+	isp->smk_flags |= (SMK_INODE_INSTANT | transflag);
 
 unlockandout:
 	mutex_unlock(&isp->smk_lock);
@@ -2456,6 +2479,7 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 			     void *value, size_t size)
 {
 	struct task_smack *tsp;
+	struct task_smack *oldtsp;
 	struct cred *new;
 	char *newsmack;
 
@@ -2485,6 +2509,7 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 	if (newsmack == smack_known_web.smk_known)
 		return -EPERM;
 
+	oldtsp = p->cred->security;
 	new = prepare_creds();
 	if (new == NULL)
 		return -ENOMEM;
@@ -2494,6 +2519,7 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 		return -ENOMEM;
 	}
 	tsp->smk_task = newsmack;
+	tsp->smk_forked = oldtsp->smk_forked;
 	new->security = tsp;
 	commit_creds(new);
 	return size;
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 01a0be9..362d5ed 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -109,9 +109,12 @@ const char *smack_cipso_option = SMACK_CIPSO_OPTION;
  * SMK_ACCESSLEN: Maximum length for a rule access field
  * SMK_LOADLEN: Smack rule length
  */
-#define SMK_ACCESS    "rwxa"
-#define SMK_ACCESSLEN (sizeof(SMK_ACCESS) - 1)
-#define SMK_LOADLEN   (SMK_LABELLEN + SMK_LABELLEN + SMK_ACCESSLEN)
+#define SMK_OACCESS	"rwxa"
+#define SMK_ACCESS	"rwxat"
+#define SMK_OACCESSLEN	(sizeof(SMK_OACCESS) - 1)
+#define SMK_ACCESSLEN	(sizeof(SMK_ACCESS) - 1)
+#define SMK_OLOADLEN	(SMK_LABELLEN + SMK_LABELLEN + SMK_OACCESSLEN)
+#define SMK_LOADLEN	(SMK_LABELLEN + SMK_LABELLEN + SMK_ACCESSLEN)
 
 /**
  * smk_netlabel_audit_set - fill a netlbl_audit struct
@@ -175,6 +178,8 @@ static int load_seq_show(struct seq_file *s, void *v)
 		seq_putc(s, 'x');
 	if (srp->smk_access & MAY_APPEND)
 		seq_putc(s, 'a');
+	if (srp->smk_access & MAY_TRANSMUTE)
+		seq_putc(s, 't');
 	if (srp->smk_access == 0)
 		seq_putc(s, '-');
 
@@ -273,10 +278,15 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 
-	if (*ppos != 0 || count != SMK_LOADLEN)
+	if (*ppos != 0)
+		return -EINVAL;
+	/*
+	 * Minor hack for backward compatability
+	 */
+	if (count < (SMK_OLOADLEN) || count > SMK_LOADLEN)
 		return -EINVAL;
 
-	data = kzalloc(count, GFP_KERNEL);
+	data = kzalloc(SMK_LOADLEN, GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
@@ -285,6 +295,12 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 		goto out;
 	}
 
+	/*
+	 * More on the minor hack for backward compatability
+	 */
+	if (count == (SMK_OLOADLEN))
+		data[SMK_OLOADLEN] = '-';
+
 	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
 	if (rule == NULL) {
 		rc = -ENOMEM;
@@ -345,6 +361,17 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 		goto out_free_rule;
 	}
 
+	switch (data[SMK_LABELLEN + SMK_LABELLEN + 4]) {
+	case '-':
+		break;
+	case 't':
+	case 'T':
+		rule->smk_access |= MAY_TRANSMUTE;
+		break;
+	default:
+		goto out_free_rule;
+	}
+
 	rc = smk_set_access(rule);
 
 	if (!rc)

