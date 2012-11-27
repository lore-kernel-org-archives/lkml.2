Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab2K0Ge6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:34:58 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37202 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab2K0Ge4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:34:56 -0500
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4 v7] AMD64 EDAC: Add multi-domain support
Date: Tue, 27 Nov 2012 14:32:09 +0800
Message-Id: <1353997932-8475-1-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix get_node_id to match northbridge IDs from the array of detected ones,
allowing multi-server support such as with Numascale's NumaConnect, renaming
to 'amd_get_node_id' for consistency.

v7: Refactor patches grouping changes

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/include/asm/amd_nb.h |   17 +++++++++++++++++
 drivers/edac/amd64_edac.c     |    6 +++---
 drivers/edac/amd64_edac.h     |    6 ------
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index b3341e9..417eb24 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -81,6 +81,23 @@ static inline struct amd_northbridge *node_to_amd_nb(int node)
 	return (node < amd_northbridges.num) ? &amd_northbridges.nb[node] : NULL;
 }
 
+static inline u16 amd_get_node_id(struct pci_dev *pdev)
+{
+	struct pci_dev *misc;
+	int i;
+
+	for (i = 0; i != amd_nb_num(); i++) {
+		misc = node_to_amd_nb(i)->misc;
+
+		if (pci_domain_nr(misc->bus) == pci_domain_nr(pdev->bus) &&
+		    PCI_SLOT(misc->devfn) == PCI_SLOT(pdev->devfn))
+			return i;
+	}
+
+	WARN(1, "Unable to find AMD Northbridge identifier for %s\n", pci_name(pdev));
+	return 0;
+}
+
 #else
 
 #define amd_nb_num(x)		0
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index cc8e7c7..9ba70a5 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2546,7 +2546,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 	struct mem_ctl_info *mci = NULL;
 	struct edac_mc_layer layers[2];
 	int err = 0, ret;
-	u8 nid = get_node_id(F2);
+	u16 nid = amd_get_node_id(F2);
 
 	ret = -ENOMEM;
 	pvt = kzalloc(sizeof(struct amd64_pvt), GFP_KERNEL);
@@ -2637,7 +2637,7 @@ err_ret:
 static int __devinit amd64_probe_one_instance(struct pci_dev *pdev,
 					     const struct pci_device_id *mc_type)
 {
-	u8 nid = get_node_id(pdev);
+	u16 nid = amd_get_node_id(pdev);
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s;
 	int ret = 0;
@@ -2687,7 +2687,7 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
-	u8 nid = get_node_id(pdev);
+	u16 nid = amd_get_node_id(pdev);
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s = ecc_stngs[nid];
 
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 8c41396..cecd0c4 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -290,12 +290,6 @@
 /* MSRs */
 #define MSR_MCGCTL_NBE			BIT(4)
 
-/* AMD sets the first MC device at device ID 0x18. */
-static inline u8 get_node_id(struct pci_dev *pdev)
-{
-	return PCI_SLOT(pdev->devfn) - 0x18;
-}
-
 enum amd_families {
 	K8_CPUS = 0,
 	F10_CPUS,
-- 
1.7.10.4

