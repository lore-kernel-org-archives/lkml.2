Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab1IWO0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:26:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:53645 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466Ab1IWO0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:26:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,430,1312182000"; 
   d="scan'208";a="69519336"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pekka Enberg <penberg@kernel.org>, kvm@vger.kernel.org
Subject: [RFC][PATCH] tools: kvm: don't use custom strtoul for hex numbers
Date: Fri, 23 Sep 2011 17:25:46 +0300
Message-Id: <ae9ebfd216b4560d885e3b437d98b93b78e45c1c.1316787913.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: kvm@vger.kernel.org
---
 tools/kvm/util/parse-options.c |   81 ++++++++--------------------------------
 1 files changed, 16 insertions(+), 65 deletions(-)

diff --git a/tools/kvm/util/parse-options.c b/tools/kvm/util/parse-options.c
index c280379..4f9fdff 100644
--- a/tools/kvm/util/parse-options.c
+++ b/tools/kvm/util/parse-options.c
@@ -1,3 +1,4 @@
+#include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
 #include <unistd.h>
@@ -39,74 +40,24 @@ static int get_arg(struct parse_opt_ctx_t *p, const struct option *opt,
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
+		goto invcall;
 	}
 
 	return 0;
-- 
1.7.6.3

