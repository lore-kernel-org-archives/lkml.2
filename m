Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab2GUA3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 20:29:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43863 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab2GUA3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 20:29:41 -0400
Date: Fri, 20 Jul 2012 17:27:37 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH for-3.5 1/4] kdb: Revive dmesg command
Message-ID: <20120721002737.GA2213@lizard>
References: <20120721002529.GA20567@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120721002529.GA20567@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmesg command appears to be broken after the printk rework. The old logic
in kdb code makes no sense in terms of current printk/logging storage
format, and KDB simply hangs forever.

This patch revives the command by switching to kmsg_dumper iterator.

The code is now much more simpler and shorter.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 kernel/debug/kdb/kdb_main.c |   91 ++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 58 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 67b847d..df17c93 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -14,6 +14,7 @@
 #include <linux/ctype.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/kmsg_dump.h>
 #include <linux/reboot.h>
 #include <linux/sched.h>
 #include <linux/sysrq.h>
@@ -2040,8 +2041,15 @@ static int kdb_env(int argc, const char **argv)
  */
 static int kdb_dmesg(int argc, const char **argv)
 {
-	char *syslog_data[4], *start, *end, c = '\0', *p;
-	int diag, logging, logsize, lines = 0, adjust = 0, n;
+	int diag;
+	int logging;
+	int lines = 0;
+	int adjust = 0;
+	int n = 0;
+	int skip = 0;
+	struct kmsg_dumper dumper = { .active = 1 };
+	size_t len;
+	char buf[201];
 
 	if (argc > 2)
 		return KDB_ARGCOUNT;
@@ -2064,22 +2072,10 @@ static int kdb_dmesg(int argc, const char **argv)
 		kdb_set(2, setargs);
 	}
 
-	/* syslog_data[0,1] physical start, end+1.  syslog_data[2,3]
-	 * logical start, end+1. */
-	kdb_syslog_data(syslog_data);
-	if (syslog_data[2] == syslog_data[3])
-		return 0;
-	logsize = syslog_data[1] - syslog_data[0];
-	start = syslog_data[2];
-	end = syslog_data[3];
-#define KDB_WRAP(p) (((p - syslog_data[0]) % logsize) + syslog_data[0])
-	for (n = 0, p = start; p < end; ++p) {
-		c = *KDB_WRAP(p);
-		if (c == '\n')
-			++n;
-	}
-	if (c != '\n')
-		++n;
+	kmsg_dump_rewind(&dumper);
+	while (kmsg_dump_get_line(&dumper, 1, NULL, 0, NULL))
+		n++;
+
 	if (lines < 0) {
 		if (adjust >= n)
 			kdb_printf("buffer only contains %d lines, nothing "
@@ -2087,21 +2083,11 @@ static int kdb_dmesg(int argc, const char **argv)
 		else if (adjust - lines >= n)
 			kdb_printf("buffer only contains %d lines, last %d "
 				   "lines printed\n", n, n - adjust);
-		if (adjust) {
-			for (; start < end && adjust; ++start) {
-				if (*KDB_WRAP(start) == '\n')
-					--adjust;
-			}
-			if (start < end)
-				++start;
-		}
-		for (p = start; p < end && lines; ++p) {
-			if (*KDB_WRAP(p) == '\n')
-				++lines;
-		}
-		end = p;
+		skip = adjust;
+		lines = abs(lines);
 	} else if (lines > 0) {
-		int skip = n - (adjust + lines);
+		skip = n - lines - adjust;
+		lines = abs(lines);
 		if (adjust >= n) {
 			kdb_printf("buffer only contains %d lines, "
 				   "nothing printed\n", n);
@@ -2112,35 +2098,24 @@ static int kdb_dmesg(int argc, const char **argv)
 			kdb_printf("buffer only contains %d lines, first "
 				   "%d lines printed\n", n, lines);
 		}
-		for (; start < end && skip; ++start) {
-			if (*KDB_WRAP(start) == '\n')
-				--skip;
-		}
-		for (p = start; p < end && lines; ++p) {
-			if (*KDB_WRAP(p) == '\n')
-				--lines;
-		}
-		end = p;
+	} else {
+		lines = n;
 	}
-	/* Do a line at a time (max 200 chars) to reduce protocol overhead */
-	c = '\n';
-	while (start != end) {
-		char buf[201];
-		p = buf;
-		if (KDB_FLAG(CMD_INTERRUPT))
-			return 0;
-		while (start < end && (c = *KDB_WRAP(start)) &&
-		       (p - buf) < sizeof(buf)-1) {
-			++start;
-			*p++ = c;
-			if (c == '\n')
-				break;
+
+	if (skip >= n || skip < 0)
+		return 0;
+
+	kmsg_dump_rewind(&dumper);
+	while (kmsg_dump_get_line(&dumper, 1, buf, sizeof(buf), &len)) {
+		if (skip) {
+			skip--;
+			continue;
 		}
-		*p = '\0';
-		kdb_printf("%s", buf);
+		if (!lines--)
+			break;
+
+		kdb_printf("%.*s\n", (int)len - 1, buf);
 	}
-	if (c != '\n')
-		kdb_printf("\n");
 
 	return 0;
 }
-- 
1.7.10.4

