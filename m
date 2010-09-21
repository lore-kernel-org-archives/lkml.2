Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab0IUTjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 15:39:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36446 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333Ab0IUTjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 15:39:31 -0400
Date: Tue, 21 Sep 2010 21:39:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20100921193904.GA13176@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (1):
      x86: Fix instruction breakpoint encoding

Masami Hiramatsu (1):
      kprobes: Fix Kconfig dependency

Matt Helsley (1):
      hw breakpoints: Fix pid namespace bug

Patrick Simmons (1):
      oprofile: Add Support for Intel CPU Family 6 / Model 22 (Intel Celeron 540)


 arch/Kconfig                         |    4 +-
 arch/x86/include/asm/hw_breakpoint.h |    2 +-
 arch/x86/kernel/hw_breakpoint.c      |   40 ++++++++++++++++-----------------
 arch/x86/oprofile/nmi_int.c          |    4 ++-
 kernel/hw_breakpoint.c               |    3 +-
 5 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 4877a8c..fe48fc7 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -32,8 +32,9 @@ config HAVE_OPROFILE
 
 config KPROBES
 	bool "Kprobes"
-	depends on KALLSYMS && MODULES
+	depends on MODULES
 	depends on HAVE_KPROBES
+	select KALLSYMS
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
@@ -45,7 +46,6 @@ config OPTPROBES
 	def_bool y
 	depends on KPROBES && HAVE_OPTPROBES
 	depends on !PREEMPT
-	select KALLSYMS_ALL
 
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	bool
diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 528a11e..824ca07 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -20,7 +20,7 @@ struct arch_hw_breakpoint {
 #include <linux/list.h>
 
 /* Available HW breakpoint length encodings */
-#define X86_BREAKPOINT_LEN_X		0x00
+#define X86_BREAKPOINT_LEN_X		0x40
 #define X86_BREAKPOINT_LEN_1		0x40
 #define X86_BREAKPOINT_LEN_2		0x44
 #define X86_BREAKPOINT_LEN_4		0x4c
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index a474ec3..ff15c9d 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -206,11 +206,27 @@ int arch_check_bp_in_kernelspace(struct perf_event *bp)
 int arch_bp_generic_fields(int x86_len, int x86_type,
 			   int *gen_len, int *gen_type)
 {
-	/* Len */
-	switch (x86_len) {
-	case X86_BREAKPOINT_LEN_X:
+	/* Type */
+	switch (x86_type) {
+	case X86_BREAKPOINT_EXECUTE:
+		if (x86_len != X86_BREAKPOINT_LEN_X)
+			return -EINVAL;
+
+		*gen_type = HW_BREAKPOINT_X;
 		*gen_len = sizeof(long);
+		return 0;
+	case X86_BREAKPOINT_WRITE:
+		*gen_type = HW_BREAKPOINT_W;
 		break;
+	case X86_BREAKPOINT_RW:
+		*gen_type = HW_BREAKPOINT_W | HW_BREAKPOINT_R;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Len */
+	switch (x86_len) {
 	case X86_BREAKPOINT_LEN_1:
 		*gen_len = HW_BREAKPOINT_LEN_1;
 		break;
@@ -229,21 +245,6 @@ int arch_bp_generic_fields(int x86_len, int x86_type,
 		return -EINVAL;
 	}
 
-	/* Type */
-	switch (x86_type) {
-	case X86_BREAKPOINT_EXECUTE:
-		*gen_type = HW_BREAKPOINT_X;
-		break;
-	case X86_BREAKPOINT_WRITE:
-		*gen_type = HW_BREAKPOINT_W;
-		break;
-	case X86_BREAKPOINT_RW:
-		*gen_type = HW_BREAKPOINT_W | HW_BREAKPOINT_R;
-		break;
-	default:
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
@@ -316,9 +317,6 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
 	ret = -EINVAL;
 
 	switch (info->len) {
-	case X86_BREAKPOINT_LEN_X:
-		align = sizeof(long) -1;
-		break;
 	case X86_BREAKPOINT_LEN_1:
 		align = 0;
 		break;
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index cfe4faa..009b819 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -671,7 +671,9 @@ static int __init ppro_init(char **cpu_type)
 	case 14:
 		*cpu_type = "i386/core";
 		break;
-	case 15: case 23:
+	case 0x0f:
+	case 0x16:
+	case 0x17:
 		*cpu_type = "i386/core_2";
 		break;
 	case 0x1a:
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index d71a987..c7c2aed 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -433,7 +433,8 @@ register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
 			    struct task_struct *tsk)
 {
-	return perf_event_create_kernel_counter(attr, -1, tsk->pid, triggered);
+	return perf_event_create_kernel_counter(attr, -1, task_pid_vnr(tsk),
+						triggered);
 }
 EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
 
