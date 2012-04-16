Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab2DPHjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 03:39:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57061 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2DPHjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 03:39:45 -0400
From: Ido Yariv <ido@wizery.com>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Shai Fultheim <shai@scalemp.com>, Ido Yariv <ido@wizery.com>
Subject: [PATCH v2 1/2] vsmp: Fix number of CPUs when vsmp is disabled
Date: Mon, 16 Apr 2012 10:39:35 +0300
Message-Id: <1334561976-13965-1-git-send-email-ido@wizery.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333715987-26059-2-git-send-email-ido@wizery.com>
References: <1333715987-26059-2-git-send-email-ido@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shai Fultheim <shai@scalemp.com>

In case CONFIG_X86_VSMP is not set, limit the number of CPUs to the
number of CPUs of the first board.

Signed-off-by: Shai Fultheim <shai@scalemp.com>
[ido@wizery.com: rebased, fixed minor coding-style issues]
Signed-off-by: Ido Yariv <ido@wizery.com>
---
 arch/x86/kernel/vsmp_64.c |   48 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index a1d804b..61571fd 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/pci_ids.h>
 #include <linux/pci_regs.h>
+#include <linux/smp.h>
 
 #include <asm/apic.h>
 #include <asm/pci-direct.h>
@@ -22,6 +23,8 @@
 #include <asm/paravirt.h>
 #include <asm/setup.h>
 
+#define TOPOLOGY_REGISTER_OFFSET 0x10
+
 #if defined CONFIG_PCI && defined CONFIG_PARAVIRT
 /*
  * Interrupt control on vSMPowered systems:
@@ -149,12 +152,57 @@ int is_vsmp_box(void)
 	return 0;
 }
 #endif
+
+#ifdef CONFIG_X86_VSMP
+
+static void __init vsmp_cap_cpus(void)
+{
+	/* VSMP is enabled, no need to cap cpus */
+}
+
+#else
+
+static void __init vsmp_cap_cpus(void)
+{
+	/*
+	 * CONFIG_X86_VSMP is not configured, so limit the number CPUs to the
+	 * ones present in the first board, unless explicitly overridden by
+	 * setup_max_cpus
+	 */
+	if (setup_max_cpus == NR_CPUS) {
+		void __iomem *address;
+		unsigned int cfg, topology, node_shift, maxcpus;
+
+		/* Read the vSMP Foundation topology register */
+		cfg = read_pci_config(0, 0x1f, 0, PCI_BASE_ADDRESS_0);
+		address = early_ioremap(cfg + TOPOLOGY_REGISTER_OFFSET, 4);
+		if (WARN_ON(!address))
+			return;
+
+		topology = readl(address);
+		node_shift = (topology >> 16) & 0x7;
+		if (!node_shift)
+			/* The value 0 should be decoded as 8 */
+			node_shift = 8;
+		maxcpus = (topology & ((1 << node_shift) - 1)) + 1;
+
+		printk(KERN_INFO "vSMP CTL: Capping CPUs to %d "
+				 "(CONFIG_X86_VSMP is unset)\n", maxcpus);
+		setup_max_cpus = maxcpus;
+		early_iounmap(address, 4);
+	}
+}
+
+#endif
+
 void __init vsmp_init(void)
 {
 	detect_vsmp_box();
 	if (!is_vsmp_box())
 		return;
 
+	vsmp_cap_cpus();
+
 	set_vsmp_pv_ops();
 	return;
 }
-- 
1.7.7.6

