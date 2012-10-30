Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965562Ab2J3TPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:15:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965240Ab2J3TPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:15:17 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Avi Kivity <avi@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Marcelo Tostatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, x86@kernel.org
Subject: [PATCH] x86, add hypervisor name to dump_stack() [v3]
Date: Tue, 30 Oct 2012 15:14:57 -0400
Message-Id: <1351624497-26389-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debugging crash, panics, stack trace WARN_ONs, etc., from both virtual and
bare-metal boots can get difficult very quickly.  While there are ways to
decipher the output and determine if the output is from a virtual guest,
the in-kernel hypervisors now have a single registration point
and set x86_hyper.  We can use this to output additional debug
information during a panic/oops/stack trace.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Marcelo Tostatti <mtosatti@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: kvm@vger.kernel.org
Cc: x86@kernel.org

[v2]: Modifications suggested by Ingo and added changes for similar output
      from process.c

[v3]: Unify common code and move output to end of line
---
 arch/x86/kernel/dumpstack.c |    6 +-----
 arch/x86/kernel/process.c   |   12 +++++++++++-
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index ae42418b..96d40ed 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -188,11 +188,7 @@ void dump_stack(void)
 	unsigned long stack;
 
 	bp = stack_frame(current, NULL);
-	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
-		current->pid, current->comm, print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
+	show_regs_common();
 	show_trace(NULL, NULL, &stack, bp);
 }
 EXPORT_SYMBOL(dump_stack);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index b644e1c..14bd064 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -28,6 +28,7 @@
 #include <asm/fpu-internal.h>
 #include <asm/debugreg.h>
 #include <asm/nmi.h>
+#include <asm/hypervisor.h>
 
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
@@ -124,6 +125,13 @@ void exit_thread(void)
 void show_regs_common(void)
 {
 	const char *vendor, *product, *board;
+	const char *machine_name = "x86";
+	const char *kernel_type = "native";
+
+	if (x86_hyper) {
+		machine_name = x86_hyper->name;
+		kernel_type = "guest";
+	}
 
 	vendor = dmi_get_system_info(DMI_SYS_VENDOR);
 	if (!vendor)
@@ -135,7 +143,9 @@ void show_regs_common(void)
 	/* Board Name is optional */
 	board = dmi_get_system_info(DMI_BOARD_NAME);
 
-	printk(KERN_DEFAULT "Pid: %d, comm: %.20s %s %s %.*s %s %s%s%s\n",
+	printk(KERN_DEFAULT
+	       "[%s %s kernel] Pid: %d, comm: %.20s %s %s %.*s %s %s%s%s\n",
+	       machine_name, kernel_type,
 	       current->pid, current->comm, print_tainted(),
 	       init_utsname()->release,
 	       (int)strcspn(init_utsname()->version, " "),
-- 
1.7.9.3

