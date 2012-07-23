Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2GWPAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:00:15 -0400
Received: from shutemov.name ([176.9.204.213]:44214 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab2GWPAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:00:12 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 2/2] perf: use XSI-complaint version of strerror_r() instead of GNU-specific
Date: Mon, 23 Jul 2012 18:00:45 +0300
Message-Id: <1343055645-24083-2-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1343055645-24083-1-git-send-email-kirill@shutemov.name>
References: <1343055645-24083-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>

Perf uses GNU-specific version of strerror_r(). The GNU-specific
strerror_r() returns a pointer to a string containing the error message.
This may be either a pointer to a string that the function stores in
buf, or a pointer to some (immutable) static string (in which case buf
is unused).

In glibc-2.16 GNU version was marked with attribute warn_unused_result.
It triggers few warnings in perf:

util/target.c: In function ‘perf_target__strerror’:
util/target.c:114:13: error: ignoring return value of ‘strerror_r’, declared with attribute warn_unused_result [-Werror=unused-result]
ui/browsers/hists.c: In function ‘hist_browser__dump’:
ui/browsers/hists.c:981:13: error: ignoring return value of ‘strerror_r’, declared with attribute warn_unused_result [-Werror=unused-result]

They are bugs.

The right way to fix it is to switch to XSI-compliant version.
Unfortunately, glibc doesn't allow to get XSI-complaint strerror_r() and
_GNU_SOURCE at the same time.

Let's bundle XSI-complaint version to perf and use it.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 tools/perf/ui/browsers/hists.c |  2 +-
 tools/perf/util/string.c       | 25 +++++++++++++++++++++++++
 tools/perf/util/target.c       |  3 ++-
 tools/perf/util/util.h         |  1 +
 4 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 482f051..8bd1780 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -978,7 +978,7 @@ static int hist_browser__dump(struct hist_browser *browser)
 	fp = fopen(filename, "w");
 	if (fp == NULL) {
 		char bf[64];
-		strerror_r(errno, bf, sizeof(bf));
+		xsi_strerror_r(errno, bf, sizeof(bf));
 		ui_helpline__fpush("Couldn't write to %s: %s", filename, bf);
 		return -1;
 	}
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 199bc4d..71b68b9 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -1,5 +1,6 @@
 #include "util.h"
 #include "string.h"
+#include <linux/kernel.h>
 
 #define K 1024LL
 /*
@@ -335,3 +336,27 @@ char *rtrim(char *s)
 
 	return s;
 }
+
+/**
+ * xsi_strerror_r() - XSI-compliant version of strerror_r()
+ */
+int xsi_strerror_r(int errnum, char *buf, size_t buflen)
+{
+	const char *p;
+	size_t len;
+
+	/* GNU-specific version of strerror_r() */
+	p = strerror_r(errnum, buf, buflen);
+
+	/* glibc use the buffer only if errnum is not correct */
+	if (p == buf)
+		return EINVAL;
+
+	len = strlen(p);
+	if (buflen > 0) {
+		char *c = mempcpy(buf, p, min(buflen - 1, len));
+		*c = '\0';
+	}
+
+	return buflen > len ? 0 : ERANGE;
+}
diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 1064d5b..0ec1a30 100644
--- a/tools/perf/util/target.c
+++ b/tools/perf/util/target.c
@@ -8,6 +8,7 @@
 
 #include "target.h"
 #include "debug.h"
+#include "util.h"
 
 #include <pwd.h>
 #include <string.h>
@@ -111,7 +112,7 @@ int perf_target__strerror(struct perf_target *target, int errnum,
 	const char *msg;
 
 	if (errnum >= 0) {
-		strerror_r(errnum, buf, buflen);
+		xsi_strerror_r(errnum, buf, buflen);
 		return 0;
 	}
 
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index b13c733..3e85d63 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -265,5 +265,6 @@ bool is_power_of_2(unsigned long n)
 size_t hex_width(u64 v);
 
 char *rtrim(char *s);
+int xsi_strerror_r(int errnum, char *buf, size_t buflen);
 
 #endif
-- 
1.7.11.2

