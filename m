Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1IWOyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:54:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:29116 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758Ab1IWOyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:54:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="55551326"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pekka Enberg <penberg@kernel.org>, kvm@vger.kernel.org
Subject: [RFC][PATCHv2] tools: kvm: don't use custom strtoul for hex numbers
Date: Fri, 23 Sep 2011 17:53:44 +0300
Message-Id: <6aa9922954a7119f0199d80e29c3edc7885b8e40.1316789582.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <ae9ebfd216b4560d885e3b437d98b93b78e45c1c.1316787913.git.andriy.shevchenko@linux.intel.com>
References: <ae9ebfd216b4560d885e3b437d98b93b78e45c1c.1316787913.git.andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: kvm@vger.kernel.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 tools/kvm/util/parse-options.c |   86 +++++++--------------------------------
 1 files changed, 16 insertions(+), 70 deletions(-)

diff --git a/tools/kvm/util/parse-options.c b/tools/kvm/util/parse-options.c
index c280379..2665be5 100644
--- a/tools/kvm/util/parse-options.c
+++ b/tools/kvm/util/parse-options.c
@@ -1,3 +1,4 @@
+#include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
 #include <unistd.h>
@@ -39,82 +40,27 @@ static int get_arg(struct parse_opt_ctx_t *p, const struct option *opt,
 	return 0;
 }
 
-#define numvalue(c)					\
-	((c) >= 'a' ? (c) - 'a' + 10 :			\
-	 (c) >= 'A' ? (c) - 'A' + 10 : (c) - '0')
-
-static u64 readhex(const char *str, bool *error)
-{
-	char *pos = strchr(str, 'x') + 1;
-	u64 res = 0;
-
-	while (*pos) {
-		unsigned int v = numvalue(*pos);
-		if (v > 16) {
-			*error = true;
-			return 0;
-		}
-
-		res = (res * 16) + v;
-		pos++;
-	}
-
-	*error = false;
-	return res;
-}
-
 static int readnum(const struct option *opt, int flags,
 		   const char *str, char **end)
 {
-	if (strchr(str, 'x')) {
-		bool error;
-		u64 value;
-
-		value = readhex(str, &error);
-		if (error)
-			goto enotnum;
-
-		switch (opt->type) {
-		case OPTION_INTEGER:
-			*(int *)opt->value = value;
-			break;
-		case OPTION_UINTEGER:
-			*(unsigned int *)opt->value = value;
-			break;
-		case OPTION_LONG:
-			*(long *)opt->value = value;
-			break;
-		case OPTION_U64:
-			*(u64 *)opt->value = value;
-			break;
-		default:
-			goto invcall;
-		}
-	} else {
-		switch (opt->type) {
-		case OPTION_INTEGER:
-			*(int *)opt->value = strtol(str, end, 10);
-			break;
-		case OPTION_UINTEGER:
-			*(unsigned int *)opt->value = strtol(str, end, 10);
-			break;
-		case OPTION_LONG:
-			*(long *)opt->value = strtol(str, end, 10);
-			break;
-		case OPTION_U64:
-			*(u64 *)opt->value = strtoull(str, end, 10);
-			break;
-		default:
-			goto invcall;
-		}
+	switch (opt->type) {
+	case OPTION_INTEGER:
+		*(int *)opt->value = strtol(str, end, 0);
+		break;
+	case OPTION_UINTEGER:
+		*(unsigned int *)opt->value = strtol(str, end, 0);
+		break;
+	case OPTION_LONG:
+		*(long *)opt->value = strtol(str, end, 0);
+		break;
+	case OPTION_U64:
+		*(u64 *)opt->value = strtoull(str, end, 0);
+		break;
+	default:
+		return opterror(opt, "invalid numeric conversion", flags);
 	}
 
 	return 0;
-
-enotnum:
-	return opterror(opt, "expects a numerical value", flags);
-invcall:
-	return opterror(opt, "invalid numeric conversion", flags);
 }
 
 static int get_value(struct parse_opt_ctx_t *p,
-- 
1.7.6.3

