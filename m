Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab2GKPtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:49:55 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:33122 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab2GKPtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:49:52 -0400
From: Rafal Krypa <r.krypa@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Rafal Krypa <r.krypa@samsung.com>
Subject: [PATCH] Smack: implement revoking all rules for a subject label
Date: Wed, 11 Jul 2012 17:49:30 +0200
Message-id: <1342021770-23684-1-git-send-email-r.krypa@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add /smack/revoke-subject special file. Writing a SMACK label to this file will
set the access to '-' for all access rules with that subject label.

Targeted for git://git.gitorious.org/smack-next/kernel.git

Signed-off-by: Rafal Krypa <r.krypa@samsung.com>
---
 Documentation/security/Smack.txt |    3 ++
 security/smack/smackfs.c         |   75 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/Documentation/security/Smack.txt b/Documentation/security/Smack.txt
index a416479..e68536d 100644
--- a/Documentation/security/Smack.txt
+++ b/Documentation/security/Smack.txt
@@ -194,6 +194,9 @@ onlycap
 	these capabilities are effective at for processes with any
 	label. The value is set by writing the desired label to the
 	file or cleared by writing "-" to the file.
+revoke-subject
+	Writing a Smack label here sets the access to '-' for all access
+	rules with that subject label.
 
 You can add access rules in /etc/smack/accesses. They take the form:
 
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index d31e6d9..c434441 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -49,6 +49,7 @@ enum smk_inos {
 	SMK_LOAD_SELF2	= 15,	/* load task specific rules with long labels */
 	SMK_ACCESS2	= 16,	/* make an access check with long labels */
 	SMK_CIPSO2	= 17,	/* load long label -> CIPSO mapping */
+	SMK_REVOKE_SUBJ	= 18,	/* set rules with subject label to '-' */
 };
 
 /*
@@ -1992,6 +1993,77 @@ static const struct file_operations smk_access2_ops = {
 };
 
 /**
+ * smk_write_revoke_subj - write() for /smack/revoke-subject
+ * @file: file pointer
+ * @buf: data from user space
+ * @count: bytes sent
+ * @ppos: where to start - must be 0
+ */
+static ssize_t smk_write_revoke_subj(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	char *data = NULL;
+	const char *cp = NULL;
+	struct smack_known *skp;
+	struct smack_rule *sp;
+	struct list_head *rule_list;
+	struct mutex *rule_lock;
+	int rc = count;
+
+	if (*ppos != 0)
+		return -EINVAL;
+
+	if (!smack_privileged(CAP_MAC_ADMIN))
+		return -EPERM;
+
+	if (count == 0 || count > SMK_LONGLABEL)
+		return -EINVAL;
+
+	data = kzalloc(count, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	if (copy_from_user(data, buf, count) != 0) {
+		rc = -EFAULT;
+		goto free_out;
+	}
+
+	cp = smk_parse_smack(data, count);
+	if (cp == NULL) {
+		rc = -EINVAL;
+		goto free_out;
+	}
+
+	skp = smk_find_entry(cp);
+	if (skp == NULL) {
+		rc = -EINVAL;
+		goto free_out;
+	}
+
+	rule_list = &skp->smk_rules;
+	rule_lock = &skp->smk_rules_lock;
+
+	mutex_lock(rule_lock);
+
+	list_for_each_entry_rcu(sp, rule_list, list)
+		sp->smk_access = 0;
+
+	mutex_unlock(rule_lock);
+
+free_out:
+	kfree(data);
+	kfree(cp);
+	return rc;
+}
+
+static const struct file_operations smk_revoke_subj_ops = {
+	.write		= smk_write_revoke_subj,
+	.read		= simple_transaction_read,
+	.release	= simple_transaction_release,
+	.llseek		= generic_file_llseek,
+};
+
+/**
  * smk_fill_super - fill the /smackfs superblock
  * @sb: the empty superblock
  * @data: unused
@@ -2037,6 +2109,9 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
 			"access2", &smk_access2_ops, S_IRUGO|S_IWUGO},
 		[SMK_CIPSO2] = {
 			"cipso2", &smk_cipso2_ops, S_IRUGO|S_IWUSR},
+		[SMK_REVOKE_SUBJ] = {
+			"revoke-subject", &smk_revoke_subj_ops,
+			S_IRUGO|S_IWUSR},
 		/* last one */
 			{""}
 	};
-- 
1.7.10.4

