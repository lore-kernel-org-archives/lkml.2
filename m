Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0HRXqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 19:46:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60078 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab0HRXqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 19:46:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=ta2kgWKpXCUz1VWJsi6+hY2TfmMXOThPs5xEJeSQ6abuMp33UlV7kN0Rj1TvRDFODi
         NvsE6rRLNIsM0Zo5e1ODBkpHq6VskV1jEx+fycZXJVPQtNKSQyV642WYfZLVA5i1D5Vj
         7k8tPq1UDr4NhVmg8z6CoLV7zTplo2SAg117U=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
        Borislav Petkov <bp@amd64.org>
Subject: [PATCH 4/7] perf: Factorize callchain context handling
Date: Thu, 19 Aug 2010 01:46:13 +0200
Message-Id: <1282175176-6363-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1282175176-6363-1-git-send-regression-fweisbec@gmail.com>
References: <1282175176-6363-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Store the kernel and user contexts from the generic layer instead
of archs, this gathers some repetitive code.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul Mackerras <paulus@samba.org>
Tested-by: Will Deacon <will.deacon@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Borislav Petkov <bp@amd64.org>
---
 arch/arm/kernel/perf_event.c         |    2 --
 arch/powerpc/kernel/perf_callchain.c |    3 ---
 arch/sh/kernel/perf_callchain.c      |    1 -
 arch/sparc/kernel/perf_event.c       |    3 ---
 arch/x86/kernel/cpu/perf_event.c     |    2 --
 kernel/perf_event.c                  |    5 ++++-
 6 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 0e3bbdb..64ca8c3 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -3049,7 +3049,6 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 {
 	struct frame_tail *tail;
 
-	perf_callchain_store(entry, PERF_CONTEXT_USER);
 
 	tail = (struct frame_tail *)regs->ARM_fp - 1;
 
@@ -3076,7 +3075,6 @@ perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
 {
 	struct stackframe fr;
 
-	perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
 	fr.fp = regs->ARM_fp;
 	fr.sp = regs->ARM_sp;
 	fr.lr = regs->ARM_lr;
diff --git a/arch/powerpc/kernel/perf_callchain.c b/arch/powerpc/kernel/perf_callchain.c
index f7a85ed..d05ae42 100644
--- a/arch/powerpc/kernel/perf_callchain.c
+++ b/arch/powerpc/kernel/perf_callchain.c
@@ -57,7 +57,6 @@ perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
 
 	lr = regs->link;
 	sp = regs->gpr[1];
-	perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
 	perf_callchain_store(entry, regs->nip);
 
 	if (!validate_sp(sp, current, STACK_FRAME_OVERHEAD))
@@ -234,7 +233,6 @@ static void perf_callchain_user_64(struct perf_callchain_entry *entry,
 	next_ip = regs->nip;
 	lr = regs->link;
 	sp = regs->gpr[1];
-	perf_callchain_store(entry, PERF_CONTEXT_USER);
 	perf_callchain_store(entry, next_ip);
 
 	for (;;) {
@@ -435,7 +433,6 @@ static void perf_callchain_user_32(struct perf_callchain_entry *entry,
 	next_ip = regs->nip;
 	lr = regs->link;
 	sp = regs->gpr[1];
-	perf_callchain_store(entry, PERF_CONTEXT_USER);
 	perf_callchain_store(entry, next_ip);
 
 	while (entry->nr < PERF_MAX_STACK_DEPTH) {
diff --git a/arch/sh/kernel/perf_callchain.c b/arch/sh/kernel/perf_callchain.c
index ef076a9..d5ca1ef 100644
--- a/arch/sh/kernel/perf_callchain.c
+++ b/arch/sh/kernel/perf_callchain.c
@@ -47,7 +47,6 @@ static const struct stacktrace_ops callchain_ops = {
 void
 perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
 {
-	perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
 	perf_callchain_store(entry, regs->pc);
 
 	unwind_stack(NULL, regs, NULL, &callchain_ops, entry);
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 460162d..4bc4029 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1293,7 +1293,6 @@ void perf_callchain_kernel(struct perf_callchain_entry *entry,
 
 	stack_trace_flush();
 
-	perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
 	perf_callchain_store(entry, regs->tpc);
 
 	ksp = regs->u_regs[UREG_I6];
@@ -1337,7 +1336,6 @@ static void perf_callchain_user_64(struct perf_callchain_entry *entry,
 {
 	unsigned long ufp;
 
-	perf_callchain_store(entry, PERF_CONTEXT_USER);
 	perf_callchain_store(entry, regs->tpc);
 
 	ufp = regs->u_regs[UREG_I6] + STACK_BIAS;
@@ -1360,7 +1358,6 @@ static void perf_callchain_user_32(struct perf_callchain_entry *entry,
 {
 	unsigned long ufp;
 
-	perf_callchain_store(entry, PERF_CONTEXT_USER);
 	perf_callchain_store(entry, regs->tpc);
 
 	ufp = regs->u_regs[UREG_I6] & 0xffffffffUL;
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 39f8421..a3c9222 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1608,7 +1608,6 @@ static const struct stacktrace_ops backtrace_ops = {
 void
 perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
 {
-	perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
 	perf_callchain_store(entry, regs->ip);
 
 	dump_trace(NULL, regs, NULL, regs->bp, &backtrace_ops, entry);
@@ -1660,7 +1659,6 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 
 	fp = (void __user *)regs->bp;
 
-	perf_callchain_store(entry, PERF_CONTEXT_USER);
 	perf_callchain_store(entry, regs->ip);
 
 	if (perf_callchain_user32(regs, entry))
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 02efde6..615d024 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2969,6 +2969,7 @@ static struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 	entry->nr = 0;
 
 	if (!user_mode(regs)) {
+		perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
 		perf_callchain_kernel(entry, regs);
 		if (current->mm)
 			regs = task_pt_regs(current);
@@ -2976,8 +2977,10 @@ static struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 			regs = NULL;
 	}
 
-	if (regs)
+	if (regs) {
+		perf_callchain_store(entry, PERF_CONTEXT_USER);
 		perf_callchain_user(entry, regs);
+	}
 
 	return entry;
 }
-- 
1.6.2.3

