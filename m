Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab2K0Rko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:40:44 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12885 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab2K0Rkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:40:37 -0500
From: Rafal Krypa <r.krypa@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rafal Krypa <r.krypa@samsung.com>
Subject: [PATCH 1/3] Smack: use RCU functions and read locking in smackfs seq
 list operations
Date: Tue, 27 Nov 2012 18:40:19 +0100
Message-id: <1354038021-28324-2-git-send-email-r.krypa@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1354038021-28324-1-git-send-email-r.krypa@samsung.com>
References: <1354038021-28324-1-git-send-email-r.krypa@samsung.com>
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Targeted for git://git.gitorious.org/smack-next/kernel.git

Signed-off-by: Rafal Krypa <r.krypa@samsung.com>
---
 security/smack/smackfs.c |   50 +++++++++++++++++++---------------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 76a5dca..0fadceb 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -470,24 +470,17 @@ out:
 static void *smk_seq_start(struct seq_file *s, loff_t *pos,
 				struct list_head *head)
 {
-	struct list_head *list;
+	struct list_head *list = head;
+	int i = *pos;
 
-	/*
-	 * This is 0 the first time through.
-	 */
-	if (s->index == 0)
-		s->private = head;
-
-	if (s->private == NULL)
-		return NULL;
+	rcu_read_lock();
+	do {
+		list = list_next_rcu(list);
+		if (i-- == 0)
+			return list;
+	} while (pos != head);
 
-	list = s->private;
-	if (list_empty(list))
-		return NULL;
-
-	if (s->index == 0)
-		return list->next;
-	return list;
+	return NULL;
 }
 
 static void *smk_seq_next(struct seq_file *s, void *v, loff_t *pos,
@@ -495,17 +488,14 @@ static void *smk_seq_next(struct seq_file *s, void *v, loff_t *pos,
 {
 	struct list_head *list = v;
 
-	if (list_is_last(list, head)) {
-		s->private = NULL;
-		return NULL;
-	}
-	s->private = list->next;
-	return list->next;
+	list = list_next_rcu(list);
+	++*pos;
+	return list == head ? NULL : list;
 }
 
 static void smk_seq_stop(struct seq_file *s, void *v)
 {
-	/* No-op */
+	rcu_read_unlock();
 }
 
 static void smk_rule_show(struct seq_file *s, struct smack_rule *srp, int max)
@@ -558,7 +548,7 @@ static int load_seq_show(struct seq_file *s, void *v)
 {
 	struct list_head *list = v;
 	struct smack_master_list *smlp =
-		 list_entry(list, struct smack_master_list, list);
+		 list_entry_rcu(list, struct smack_master_list, list);
 
 	smk_rule_show(s, smlp->smk_rule, SMK_LABELLEN);
 
@@ -706,7 +696,7 @@ static int cipso_seq_show(struct seq_file *s, void *v)
 {
 	struct list_head  *list = v;
 	struct smack_known *skp =
-		 list_entry(list, struct smack_known, list);
+		 list_entry_rcu(list, struct smack_known, list);
 	struct netlbl_lsm_secattr_catmap *cmp = skp->smk_netlabel.attr.mls.cat;
 	char sep = '/';
 	int i;
@@ -895,7 +885,7 @@ static int cipso2_seq_show(struct seq_file *s, void *v)
 {
 	struct list_head  *list = v;
 	struct smack_known *skp =
-		 list_entry(list, struct smack_known, list);
+		 list_entry_rcu(list, struct smack_known, list);
 	struct netlbl_lsm_secattr_catmap *cmp = skp->smk_netlabel.attr.mls.cat;
 	char sep = '/';
 	int i;
@@ -979,7 +969,7 @@ static int netlbladdr_seq_show(struct seq_file *s, void *v)
 {
 	struct list_head *list = v;
 	struct smk_netlbladdr *skp =
-			 list_entry(list, struct smk_netlbladdr, list);
+			 list_entry_rcu(list, struct smk_netlbladdr, list);
 	unsigned char *hp = (char *) &skp->smk_host.sin_addr.s_addr;
 	int maskn;
 	u32 temp_mask = be32_to_cpu(skp->smk_mask.s_addr);
@@ -1712,7 +1702,7 @@ static int load_self_seq_show(struct seq_file *s, void *v)
 {
 	struct list_head *list = v;
 	struct smack_rule *srp =
-		 list_entry(list, struct smack_rule, list);
+		 list_entry_rcu(list, struct smack_rule, list);
 
 	smk_rule_show(s, srp, SMK_LABELLEN);
 
@@ -1844,7 +1834,7 @@ static int load2_seq_show(struct seq_file *s, void *v)
 {
 	struct list_head *list = v;
 	struct smack_master_list *smlp =
-		 list_entry(list, struct smack_master_list, list);
+		 list_entry_rcu(list, struct smack_master_list, list);
 
 	smk_rule_show(s, smlp->smk_rule, SMK_LONGLABEL);
 
@@ -1921,7 +1911,7 @@ static int load_self2_seq_show(struct seq_file *s, void *v)
 {
 	struct list_head *list = v;
 	struct smack_rule *srp =
-		 list_entry(list, struct smack_rule, list);
+		 list_entry_rcu(list, struct smack_rule, list);
 
 	smk_rule_show(s, srp, SMK_LONGLABEL);
 
-- 
1.7.10.4

