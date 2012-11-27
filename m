Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2K0Rkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:40:42 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58874 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab2K0Rkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:40:39 -0500
From: Rafal Krypa <r.krypa@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rafal Krypa <r.krypa@samsung.com>
Subject: [PATCH 2/3] Smack: remove global master list of rules
Date: Tue, 27 Nov 2012 18:40:20 +0100
Message-id: <1354038021-28324-3-git-send-email-r.krypa@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1354038021-28324-1-git-send-email-r.krypa@samsung.com>
References: <1354038021-28324-1-git-send-email-r.krypa@samsung.com>
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The global rule list was optimized and changed into two-level list some
time ago. But the master list remained, serving as data source for reading
/smack/load and /smack/load2. It contained all the same information as the
new two-level list, duplicating all global rules.

This patch removes the master list. Appropriate seq_file functions have been
rewritten.

Targeted for git://git.gitorious.org/smack-next/kernel.git

Signed-off-by: Rafal Krypa <r.krypa@samsung.com>
---
 security/smack/smackfs.c |  101 +++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 47 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 0fadceb..5337270 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -55,7 +55,6 @@ enum smk_inos {
 /*
  * List locks
  */
-static DEFINE_MUTEX(smack_list_lock);
 static DEFINE_MUTEX(smack_cipso_lock);
 static DEFINE_MUTEX(smack_ambient_lock);
 static DEFINE_MUTEX(smk_netlbladdr_lock);
@@ -99,17 +98,13 @@ char *smack_onlycap;
 
 LIST_HEAD(smk_netlbladdr_list);
 
-/*
- * Rule lists are maintained for each label.
- * This master list is just for reading /smack/load and /smack/load2.
- */
-struct smack_master_list {
-	struct list_head	list;
-	struct smack_rule	*smk_rule;
+struct smack_seq_iter {
+	struct list_head *known_list;
+	struct list_head *rule_list;
+	struct smack_known *skp;
+	struct smack_rule *srp;
 };
 
-LIST_HEAD(smack_rule_list);
-
 static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
 
 const char *smack_cipso_option = SMACK_CIPSO_OPTION;
@@ -372,13 +367,11 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
 					struct list_head *rule_list,
 					struct mutex *rule_lock, int format)
 {
-	struct smack_master_list *smlp;
 	struct smack_known *skp;
 	struct smack_rule *rule;
 	char *data;
 	int datalen;
 	int rc = -EINVAL;
-	int load = 0;
 
 	/*
 	 * No partial writes.
@@ -431,30 +424,14 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
 
 
 	if (rule_list == NULL) {
-		load = 1;
 		skp = smk_find_entry(rule->smk_subject);
 		rule_list = &skp->smk_rules;
 		rule_lock = &skp->smk_rules_lock;
 	}
 
 	rc = count;
-	/*
-	 * If this is a global as opposed to self and a new rule
-	 * it needs to get added for reporting.
-	 * smk_set_access returns true if there was already a rule
-	 * for the subject/object pair, and false if it was new.
-	 */
-	if (!smk_set_access(rule, rule_list, rule_lock)) {
-		if (load) {
-			smlp = kzalloc(sizeof(*smlp), GFP_KERNEL);
-			if (smlp != NULL) {
-				smlp->smk_rule = rule;
-				list_add_rcu(&smlp->list, &smack_rule_list);
-			} else
-				rc = -ENOMEM;
-		}
+	if (!smk_set_access(rule, rule_list, rule_lock))
 		goto out;
-	}
 
 out_free_rule:
 	kfree(rule);
@@ -534,32 +511,64 @@ static void smk_rule_show(struct seq_file *s, struct smack_rule *srp, int max)
  * Seq_file read operations for /smack/load
  */
 
-static void *load2_seq_start(struct seq_file *s, loff_t *pos)
+static void *load_seq_start(struct seq_file *s, loff_t *pos)
 {
-	return smk_seq_start(s, pos, &smack_rule_list);
+	int i = *pos;
+	struct smack_seq_iter *it;
+
+	it = kmalloc(sizeof(*it), GFP_KERNEL);
+	s->private = it;
+	if (it == NULL)
+		return NULL;
+
+	rcu_read_lock();
+	it->known_list = &smack_known_list;
+	list_for_each_entry_rcu(it->skp, it->known_list, list) {
+		it->rule_list = &it->skp->smk_rules;
+		list_for_each_entry_rcu(it->srp, it->rule_list, list)
+			if (i-- == 0)
+				return it;
+	}
+
+	return NULL;
+}
+
+static void *load_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct smack_seq_iter *it = v;
+
+	list_for_each_entry_continue_rcu(it->srp, it->rule_list, list)
+		return it;
+
+	list_for_each_entry_continue_rcu(it->skp, it->known_list, list) {
+		it->rule_list = &it->skp->smk_rules;
+		list_for_each_entry_rcu(it->srp, it->rule_list, list)
+			return it;
+	}
+
+	return NULL;
 }
 
-static void *load2_seq_next(struct seq_file *s, void *v, loff_t *pos)
+static void load_seq_stop(struct seq_file *s, void *v)
 {
-	return smk_seq_next(s, v, pos, &smack_rule_list);
+	kfree(s->private);
+	rcu_read_unlock();
 }
 
 static int load_seq_show(struct seq_file *s, void *v)
 {
-	struct list_head *list = v;
-	struct smack_master_list *smlp =
-		 list_entry_rcu(list, struct smack_master_list, list);
+	struct smack_seq_iter *it = v;
 
-	smk_rule_show(s, smlp->smk_rule, SMK_LABELLEN);
+	smk_rule_show(s, it->srp, SMK_LABELLEN);
 
 	return 0;
 }
 
 static const struct seq_operations load_seq_ops = {
-	.start = load2_seq_start,
-	.next  = load2_seq_next,
+	.start = load_seq_start,
+	.next  = load_seq_next,
 	.show  = load_seq_show,
-	.stop  = smk_seq_stop,
+	.stop  = load_seq_stop,
 };
 
 /**
@@ -1832,20 +1841,18 @@ static const struct file_operations smk_access_ops = {
 
 static int load2_seq_show(struct seq_file *s, void *v)
 {
-	struct list_head *list = v;
-	struct smack_master_list *smlp =
-		 list_entry_rcu(list, struct smack_master_list, list);
+	struct smack_seq_iter *it = v;
 
-	smk_rule_show(s, smlp->smk_rule, SMK_LONGLABEL);
+	smk_rule_show(s, it->srp, SMK_LONGLABEL);
 
 	return 0;
 }
 
 static const struct seq_operations load2_seq_ops = {
-	.start = load2_seq_start,
-	.next  = load2_seq_next,
+	.start = load_seq_start,
+	.next  = load_seq_next,
 	.show  = load2_seq_show,
-	.stop  = smk_seq_stop,
+	.stop  = load_seq_stop,
 };
 
 /**
-- 
1.7.10.4

