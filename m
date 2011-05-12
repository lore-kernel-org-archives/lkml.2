Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab1ELUcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 16:32:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39401 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758599Ab1ELUcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 16:32:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ufpE/vEN0SjIyjUvWygsanWv+14+TVPhaYzmSiAzMWt++7RaaB30cXrx7sQ3gIqBfy
         +Rw4V8pOsRucDLx/iD2Dn52oFZboQgmcezswNlDOTM4dB/eaLVII73gWfKLAn1GUwqwJ
         coKPUp9miSVzvp+S80M19e3kyQ8z6agaXnmQY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Richard Weinberger <richard@nod.at>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        Soeren Sandmann Pedersen <ssp@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, x86 <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Robert Richter <robert.richter@amd.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] x86: Remove warning and warning_symbol from struct stacktrace_ops
Date: Thu, 12 May 2011 22:32:05 +0200
Message-Id: <1305232326-9804-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1305232326-9804-1-git-send-email-fweisbec@gmail.com>
References: <1305232326-9804-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

Both warning and warning_symbol are nowhere used.
Let's get rid of them.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Soeren Sandmann Pedersen <ssp@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: x86 <x86@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Link: http://lkml.kernel.org/r/1305205872-10321-2-git-send-email-richard@nod.at
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
index 0de6b2b..3a0338b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1773,17 +1773,6 @@ static struct pmu pmu = {
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
@@ -1797,8 +1786,6 @@ static void backtrace_address(void *data, unsigned long addr, int reliable)
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
1.7.3.2

