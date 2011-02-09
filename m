Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1BII0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 03:26:19 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:55160 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab1BII0S convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 9 Feb 2011 03:26:18 -0500
Message-Id: <4D525DDD0200007800030F07@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 09 Feb 2011 08:26:53 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: adjust section placement in AMD northbridge
	 related code
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amd_nb_misc_ids[] can live in .rodata, and enable_pci_io_ecs() can be
moved into .cpuinit.text.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/amd_nb.h |    2 +-
 arch/x86/kernel/amd_nb.c      |    7 ++++---
 arch/x86/pci/amd_bus.c        |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

--- 2.6.38-rc4/arch/x86/include/asm/amd_nb.h
+++ 2.6.38-rc4-x86-amd-nb-sections/arch/x86/include/asm/amd_nb.h
@@ -9,7 +9,7 @@ struct amd_nb_bus_dev_range {
 	u8 dev_limit;
 };
 
-extern struct pci_device_id amd_nb_misc_ids[];
+extern const struct pci_device_id amd_nb_misc_ids[];
 extern const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[];
 struct bootnode;
 
--- 2.6.38-rc4/arch/x86/kernel/amd_nb.c
+++ 2.6.38-rc4-x86-amd-nb-sections/arch/x86/kernel/amd_nb.c
@@ -12,7 +12,7 @@
 
 static u32 *flush_words;
 
-struct pci_device_id amd_nb_misc_ids[] = {
+const struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_MISC) },
@@ -31,7 +31,7 @@ struct amd_northbridge_info amd_northbri
 EXPORT_SYMBOL(amd_northbridges);
 
 static struct pci_dev *next_northbridge(struct pci_dev *dev,
-					struct pci_device_id *ids)
+					const struct pci_device_id *ids)
 {
 	do {
 		dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
@@ -93,8 +93,9 @@ EXPORT_SYMBOL_GPL(amd_cache_northbridges
    they're useless anyways */
 int __init early_is_amd_nb(u32 device)
 {
-	struct pci_device_id *id;
+	const struct pci_device_id *id;
 	u32 vendor = device & 0xffff;
+
 	device >>= 16;
 	for (id = amd_nb_misc_ids; id->vendor; id++)
 		if (vendor == id->vendor && device == id->device)
--- 2.6.38-rc4/arch/x86/pci/amd_bus.c
+++ 2.6.38-rc4-x86-amd-nb-sections/arch/x86/pci/amd_bus.c
@@ -350,7 +350,7 @@ static int __init early_fill_mp_bus_info
 
 #define ENABLE_CF8_EXT_CFG      (1ULL << 46)
 
-static void enable_pci_io_ecs(void *unused)
+static void __cpuinit enable_pci_io_ecs(void *unused)
 {
 	u64 reg;
 	rdmsrl(MSR_AMD64_NB_CFG, reg);



