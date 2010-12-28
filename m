Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0L1Gsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 01:48:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:51055 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab0L1Gs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 01:48:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,238,1291622400"; 
   d="scan'208";a="367168212"
Subject: [PATCH] apic: use GFP_ATOMIC in lapic_resume
From: Zhang Rui <rui.zhang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 14:48:42 +0800
Message-ID: <1293518922.14005.601.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sysdev .suspend/.resume is invoked with irq disabled,
GFP_ATOMIC should be used in lapic_resume.

Without this patch, I got the following warning messages after resume.
[  109.780371] BUG: sleeping function called from invalid context at mm/slub.c:793
[  109.780782] in_atomic(): 0, irqs_disabled(): 1, pid: 1391, name: bash
[  109.781024] Pid: 1391, comm: bash Not tainted 2.6.37-rc5+ #182
[  109.781264] Call Trace:
[  109.781501]  [<ffffffff8104156a>] __might_sleep+0xeb/0xf0
[  109.781743]  [<ffffffff8110d5e2>] slab_pre_alloc_hook.clone.33+0x28/0x31
[  109.781987]  [<ffffffff8110dcef>] __kmalloc+0x88/0x115
[  109.782224]  [<ffffffff81025e4a>] ? kzalloc.clone.19+0x13/0x15
[  109.782465]  [<ffffffff81025e4a>] kzalloc.clone.19+0x13/0x15
[  109.782704]  [<ffffffff81025ff0>] alloc_ioapic_entries+0x20/0x82
[  109.782948]  [<ffffffff81024201>] lapic_resume+0x3a/0x245
[  109.783189]  [<ffffffff813a8329>] ? cpufreq_resume+0x30/0xb0
[  109.783431]  [<ffffffff812ec4ee>] __sysdev_resume+0x25/0xc5
[  109.783673]  [<ffffffff812ec644>] sysdev_resume+0xb6/0xfb
[  109.783914]  [<ffffffff81083256>] suspend_devices_and_enter+0x13c/0x1c1
[  109.784159]  [<ffffffff810833b8>] enter_state+0xdd/0x12e
[  109.784398]  [<ffffffff81082a61>] state_store+0xae/0xcb
[  109.784640]  [<ffffffff81225737>] kobj_attr_store+0x17/0x19
[  109.784882]  [<ffffffff81173311>] sysfs_write_file+0x114/0x150
[  109.785124]  [<ffffffff8111aebb>] vfs_write+0xac/0xff
[  109.785365]  [<ffffffff8111b0c2>] sys_write+0x4a/0x6e
[  109.785604]  [<ffffffff8100ac82>] system_call_fastpath+0x16/0x1b

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 arch/x86/include/asm/io_apic.h |    2 +-
 arch/x86/kernel/apic/apic.c    |    4 ++--
 arch/x86/kernel/apic/io_apic.c |    7 +++----
 3 files changed, 6 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -589,20 +589,19 @@ static int __init ioapic_pirq_setup(char
 __setup("pirq=", ioapic_pirq_setup);
 #endif /* CONFIG_X86_32 */
 
-struct IO_APIC_route_entry **alloc_ioapic_entries(void)
+struct IO_APIC_route_entry **alloc_ioapic_entries(gfp_t flags)
 {
 	int apic;
 	struct IO_APIC_route_entry **ioapic_entries;
 
-	ioapic_entries = kzalloc(sizeof(*ioapic_entries) * nr_ioapics,
-				GFP_KERNEL);
+	ioapic_entries = kzalloc(sizeof(*ioapic_entries) * nr_ioapics, flags);
 	if (!ioapic_entries)
 		return 0;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
 		ioapic_entries[apic] =
 			kzalloc(sizeof(struct IO_APIC_route_entry) *
-				nr_ioapic_registers[apic], GFP_KERNEL);
+				nr_ioapic_registers[apic], flags);
 		if (!ioapic_entries[apic])
 			goto nomem;
 	}
Index: linux-2.6/arch/x86/include/asm/io_apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/io_apic.h
+++ linux-2.6/arch/x86/include/asm/io_apic.h
@@ -162,7 +162,7 @@ void setup_IO_APIC_irq_extra(u32 gsi);
 extern void ioapic_init_mappings(void);
 extern void ioapic_insert_resources(void);
 
-extern struct IO_APIC_route_entry **alloc_ioapic_entries(void);
+extern struct IO_APIC_route_entry **alloc_ioapic_entries(gfp_t flags);
 extern void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries);
 extern int save_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -1459,7 +1459,7 @@ void __init enable_IR_x2apic(void)
 	if (dmar_table_init_ret && !x2apic_supported())
 		return;
 
-	ioapic_entries = alloc_ioapic_entries();
+	ioapic_entries = alloc_ioapic_entries(GFP_KERNEL);
 	if (!ioapic_entries) {
 		pr_err("Allocate ioapic_entries failed\n");
 		goto out;
@@ -2084,7 +2084,7 @@ static int lapic_resume(struct sys_devic
 
 	local_irq_save(flags);
 	if (intr_remapping_enabled) {
-		ioapic_entries = alloc_ioapic_entries();
+		ioapic_entries = alloc_ioapic_entries(GFP_ATOMIC);
 		if (!ioapic_entries) {
 			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
 			ret = -ENOMEM;


