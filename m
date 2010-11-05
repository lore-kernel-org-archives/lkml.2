Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0KEXNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 19:13:32 -0400
Received: from mail.perches.com ([173.55.12.10]:4361 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085Ab0KEXMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 19:12:43 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] fs/proc/base.c kernel/latencytop.c: Convert sprintf_symbol to %ps
Date: Fri,  5 Nov 2010 16:12:37 -0700
Message-Id: <1288998760-11775-5-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288998760-11775-1-git-send-email-joe@perches.com>
References: <1288998760-11775-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use temporary lr for struct latency_record for improved readability
and fewer columns used.  Removed trailing space from output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/proc/base.c      |   22 ++++++++--------------
 kernel/latencytop.c |   23 +++++++++--------------
 2 files changed, 17 insertions(+), 28 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index f3d02ca..1e0cbf4 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -373,24 +373,18 @@ static int lstats_show_proc(struct seq_file *m, void *v)
 		return -ESRCH;
 	seq_puts(m, "Latency Top version : v0.1\n");
 	for (i = 0; i < 32; i++) {
-		if (task->latency_record[i].backtrace[0]) {
+		struct latency_record *lr = &task->latency_record[i];
+		if (lr->backtrace[0]) {
 			int q;
-			seq_printf(m, "%i %li %li ",
-				task->latency_record[i].count,
-				task->latency_record[i].time,
-				task->latency_record[i].max);
+			seq_printf(m, "%i %li %li",
+				   lr->count, lr->time, lr->max);
 			for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
-				char sym[KSYM_SYMBOL_LEN];
-				char *c;
-				if (!task->latency_record[i].backtrace[q])
+				unsigned long bt = lr->backtrace[q]; 
+				if (!bt)
 					break;
-				if (task->latency_record[i].backtrace[q] == ULONG_MAX)
+				if (bt == ULONG_MAX)
 					break;
-				sprint_symbol(sym, task->latency_record[i].backtrace[q]);
-				c = strchr(sym, '+');
-				if (c)
-					*c = 0;
-				seq_printf(m, "%s ", sym);
+				seq_printf(m, " %ps", (void *)bt);
 			}
 			seq_printf(m, "\n");
 		}
diff --git a/kernel/latencytop.c b/kernel/latencytop.c
index 877fb30..7cbbf5c 100644
--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -242,24 +242,19 @@ static int lstats_show(struct seq_file *m, void *v)
 	seq_puts(m, "Latency Top version : v0.1\n");
 
 	for (i = 0; i < MAXLR; i++) {
-		if (latency_record[i].backtrace[0]) {
+		struct latency_record *lr = &latency_record[i];
+
+		if (lr->backtrace[0]) {
 			int q;
-			seq_printf(m, "%i %lu %lu ",
-				latency_record[i].count,
-				latency_record[i].time,
-				latency_record[i].max);
+			seq_printf(m, "%i %lu %lu",
+				   lr->count, lr->time, lr->max);
 			for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
-				char sym[KSYM_SYMBOL_LEN];
-				char *c;
-				if (!latency_record[i].backtrace[q])
+				unsigned long bt = lr->backtrace[q]; 
+				if (!bt)
 					break;
-				if (latency_record[i].backtrace[q] == ULONG_MAX)
+				if (bt == ULONG_MAX)
 					break;
-				sprint_symbol(sym, latency_record[i].backtrace[q]);
-				c = strchr(sym, '+');
-				if (c)
-					*c = 0;
-				seq_printf(m, "%s ", sym);
+				seq_printf(m, " %ps", (void *)bt);
 			}
 			seq_printf(m, "\n");
 		}
-- 
1.7.3.2.146.gca209

