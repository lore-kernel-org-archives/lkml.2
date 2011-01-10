Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab1AJIqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 03:46:16 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:21867 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab1AJIqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 03:46:12 -0500
Message-ID: <4D2AC6E2.5090903@kernel.org>
Date: Mon, 10 Jan 2011 00:44:18 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <greg@kroah.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/4] x86: usb handoff in early_quirk
References: <4D2A1382.7010407@kernel.org> <4D2AC584.6010004@kernel.org>
In-Reply-To: <4D2AC584.6010004@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


some systems keep getting
  APIC calibration not consistent with PM-Timer: 139ms instead of 100ms
  APIC delta adjusted to PM-Timer: 831249 (1163736)

USB legacy SMI handler is not disabled at that time.

Try to disable USB legacy support early with this patch.
So later APIC Timer calibration don't get messed up by USB legacy support SMI handler.
After this patch, that warning never show up for 100 reboot tests.

reuse code from drivers/usb/host/pci-quirks.c
with changes
1. delay and sleep  ===> io_delay
2. dev_warn etc to pr_warn(num, slot, func...)

-v2: use get_early_pci_dev() etc.
     fix typo with PARAVIRT according to Sander Eikelenboom <linux@eikelenboom.it>

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/pci-direct.h |    2 
 arch/x86/kernel/early-quirks.c    |  170 ++++++++++++++++++++++++++++++++++++++
 arch/x86/pci/early.c              |   72 ++++++++++++++++
 3 files changed, 244 insertions(+)

Index: linux-2.6/arch/x86/kernel/early-quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/early-quirks.c
+++ linux-2.6/arch/x86/kernel/early-quirks.c
@@ -19,6 +19,174 @@
 #include <asm/iommu.h>
 #include <asm/gart.h>
 
+static inline void early_udelay2(void)
+{
+#ifndef CONFIG_PARAVIRT
+	native_io_delay();
+#else
+	pv_cpu_ops.io_delay();
+#endif
+}
+
+static void usb_handoff_udelay(unsigned long usecs)
+{
+	unsigned long count;
+
+	count = usecs >> 1;
+
+	if (!count)
+		count = 1;
+
+	while (count-- > 0)
+		early_udelay2();
+}
+
+static void usb_handoff_msleep(unsigned long msecs)
+{
+	while (msecs-- > 0)
+		usb_handoff_udelay(1000);
+}
+
+#include "../../../drivers/usb/host/usb_handoff.c"
+
+static inline int io_type_enabled(int num, int slot, int func, unsigned int mask)
+{
+	return read_pci_config_16(num, slot, func, PCI_COMMAND) & mask;
+}
+
+#define pio_enabled(num, slot, func) io_type_enabled(num, slot, func, PCI_COMMAND_IO)
+#define mmio_enabled(num, slot, func) io_type_enabled(num, slot, func, PCI_COMMAND_MEMORY)
+
+static __init u32 get_usb_io_port(int num, int slot, int func)
+{
+	int i;
+
+	if (!pio_enabled(num, slot, func))
+		return 0;
+
+	for (i = 0; i < PCI_ROM_RESOURCE; i++) {
+		u32 addr = read_pci_config(num, slot, func, 0x10+(i<<2));
+
+		if (!addr)
+			continue;
+		if ((addr & PCI_BASE_ADDRESS_SPACE) != PCI_BASE_ADDRESS_SPACE_IO)
+			continue;
+
+		addr &= PCI_BASE_ADDRESS_IO_MASK;
+		if (addr)
+			return addr;
+	}
+
+	return 0;
+}
+
+static void __init quirk_usb_handoff_uhci(int num, int slot, int func)
+{
+	unsigned long base;
+
+	base = get_usb_io_port(num, slot, func);
+	if (!base)
+		return;
+
+	printk(KERN_DEBUG "%02x:%02x.%01x: uhci ioport = 0x%04lx\n",
+					num, slot, func, base);
+	__uhci_check_and_reset_hc(get_early_pci_dev(num, slot, func), base);
+}
+
+static __init u32 get_usb_mmio_addr(int num, int slot, int func)
+{
+	u32 addr;
+
+	if (!mmio_enabled(num, slot, func))
+		return 0;
+
+	addr = read_pci_config(num, slot, func, 0x10);
+	if (!addr)
+		return 0;
+	if ((addr & PCI_BASE_ADDRESS_SPACE) != PCI_BASE_ADDRESS_SPACE_MEMORY)
+		return 0;
+
+	addr &= PCI_BASE_ADDRESS_MEM_MASK;
+
+	return addr;
+}
+
+static __init void quirk_usb_handoff_ohci(int num, int slot, int func)
+{
+	void __iomem *base;
+	u32 addr;
+
+	addr = get_usb_mmio_addr(num, slot, func);
+	if (!addr)
+		return;
+
+	printk(KERN_DEBUG "%02x:%02x.%01x: ohci mmio = 0x%08x\n", num, slot, func, addr);
+	base = early_ioremap(addr, 0x1000);
+	if (!base)
+		return;
+
+	__usb_handoff_ohci(get_early_pci_dev(num, slot, func), base);
+
+	early_iounmap(base, 0x1000);
+}
+
+static __init void quirk_usb_handoff_ehci(int num, int slot, int func)
+{
+	void __iomem *base;
+	u32 addr;
+
+	addr = get_usb_mmio_addr(num, slot, func);
+	if (!addr)
+		return;
+
+	printk(KERN_DEBUG "%02x:%02x.%01x: ehci mmio = 0x%08x\n",
+				 num, slot, func, addr);
+	base = early_ioremap(addr, 0x1000);
+	if (!base)
+		return;
+
+	__usb_handoff_ehci(get_early_pci_dev(num, slot, func), base);
+
+	early_iounmap(base, 0x1000);
+}
+
+static __init void quirk_usb_handoff_xhci(int num, int slot, int func)
+{
+	void __iomem *base;
+	u32 addr;
+
+	addr = get_usb_mmio_addr(num, slot, func);
+	if (!addr)
+		return;
+
+	printk(KERN_DEBUG "%02x:%02x.%01x: xhci mmio = 0x%08x\n",
+				num, slot, func, addr);
+	base = early_ioremap(addr, 0x1000);
+	if (!base)
+		return;
+
+	__usb_handoff_xhci(get_early_pci_dev(num, slot, func), base);
+
+	early_iounmap(base, 0x1000);
+}
+
+static __init void quirk_usb_handoff(int num, int slot, int func)
+{
+	u32 class;
+
+	class = read_pci_config(num, slot, func, PCI_CLASS_REVISION);
+	class >>= 8;
+
+	if (class == PCI_CLASS_SERIAL_USB_UHCI)
+		quirk_usb_handoff_uhci(num, slot, func);
+	else if (class == PCI_CLASS_SERIAL_USB_OHCI)
+		quirk_usb_handoff_ohci(num, slot, func);
+	else if (class == PCI_CLASS_SERIAL_USB_EHCI)
+		quirk_usb_handoff_ehci(num, slot, func);
+	else if (class == PCI_CLASS_SERIAL_USB_XHCI)
+		quirk_usb_handoff_xhci(num, slot, func);
+}
+
 static void __init fix_hypertransport_config(int num, int slot, int func)
 {
 	u32 htcfg;
@@ -208,6 +376,8 @@ struct chipset {
  * only matching on bus 0.
  */
 static struct chipset early_qrk[] __initdata = {
+	{ PCI_ANY_ID, PCI_ANY_ID,
+	  PCI_CLASS_SERIAL_USB, PCI_ANY_ID, 0, quirk_usb_handoff },
 	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
 	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, nvidia_bugs },
 	{ PCI_VENDOR_ID_VIA, PCI_ANY_ID,
