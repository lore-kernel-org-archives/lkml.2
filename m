Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111Ab0GTXIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 19:08:44 -0400
Received: from relay2.sgi.com ([192.48.179.30]:57753 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932946Ab0GTXIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 19:08:43 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, UV: make kdump avoid stack dumps
Cc: mingo@elte.hu, hpa@zytor.com
Message-Id: <E1ObLvt-0005UZ-Va@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Tue, 20 Jul 2010 18:09:05 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is the same as one sent Jun18 2010.  It doesn't seem to 
have been noticed.


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
 arch/x86/include/asm/kdebug.h      |    1 +
 arch/x86/kernel/apic/x2apic_uv_x.c |    4 ++++
 arch/x86/kernel/crash.c            |    3 +++
 3 files changed, 8 insertions(+)

Index: linux-2.6.35-rc3/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux-2.6.35-rc3.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux-2.6.35-rc3/arch/x86/kernel/apic/x2apic_uv_x.c
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
Index: linux-2.6.35-rc3/arch/x86/kernel/crash.c
===================================================================
--- linux-2.6.35-rc3.orig/arch/x86/kernel/crash.c
+++ linux-2.6.35-rc3/arch/x86/kernel/crash.c
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
Index: linux-2.6.35-rc3/arch/x86/include/asm/kdebug.h
===================================================================
--- linux-2.6.35-rc3.orig/arch/x86/include/asm/kdebug.h
+++ linux-2.6.35-rc3/arch/x86/include/asm/kdebug.h
@@ -33,5 +33,6 @@ extern void __show_regs(struct pt_regs *
 extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
+extern int in_crash_kexec;
 
 #endif /* _ASM_X86_KDEBUG_H */
