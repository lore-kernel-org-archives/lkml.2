Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab2JaF4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:56:18 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63911 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab2JaF4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:56:14 -0400
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH 2/4] AMD64 EDAC: Add support for >255 memory controllers
Date: Wed, 31 Oct 2012 13:55:30 +0800
Message-Id: <1351662932-22279-2-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351662932-22279-1-git-send-email-daniel@numascale-asia.com>
References: <1351662932-22279-1-git-send-email-daniel@numascale-asia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the AMD64 last-level-cache ID is 16-bits and federated systems
eg using Numascale's NumaConnect/NumaChip can have more than 255 memory
controllers, use 16-bits to store the ID.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 drivers/edac/amd64_edac.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 18d404a..9920dfd 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -942,7 +942,7 @@ static u64 get_error_address(struct mce *m)
 		struct amd64_pvt *pvt;
 		u64 cc6_base, tmp_addr;
 		u32 tmp;
-		u8 mce_nid, intlv_en;
+		u16 mce_nid, intlv_en;
 
 		if ((addr & GENMASK(24, 47)) >> 24 != 0x00fdf7)
 			return addr;
@@ -1499,7 +1499,7 @@ static int f1x_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
 	u8 channel;
 	bool high_range = false;
 
-	u8 node_id    = dram_dst_node(pvt, range);
+	u16 node_id   = dram_dst_node(pvt, range);
 	u8 intlv_en   = dram_intlv_en(pvt, range);
 	u32 intlv_sel = dram_intlv_sel(pvt, range);
 
@@ -2306,7 +2306,7 @@ out:
 	return ret;
 }
 
-static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
+static int toggle_ecc_err_reporting(struct ecc_settings *s, u16 nid, bool on)
 {
 	cpumask_var_t cmask;
 	int cpu;
@@ -2344,7 +2344,7 @@ static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
 	return 0;
 }
 
-static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
+static bool enable_ecc_error_reporting(struct ecc_settings *s, u16 nid,
 				       struct pci_dev *F3)
 {
 	bool ret = true;
@@ -2396,7 +2396,7 @@ static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 	return ret;
 }
 
-static void restore_ecc_error_reporting(struct ecc_settings *s, u8 nid,
+static void restore_ecc_error_reporting(struct ecc_settings *s, u16 nid,
 					struct pci_dev *F3)
 {
 	u32 value, mask = 0x3;		/* UECC/CECC enable */
@@ -2435,7 +2435,7 @@ static const char *ecc_msg =
 	"'ecc_enable_override'.\n"
 	" (Note that use of the override may cause unknown side effects.)\n";
 
-static bool ecc_enabled(struct pci_dev *F3, u8 nid)
+static bool ecc_enabled(struct pci_dev *F3, u16 nid)
 {
 	u32 value;
 	u8 ecc_en = 0;
@@ -2556,7 +2556,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 	struct mem_ctl_info *mci = NULL;
 	struct edac_mc_layer layers[2];
 	int err = 0, ret;
-	u8 nid = get_node_id(F2);
+	u16 nid = get_node_id(F2);
 
 	ret = -ENOMEM;
 	pvt = kzalloc(sizeof(struct amd64_pvt), GFP_KERNEL);
@@ -2647,7 +2647,7 @@ err_ret:
 static int __devinit amd64_probe_one_instance(struct pci_dev *pdev,
 					     const struct pci_device_id *mc_type)
 {
-	u8 nid = get_node_id(pdev);
+	u16 nid = get_node_id(pdev);
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s;
 	int ret = 0;
@@ -2697,7 +2697,7 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
-	u8 nid = get_node_id(pdev);
+	u16 nid = get_node_id(pdev);
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s = ecc_stngs[nid];
 
-- 
1.7.9.5

