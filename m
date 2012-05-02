Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2EBTcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:32:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8627 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070Ab2EBTci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:32:38 -0400
X-Authority-Analysis: v=2.0 cv=T/EOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=MiADmTIbiPcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=_IGxp2mfFUYWymhGOywA:9 a=9GTYEX1tESxK75rzqtoA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120502193236.102368477@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 May 2012 15:24:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/9][RFC] ftrace: Sort all function addresses, not just per page
References: <20120502192418.024103772@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Sort-all-function-addresses-not-just-per-page.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Instead of just sorting the ip's of the functions per ftrace page,
sort the entire list before adding them to the ftrace pages.

This will allow the bsearch algorithm to be sped up as it can
also sort by pages, not just records within a page.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-generic/vmlinux.lds.h |    2 +-
 kernel/trace/ftrace.c             |   34 ++++++++++++++++++++++------------
 2 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 8aeadf6..4e2e1cc 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -486,8 +486,8 @@
 	CPU_DISCARD(init.data)						\
 	MEM_DISCARD(init.data)						\
 	KERNEL_CTORS()							\
-	*(.init.rodata)							\
 	MCOUNT_REC()							\
+	*(.init.rodata)							\
 	FTRACE_EVENTS()							\
 	TRACE_SYSCALLS()						\
 	DEV_DISCARD(init.rodata)					\
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0fa92f6..6a19e81 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3688,15 +3688,27 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 	return 0;
 }
 
-static void ftrace_swap_recs(void *a, void *b, int size)
+static int ftrace_cmp_ips(const void *a, const void *b)
 {
-	struct dyn_ftrace *reca = a;
-	struct dyn_ftrace *recb = b;
-	struct dyn_ftrace t;
+	const unsigned long *ipa = a;
+	const unsigned long *ipb = b;
 
-	t = *reca;
-	*reca = *recb;
-	*recb = t;
+	if (*ipa > *ipb)
+		return 1;
+	if (*ipa < *ipb)
+		return -1;
+	return 0;
+}
+
+static void ftrace_swap_ips(void *a, void *b, int size)
+{
+	unsigned long *ipa = a;
+	unsigned long *ipb = b;
+	unsigned long t;
+
+	t = *ipa;
+	*ipa = *ipb;
+	*ipb = t;
 }
 
 static int ftrace_process_locs(struct module *mod,
@@ -3715,6 +3727,9 @@ static int ftrace_process_locs(struct module *mod,
 	if (!count)
 		return 0;
 
+	sort(start, count, sizeof(*start),
+	     ftrace_cmp_ips, ftrace_swap_ips);
+
 	pg = ftrace_allocate_pages(count);
 	if (!pg)
 		return -ENOMEM;
@@ -3762,11 +3777,6 @@ static int ftrace_process_locs(struct module *mod,
 	/* These new locations need to be initialized */
 	ftrace_new_pgs = pg;
 
-	/* Make each individual set of pages sorted by ips */
-	for (; pg; pg = pg->next)
-		sort(pg->records, pg->index, sizeof(struct dyn_ftrace),
-		     ftrace_cmp_recs, ftrace_swap_recs);
-
 	/*
 	 * We only need to disable interrupts on start up
 	 * because we are modifying code that an interrupt
-- 
1.7.9.5


