Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093Ab2DJPIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:08:35 -0400
Received: from [124.207.24.138] ([124.207.24.138]:38949 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759059Ab2DJPIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:08:17 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Apr 2012 11:08:17 EDT
Subject: [RFC PATCH] xen: get correct nr_irqs_gsi value from hypervisor
From: Lin Ming <mlin@ss.pku.edu.cn>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, x86@kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 10 Apr 2012 22:57:18 +0800
Message-ID: <1334069838.5865.130.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nr_irqs_gsi is set in probe_nr_irqs_gsi()
	nr_irqs_gsi = gsi_top + NR_IRQS_LEGACY;

gsi_top is set in mp_register_ioapic()
	gsi_top = gsi_cfg->gsi_end + 1;

mp_register_ioapic() calls io_apic_read, which don't have a Xen specific
version. Actually, io_apic_read() always return -1 on Xen Dom0 kernel.

So currently, nr_irqs_gsi is always wrong on Xen Dom0 kernel.

This patch gets the correct nr_irqs_gsi value from Xen hypervisor with a
hypercall.

Signed-off-by: Lin Ming <mlin@ss.pku.edu.cn>
--
 arch/x86/include/asm/io_apic.h  |    2 ++
 arch/x86/kernel/apic/io_apic.c  |    2 +-
 arch/x86/xen/setup.c            |    9 +++++++++
 include/xen/interface/physdev.h |    6 ++++++
 4 files changed, 18 insertions(+), 1 deletions(-)

(I will send xen hypervisor patch in another mail)

Here comes the detail story.

Xen Dom0 kernel panics with 3.4-rc1. I took the panics picture at
http://www.sendspace.com/file/12ob33

Bisected to below commit.

commit 73d63d038ee9f769f5e5b46792d227fe20e442c5
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Mon Mar 12 11:36:33 2012 -0700

    x86/ioapic: Add register level checks to detect bogus io-apic entries

But this commit itself has no problem.
This commit just triggers the panic.

The panic happens at xen_irq_init(..)

pci_enable_device
__pci_enable_device_flags
do_pci_enable_device
pcibios_enable_device
acpi_pci_irq_enable
acpi_register_gsi
acpi_register_gsi_xen
xen_register_gsi
xen_register_pirq
xen_bind_pirq_gsi_to_irq
xen_allocate_irq_gsi:
        irq = irq_alloc_desc_at(gsi, -1);
        xen_irq_init(irq);

On my machine, when enable PCI root port, gsi 16 is passed into
irq_alloc_desc_at, but it returns -17(-EEXIST) because irq 16 was
already took by xen timer(see below). Then negative value -17 is passed
into xen_irq_init --> irq_to_desc --> radix_tree_lookup, which causes
the panic.

xen timer allocates the irq number "nr_irqs_gsi"
nr_irqs_gsi is set in probe_nr_irqs_gsi()
	nr_irqs_gsi = gsi_top + NR_IRQS_LEGACY
gsi_top is set in mp_register_ioapic()
	gsi_top = gsi_cfg->gsi_end + 1;

In 3.4-rc1 kernel:

mp_register_ioapic
  bad_ioapic_register (added in 3.4-rc1)
    <always return true(bad) on Xen Dom0 kernel>

So mp_register_ioapic exist and gsi_top was not set up. It is left as
the initialized value(zero). So nr_irqs_gsi is 16(NR_IRQS_LEGACY).
That's why Xen timer allocated irq 16.


Actually, gsi_top was never setup correctly in mp_register_ioapic on Xen
Dom0 kernel. Because mp_register_ioapic calls io_apic_read, which is not
implemented with hypercall in Linux kernel. So io_apic_read() always
return -1 on Xen Dom0 kernel.

For 3.3 kernel in Xen Dom0, the dmesg shows

IOAPIC[0]: apic_id 2, version 255, address 0xfec00000, GSI 0-255
......
nr_irqs_gsi: 272

This is obviously wrong, "255" is actually -1(0xFFFF).


diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 2c4943d..a8bf3b2 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -115,6 +115,8 @@ struct IR_IO_APIC_route_entry {
  */
 extern int nr_ioapics;
 
+extern int nr_irqs_gsi;
+
 extern int mpc_ioapic_id(int ioapic);
 extern unsigned int mpc_ioapic_addr(int ioapic);
 extern struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e88300d..8bff292 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -140,7 +140,7 @@ struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 int mp_irq_entries;
 
 /* GSI interrupts */
-static int nr_irqs_gsi = NR_IRQS_LEGACY;
+int nr_irqs_gsi = NR_IRQS_LEGACY;
 
 #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
 int mp_bus_id_to_type[MAX_MP_BUSSES];
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 1ba8dff..9ce82bc 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -389,6 +389,9 @@ void __cpuinit xen_enable_syscall(void)
 
 void __init xen_arch_setup(void)
 {
+	struct physdev_nr_irqs_gsi irqs_gsi;
+	int rc;
+
 	xen_panic_handler_init();
 
 	HYPERVISOR_vm_assist(VMASST_CMD_enable, VMASST_TYPE_4gb_segments);
@@ -424,4 +427,10 @@ void __init xen_arch_setup(void)
 	disable_cpufreq();
 	WARN_ON(set_pm_idle_to_default());
 	fiddle_vdso();
+
+	rc = HYPERVISOR_physdev_op(PHYSDEVOP_nr_irqs_gsi, &irqs_gsi);
+	if (rc)
+		printk(KERN_ERR "Failed to init nr_irqs_gsi, err_code:%d\n", rc);
+	else
+		nr_irqs_gsi = irqs_gsi.nr_irqs_gsi;
 }
diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
index 9ce788d..180a0a3 100644
--- a/include/xen/interface/physdev.h
+++ b/include/xen/interface/physdev.h
@@ -258,6 +258,12 @@ struct physdev_pci_device {
     uint8_t devfn;
 };
 
+#define PHYSDEVOP_nr_irqs_gsi           29
+struct physdev_nr_irqs_gsi {
+    /* OUT */
+    uint32_t nr_irqs_gsi;
+};
+
 /*
  * Notify that some PIRQ-bound event channels have been unmasked.
  * ** This command is obsolete since interface version 0x00030202 and is **




