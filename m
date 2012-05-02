Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab2EBTck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:32:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11476 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab2EBTci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:32:38 -0400
X-Authority-Analysis: v=2.0 cv=N/Wr5hBB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=6qGlG7qhhrQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=meVymXHHAAAA:8 a=xkS7cEQK18UYUIan8ZcA:9 a=5U9k56OlpVqdqvqouuEA:7 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=BKN6tE9iLdKNP7uY:21 a=ZniWxbwpcDarBSNa:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120502193236.535319046@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 May 2012 15:24:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/9][RFC] ftrace: Speed up search by skipping pages by address
References: <20120502192418.024103772@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Speed-up-search-by-skipping-pages-by-address.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

As all records in a page of the ftrace table are sorted, we can
speed up the search algorithm by checking if the address to look for
falls in between the first and last record ip on the page.

This speeds up both the ftrace_location() and ftrace_text_reserved()
algorithms, as it can skip full pages when the search address is
not in them.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4e608f8..333f890 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1411,6 +1411,8 @@ int ftrace_location(unsigned long ip)
 	key.ip = ip;
 
 	for (pg = ftrace_pages_start; pg; pg = pg->next) {
+		if (ip < pg->records[0].ip || ip > pg->records[pg->index - 1].ip)
+			continue;
 		rec = bsearch(&key, pg->records, pg->index,
 			      sizeof(struct dyn_ftrace),
 			      ftrace_cmp_recs);
@@ -1571,16 +1573,24 @@ void ftrace_bug(int failed, unsigned long ip)
 
 
 /* Return 1 if the address range is reserved for ftrace */
-int ftrace_text_reserved(void *start, void *end)
+int ftrace_text_reserved(void *s, void *e)
 {
 	struct dyn_ftrace *rec;
 	struct ftrace_page *pg;
+	unsigned long start = (unsigned long)s;
+	unsigned long end = (unsigned long)e;
+	int i;
 
-	do_for_each_ftrace_rec(pg, rec) {
-		if (rec->ip <= (unsigned long)end &&
-		    rec->ip + MCOUNT_INSN_SIZE > (unsigned long)start)
-			return 1;
-	} while_for_each_ftrace_rec();
+	for (pg = ftrace_pages_start; pg; pg = pg->next) {
+		if (end < pg->records[0].ip ||
+		    start >= (pg->records[pg->index - 1].ip + MCOUNT_INSN_SIZE))
+			continue;
+		for (i = 0; i < pg->index; i++) {
+			rec = &pg->records[i];
+			if (rec->ip <= end && rec->ip + MCOUNT_INSN_SIZE > start)
+				return 1;
+		}
+	}
 	return 0;
 }
 
-- 
1.7.9.5


