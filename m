Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab2FEW2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 18:28:33 -0400
Received: from nm11.access.bullet.mail.mud.yahoo.com ([66.94.237.212]:34304
	"HELO nm11.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751187Ab2FEW2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 18:28:31 -0400
X-Yahoo-Newman-Id: 176778.77797.bm@smtp105.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: RxPs9n0VM1nXDWubIA.dgPlmHSYqbU_xYbUVkl8hyrJIacO
 vIyYjruLYOm9iU5lkuVWuW6PmtILLNANhSR_Y2FXT6jjlEXCKJznDptPDRfs
 nLqt_mPGlsIqTc_ZIwB27w.SebjTI0pTYdEGMxmmlgf8rzwMS2IHP8.jB9e4
 .zrIYENApn87ylfEDcMUQmj6nGUQbL9zdsGjmT0OwTDyYk2d4FBpCvaXFAlJ
 1UnPllR.miOr2mxPwJBTjkE6evFJDlmp0.VWoVdHaAjYAK05KNw50OGvFLlJ
 zBfkg_VMOprBRFqu3G3znFa0kM3gGS64xJ9ZbeBhvnCRas3VdhBFaWHf2wGj
 ZG10M9u.PDJBx1eZcjVsRulajkH8FBhfnHDk7K2N70h.QRgNeivDpE.QhcNX
 b6q8DzVQ1lMRhJ4rSMMXZzcDJL2N1_7oRNBzwftHcEC3Q9uMTTMbltarBo0V
 .65KWNWeFb5koROVVhhrHX8pJiC1xI3AkyRBfD.smqtq6a6jjSz.3EWZTv1O
 wUX7Fs5vi82t3G4OK9aLBQYCbuQ--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4FCE880E.3020809@schaufler-ca.com>
Date: Tue, 05 Jun 2012 15:28:30 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>
CC: Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: onlycap limits on CAP_MAC_ADMIN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: onlycap limits on CAP_MAC_ADMIN

Smack is integrated with the POSIX capabilities scheme,
using the capabilities CAP_MAC_OVERRIDE and CAP_MAC_ADMIN to
determine if a process is allowed to ignore Smack checks or
change Smack related data respectively. Smack provides an
additional restriction that if an onlycap value is set
by writing to /smack/onlycap only tasks with that Smack
label are allowed to use CAP_MAC_OVERRIDE.

This change adds CAP_MAC_ADMIN as a capability that is affected
by the onlycap mechanism. 

Targeted for git://git.gitorious.org/smack-next/kernel.git

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 security/smack/smack.h        |   13 +++++++++++++
 security/smack/smack_access.c |    9 ++-------
 security/smack/smack_lsm.c    |   17 +++++++++--------
 security/smack/smackfs.c      |   21 ++++++++++-----------
 4 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index 76feb31..99b3612 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -283,6 +283,19 @@ static inline char *smk_of_current(void)
 }
 
 /*
+ * Is the task privileged and allowed to be privileged
+ * by the onlycap rule.
+ */
+static inline int smack_privileged(int cap)
+{
+	if (!capable(cap))
+		return 0;
+	if (smack_onlycap == NULL || smack_onlycap == smk_of_current())
+		return 1;
+	return 0;
+}
+
+/*
  * logging functions
  */
 #define SMACK_AUDIT_DENIED 0x1
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 9f3705e..db14689 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -220,14 +220,9 @@ int smk_curacc(char *obj_label, u32 mode, struct smk_audit_info *a)
 	}
 
 	/*
-	 * Return if a specific label has been designated as the
-	 * only one that gets privilege and current does not
-	 * have that label.
+	 * Allow for priviliged to override policy.
 	 */
-	if (smack_onlycap != NULL && smack_onlycap != sp)
-		goto out_audit;
-
-	if (capable(CAP_MAC_OVERRIDE))
+	if (rc != 0 && smack_privileged(CAP_MAC_OVERRIDE))
 		rc = 0;
 
 out_audit:
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 5a4d52c..99a457a 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -217,7 +217,7 @@ static int smack_syslog(int typefrom_file)
 	int rc = 0;
 	char *sp = smk_of_current();
 
-	if (capable(CAP_MAC_OVERRIDE))
+	if (smack_privileged(CAP_MAC_OVERRIDE))
 		return 0;
 
 	 if (sp != smack_known_floor.smk_known)
@@ -821,7 +821,7 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
 	    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0 ||
 	    strcmp(name, XATTR_NAME_SMACKEXEC) == 0 ||
 	    strcmp(name, XATTR_NAME_SMACKMMAP) == 0) {
-		if (!capable(CAP_MAC_ADMIN))
+		if (!smack_privileged(CAP_MAC_ADMIN))
 			rc = -EPERM;
 		/*
 		 * check label validity here so import wont fail on
@@ -831,7 +831,7 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
 		    smk_import(value, size) == NULL)
 			rc = -EINVAL;
 	} else if (strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0) {
-		if (!capable(CAP_MAC_ADMIN))
+		if (!smack_privileged(CAP_MAC_ADMIN))
 			rc = -EPERM;
 		if (size != TRANS_TRUE_SIZE ||
 		    strncmp(value, TRANS_TRUE, TRANS_TRUE_SIZE) != 0)
@@ -927,7 +927,7 @@ static int smack_inode_removexattr(struct dentry *dentry, const char *name)
 	    strcmp(name, XATTR_NAME_SMACKEXEC) == 0 ||
 	    strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0 ||
 	    strcmp(name, XATTR_NAME_SMACKMMAP)) {
-		if (!capable(CAP_MAC_ADMIN))
+		if (!smack_privileged(CAP_MAC_ADMIN))
 			rc = -EPERM;
 	} else
 		rc = cap_inode_removexattr(dentry, name);
@@ -1722,7 +1722,8 @@ static int smack_task_wait(struct task_struct *p)
 	 * state into account in the decision as well as
 	 * the smack value.
 	 */
-	if (capable(CAP_MAC_OVERRIDE) || has_capability(p, CAP_MAC_OVERRIDE))
+	if (smack_privileged(CAP_MAC_OVERRIDE) ||
+	    has_capability(p, CAP_MAC_OVERRIDE))
 		rc = 0;
 	/* we log only if we didn't get overriden */
  out_log:
@@ -2723,7 +2724,7 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 	if (p != current)
 		return -EPERM;
 
-	if (!capable(CAP_MAC_ADMIN))
+	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	if (value == NULL || size == 0 || size >= SMK_LONGLABEL)
@@ -2786,7 +2787,7 @@ static int smack_unix_stream_connect(struct sock *sock,
 	smk_ad_setfield_u_net_sk(&ad, other);
 #endif
 
-	if (!capable(CAP_MAC_OVERRIDE))
+	if (!smack_privileged(CAP_MAC_OVERRIDE))
 		rc = smk_access(ssp->smk_out, osp->smk_in, MAY_WRITE, &ad);
 
 	/*
@@ -2822,7 +2823,7 @@ static int smack_unix_may_send(struct socket *sock, struct socket *other)
 	smk_ad_setfield_u_net_sk(&ad, other->sk);
 #endif
 
-	if (!capable(CAP_MAC_OVERRIDE))
+	if (!smack_privileged(CAP_MAC_OVERRIDE))
 		rc = smk_access(ssp->smk_out, osp->smk_in, MAY_WRITE, &ad);
 
 	return rc;
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 3686db7..2152965 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -595,13 +595,12 @@ static int smk_open_load(struct inode *inode, struct file *file)
 static ssize_t smk_write_load(struct file *file, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-
 	/*
 	 * Must have privilege.
 	 * No partial writes.
 	 * Enough data must be present.
 	 */
-	if (!capable(CAP_MAC_ADMIN))
+	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	return smk_write_rules_list(file, buf, count, ppos, NULL, NULL,
@@ -787,7 +786,7 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 	 * No partial writes.
 	 * Enough data must be present.
 	 */
-	if (!capable(CAP_MAC_ADMIN))
+	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 	if (*ppos != 0)
 		return -EINVAL;
@@ -1090,7 +1089,7 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	 * "<addr/mask, as a.b.c.d/e><space><label>"
 	 * "<addr, as a.b.c.d><space><label>"
 	 */
-	if (!capable(CAP_MAC_ADMIN))
+	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 	if (*ppos != 0)
 		return -EINVAL;
@@ -1267,7 +1266,7 @@ static ssize_t smk_write_doi(struct file *file, const char __user *buf,
 	char temp[80];
 	int i;
 
-	if (!capable(CAP_MAC_ADMIN))
+	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	if (count >= sizeof(temp) || count == 0)
@@ -1334,7 +1333,7 @@ static ssize_t smk_write_direct(struct file *file, const char __user *buf,
 	char temp[80];
 	int i;
 
-	if (!capable(CAP_MAC_ADMIN))
+	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	if (count >= sizeof(temp) || count == 0)
@@ -1412,7 +1411,7 @@ static ssize_t smk_write_mapped(struct file *file, const char __user *buf,
 	char temp[80];
 	int i;
 
-	if (!capable(CAP_MAC_ADMIN))
+	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	if (count >= sizeof(temp) || count == 0)
@@ -1503,7 +1502,7 @@ static ssize_t smk_write_ambient(struct file *file, const char __user *buf,
 	char *data;
 	int rc = count;
 
-	if (!capable(CAP_MAC_ADMIN))
+	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	data = kzalloc(count + 1, GFP_KERNEL);
@@ -1586,7 +1585,7 @@ static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
 	char *sp = smk_of_task(current->cred->security);
 	int rc = count;
 
-	if (!capable(CAP_MAC_ADMIN))
+	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	/*
@@ -1664,7 +1663,7 @@ static ssize_t smk_write_logging(struct file *file, const char __user *buf,
 	char temp[32];
 	int i;
 
-	if (!capable(CAP_MAC_ADMIN))
+	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	if (count >= sizeof(temp) || count == 0)
@@ -1885,7 +1884,7 @@ static ssize_t smk_write_load2(struct file *file, const char __user *buf,
 	/*
 	 * Must have privilege.
 	 */
-	if (!capable(CAP_MAC_ADMIN))
+	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	return smk_write_rules_list(file, buf, count, ppos, NULL, NULL,
 


