Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab1ELNMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:12:48 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:50611 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911Ab1ELNMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:12:45 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, oleg@redhat.com, akpm@linux-foundation.org,
        ying.huang@intel.com, ssp@redhat.com, namhyung@gmail.com,
        fweisbec@gmail.com, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de,
        robert.richter@amd.com, lethal@linux-sh.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/2] x86: remove warning and warning_symbol from struct stacktrace_ops
Date: Thu, 12 May 2011 15:11:12 +0200
Message-Id: <1305205872-10321-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305205872-10321-1-git-send-email-richard@nod.at>
References: <1305205872-10321-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both warning and warning_symbol are nowhere used.
Let's get rid of them.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/x86/include/asm/stacktrace.h |    3 ---
 arch/x86/kernel/cpu/perf_event.c  |   13 -------------
 arch/x86/kernel/dumpstack.c       |   16 ----------------
 arch/x86/kernel/stacktrace.c      |   13 -------------
 arch/x86/oprofile/backtrace.c     |   13 -------------
 5 files changed, 0 insertions(+), 58 deletions(-)

diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index d7e89c8..70bbe39 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -37,9 +37,6 @@ print_context_stack_bp(struct thread_info *tinfo,
 /* Generic stack tracer with callbacks */
 
 struct stacktrace_ops {
-	void (*warning)(void *data, char *msg);
-	/* msg must contain %s for the symbol */
-	void (*warning_symbol)(void *data, char *msg, unsigned long symbol);
 	void (*address)(void *data, unsigned long address, int reliable);
 	/* On negative return stop dumping */
 	int (*stack)(void *data, char *name);
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index e638689..2828bca 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1766,17 +1766,6 @@ static struct pmu pmu = {
  * callchain support
  */
 
-static void
-backtrace_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-	/* Ignore warnings */
-}
-
-static void backtrace_warning(void *data, char *msg)
-{
-	/* Ignore warnings */
-}
-
 static int backtrace_stack(void *data, char *name)
 {
 	return 0;
@@ -1790,8 +1779,6 @@ static void backtrace_address(void *data, unsigned long addr, int reliable)
 }
 
 static const struct stacktrace_ops backtrace_ops = {
-	.warning		= backtrace_warning,
-	.warning_symbol		= backtrace_warning_symbol,
 	.stack			= backtrace_stack,
 	.address		= backtrace_address,
 	.walk_stack		= print_context_stack_bp,
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index e2a3f06..f478ff6 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -135,20 +135,6 @@ print_context_stack_bp(struct thread_info *tinfo,
 }
 EXPORT_SYMBOL_GPL(print_context_stack_bp);
 
-
-static void
-print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-	printk(data);
-	print_symbol(msg, symbol);
-	printk("\n");
-}
-
-static void print_trace_warning(void *data, char *msg)
-{
-	printk("%s%s\n", (char *)data, msg);
-}
-
 static int print_trace_stack(void *data, char *name)
 {
 	printk("%s <%s> ", (char *)data, name);
@@ -166,8 +152,6 @@ static void print_trace_address(void *data, unsigned long addr, int reliable)
 }
 
 static const struct stacktrace_ops print_trace_ops = {
-	.warning		= print_trace_warning,
-	.warning_symbol		= print_trace_warning_symbol,
 	.stack			= print_trace_stack,
 	.address		= print_trace_address,
 	.walk_stack		= print_context_stack,
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 6515733..55d9bc0 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -9,15 +9,6 @@
 #include <linux/uaccess.h>
 #include <asm/stacktrace.h>
 
-static void save_stack_warning(void *data, char *msg)
-{
-}
-
-static void
-save_stack_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-}
-
 static int save_stack_stack(void *data, char *name)
 {
 	return 0;
@@ -53,16 +44,12 @@ save_stack_address_nosched(void *data, unsigned long addr, int reliable)
 }
 
 static const struct stacktrace_ops save_stack_ops = {
-	.warning	= save_stack_warning,
-	.warning_symbol	= save_stack_warning_symbol,
 	.stack		= save_stack_stack,
 	.address	= save_stack_address,
 	.walk_stack	= print_context_stack,
 };
 
 static const struct stacktrace_ops save_stack_ops_nosched = {
-	.warning	= save_stack_warning,
-	.warning_symbol	= save_stack_warning_symbol,
 	.stack		= save_stack_stack,
 	.address	= save_stack_address_nosched,
 	.walk_stack	= print_context_stack,
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 2d49d4e..a5b64ab 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -16,17 +16,6 @@
 #include <asm/stacktrace.h>
 #include <linux/compat.h>
 
-static void backtrace_warning_symbol(void *data, char *msg,
-				     unsigned long symbol)
-{
-	/* Ignore warnings */
-}
-
-static void backtrace_warning(void *data, char *msg)
-{
-	/* Ignore warnings */
-}
-
 static int backtrace_stack(void *data, char *name)
 {
 	/* Yes, we want all stacks */
@@ -42,8 +31,6 @@ static void backtrace_address(void *data, unsigned long addr, int reliable)
 }
 
 static struct stacktrace_ops backtrace_ops = {
-	.warning	= backtrace_warning,
-	.warning_symbol	= backtrace_warning_symbol,
 	.stack		= backtrace_stack,
 	.address	= backtrace_address,
 	.walk_stack	= print_context_stack,
-- 
1.7.4.2

