Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab0DVTnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:43:43 -0400
Received: from kroah.org ([198.145.64.141]:41274 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756719Ab0DVT3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:19 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:19 2010
Message-Id: <20100422190919.572825264@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Airlie <airlied@linux.ie>, "H. Peter Anvin" <hpa@zytor.com>,
       maximilian attems <max@stro.at>
Subject: [137/197] pci: Update pci_set_vga_state() to call arch functions
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Travis <travis@sgi.com>

commit 95a8b6efc5d07103583f706c8a5889437d537939 upstream.

Update pci_set_vga_state to call arch dependent functions to enable Legacy
VGA I/O transactions to be redirected to correct target.

[akpm@linux-foundation.org: make pci_register_set_vga_state() __init]
Signed-off-by: Mike Travis <travis@sgi.com>
LKML-Reference: <201002022238.o12McE1J018723@imap1.linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci.c   |   25 ++++++++++++++++++++++++-
 include/linux/pci.h |    5 +++++
 2 files changed, 29 insertions(+), 1 deletion(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2541,6 +2541,23 @@ int pci_resource_bar(struct pci_dev *dev
 	return 0;
 }
 
+/* Some architectures require additional programming to enable VGA */
+static arch_set_vga_state_t arch_set_vga_state;
+
+void __init pci_register_set_vga_state(arch_set_vga_state_t func)
+{
+	arch_set_vga_state = func;	/* NULL disables */
+}
+
+static int pci_set_vga_state_arch(struct pci_dev *dev, bool decode,
+		      unsigned int command_bits, bool change_bridge)
+{
+	if (arch_set_vga_state)
+		return arch_set_vga_state(dev, decode, command_bits,
+						change_bridge);
+	return 0;
+}
+
 /**
  * pci_set_vga_state - set VGA decode state on device and parents if requested
  * @dev: the PCI device
@@ -2554,9 +2571,15 @@ int pci_set_vga_state(struct pci_dev *de
 	struct pci_bus *bus;
 	struct pci_dev *bridge;
 	u16 cmd;
+	int rc;
 
 	WARN_ON(command_bits & ~(PCI_COMMAND_IO|PCI_COMMAND_MEMORY));
 
+	/* ARCH specific VGA enables */
+	rc = pci_set_vga_state_arch(dev, decode, command_bits, change_bridge);
+	if (rc)
+		return rc;
+
 	pci_read_config_word(dev, PCI_COMMAND, &cmd);
 	if (decode == true)
 		cmd |= command_bits;
@@ -2771,6 +2794,7 @@ EXPORT_SYMBOL(pcim_pin_device);
 EXPORT_SYMBOL(pci_disable_device);
 EXPORT_SYMBOL(pci_find_capability);
 EXPORT_SYMBOL(pci_bus_find_capability);
+EXPORT_SYMBOL(pci_register_set_vga_state);
 EXPORT_SYMBOL(pci_release_regions);
 EXPORT_SYMBOL(pci_request_regions);
 EXPORT_SYMBOL(pci_request_regions_exclusive);
@@ -2803,4 +2827,3 @@ EXPORT_SYMBOL(pci_target_state);
 EXPORT_SYMBOL(pci_prepare_to_sleep);
 EXPORT_SYMBOL(pci_back_from_sleep);
 EXPORT_SYMBOL_GPL(pci_set_pcie_reset_state);
-
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -945,6 +945,11 @@ static inline int pci_proc_domain(struct
 }
 #endif /* CONFIG_PCI_DOMAINS */
 
+/* some architectures require additional setup to direct VGA traffic */
+typedef int (*arch_set_vga_state_t)(struct pci_dev *pdev, bool decode,
+		      unsigned int command_bits, bool change_bridge);
+extern void pci_register_set_vga_state(arch_set_vga_state_t func);
+
 #else /* CONFIG_PCI is not enabled */
 
 /*


