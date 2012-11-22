Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab2KVVzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:55:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:23470 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955Ab2KVVzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:55:06 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ima: skip policy search for never appraised or measured files
Date: Thu, 22 Nov 2012 23:54:44 +0200
Message-Id: <73c092fc6b6075244d834a9858dbe049465f614a.1353621075.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1353621075.git.dmitry.kasatkin@intel.com>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1353621075.git.dmitry.kasatkin@intel.com>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain file system types and partitions will never be measured or
appraised by IMA depending on the policy. For example, pseudo file
systems are never measured and appraised. In current implementation
policy will be checked again and again. It happens thousands times
per second. That is absolute waste of CPU and may be battery resources.

This patch uses new super block SF_IMA_DISABLED flag. IMA set the
SF_IMA_DISABLED flag when file system will not be measured and
appraised and test this flag during subsequent calls to skip policy
search.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 security/integrity/ima/ima_api.c    |    8 ++------
 security/integrity/ima/ima_policy.c |   20 +++++++++++++++++---
 security/integrity/integrity.h      |    3 +++
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index b356884..2156020 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -114,12 +114,8 @@ err_out:
  */
 int ima_get_action(struct inode *inode, int mask, int function)
 {
-	int flags = IMA_MEASURE | IMA_AUDIT | IMA_APPRAISE;
-
-	if (!ima_appraise)
-		flags &= ~IMA_APPRAISE;
-
-	return ima_match_policy(inode, function, mask, flags);
+	return ima_match_policy(inode, function, mask,
+				IMA_MEASURE | IMA_AUDIT | IMA_APPRAISE);
 }
 
 int ima_must_measure(struct inode *inode, int mask, int function)
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index c7dacd2..a68ea55 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -22,7 +22,6 @@
 /* flags definitions */
 #define IMA_FUNC 	0x0001
 #define IMA_MASK 	0x0002
-#define IMA_FSMAGIC	0x0004
 #define IMA_UID		0x0008
 #define IMA_FOWNER	0x0010
 
@@ -198,7 +197,16 @@ int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
 		     int flags)
 {
 	struct ima_rule_entry *entry;
-	int action = 0, actmask = flags | (flags << 1);
+	int all_actions = (flags == IMA_DO_MASK);
+	int action = 0, actmask;
+
+	if (inode->i_sb->s_feature_flags & SF_IMA_DISABLED)
+		return 0;
+
+	if (!ima_appraise)
+		flags &= ~IMA_APPRAISE;
+
+	actmask = flags | (flags << 1);
 
 	list_for_each_entry(entry, ima_rules, list) {
 
@@ -208,6 +216,7 @@ int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
 		if (!ima_match_rules(entry, inode, func, mask))
 			continue;
 
+		action |= entry->flags & IMA_ACTION_FLAGS;
 		action |= entry->action & IMA_DO_MASK;
 		if (entry->action & IMA_DO_MASK)
 			actmask &= ~(entry->action | entry->action << 1);
@@ -217,7 +226,12 @@ int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
 		if (!actmask)
 			break;
 	}
-
+	if (all_actions && (action & IMA_FS_MASK)) {
+		action &= ~IMA_FS_MASK;
+		/* dont_measure, dont_audit and dont_appraise */
+		if (!action)
+			inode->i_sb->s_feature_flags |= SF_IMA_DISABLED;
+	}
 	return action;
 }
 
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index e9db763..d67d867 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -26,7 +26,10 @@
 #define IMA_AUDITED		0x0080
 
 /* iint cache flags */
+#define IMA_ACTION_FLAGS	0xff00
 #define IMA_DIGSIG		0x0100
+#define IMA_FSMAGIC		0x0200
+#define IMA_FS_MASK		IMA_FSMAGIC
 
 #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT)
 #define IMA_DONE_MASK		(IMA_MEASURED | IMA_APPRAISED | IMA_AUDITED \
-- 
1.7.10.4

