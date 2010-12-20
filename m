Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975Ab0LTRON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 12:14:13 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:18851
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932940Ab0LTROK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 12:14:10 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LDQL72-01-5ED-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, <andreas.herrmann3@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 3/4] x86, amd: Extend AMD northbridge caching code to support "Link Control" devices
Date: Mon, 20 Dec 2010 18:13:46 +0100
Message-ID: <1292865227-647466-4-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292865227-647466-1-git-send-email-hans.rosenfeld@amd.com>
References: <1292865227-647466-1-git-send-email-hans.rosenfeld@amd.com>
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
index 6aee50d..b830c7f 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -15,6 +15,7 @@ extern int amd_scan_nodes(void);
 
 struct amd_northbridge {
 	struct pci_dev *misc;
+	struct pci_dev *link;
 };
 
 struct amd_northbridge_info {
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 4ce87c2..aecf12f 100644
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
 struct amd_northbridge_info amd_northbridges;
 EXPORT_SYMBOL(amd_northbridges);
 
@@ -38,7 +43,7 @@ int amd_cache_northbridges(void)
 {
 	int i = 0;
 	struct amd_northbridge *nb;
-	struct pci_dev *misc;
+	struct pci_dev *misc, *link;
 
 	if (amd_nb_num())
 		return 0;
@@ -57,10 +62,12 @@ int amd_cache_northbridges(void)
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
index c6bcfe9..dd8be13 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -518,6 +518,7 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
 #define PCI_DEVICE_ID_AMD_15H_NB_MISC	0x1603
+#define PCI_DEVICE_ID_AMD_15H_NB_LINK	0x1604
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
 #define PCI_DEVICE_ID_AMD_SCSI		0x2020
-- 
1.5.6.5


