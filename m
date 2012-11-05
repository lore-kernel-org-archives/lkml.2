Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab2KEGGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 01:06:10 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35887 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab2KEGGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 01:06:04 -0500
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH 2/3, v3] AMD64 EDAC: Support >255 memory controllers
Date: Mon,  5 Nov 2012 14:05:25 +0800
Message-Id: <1352095526-6522-2-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1352095526-6522-1-git-send-email-daniel@numascale-asia.com>
References: <1352095526-6522-1-git-send-email-daniel@numascale-asia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the AMD64 last-level-cache ID is 16-bits and federated systems
eg using Numascale's NumaConnect/NumaChip can have more than 255 memory
controllers, use 16-bits to store the ID.

v2: Avoid change to intlv_en variable
v3: Drop unneeded change to index

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 drivers/edac/amd64_edac.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 852f1cd..5dfe452 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -942,7 +942,8 @@ static u64 get_error_address(struct mce *m)
 		struct amd64_pvt *pvt;
 		u64 cc6_base, tmp_addr;
 		u32 tmp;
-		u8 mce_nid, intlv_en;
+		u16 mce_nid;
+		u8 intlv_en;
 
 		if ((addr & GENMASK(24, 47)) >> 24 != 0x00fdf7)
 			return addr;
@@ -2299,7 +2300,7 @@ out:
 	return ret;
 }
 
-static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
+static int toggle_ecc_err_reporting(struct ecc_settings *s, u16 nid, bool on)
 {
 	cpumask_var_t cmask;
 	int cpu;
@@ -2337,7 +2338,7 @@ static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
 	return 0;
 }
 
-static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
+static bool enable_ecc_error_reporting(struct ecc_settings *s, u16 nid,
 				       struct pci_dev *F3)
 {
 	bool ret = true;
@@ -2389,7 +2390,7 @@ static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 	return ret;
 }
 
-static void restore_ecc_error_reporting(struct ecc_settings *s, u8 nid,
+static void restore_ecc_error_reporting(struct ecc_settings *s, u16 nid,
 					struct pci_dev *F3)
 {
 	u32 value, mask = 0x3;		/* UECC/CECC enable */
@@ -2428,7 +2429,7 @@ static const char *ecc_msg =
 	"'ecc_enable_override'.\n"
 	" (Note that use of the override may cause unknown side effects.)\n";
 
-static bool ecc_enabled(struct pci_dev *F3, u8 nid)
+static bool ecc_enabled(struct pci_dev *F3, u16 nid)
 {
 	u32 value;
 	u8 ecc_en = 0;
@@ -2549,7 +2550,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 	struct mem_ctl_info *mci = NULL;
 	struct edac_mc_layer layers[2];
 	int err = 0, ret;
-	u8 nid = amd_get_node_id(F2);
+	u16 nid = amd_get_node_id(F2);
 
 	ret = -ENOMEM;
 	pvt = kzalloc(sizeof(struct amd64_pvt), GFP_KERNEL);
@@ -2640,7 +2641,7 @@ err_ret:
 static int __devinit amd64_probe_one_instance(struct pci_dev *pdev,
 					     const struct pci_device_id *mc_type)
 {
-	u8 nid = amd_get_node_id(pdev);
+	u16 nid = amd_get_node_id(pdev);
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s;
 	int ret = 0;
@@ -2690,7 +2691,7 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
-	u8 nid = amd_get_node_id(pdev);
+	u16 nid = amd_get_node_id(pdev);
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s = ecc_stngs[nid];
 
-- 
1.7.10.4

