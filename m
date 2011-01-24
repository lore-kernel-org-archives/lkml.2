Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1AXPGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:06:24 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:52121
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752981Ab1AXPF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:05:58 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LFJ8LP-01-DFL-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>
CC: <andreas.herrmann3@amd.com>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 3/4] x86, amd: Extend AMD northbridge caching code to support "Link Control" devices
Date: Mon, 24 Jan 2011 16:05:42 +0100
Message-ID: <1295881543-572552-4-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1295881543-572552-1-git-send-email-hans.rosenfeld@amd.com>
References: <1295881543-572552-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Link Control" devices (NB function 4) will be used by L3 cache
partitioning on family 0x15.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/amd_nb.h |    1 +
 arch/x86/kernel/amd_nb.c      |   11 +++++++++--
 include/linux/pci_ids.h       |    1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 64dc82e..3e70700 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -26,6 +26,7 @@ extern void amd_get_nodes(struct bootnode *nodes);
 
 struct amd_northbridge {
 	struct pci_dev *misc;
+	struct pci_dev *link;
 };
 
 struct amd_northbridge_info {
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index a4f394c..4ae9a96 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -20,6 +20,11 @@ struct pci_device_id amd_nb_misc_ids[] = {
 };
 EXPORT_SYMBOL(amd_nb_misc_ids);
 
+static struct pci_device_id amd_nb_link_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_LINK) },
+	{}
+};
+
 const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[] __initconst = {
 	{ 0x00, 0x18, 0x20 },
 	{ 0xff, 0x00, 0x20 },
@@ -45,7 +50,7 @@ int amd_cache_northbridges(void)
 {
 	int i = 0;
 	struct amd_northbridge *nb;
-	struct pci_dev *misc;
+	struct pci_dev *misc, *link;
 
 	if (amd_nb_num())
 		return 0;
@@ -64,10 +69,12 @@ int amd_cache_northbridges(void)
 	amd_northbridges.nb = nb;
 	amd_northbridges.num = i;
 
-	misc = NULL;
+	link = misc = NULL;
 	for (i = 0; i != amd_nb_num(); i++) {
 		node_to_amd_nb(i)->misc = misc =
 			next_northbridge(misc, amd_nb_misc_ids);
+		node_to_amd_nb(i)->link = link =
+			next_northbridge(link, amd_nb_link_ids);
         }
 
 	/* some CPU families (e.g. family 0x11) do not support GART */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3adb06e..580de67 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -518,6 +518,7 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
 #define PCI_DEVICE_ID_AMD_15H_NB_MISC	0x1603
+#define PCI_DEVICE_ID_AMD_15H_NB_LINK	0x1604
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
-- 
1.5.6.5


