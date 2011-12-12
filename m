Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab1LLHQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:16:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60318 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab1LLHN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:13:58 -0500
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 08/11] kvm tools: move strlcat() to util/strbuf.c
Date: Mon, 12 Dec 2011 15:15:52 +0800
Message-Id: <1323674155-17570-9-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1323674155-17570-1-git-send-email-laijs@cn.fujitsu.com>
References: <1323674155-17570-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-12 15:13:21,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-12 15:13:22,
	Serialize complete at 2011-12-12 15:13:22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strlcat() is a string related function.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 tools/kvm/builtin-run.c        |    1 +
 tools/kvm/include/kvm/strbuf.h |   13 +++++++++++++
 tools/kvm/include/kvm/util.h   |   10 ----------
 tools/kvm/util/strbuf.c        |   26 ++++++++++++++++++++++++++
 tools/kvm/util/util.c          |   25 -------------------------
 5 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/tools/kvm/builtin-run.c b/tools/kvm/builtin-run.c
index 76ce657..5afc8c0 100644
--- a/tools/kvm/builtin-run.c
+++ b/tools/kvm/builtin-run.c
@@ -21,6 +21,7 @@
 #include "kvm/mutex.h"
 #include "kvm/term.h"
 #include "kvm/util.h"
+#include "kvm/strbuf.h"
 #include "kvm/vesa.h"
 #include "kvm/irq.h"
 #include "kvm/kvm.h"
diff --git a/tools/kvm/include/kvm/strbuf.h b/tools/kvm/include/kvm/strbuf.h
index e67ca20..8fdef7e 100644
--- a/tools/kvm/include/kvm/strbuf.h
+++ b/tools/kvm/include/kvm/strbuf.h
@@ -1,6 +1,19 @@
 #ifndef __STRBUF_H__
 #define __STRBUF_H__
 
+#include <sys/types.h>
+#include <string.h>
+
 int prefixcmp(const char *str, const char *prefix);
 
+extern size_t strlcat(char *dest, const char *src, size_t count);
+
+/* some inline functions */
+
+static inline const char *skip_prefix(const char *str, const char *prefix)
+{
+	size_t len = strlen(prefix);
+	return strncmp(str, prefix, len) ? NULL : str + len;
+}
+
 #endif
diff --git a/tools/kvm/include/kvm/util.h b/tools/kvm/include/kvm/util.h
index dc2e0b9..3e382fc 100644
--- a/tools/kvm/include/kvm/util.h
+++ b/tools/kvm/include/kvm/util.h
@@ -58,16 +58,6 @@ do {								\
 		__stringify(cnd) "\n");				\
 } while (0)
 
-extern size_t strlcat(char *dest, const char *src, size_t count);
-
-/* some inline functions */
-
-static inline const char *skip_prefix(const char *str, const char *prefix)
-{
-	size_t len = strlen(prefix);
-	return strncmp(str, prefix, len) ? NULL : str + len;
-}
-
 #define MSECS_TO_USECS(s) ((s) * 1000)
 
 /* Millisecond sleep */
diff --git a/tools/kvm/util/strbuf.c b/tools/kvm/util/strbuf.c
index ec77ab1..6632a14 100644
--- a/tools/kvm/util/strbuf.c
+++ b/tools/kvm/util/strbuf.c
@@ -1,5 +1,6 @@
 
 /* user defined headers */
+#include <kvm/util.h>
 #include <kvm/strbuf.h>
 
 int prefixcmp(const char *str, const char *prefix)
@@ -11,3 +12,28 @@ int prefixcmp(const char *str, const char *prefix)
 			return (unsigned char)*prefix - (unsigned char)*str;
 	}
 }
+
+/**
+ * strlcat - Append a length-limited, %NUL-terminated string to another
+ * @dest: The string to be appended to
+ * @src: The string to append to it
+ * @count: The size of the destination buffer.
+ */
+size_t strlcat(char *dest, const char *src, size_t count)
+{
+	size_t dsize = strlen(dest);
+	size_t len = strlen(src);
+	size_t res = dsize + len;
+
+	DIE_IF(dsize >= count);
+
+	dest += dsize;
+	count -= dsize;
+	if (len >= count)
+		len = count - 1;
+
+	memcpy(dest, src, len);
+	dest[len] = 0;
+
+	return res;
+}
diff --git a/tools/kvm/util/util.c b/tools/kvm/util/util.c
index 4efbce9..682ed6c 100644
--- a/tools/kvm/util/util.c
+++ b/tools/kvm/util/util.c
@@ -74,28 +74,3 @@ void die_perror(const char *s)
 	perror(s);
 	exit(1);
 }
-
-/**
- * strlcat - Append a length-limited, %NUL-terminated string to another
- * @dest: The string to be appended to
- * @src: The string to append to it
- * @count: The size of the destination buffer.
- */
-size_t strlcat(char *dest, const char *src, size_t count)
-{
-	size_t dsize = strlen(dest);
-	size_t len = strlen(src);
-	size_t res = dsize + len;
-
-	DIE_IF(dsize >= count);
-
-	dest += dsize;
-	count -= dsize;
-	if (len >= count)
-		len = count - 1;
-
-	memcpy(dest, src, len);
-	dest[len] = 0;
-
-	return res;
-}
-- 
1.7.4.4

