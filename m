Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab1I1Po7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:44:59 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:42654 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab1I1Po6 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:4:1>);
	Wed, 28 Sep 2011 11:44:58 -0400
Message-Id: <4E835D16020000780005844C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 28 Sep 2011 16:44:54 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <stable@kernel.org>, <tj@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH, v2] i386/bigsmp: eliminate false warnings regarding
	 logical APIC ID mismatches
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These warnings (generally one per CPU) are a result of initializing
x86_cpu_to_logical_apicid while apic_default is still in use, but the
check in setup_local_APIC() being done when apic_bigsmp was already
used as an override in default_setup_apic_routing():

Overriding APIC driver with bigsmp
Enabling APIC mode:  Physflat.  Using 5 I/O APICs
------------[ cut here ]------------
WARNING: at .../arch/x86/kernel/apic/apic.c:1239 setup_local_APIC+0x137/0x46b()
Hardware name: ...
CPU0 logical APIC ID: 1 != 0
Pid: 1, comm: swapper Not tainted 3.0.1-2011-08-09-jb #2
Call Trace:
 [<c1005f91>] try_stack_unwind+0x1b1/0x1f0
 [<c1004cc7>] dump_trace+0x47/0x110
 [<c1005b0b>] show_trace_log_lvl+0x4b/0x60
 [<c1005b38>] show_trace+0x18/0x20
 [<c1261435>] dump_stack+0x6d/0x72
 [<c10355f7>] warn_slowpath_common+0x77/0xb0
 [<c10356c3>] warn_slowpath_fmt+0x33/0x40
 [<c13fda81>] setup_local_APIC+0x137/0x46b
 [<c13d1733>] native_smp_prepare_cpus+0x108/0x1cd
 [<c13c61ff>] kernel_init+0x37/0x12c
 [<c1264826>] kernel_thread_helper+0x6/0xd
---[ end trace 4eaa2a86a8e2da22 ]---
...
CPU 1 irqstacks, hard=f1c9a000 soft=f1c9c000
Booting Node   0, Processors  #1
smpboot cpu 1: start_ip = 9e000
Initializing CPU#1
------------[ cut here ]------------
WARNING: at .../arch/x86/kernel/apic/apic.c:1239 setup_local_APIC+0x137/0x46b()
Hardware name: ...
CPU1 logical APIC ID: 2 != 8
...

Fix this (for the time being, i.e. until x86_32_early_logical_apicid()
will get removed again, as Tejun says ought to be possible) by
overriding the previously stored values at the point where the APIC
driver gets overridden.

v2: Move this and the pre-existing override logic into
    arch/x86/kernel/apic/bigsmp_32.c.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: stable@kernel.org (2.6.39 and onwards)

---
 arch/x86/include/asm/apic.h      |    2 +-
 arch/x86/kernel/apic/bigsmp_32.c |   20 ++++++++++++++++----
 arch/x86/kernel/apic/probe_32.c  |   10 ++--------
 3 files changed, 19 insertions(+), 13 deletions(-)

--- 3.1-rc8/arch/x86/include/asm/apic.h
+++ 3.1-rc8-i386-bigsmp-early-lapicid-override/arch/x86/include/asm/apic.h
@@ -495,7 +495,7 @@ static inline void default_wait_for_init
 	return;
 }
 
-extern struct apic *generic_bigsmp_probe(void);
+extern void generic_bigsmp_probe(void);
 
 
 #ifdef CONFIG_X86_LOCAL_APIC
--- 3.1-rc8/arch/x86/kernel/apic/bigsmp_32.c
+++ 3.1-rc8-i386-bigsmp-early-lapicid-override/arch/x86/kernel/apic/bigsmp_32.c
@@ -255,12 +255,24 @@ static struct apic apic_bigsmp = {
 	.x86_32_early_logical_apicid	= bigsmp_early_logical_apicid,
 };
 
-struct apic * __init generic_bigsmp_probe(void)
+void __init generic_bigsmp_probe(void)
 {
-	if (probe_bigsmp())
-		return &apic_bigsmp;
+	unsigned int cpu;
 
-	return NULL;
+	if (!probe_bigsmp())
+		return;
+
+	apic = &apic_bigsmp;
+
+	for_each_possible_cpu(cpu) {
+		if (early_per_cpu(x86_cpu_to_logical_apicid,
+				  cpu) == BAD_APICID)
+			continue;
+		early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
+			bigsmp_early_logical_apicid(cpu);
+	}
+
+	pr_info("Overriding APIC driver with %s\n", apic_bigsmp.name);
 }
 
 apic_driver(apic_bigsmp);
--- 3.1-rc8/arch/x86/kernel/apic/probe_32.c
+++ 3.1-rc8-i386-bigsmp-early-lapicid-override/arch/x86/kernel/apic/probe_32.c
@@ -200,14 +200,8 @@ void __init default_setup_apic_routing(v
 	 * - we find more than 8 CPUs in acpi LAPIC listing with xAPIC support
 	 */
 
-	if (!cmdline_apic && apic == &apic_default) {
-		struct apic *bigsmp = generic_bigsmp_probe();
-		if (bigsmp) {
-			apic = bigsmp;
-			printk(KERN_INFO "Overriding APIC driver with %s\n",
-			       apic->name);
-		}
-	}
+	if (!cmdline_apic && apic == &apic_default)
+		generic_bigsmp_probe();
 #endif
 
 	if (apic->setup_apic_routing)



