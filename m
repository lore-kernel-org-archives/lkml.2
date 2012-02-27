Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab2B0WX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:23:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38804 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab2B0WX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:23:56 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 6/7] AppArmor: Add ability to load extended policy
Date: Mon, 27 Feb 2012 14:23:16 -0800
Message-Id: <1330381397-5352-7-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330381397-5352-1-git-send-email-john.johansen@canonical.com>
References: <1330381397-5352-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the base support for the new policy extensions. This does not bring
any additional functionality, or change current semantics.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Acked-by: Kees Cook <kees@ubuntu.com>
---
 security/apparmor/include/apparmor.h |   13 +++++++++++++
 security/apparmor/include/policy.h   |   13 +++++++++++++
 security/apparmor/policy.c           |    1 +
 security/apparmor/policy_unpack.c    |   22 ++++++++++++++++++++++
 4 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/security/apparmor/include/apparmor.h b/security/apparmor/include/apparmor.h
index 248c408..40aedd9 100644
--- a/security/apparmor/include/apparmor.h
+++ b/security/apparmor/include/apparmor.h
@@ -19,6 +19,19 @@
 
 #include "match.h"
 
+/*
+ * Class of mediation types in the AppArmor policy db
+ */
+#define AA_CLASS_ENTRY		0
+#define AA_CLASS_UNKNOWN	1
+#define AA_CLASS_FILE		2
+#define AA_CLASS_CAP		3
+#define AA_CLASS_NET		4
+#define AA_CLASS_RLIMITS	5
+#define AA_CLASS_DOMAIN		6
+
+#define AA_CLASS_LAST		AA_CLASS_DOMAIN
+
 /* Control parameters settable through module/boot flags */
 extern enum audit_mode aa_g_audit;
 extern bool aa_g_audit_header;
diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
index aeda5cf..9e18e96 100644
--- a/security/apparmor/include/policy.h
+++ b/security/apparmor/include/policy.h
@@ -129,6 +129,17 @@ struct aa_namespace {
 	struct list_head sub_ns;
 };
 
+/* struct aa_policydb - match engine for a policy
+ * dfa: dfa pattern match
+ * start: set of start states for the different classes of data
+ */
+struct aa_policydb {
+	/* Generic policy DFA specific rule types will be subsections of it */
+	struct aa_dfa *dfa;
+	unsigned int start[AA_CLASS_LAST + 1];
+
+};
+
 /* struct aa_profile - basic confinement data
  * @base - base components of the profile (name, refcount, lists, lock ...)
  * @parent: parent of profile
@@ -143,6 +154,7 @@ struct aa_namespace {
  * @flags: flags controlling profile behavior
  * @path_flags: flags controlling path generation behavior
  * @size: the memory consumed by this profiles rules
+ * @policy: general match rules governing policy
  * @file: The set of rules governing basic file access and domain transitions
  * @caps: capabilities for the profile
  * @rlimits: rlimits for the profile
@@ -179,6 +191,7 @@ struct aa_profile {
 	u32 path_flags;
 	int size;
 
+	struct aa_policydb policy;
 	struct aa_file_rules file;
 	struct aa_caps caps;
 	struct aa_rlimit rlimits;
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 537e5dc..8b7febb 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -752,6 +752,7 @@ static void free_profile(struct aa_profile *profile)
 
 	aa_free_sid(profile->sid);
 	aa_put_dfa(profile->xmatch);
+	aa_put_dfa(profile->policy.dfa);
 
 	aa_put_profile(profile->replacedby);
 
diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 6137b10..c7a6d03 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -562,6 +562,28 @@ static struct aa_profile *unpack_profile(struct aa_ext *e)
 	if (!unpack_rlimits(e, profile))
 		goto fail;
 
+	if (unpack_nameX(e, AA_STRUCT, "policydb")) {
+		/* generic policy dfa - optional and may be NULL */
+		profile->policy.dfa = unpack_dfa(e);
+		if (IS_ERR(profile->policy.dfa)) {
+			error = PTR_ERR(profile->policy.dfa);
+			profile->policy.dfa = NULL;
+			goto fail;
+		}
+		if (!unpack_u32(e, &profile->policy.start[0], "start"))
+			/* default start state */
+			profile->policy.start[0] = DFA_START;
+		/* setup class index */
+		for (i = AA_CLASS_FILE; i <= AA_CLASS_LAST; i++) {
+			profile->policy.start[i] =
+				aa_dfa_next(profile->policy.dfa,
+					    profile->policy.start[0],
+					    i);
+		}
+		if (!unpack_nameX(e, AA_STRUCTEND, NULL))
+			goto fail;
+	}
+
 	/* get file rules */
 	profile->file.dfa = unpack_dfa(e);
 	if (IS_ERR(profile->file.dfa)) {
-- 
1.7.9

