Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab0HIVJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 17:09:49 -0400
Received: from relay3.sgi.com ([192.48.152.1]:55427 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755586Ab0HIVJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 17:09:48 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86, UV: make kdump avoid stack dumps
Cc: mingo@elte.hu, hpa@zytor.com
Message-Id: <E1OiZcw-0001Hb-2g@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Mon, 09 Aug 2010 16:11:22 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This replaces Version 1 of this patch, which broke the build when
CONFIG_KEXEC and CONFIG_CRASH_DUMP were configured off.  In that case
the storage for the 'in_crash_kexec' flag was never built.

This v2 was submitted on 7/22, but apparently never seen (probably too close
in date and name to v1, sent on 7/20).

This version defines that flag as 0 if CONFIG_KEXEC is not set.
The patch is tested with all combinations of those two options.


UV NMI callback's should not write stack dumps when a kdump is to be written.

When invoking the crash kernel to write a dump, kdump_nmi_shootdown_cpus()
uses NMI's to get all the cpu's to save their register context and halt.

But the NMI interrupt handler runs a callback list.  This patch sets a flag
to prevent any of those callbacks from interfering with the halt of the cpu.

For UV, which currently has the only callback to which this is relevant, the
uv_handle_nmi() callback should not do dumping of stacks.

The 'in_crash_kexec' flag is defined as an extern in kdebug.h firstly
because x2apic_uv_x.c includes it.  Secondly because some future callback
might need the flag to know that it should not enter the debugger.
(Such a scenario was in fact present in the 2.6.32 kernel, SuSE distribution,
 where a call to kdb needed to be avoided.)

Diffed against 2.6.35

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/include/asm/kdebug.h      |    6 ++++++
 arch/x86/kernel/apic/x2apic_uv_x.c |    4 ++++
 arch/x86/kernel/crash.c            |    3 +++
 3 files changed, 13 insertions(+)

Index: 100722.linux-tip/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- 100722.linux-tip.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ 100722.linux-tip/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -604,6 +604,10 @@ int uv_handle_nmi(struct notifier_block
 {
 	if (reason != DIE_NMI_IPI)
 		return NOTIFY_OK;
+
+	if (in_crash_kexec)
+		/* do nothing if entering the crash kernel */
+		return NOTIFY_OK;
 	/*
 	 * Use a lock so only one cpu prints at a time
 	 * to prevent intermixed output.
Index: 100722.linux-tip/arch/x86/kernel/crash.c
===================================================================
--- 100722.linux-tip.orig/arch/x86/kernel/crash.c
+++ 100722.linux-tip/arch/x86/kernel/crash.c
@@ -28,6 +28,8 @@
 #include <asm/reboot.h>
 #include <asm/virtext.h>
 
+int in_crash_kexec;
+
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
 static void kdump_nmi_callback(int cpu, struct die_args *args)
@@ -61,6 +63,7 @@ static void kdump_nmi_callback(int cpu,
 
 static void kdump_nmi_shootdown_cpus(void)
 {
+	in_crash_kexec = 1;
 	nmi_shootdown_cpus(kdump_nmi_callback);
 
 	disable_local_APIC();
Index: 100722.linux-tip/arch/x86/include/asm/kdebug.h
===================================================================
--- 100722.linux-tip.orig/arch/x86/include/asm/kdebug.h
+++ 100722.linux-tip/arch/x86/include/asm/kdebug.h
@@ -33,5 +33,11 @@ extern void __show_regs(struct pt_regs *
 extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
+#ifdef CONFIG_KEXEC
+extern int in_crash_kexec;
+#else
+/* no crash dump is ever in progress if no crash kernel can be kexec'd */
+#define in_crash_kexec 0
+#endif
 
 #endif /* _ASM_X86_KDEBUG_H */
