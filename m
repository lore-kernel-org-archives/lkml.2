Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab2EBTed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:34:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23093 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab2EBTci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:32:38 -0400
X-Authority-Analysis: v=2.0 cv=fvFelSEf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=IQYnrVmFIPkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=meVymXHHAAAA:8 a=4BIMDcWzHu9iSGmsBiMA:9 a=2gubk0O2b5VqwnY0ZwYA:7 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=fn377KWBaqxLxJIR:21 a=YRRBCSia_ZuyMKyK:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120502193236.753783243@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 May 2012 15:24:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 4/9][RFC] ftrace: Consolidate ftrace_location() and ftrace_text_reserved()
References: <20120502192418.024103772@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-Consolidate-ftrace_location-and-ftrace_text_r.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Both ftrace_location() and ftrace_text_reserved() do basically the same thing.
They search to see if an address is in the ftace table (contains an address
that may change from nop to call ftrace_caller). The difference is
that ftrace_location() searches a single address, but ftrace_text_reserved()
searches a range.

This also makes the ftrace_text_reserved() faster as it now uses a bsearch()
instead of linearly searching all the addresses within a page.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   80 ++++++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 333f890..51e07f7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1383,35 +1383,28 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip)
 
 static int ftrace_cmp_recs(const void *a, const void *b)
 {
-	const struct dyn_ftrace *reca = a;
-	const struct dyn_ftrace *recb = b;
+	const struct dyn_ftrace *key = a;
+	const struct dyn_ftrace *rec = b;
 
-	if (reca->ip > recb->ip)
-		return 1;
-	if (reca->ip < recb->ip)
+	if (key->flags < rec->ip)
 		return -1;
+	if (key->ip >= rec->ip + MCOUNT_INSN_SIZE)
+		return 1;
 	return 0;
 }
 
-/**
- * ftrace_location - return true if the ip giving is a traced location
- * @ip: the instruction pointer to check
- *
- * Returns 1 if @ip given is a pointer to a ftrace location.
- * That is, the instruction that is either a NOP or call to
- * the function tracer. It checks the ftrace internal tables to
- * determine if the address belongs or not.
- */
-int ftrace_location(unsigned long ip)
+static int ftrace_location_range(unsigned long start, unsigned long end)
 {
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
 	struct dyn_ftrace key;
 
-	key.ip = ip;
+	key.ip = start;
+	key.flags = end;	/* overload flags, as it is unsigned long */
 
 	for (pg = ftrace_pages_start; pg; pg = pg->next) {
-		if (ip < pg->records[0].ip || ip > pg->records[pg->index - 1].ip)
+		if (end < pg->records[0].ip ||
+		    start >= (pg->records[pg->index - 1].ip + MCOUNT_INSN_SIZE))
 			continue;
 		rec = bsearch(&key, pg->records, pg->index,
 			      sizeof(struct dyn_ftrace),
@@ -1423,6 +1416,36 @@ int ftrace_location(unsigned long ip)
 	return 0;
 }
 
+/**
+ * ftrace_location - return true if the ip giving is a traced location
+ * @ip: the instruction pointer to check
+ *
+ * Returns 1 if @ip given is a pointer to a ftrace location.
+ * That is, the instruction that is either a NOP or call to
+ * the function tracer. It checks the ftrace internal tables to
+ * determine if the address belongs or not.
+ */
+int ftrace_location(unsigned long ip)
+{
+	return ftrace_location_range(ip, ip);
+}
+
+/**
+ * ftrace_text_reserved - return true if range contains an ftrace location
+ * @start: start of range to search
+ * @end: end of range to search (inclusive). @end points to the last byte to check.
+ *
+ * Returns 1 if @start and @end contains a ftrace location.
+ * That is, the instruction that is either a NOP or call to
+ * the function tracer. It checks the ftrace internal tables to
+ * determine if the address belongs or not.
+ */
+int ftrace_text_reserved(void *start, void *end)
+{
+	return ftrace_location_range((unsigned long)start,
+				     (unsigned long)end);
+}
+
 static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 				     int filter_hash,
 				     bool inc)
@@ -1571,29 +1594,6 @@ void ftrace_bug(int failed, unsigned long ip)
 	}
 }
 
-
-/* Return 1 if the address range is reserved for ftrace */
-int ftrace_text_reserved(void *s, void *e)
-{
-	struct dyn_ftrace *rec;
-	struct ftrace_page *pg;
-	unsigned long start = (unsigned long)s;
-	unsigned long end = (unsigned long)e;
-	int i;
-
-	for (pg = ftrace_pages_start; pg; pg = pg->next) {
-		if (end < pg->records[0].ip ||
-		    start >= (pg->records[pg->index - 1].ip + MCOUNT_INSN_SIZE))
-			continue;
-		for (i = 0; i < pg->index; i++) {
-			rec = &pg->records[i];
-			if (rec->ip <= end && rec->ip + MCOUNT_INSN_SIZE > start)
-				return 1;
-		}
-	}
-	return 0;
-}
-
 static int ftrace_check_record(struct dyn_ftrace *rec, int enable, int update)
 {
 	unsigned long flag = 0UL;
-- 
1.7.9.5


