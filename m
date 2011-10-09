Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab1JIWDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 18:03:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab1JIWDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 18:03:45 -0400
From: Michal Schmidt <mschmidt@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Randy Dunlap <rdunlap@xenotime.net>,
        Michal Schmidt <mschmidt@redhat.com>
Subject: [PATCH] params: make dashes and underscores in parameter names truly equal
Date: Mon, 10 Oct 2011 00:03:37 +0200
Message-Id: <1318197817-20964-1-git-send-email-mschmidt@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user may use "foo-bar" for a kernel parameter defined as "foo_bar".
Make sure it works the other way around too.

Apply the equality of dashes and underscores on early_params and __setup
params as well.

The example given in Documentation/kernel-parameters.txt indicates that
this is the intended behaviour.

With the patch the kernel accepts "log-buf-len=1M" as expected.
https://bugzilla.redhat.com/show_bug.cgi?id=744545

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
---
 include/linux/moduleparam.h |   20 ++++++++++++++++++++
 init/main.c                 |    4 ++--
 kernel/params.c             |   34 +++++++++++++++++++++++++++-------
 3 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 56bda92..609f89c 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -267,6 +267,26 @@ static inline void __kernel_param_unlock(void)
 			    .str = &__param_string_##name, 0, perm);	\
 	__MODULE_PARM_TYPE(name, "string")
 
+/**
+ * parameq - checks if two parameter names match
+ * @name1: parameter name 1
+ * @name2: parameter name 2
+ *
+ * Returns true if the two parameter names are equal.
+ * Dashes (-) are considered equal to underscores (_).
+ */
+extern bool parameq(const char *name1, const char *name2);
+
+/**
+ * parameqn - checks if two parameter names match
+ * @name1: parameter name 1
+ * @name2: parameter name 2
+ * @n: the maximum length to compare
+ *
+ * Similar to parameq(), except it compares at most @n characters.
+ */
+extern bool parameqn(const char *name1, const char *name2, size_t n);
+
 /* Called on module insert or kernel boot */
 extern int parse_args(const char *name,
 		      char *args,
diff --git a/init/main.c b/init/main.c
index 03b408d..63f5f6f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -163,7 +163,7 @@ static int __init obsolete_checksetup(char *line)
 	p = __setup_start;
 	do {
 		int n = strlen(p->str);
-		if (!strncmp(line, p->str, n)) {
+		if (parameqn(line, p->str, n)) {
 			if (p->early) {
 				/* Already done in parse_early_param?
 				 * (Needs exact match on param part).
@@ -392,7 +392,7 @@ static int __init do_early_param(char *param, char *val)
 	const struct obs_kernel_param *p;
 
 	for (p = __setup_start; p < __setup_end; p++) {
-		if ((p->early && strcmp(param, p->str) == 0) ||
+		if ((p->early && parameq(param, p->str)) ||
 		    (strcmp(param, "console") == 0 &&
 		     strcmp(p->str, "earlycon") == 0)
 		) {
diff --git a/kernel/params.c b/kernel/params.c
index 1d1c01b..aa8933c 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -67,20 +67,40 @@ static void maybe_kfree_parameter(void *param)
 	}
 }
 
-static inline char dash2underscore(char c)
+static char dash2underscore(char c)
 {
 	if (c == '-')
 		return '_';
 	return c;
 }
 
-static inline int parameq(const char *input, const char *paramname)
+bool parameq(const char *name1, const char *name2)
 {
-	unsigned int i;
-	for (i = 0; dash2underscore(input[i]) == paramname[i]; i++)
-		if (input[i] == '\0')
-			return 1;
-	return 0;
+	char c1, c2;
+	while (1) {
+		c1 = dash2underscore(*name1++);
+		c2 = dash2underscore(*name2++);
+		if (c1 != c2)
+			return false;
+		if (c1 == '\0')
+			break;
+	}
+	return true;
+}
+
+bool parameqn(const char *name1, const char *name2, size_t n)
+{
+	char c1, c2;
+	while (n) {
+		c1 = dash2underscore(*name1++);
+		c2 = dash2underscore(*name2++);
+		if (c1 != c2)
+			return false;
+		if (c1 == '\0')
+			break;
+		n--;
+	}
+	return true;
 }
 
 static int parse_one(char *param,
-- 
1.7.4.4

