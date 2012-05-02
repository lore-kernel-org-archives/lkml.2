Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab2EBTcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:32:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7090 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988Ab2EBTci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:32:38 -0400
X-Authority-Analysis: v=2.0 cv=bcnpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=BGuSG2PTZbwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=5KKST3nhYfKchGJsNdYA:9 a=mFn69egfai9yg4NuL1gA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120502193236.324199805@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 May 2012 15:24:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/9][RFC] ftrace: Remove extra helper functions
References: <20120502192418.024103772@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Remove-extra-helper-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The ftrace_record_ip() and ftrace_alloc_dyn_node() were from the
time of the ftrace daemon. Although they were still used, they
still make things a bit more complex than necessary.

Move the code into the one function that uses it, and remove the
helper functions.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   61 +++++++++++++++++++------------------------------
 1 file changed, 24 insertions(+), 37 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6a19e81..4e608f8 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1520,35 +1520,6 @@ static void ftrace_hash_rec_enable(struct ftrace_ops *ops,
 	__ftrace_hash_rec_update(ops, filter_hash, 1);
 }
 
-static struct dyn_ftrace *ftrace_alloc_dyn_node(unsigned long ip)
-{
-	if (ftrace_pages->index == ftrace_pages->size) {
-		/* We should have allocated enough */
-		if (WARN_ON(!ftrace_pages->next))
-			return NULL;
-		ftrace_pages = ftrace_pages->next;
-	}
-
-	return &ftrace_pages->records[ftrace_pages->index++];
-}
-
-static struct dyn_ftrace *
-ftrace_record_ip(unsigned long ip)
-{
-	struct dyn_ftrace *rec;
-
-	if (ftrace_disabled)
-		return NULL;
-
-	rec = ftrace_alloc_dyn_node(ip);
-	if (!rec)
-		return NULL;
-
-	rec->ip = ip;
-
-	return rec;
-}
-
 static void print_ip_ins(const char *fmt, unsigned char *p)
 {
 	int i;
@@ -3715,7 +3686,9 @@ static int ftrace_process_locs(struct module *mod,
 			       unsigned long *start,
 			       unsigned long *end)
 {
+	struct ftrace_page *start_pg;
 	struct ftrace_page *pg;
+	struct dyn_ftrace *rec;
 	unsigned long count;
 	unsigned long *p;
 	unsigned long addr;
@@ -3730,8 +3703,8 @@ static int ftrace_process_locs(struct module *mod,
 	sort(start, count, sizeof(*start),
 	     ftrace_cmp_ips, ftrace_swap_ips);
 
-	pg = ftrace_allocate_pages(count);
-	if (!pg)
+	start_pg = ftrace_allocate_pages(count);
+	if (!start_pg)
 		return -ENOMEM;
 
 	mutex_lock(&ftrace_lock);
@@ -3744,7 +3717,7 @@ static int ftrace_process_locs(struct module *mod,
 	if (!mod) {
 		WARN_ON(ftrace_pages || ftrace_pages_start);
 		/* First initialization */
-		ftrace_pages = ftrace_pages_start = pg;
+		ftrace_pages = ftrace_pages_start = start_pg;
 	} else {
 		if (!ftrace_pages)
 			goto out;
@@ -3755,11 +3728,11 @@ static int ftrace_process_locs(struct module *mod,
 				ftrace_pages = ftrace_pages->next;
 		}
 
-		ftrace_pages->next = pg;
-		ftrace_pages = pg;
+		ftrace_pages->next = start_pg;
 	}
 
 	p = start;
+	pg = start_pg;
 	while (p < end) {
 		addr = ftrace_call_adjust(*p++);
 		/*
@@ -3770,12 +3743,26 @@ static int ftrace_process_locs(struct module *mod,
 		 */
 		if (!addr)
 			continue;
-		if (!ftrace_record_ip(addr))
-			break;
+
+		if (pg->index == pg->size) {
+			/* We should have allocated enough */
+			if (WARN_ON(!pg->next))
+				break;
+			pg = pg->next;
+		}
+
+		rec = &pg->records[pg->index++];
+		rec->ip = addr;
 	}
 
+	/* We should have used all pages */
+	WARN_ON(pg->next);
+
+	/* Assign the last page to ftrace_pages */
+	ftrace_pages = pg;
+
 	/* These new locations need to be initialized */
-	ftrace_new_pgs = pg;
+	ftrace_new_pgs = start_pg;
 
 	/*
 	 * We only need to disable interrupts on start up
-- 
1.7.9.5


