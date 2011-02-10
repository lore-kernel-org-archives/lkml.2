Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab1BJRPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:15:53 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44642 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab1BJRPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:48 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 15/30] amd64_edac: Cleanup old defines cruft
Date: Thu, 10 Feb 2011 18:15:18 +0100
Message-Id: <1297358133-14320-16-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Remove unused defines, drop family names from define names.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   26 ++++++++--------
 drivers/edac/amd64_edac.h |   72 +++++---------------------------------------
 2 files changed, 22 insertions(+), 76 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 04d481b..729d9f1 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -229,7 +229,7 @@ static int __amd64_set_scrub_rate(struct pci_dev *ctl, u32 new_bw, u32 min_rate)
 
 	scrubval = scrubrates[i].scrubval;
 
-	pci_write_bits32(ctl, K8_SCRCTRL, scrubval, 0x001F);
+	pci_write_bits32(ctl, SCRCTRL, scrubval, 0x001F);
 
 	if (scrubval)
 		return scrubrates[i].bandwidth;
@@ -250,7 +250,7 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
 	u32 scrubval = 0;
 	int i, retval = -EINVAL;
 
-	amd64_read_pci_cfg(pvt->F3, K8_SCRCTRL, &scrubval);
+	amd64_read_pci_cfg(pvt->F3, SCRCTRL, &scrubval);
 
 	scrubval = scrubval & 0x001F;
 
@@ -843,11 +843,11 @@ static void dump_misc_regs(struct amd64_pvt *pvt)
 	debugf1("F3xE8 (NB Cap): 0x%08x\n", pvt->nbcap);
 
 	debugf1("  NB two channel DRAM capable: %s\n",
-		(pvt->nbcap & K8_NBCAP_DCT_DUAL) ? "yes" : "no");
+		(pvt->nbcap & NBCAP_DCT_DUAL) ? "yes" : "no");
 
 	debugf1("  ECC capable: %s, ChipKill ECC capable: %s\n",
-		(pvt->nbcap & K8_NBCAP_SECDED) ? "yes" : "no",
-		(pvt->nbcap & K8_NBCAP_CHIPKILL) ? "yes" : "no");
+		(pvt->nbcap & NBCAP_SECDED) ? "yes" : "no",
+		(pvt->nbcap & NBCAP_CHIPKILL) ? "yes" : "no");
 
 	amd64_dump_dramcfg_low(pvt->dclr0, 0);
 
@@ -1814,7 +1814,7 @@ static inline void __amd64_decode_bus_error(struct mem_ctl_info *mci,
 	int ecc_type = (info->nbsh >> 13) & 0x3;
 
 	/* Bail early out if this was an 'observed' error */
-	if (PP(ec) == K8_NBSL_PP_OBS)
+	if (PP(ec) == NBSL_PP_OBS)
 		return;
 
 	/* Do only ECC errors */
@@ -1906,7 +1906,7 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 	} else
 		debugf0("  TOP_MEM2 disabled.\n");
 
-	amd64_read_pci_cfg(pvt->F3, K8_NBCAP, &pvt->nbcap);
+	amd64_read_pci_cfg(pvt->F3, NBCAP, &pvt->nbcap);
 
 	if (pvt->ops->read_dram_ctl_register)
 		pvt->ops->read_dram_ctl_register(pvt);
@@ -2126,7 +2126,7 @@ static bool amd64_nb_mce_bank_enabled_on_node(int nid)
 
 	for_each_cpu(cpu, mask) {
 		struct msr *reg = per_cpu_ptr(msrs, cpu);
-		nbe = reg->l & K8_MSR_MCGCTL_NBE;
+		nbe = reg->l & MSR_MCGCTL_NBE;
 
 		debugf0("core: %u, MCG_CTL: 0x%llx, NB MSR is %s\n",
 			cpu, reg->q,
@@ -2161,16 +2161,16 @@ static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
 		struct msr *reg = per_cpu_ptr(msrs, cpu);
 
 		if (on) {
-			if (reg->l & K8_MSR_MCGCTL_NBE)
+			if (reg->l & MSR_MCGCTL_NBE)
 				s->flags.nb_mce_enable = 1;
 
-			reg->l |= K8_MSR_MCGCTL_NBE;
+			reg->l |= MSR_MCGCTL_NBE;
 		} else {
 			/*
 			 * Turn off NB MCE reporting only when it was off before
 			 */
 			if (!s->flags.nb_mce_enable)
-				reg->l &= ~K8_MSR_MCGCTL_NBE;
+				reg->l &= ~MSR_MCGCTL_NBE;
 		}
 	}
 	wrmsr_on_cpus(cmask, MSR_IA32_MCG_CTL, msrs);
@@ -2324,10 +2324,10 @@ static void setup_mci_misc_attrs(struct mem_ctl_info *mci)
 	mci->mtype_cap		= MEM_FLAG_DDR2 | MEM_FLAG_RDDR2;
 	mci->edac_ctl_cap	= EDAC_FLAG_NONE;
 
-	if (pvt->nbcap & K8_NBCAP_SECDED)
+	if (pvt->nbcap & NBCAP_SECDED)
 		mci->edac_ctl_cap |= EDAC_FLAG_SECDED;
 
-	if (pvt->nbcap & K8_NBCAP_CHIPKILL)
+	if (pvt->nbcap & NBCAP_CHIPKILL)
 		mci->edac_ctl_cap |= EDAC_FLAG_S4ECD4ED;
 
 	mci->edac_cap		= amd64_determine_edac_cap(pvt);
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 6c52736..04293306 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -250,57 +250,11 @@
 #define NBCFG_CHIPKILL			BIT(23)
 #define NBCFG_ECC_ENABLE		BIT(22)
 
-#define K8_NBSL				0x48
-
-/* Family F10h: Normalized Extended Error Codes */
-#define F10_NBSL_EXT_ERR_RES		0x0
+/* F3x48: NBSL */
 #define F10_NBSL_EXT_ERR_ECC		0x8
+#define NBSL_PP_OBS			0x2
 
-/* Next two are overloaded values */
-#define F10_NBSL_EXT_ERR_LINK_PROTO	0xB
-#define F10_NBSL_EXT_ERR_L3_PROTO	0xB
-
-#define F10_NBSL_EXT_ERR_NB_ARRAY	0xC
-#define F10_NBSL_EXT_ERR_DRAM_PARITY	0xD
-#define F10_NBSL_EXT_ERR_LINK_RETRY	0xE
-
-/* Next two are overloaded values */
-#define F10_NBSL_EXT_ERR_GART_WALK	0xF
-#define F10_NBSL_EXT_ERR_DEV_WALK	0xF
-
-/* 0x10 to 0x1B: Reserved */
-#define F10_NBSL_EXT_ERR_L3_DATA	0x1C
-#define F10_NBSL_EXT_ERR_L3_TAG		0x1D
-#define F10_NBSL_EXT_ERR_L3_LRU		0x1E
-
-/* K8: Normalized Extended Error Codes */
-#define K8_NBSL_EXT_ERR_ECC		0x0
-#define K8_NBSL_EXT_ERR_CRC		0x1
-#define K8_NBSL_EXT_ERR_SYNC		0x2
-#define K8_NBSL_EXT_ERR_MST		0x3
-#define K8_NBSL_EXT_ERR_TGT		0x4
-#define K8_NBSL_EXT_ERR_GART		0x5
-#define K8_NBSL_EXT_ERR_RMW		0x6
-#define K8_NBSL_EXT_ERR_WDT		0x7
-#define K8_NBSL_EXT_ERR_CHIPKILL_ECC	0x8
-#define K8_NBSL_EXT_ERR_DRAM_PARITY	0xD
-
-/*
- * The following are for BUS type errors AFTER values have been normalized by
- * shifting right
- */
-#define K8_NBSL_PP_SRC			0x0
-#define K8_NBSL_PP_RES			0x1
-#define K8_NBSL_PP_OBS			0x2
-#define K8_NBSL_PP_GENERIC		0x3
-
-#define EXTRACT_ERR_CPU_MAP(x)		((x) & 0xF)
-
-#define K8_NBEAL			0x50
-#define K8_NBEAH			0x54
-#define K8_SCRCTRL			0x58
-
-#define F10_NB_CFG_LOW			0x88
+#define SCRCTRL				0x58
 
 #define F10_ONLINE_SPARE		0xB0
 #define F10_ONLINE_SPARE_SWAPDONE0(x)	((x) & BIT(1))
@@ -309,36 +263,28 @@
 #define F10_ONLINE_SPARE_BADDRAM_CS1(x) (((x) >> 8) & 0x00000007)
 
 #define F10_NB_ARRAY_ADDR		0xB8
-
-#define F10_NB_ARRAY_DRAM_ECC		0x80000000
+#define F10_NB_ARRAY_DRAM_ECC		BIT(31)
 
 /* Bits [2:1] are used to select 16-byte section within a 64-byte cacheline  */
 #define SET_NB_ARRAY_ADDRESS(section)	(((section) & 0x3) << 1)
 
 #define F10_NB_ARRAY_DATA		0xBC
-
 #define SET_NB_DRAM_INJECTION_WRITE(word, bits)  \
 					(BIT(((word) & 0xF) + 20) | \
 					BIT(17) | bits)
-
 #define SET_NB_DRAM_INJECTION_READ(word, bits)  \
 					(BIT(((word) & 0xF) + 20) | \
 					BIT(16) |  bits)
 
-#define K8_NBCAP			0xE8
-#define K8_NBCAP_CORES			(BIT(12)|BIT(13))
-#define K8_NBCAP_CHIPKILL		BIT(4)
-#define K8_NBCAP_SECDED			BIT(3)
-#define K8_NBCAP_DCT_DUAL		BIT(0)
+#define NBCAP				0xE8
+#define NBCAP_CHIPKILL			BIT(4)
+#define NBCAP_SECDED			BIT(3)
+#define NBCAP_DCT_DUAL			BIT(0)
 
 #define EXT_NB_MCA_CFG			0x180
 
 /* MSRs */
-#define K8_MSR_MCGCTL_NBE		BIT(4)
-
-#define K8_MSR_MC4CTL			0x0410
-#define K8_MSR_MC4STAT			0x0411
-#define K8_MSR_MC4ADDR			0x0412
+#define MSR_MCGCTL_NBE			BIT(4)
 
 /* AMD sets the first MC device at device ID 0x18. */
 static inline int get_node_id(struct pci_dev *pdev)
-- 
1.7.4.rc2

