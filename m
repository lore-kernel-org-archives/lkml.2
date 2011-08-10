Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab1HJALz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 20:11:55 -0400
Received: from usa7109mr002.acs-inc.com ([63.101.151.11]:18317 "EHLO
	USA7109MR002.ACS-INC.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab1HJALx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 20:11:53 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Aug 2011 20:11:53 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao0FAJjJQU4N/Z0f/2dsb2JhbAA/mCUBjxp3gVYBF4IREsQ9hkYEh12LK5EL
Message-Id: <201108100002.p7A02OcR001266@pogo.cesa.opbu.xerox.com>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] PCI probe: fix "can't handle 64-bit address space for bridge" on x86-32 PAE
Date: Tue, 09 Aug 2011 17:02:24 -0700
From: Andrew Klossner <andrew@cesa.opbu.xerox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If sizeof(long) is 4 bytes but sizeof(phys_addr_t) is 8 bytes, don't
fail to configure a bridge for PCI prefetchable memory space that
extends beyond 4GB.  The problem was encountered on an embedded system
using a Freescale MPC8536 PowerPC processor.  The problem is possible
on x86-32 systems with PAE, although it has not been observed in the
wild.

This patch preserves the current behavior for any oddball systems on
which sizeof(long) is 8 bytes and sizeof(phys_addr_t) is 4 bytes.

Signed-off-by: Andrew Klossner <andrew@cesa.opbu.xerox.com>

---
 drivers/pci/probe.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 795c902..1385bd3 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -316,7 +316,11 @@ static void __devinit pci_read_bridge_mmio_pref(struct pci_bus *child)
 {
 	struct pci_dev *dev = child->self;
 	u16 mem_base_lo, mem_limit_lo;
+#if defined CONFIG_PHYS_ADDR_T_64BIT & BITS_PER_LONG != 64
+	phys_addr_t base, limit;
+#else
 	unsigned long base, limit;
+#endif
 	struct resource *res;
 
 	res = child->resource[2];
@@ -339,6 +343,9 @@ static void __devinit pci_read_bridge_mmio_pref(struct pci_bus *child)
 #if BITS_PER_LONG == 64
 			base |= ((long) mem_base_hi) << 32;
 			limit |= ((long) mem_limit_hi) << 32;
+#elif defined CONFIG_PHYS_ADDR_T_64BIT
+			base |= ((phys_addr_t) mem_base_hi) << 32;
+			limit |= ((phys_addr_t) mem_limit_hi) << 32;
 #else
 			if (mem_base_hi || mem_limit_hi) {
 				dev_err(&dev->dev, "can't handle 64-bit "
