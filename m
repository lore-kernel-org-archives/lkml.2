Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab1AJIqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 03:46:08 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:21573 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1AJIqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 03:46:04 -0500
Message-ID: <4D2AC6DC.5040003@kernel.org>
Date: Mon, 10 Jan 2011 00:44:12 -0800
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
Subject: [PATCH 3/4] x86, pci: add dummy pci device for early stage
References: <4D2A1382.7010407@kernel.org> <4D2AC584.6010004@kernel.org>
In-Reply-To: <4D2AC584.6010004@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So we can pass pci_dev *dev to reuse some generic pci functions.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/pci-direct.h |    2 +
 arch/x86/pci/early.c              |   75 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

Index: linux-2.6/arch/x86/include/asm/pci-direct.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pci-direct.h
+++ linux-2.6/arch/x86/include/asm/pci-direct.h
@@ -18,4 +18,6 @@ extern int early_pci_allowed(void);
 extern unsigned int pci_early_dump_regs;
 extern void early_dump_pci_device(u8 bus, u8 slot, u8 func);
 extern void early_dump_pci_devices(void);
+
+struct pci_dev *get_early_pci_dev(int num, int slot, int func);
 #endif /* _ASM_X86_PCI_DIRECT_H */
Index: linux-2.6/arch/x86/pci/early.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/early.c
+++ linux-2.6/arch/x86/pci/early.c
@@ -109,3 +109,78 @@ void early_dump_pci_devices(void)
 		}
 	}
 }
+
+static __init int
+early_pci_read(struct pci_bus *bus, unsigned int devfn, int where,
+			int size, u32 *value)
+{
+	int num, slot, func;
+
+	num = bus->number;
+	slot = devfn >> 3;
+	func = devfn & 7;
+	switch (size) {
+	case 1:
+		*value = read_pci_config_byte(num, slot, func, where);
+		break;
+	case 2:
+		*value = read_pci_config_16(num, slot, func, where);
+		break;
+	case 4:
+		*value = read_pci_config(num, slot, func, where);
+		break;
+	}
+
+	return 0;
+}
+
+static __init int
+early_pci_write(struct pci_bus *bus, unsigned int devfn, int where,
+			int size, u32 value)
+{
+	int num, slot, func;
+
+	num = bus->number;
+	slot = devfn >> 3;
+	func = devfn & 7;
+	switch (size) {
+	case 1:
+		write_pci_config_byte(num, slot, func, where, (u8)value);
+		break;
+	case 2:
+		write_pci_config_16(num, slot, func, where, (u16)value);
+		break;
+	case 4:
+		write_pci_config(num, slot, func, where, (u32)value);
+		break;
+	}
+
+	return 0;
+}
+
+static __initdata struct pci_ops pci_early_ops = {
+	.read = early_pci_read,
+	.write = early_pci_write,
+};
+
+static __initdata struct pci_bus pci_early_bus = {
+	.ops = &pci_early_ops,
+};
+
+static __initdata char pci_device_init_name[8];
+static __initdata struct pci_dev pci_early_dev = {
+	.bus = &pci_early_bus,
+};
+
+__init struct pci_dev *get_early_pci_dev(int num, int slot, int func)
+{
+	struct pci_dev *pdev;
+
+	pdev = &pci_early_dev;
+	pdev->devfn = (slot<<3) | (func & 7);
+	pdev->bus->number = num;
+	sprintf(pci_device_init_name, "%02x:%02x.%01x", num, slot, func);
+	pdev->dev.init_name = pci_device_init_name;
+
+	return pdev;
+}
