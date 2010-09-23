Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab0IWQ2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 12:28:20 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:13476 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755665Ab0IWQ2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 12:28:19 -0400
X-Greylist: delayed 85449 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Sep 2010 12:28:18 EDT
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de
To: mingo@redhat.com
To: hpa@zytor.com
To: x86@kernel.org
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: dilinger@queued.net
Subject: [PATCH 1/2] OLPC: Only enable PCI configuration type override on XO-1
Message-Id: <20100923162805.0F6549D401B@zog.reactivated.net>
Date: Thu, 23 Sep 2010 17:28:04 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=DhNl2YeytwJssBBGe49HJX82LNDFEEVkpVB34RXKaPo= c=1 sm=0 a=jJZzjQJwaEoA:10 a=Op-mwl0xAAAA:8 a=hLNpAadnjJpCdfu8aiMA:9 a=ASWK05j41-sBpeq05fU1Rn_uvEQA:4 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This configuration type override is for XO-1 only and must not happen
on XO-1.5.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---

Replaces earlier patches:
[PATCH 1/3] OLPC: extended board revision detection
[PATCH 2/3] PCI: OLPC configuration cleanup

Due to the fact that CONFIG_OLPC is associated with multiple laptop models
(not only the XO-1), it makes sense to keep this as a separate configuration
option.

We decided against adding functions to distinguish between XO-1/XO-1.5 as
we don't want to encourage laptop checking in this way. There should only be
one or two cases where this actually matters (here is one of them).

 arch/x86/Kconfig       |    2 +-
 arch/x86/kernel/olpc.c |    6 ++++--
 arch/x86/pci/olpc.c    |    2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..0ed4c9b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1900,7 +1900,7 @@ config PCI_GODIRECT
 	bool "Direct"
 
 config PCI_GOOLPC
-	bool "OLPC"
+	bool "OLPC XO-1"
 	depends on OLPC
 
 config PCI_GOANY
diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 0e0cdde..635888c 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -242,8 +242,10 @@ static int __init olpc_init(void)
 			(unsigned char *) &olpc_platform_info.ecver, 1);
 
 #ifdef CONFIG_PCI_OLPC
-	/* If the VSA exists let it emulate PCI, if not emulate in kernel */
-	if (!cs5535_has_vsa2())
+	/* If the VSA exists let it emulate PCI, if not emulate in kernel.
+	 * XO-1 only. */
+	if (olpc_platform_info.boardrev < olpc_board_pre(0xd0) &&
+			!cs5535_has_vsa2())
 		x86_init.pci.arch_init = pci_olpc_init;
 #endif
 
diff --git a/arch/x86/pci/olpc.c b/arch/x86/pci/olpc.c
index b348154..13700ec 100644
--- a/arch/x86/pci/olpc.c
+++ b/arch/x86/pci/olpc.c
@@ -304,7 +304,7 @@ static struct pci_raw_ops pci_olpc_conf = {
 
 int __init pci_olpc_init(void)
 {
-	printk(KERN_INFO "PCI: Using configuration type OLPC\n");
+	printk(KERN_INFO "PCI: Using configuration type OLPC XO-1\n");
 	raw_pci_ops = &pci_olpc_conf;
 	is_lx = is_geode_lx();
 	return 0;
-- 
1.7.2.2

