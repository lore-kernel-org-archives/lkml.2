Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891Ab0JEKwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:52:35 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37937 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab0JEKwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:52:32 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/8] EDAC, MCE: Rename files
Date: Tue,  5 Oct 2010 12:54:02 +0200
Message-Id: <1286276048-20556-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286276048-20556-1-git-send-email-bp@amd64.org>
References: <1286276048-20556-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Drop "edac_" string from the filenames since they're prefixed with edac/
in their pathname anyway.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/Makefile       |    1 +
 drivers/edac/amd64_edac.h   |    2 +-
 drivers/edac/edac_mce_amd.c |  414 -------------------------------------------
 drivers/edac/edac_mce_amd.h |   72 --------
 drivers/edac/mce_amd.c      |  414 +++++++++++++++++++++++++++++++++++++++++++
 drivers/edac/mce_amd.h      |   72 ++++++++
 drivers/edac/mce_amd_inj.c  |    2 +-
 7 files changed, 489 insertions(+), 488 deletions(-)
 delete mode 100644 drivers/edac/edac_mce_amd.c
 delete mode 100644 drivers/edac/edac_mce_amd.h
 create mode 100644 drivers/edac/mce_amd.c
 create mode 100644 drivers/edac/mce_amd.h

diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 5c38ad3..32c7bc9 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -19,6 +19,7 @@ endif
 
 obj-$(CONFIG_EDAC_MCE_INJ)		+= mce_amd_inj.o
 
+edac_mce_amd-objs			:= mce_amd.o
 obj-$(CONFIG_EDAC_DECODE_MCE)		+= edac_mce_amd.o
 
 obj-$(CONFIG_EDAC_AMD76X)		+= amd76x_edac.o
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 67d9ceb..13e1d6f 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -72,7 +72,7 @@
 #include <linux/edac.h>
 #include <asm/msr.h>
 #include "edac_core.h"
-#include "edac_mce_amd.h"
+#include "mce_amd.h"
 
 #define amd64_printk(level, fmt, arg...) \
 	edac_printk(level, "amd64", fmt, ##arg)
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
deleted file mode 100644
index c75c47b..0000000
--- a/drivers/edac/edac_mce_amd.c
+++ /dev/null
@@ -1,414 +0,0 @@
-#include <linux/module.h>
-#include "edac_mce_amd.h"
-
-static bool report_gart_errors;
-static void (*nb_bus_decoder)(int node_id, struct mce *m, u32 nbcfg);
-
-void amd_report_gart_errors(bool v)
-{
-	report_gart_errors = v;
-}
-EXPORT_SYMBOL_GPL(amd_report_gart_errors);
-
-void amd_register_ecc_decoder(void (*f)(int, struct mce *, u32))
-{
-	nb_bus_decoder = f;
-}
-EXPORT_SYMBOL_GPL(amd_register_ecc_decoder);
-
-void amd_unregister_ecc_decoder(void (*f)(int, struct mce *, u32))
-{
-	if (nb_bus_decoder) {
-		WARN_ON(nb_bus_decoder != f);
-
-		nb_bus_decoder = NULL;
-	}
-}
-EXPORT_SYMBOL_GPL(amd_unregister_ecc_decoder);
-
-/*
- * string representation for the different MCA reported error types, see F3x48
- * or MSR0000_0411.
- */
-
-/* transaction type */
-const char *tt_msgs[] = { "INSN", "DATA", "GEN", "RESV" };
-EXPORT_SYMBOL_GPL(tt_msgs);
-
-/* cache level */
-const char *ll_msgs[] = { "RESV", "L1", "L2", "L3/GEN" };
-EXPORT_SYMBOL_GPL(ll_msgs);
-
-/* memory transaction type */
-const char *rrrr_msgs[] = {
-       "GEN", "RD", "WR", "DRD", "DWR", "IRD", "PRF", "EV", "SNP"
-};
-EXPORT_SYMBOL_GPL(rrrr_msgs);
-
-/* participating processor */
-const char *pp_msgs[] = { "SRC", "RES", "OBS", "GEN" };
-EXPORT_SYMBOL_GPL(pp_msgs);
-
-/* request timeout */
-const char *to_msgs[] = { "no timeout",	"timed out" };
-EXPORT_SYMBOL_GPL(to_msgs);
-
-/* memory or i/o */
-const char *ii_msgs[] = { "MEM", "RESV", "IO", "GEN" };
-EXPORT_SYMBOL_GPL(ii_msgs);
-
-/*
- * Map the 4 or 5 (family-specific) bits of Extended Error code to the
- * string table.
- */
-const char *ext_msgs[] = {
-	"K8 ECC error",					/* 0_0000b */
-	"CRC error on link",				/* 0_0001b */
-	"Sync error packets on link",			/* 0_0010b */
-	"Master Abort during link operation",		/* 0_0011b */
-	"Target Abort during link operation",		/* 0_0100b */
-	"Invalid GART PTE entry during table walk",	/* 0_0101b */
-	"Unsupported atomic RMW command received",	/* 0_0110b */
-	"WDT error: NB transaction timeout",		/* 0_0111b */
-	"ECC/ChipKill ECC error",			/* 0_1000b */
-	"SVM DEV Error",				/* 0_1001b */
-	"Link Data error",				/* 0_1010b */
-	"Link/L3/Probe Filter Protocol error",		/* 0_1011b */
-	"NB Internal Arrays Parity error",		/* 0_1100b */
-	"DRAM Address/Control Parity error",		/* 0_1101b */
-	"Link Transmission error",			/* 0_1110b */
-	"GART/DEV Table Walk Data error"		/* 0_1111b */
-	"Res 0x100 error",				/* 1_0000b */
-	"Res 0x101 error",				/* 1_0001b */
-	"Res 0x102 error",				/* 1_0010b */
-	"Res 0x103 error",				/* 1_0011b */
-	"Res 0x104 error",				/* 1_0100b */
-	"Res 0x105 error",				/* 1_0101b */
-	"Res 0x106 error",				/* 1_0110b */
-	"Res 0x107 error",				/* 1_0111b */
-	"Res 0x108 error",				/* 1_1000b */
-	"Res 0x109 error",				/* 1_1001b */
-	"Res 0x10A error",				/* 1_1010b */
-	"Res 0x10B error",				/* 1_1011b */
-	"ECC error in L3 Cache Data",			/* 1_1100b */
-	"L3 Cache Tag error",				/* 1_1101b */
-	"L3 Cache LRU Parity error",			/* 1_1110b */
-	"Probe Filter error"				/* 1_1111b */
-};
-EXPORT_SYMBOL_GPL(ext_msgs);
-
-static void amd_decode_dc_mce(struct mce *m)
-{
-	u32 ec  = m->status & 0xffff;
-	u32 xec = (m->status >> 16) & 0xf;
-
-	pr_emerg(HW_ERR "Data Cache Error: ");
-
-	if (xec == 1 && TLB_ERROR(ec))
-		pr_cont(": %s TLB multimatch.\n", LL_MSG(ec));
-	else if (xec == 0) {
-		if (m->status & (1ULL << 40))
-			pr_cont(" during Data Scrub.\n");
-		else if (TLB_ERROR(ec))
-			pr_cont(": %s TLB parity error.\n", LL_MSG(ec));
-		else if (MEM_ERROR(ec)) {
-			u8 ll   = ec & 0x3;
-			u8 tt   = (ec >> 2) & 0x3;
-			u8 rrrr = (ec >> 4) & 0xf;
-
-			/* see F10h BKDG (31116), Table 92. */
-			if (ll == 0x1) {
-				if (tt != 0x1)
-					goto wrong_dc_mce;
-
-				pr_cont(": Data/Tag %s error.\n", RRRR_MSG(ec));
-
-			} else if (ll == 0x2 && rrrr == 0x3)
-				pr_cont(" during L1 linefill from L2.\n");
-			else
-				goto wrong_dc_mce;
-		} else if (BUS_ERROR(ec) && boot_cpu_data.x86 == 0xf)
-			pr_cont(" during system linefill.\n");
-		else
-			goto wrong_dc_mce;
-	} else
-		goto wrong_dc_mce;
-
-	return;
-
-wrong_dc_mce:
-	pr_emerg(HW_ERR "Corrupted DC MCE info?\n");
-}
-
-static void amd_decode_ic_mce(struct mce *m)
-{
-	u32 ec  = m->status & 0xffff;
-	u32 xec = (m->status >> 16) & 0xf;
-
-	pr_emerg(HW_ERR "Instruction Cache Error");
-
-	if (xec == 1 && TLB_ERROR(ec))
-		pr_cont(": %s TLB multimatch.\n", LL_MSG(ec));
-	else if (xec == 0) {
-		if (TLB_ERROR(ec))
-			pr_cont(": %s TLB Parity error.\n", LL_MSG(ec));
-		else if (BUS_ERROR(ec)) {
-			if (boot_cpu_data.x86 == 0xf &&
-			    (m->status & BIT(58)))
-				pr_cont(" during system linefill.\n");
-			else
-				pr_cont(" during attempted NB data read.\n");
-		} else if (MEM_ERROR(ec)) {
-			u8 ll   = ec & 0x3;
-			u8 rrrr = (ec >> 4) & 0xf;
-
-			if (ll == 0x2)
-				pr_cont(" during a linefill from L2.\n");
-			else if (ll == 0x1) {
-
-				switch (rrrr) {
-				case 0x5:
-					pr_cont(": Parity error during "
-					       "data load.\n");
-					break;
-
-				case 0x7:
-					pr_cont(": Copyback Parity/Victim"
-						" error.\n");
-					break;
-
-				case 0x8:
-					pr_cont(": Tag Snoop error.\n");
-					break;
-
-				default:
-					goto wrong_ic_mce;
-					break;
-				}
-			}
-		} else
-			goto wrong_ic_mce;
-	} else
-		goto wrong_ic_mce;
-
-	return;
-
-wrong_ic_mce:
-	pr_emerg(HW_ERR "Corrupted IC MCE info?\n");
-}
-
-static void amd_decode_bu_mce(struct mce *m)
-{
-	u32 ec = m->status & 0xffff;
-	u32 xec = (m->status >> 16) & 0xf;
-
-	pr_emerg(HW_ERR "Bus Unit Error");
-
-	if (xec == 0x1)
-		pr_cont(" in the write data buffers.\n");
-	else if (xec == 0x3)
-		pr_cont(" in the victim data buffers.\n");
-	else if (xec == 0x2 && MEM_ERROR(ec))
-		pr_cont(": %s error in the L2 cache tags.\n", RRRR_MSG(ec));
-	else if (xec == 0x0) {
-		if (TLB_ERROR(ec))
-			pr_cont(": %s error in a Page Descriptor Cache or "
-				"Guest TLB.\n", TT_MSG(ec));
-		else if (BUS_ERROR(ec))
-			pr_cont(": %s/ECC error in data read from NB: %s.\n",
-				RRRR_MSG(ec), PP_MSG(ec));
-		else if (MEM_ERROR(ec)) {
-			u8 rrrr = (ec >> 4) & 0xf;
-
-			if (rrrr >= 0x7)
-				pr_cont(": %s error during data copyback.\n",
-					RRRR_MSG(ec));
-			else if (rrrr <= 0x1)
-				pr_cont(": %s parity/ECC error during data "
-					"access from L2.\n", RRRR_MSG(ec));
-			else
-				goto wrong_bu_mce;
-		} else
-			goto wrong_bu_mce;
-	} else
-		goto wrong_bu_mce;
-
-	return;
-
-wrong_bu_mce:
-	pr_emerg(HW_ERR "Corrupted BU MCE info?\n");
-}
-
-static void amd_decode_ls_mce(struct mce *m)
-{
-	u32 ec  = m->status & 0xffff;
-	u32 xec = (m->status >> 16) & 0xf;
-
-	pr_emerg(HW_ERR "Load Store Error");
-
-	if (xec == 0x0) {
-		u8 rrrr = (ec >> 4) & 0xf;
-
-		if (!BUS_ERROR(ec) || (rrrr != 0x3 && rrrr != 0x4))
-			goto wrong_ls_mce;
-
-		pr_cont(" during %s.\n", RRRR_MSG(ec));
-	}
-	return;
-
-wrong_ls_mce:
-	pr_emerg(HW_ERR "Corrupted LS MCE info?\n");
-}
-
-void amd_decode_nb_mce(int node_id, struct mce *m, u32 nbcfg)
-{
-	u32 ec   = m->status & 0xffff;
-	u32 nbsh = (u32)(m->status >> 32);
-	u32 nbsl = (u32)m->status;
-
-	/*
-	 * GART TLB error reporting is disabled by default. Bail out early.
-	 */
-	if (TLB_ERROR(ec) && !report_gart_errors)
-		return;
-
-	pr_emerg(HW_ERR "Northbridge Error, node %d", node_id);
-
-	/*
-	 * F10h, revD can disable ErrCpu[3:0] so check that first and also the
-	 * value encoding has changed so interpret those differently
-	 */
-	if ((boot_cpu_data.x86 == 0x10) &&
-	    (boot_cpu_data.x86_model > 7)) {
-		if (nbsh & K8_NBSH_ERR_CPU_VAL)
-			pr_cont(", core: %u\n", (u8)(nbsh & 0xf));
-	} else {
-		u8 assoc_cpus = nbsh & 0xf;
-
-		if (assoc_cpus > 0)
-			pr_cont(", core: %d", fls(assoc_cpus) - 1);
-
-		pr_cont("\n");
-	}
-
-	pr_emerg(HW_ERR "%s.\n", EXT_ERR_MSG(nbsl));
-
-	if (BUS_ERROR(ec) && nb_bus_decoder)
-		nb_bus_decoder(node_id, m, nbcfg);
-}
-EXPORT_SYMBOL_GPL(amd_decode_nb_mce);
-
-static void amd_decode_fr_mce(struct mce *m)
-{
-	/* we have only one error signature so match all fields at once. */
-	if ((m->status & 0xffff) == 0x0f0f)
-		pr_emerg(HW_ERR " FR Error: CPU Watchdog timer expire.\n");
-	else
-		pr_emerg(HW_ERR "Corrupted FR MCE info?\n");
-}
-
-static inline void amd_decode_err_code(u16 ec)
-{
-	if (TLB_ERROR(ec)) {
-		pr_emerg(HW_ERR "Transaction: %s, Cache Level: %s\n",
-			 TT_MSG(ec), LL_MSG(ec));
-	} else if (MEM_ERROR(ec)) {
-		pr_emerg(HW_ERR "Transaction: %s, Type: %s, Cache Level: %s\n",
-			 RRRR_MSG(ec), TT_MSG(ec), LL_MSG(ec));
-	} else if (BUS_ERROR(ec)) {
-		pr_emerg(HW_ERR "Transaction: %s (%s), %s, Cache Level: %s, "
-			 "Participating Processor: %s\n",
-			  RRRR_MSG(ec), II_MSG(ec), TO_MSG(ec), LL_MSG(ec),
-			  PP_MSG(ec));
-	} else
-		pr_emerg(HW_ERR "Huh? Unknown MCE error 0x%x\n", ec);
-}
-
-int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
-{
-	struct mce *m = (struct mce *)data;
-	int node, ecc;
-
-	pr_emerg(HW_ERR "MC%d_STATUS: ", m->bank);
-
-	pr_cont("%sorrected error, other errors lost: %s, "
-		 "CPU context corrupt: %s",
-		 ((m->status & MCI_STATUS_UC) ? "Unc"  : "C"),
-		 ((m->status & MCI_STATUS_OVER) ? "yes"  : "no"),
-		 ((m->status & MCI_STATUS_PCC) ? "yes" : "no"));
-
-	/* do the two bits[14:13] together */
-	ecc = (m->status >> 45) & 0x3;
-	if (ecc)
-		pr_cont(", %sECC Error", ((ecc == 2) ? "C" : "U"));
-
-	pr_cont("\n");
-
-	switch (m->bank) {
-	case 0:
-		amd_decode_dc_mce(m);
-		break;
-
-	case 1:
-		amd_decode_ic_mce(m);
-		break;
-
-	case 2:
-		amd_decode_bu_mce(m);
-		break;
-
-	case 3:
-		amd_decode_ls_mce(m);
-		break;
-
-	case 4:
-		node = amd_get_nb_id(m->extcpu);
-		amd_decode_nb_mce(node, m, 0);
-		break;
-
-	case 5:
-		amd_decode_fr_mce(m);
-		break;
-
-	default:
-		break;
-	}
-
-	amd_decode_err_code(m->status & 0xffff);
-
-	return NOTIFY_STOP;
-}
-EXPORT_SYMBOL_GPL(amd_decode_mce);
-
-static struct notifier_block amd_mce_dec_nb = {
-	.notifier_call	= amd_decode_mce,
-};
-
-static int __init mce_amd_init(void)
-{
-	/*
-	 * We can decode MCEs for K8, F10h and F11h CPUs:
-	 */
-	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
-		return 0;
-
-	if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
-		return 0;
-
-	atomic_notifier_chain_register(&x86_mce_decoder_chain, &amd_mce_dec_nb);
-
-	return 0;
-}
-early_initcall(mce_amd_init);
-
-#ifdef MODULE
-static void __exit mce_amd_exit(void)
-{
-	atomic_notifier_chain_unregister(&x86_mce_decoder_chain, &amd_mce_dec_nb);
-}
-
-MODULE_DESCRIPTION("AMD MCE decoder");
-MODULE_ALIAS("edac-mce-amd");
-MODULE_LICENSE("GPL");
-module_exit(mce_amd_exit);
-#endif
diff --git a/drivers/edac/edac_mce_amd.h b/drivers/edac/edac_mce_amd.h
deleted file mode 100644
index 2712a90..0000000
--- a/drivers/edac/edac_mce_amd.h
+++ /dev/null
@@ -1,72 +0,0 @@
-#ifndef _EDAC_MCE_AMD_H
-#define _EDAC_MCE_AMD_H
-
-#include <linux/notifier.h>
-
-#include <asm/mce.h>
-
-#define ERROR_CODE(x)			((x) & 0xffff)
-#define EXT_ERROR_CODE(x)		(((x) >> 16) & 0x1f)
-#define EXT_ERR_MSG(x)			ext_msgs[EXT_ERROR_CODE(x)]
-
-#define LOW_SYNDROME(x)			(((x) >> 15) & 0xff)
-#define HIGH_SYNDROME(x)		(((x) >> 24) & 0xff)
-
-#define TLB_ERROR(x)			(((x) & 0xFFF0) == 0x0010)
-#define MEM_ERROR(x)			(((x) & 0xFF00) == 0x0100)
-#define BUS_ERROR(x)			(((x) & 0xF800) == 0x0800)
-
-#define TT(x)				(((x) >> 2) & 0x3)
-#define TT_MSG(x)			tt_msgs[TT(x)]
-#define II(x)				(((x) >> 2) & 0x3)
-#define II_MSG(x)			ii_msgs[II(x)]
-#define LL(x)				(((x) >> 0) & 0x3)
-#define LL_MSG(x)			ll_msgs[LL(x)]
-#define TO(x)				(((x) >> 8) & 0x1)
-#define TO_MSG(x)			to_msgs[TO(x)]
-#define PP(x)				(((x) >> 9) & 0x3)
-#define PP_MSG(x)			pp_msgs[PP(x)]
-
-#define RRRR(x)				(((x) >> 4) & 0xf)
-#define RRRR_MSG(x)			((RRRR(x) < 9) ?  rrrr_msgs[RRRR(x)] : "Wrong R4!")
-
-#define K8_NBSH				0x4C
-
-#define K8_NBSH_VALID_BIT		BIT(31)
-#define K8_NBSH_OVERFLOW		BIT(30)
-#define K8_NBSH_UC_ERR			BIT(29)
-#define K8_NBSH_ERR_EN			BIT(28)
-#define K8_NBSH_MISCV			BIT(27)
-#define K8_NBSH_VALID_ERROR_ADDR	BIT(26)
-#define K8_NBSH_PCC			BIT(25)
-#define K8_NBSH_ERR_CPU_VAL		BIT(24)
-#define K8_NBSH_CECC			BIT(14)
-#define K8_NBSH_UECC			BIT(13)
-#define K8_NBSH_ERR_SCRUBER		BIT(8)
-
-extern const char *tt_msgs[];
-extern const char *ll_msgs[];
-extern const char *rrrr_msgs[];
-extern const char *pp_msgs[];
-extern const char *to_msgs[];
-extern const char *ii_msgs[];
-extern const char *ext_msgs[];
-
-/*
- * relevant NB regs
- */
-struct err_regs {
-	u32 nbcfg;
-	u32 nbsh;
-	u32 nbsl;
-	u32 nbeah;
-	u32 nbeal;
-};
-
-void amd_report_gart_errors(bool);
-void amd_register_ecc_decoder(void (*f)(int, struct mce *, u32));
-void amd_unregister_ecc_decoder(void (*f)(int, struct mce *, u32));
-void amd_decode_nb_mce(int, struct mce *, u32);
-int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data);
-
-#endif /* _EDAC_MCE_AMD_H */
diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
new file mode 100644
index 0000000..5eb8042
--- /dev/null
+++ b/drivers/edac/mce_amd.c
@@ -0,0 +1,414 @@
+#include <linux/module.h>
+#include "mce_amd.h"
+
+static bool report_gart_errors;
+static void (*nb_bus_decoder)(int node_id, struct mce *m, u32 nbcfg);
+
+void amd_report_gart_errors(bool v)
+{
+	report_gart_errors = v;
+}
+EXPORT_SYMBOL_GPL(amd_report_gart_errors);
+
+void amd_register_ecc_decoder(void (*f)(int, struct mce *, u32))
+{
+	nb_bus_decoder = f;
+}
+EXPORT_SYMBOL_GPL(amd_register_ecc_decoder);
+
+void amd_unregister_ecc_decoder(void (*f)(int, struct mce *, u32))
+{
+	if (nb_bus_decoder) {
+		WARN_ON(nb_bus_decoder != f);
+
+		nb_bus_decoder = NULL;
+	}
+}
+EXPORT_SYMBOL_GPL(amd_unregister_ecc_decoder);
+
+/*
+ * string representation for the different MCA reported error types, see F3x48
+ * or MSR0000_0411.
+ */
+
+/* transaction type */
+const char *tt_msgs[] = { "INSN", "DATA", "GEN", "RESV" };
+EXPORT_SYMBOL_GPL(tt_msgs);
+
+/* cache level */
+const char *ll_msgs[] = { "RESV", "L1", "L2", "L3/GEN" };
+EXPORT_SYMBOL_GPL(ll_msgs);
+
+/* memory transaction type */
+const char *rrrr_msgs[] = {
+       "GEN", "RD", "WR", "DRD", "DWR", "IRD", "PRF", "EV", "SNP"
+};
+EXPORT_SYMBOL_GPL(rrrr_msgs);
+
+/* participating processor */
+const char *pp_msgs[] = { "SRC", "RES", "OBS", "GEN" };
+EXPORT_SYMBOL_GPL(pp_msgs);
+
+/* request timeout */
+const char *to_msgs[] = { "no timeout",	"timed out" };
+EXPORT_SYMBOL_GPL(to_msgs);
+
+/* memory or i/o */
+const char *ii_msgs[] = { "MEM", "RESV", "IO", "GEN" };
+EXPORT_SYMBOL_GPL(ii_msgs);
+
+/*
+ * Map the 4 or 5 (family-specific) bits of Extended Error code to the
+ * string table.
+ */
+const char *ext_msgs[] = {
+	"K8 ECC error",					/* 0_0000b */
+	"CRC error on link",				/* 0_0001b */
+	"Sync error packets on link",			/* 0_0010b */
+	"Master Abort during link operation",		/* 0_0011b */
+	"Target Abort during link operation",		/* 0_0100b */
+	"Invalid GART PTE entry during table walk",	/* 0_0101b */
+	"Unsupported atomic RMW command received",	/* 0_0110b */
+	"WDT error: NB transaction timeout",		/* 0_0111b */
+	"ECC/ChipKill ECC error",			/* 0_1000b */
+	"SVM DEV Error",				/* 0_1001b */
+	"Link Data error",				/* 0_1010b */
+	"Link/L3/Probe Filter Protocol error",		/* 0_1011b */
+	"NB Internal Arrays Parity error",		/* 0_1100b */
+	"DRAM Address/Control Parity error",		/* 0_1101b */
+	"Link Transmission error",			/* 0_1110b */
+	"GART/DEV Table Walk Data error"		/* 0_1111b */
+	"Res 0x100 error",				/* 1_0000b */
+	"Res 0x101 error",				/* 1_0001b */
+	"Res 0x102 error",				/* 1_0010b */
+	"Res 0x103 error",				/* 1_0011b */
+	"Res 0x104 error",				/* 1_0100b */
+	"Res 0x105 error",				/* 1_0101b */
+	"Res 0x106 error",				/* 1_0110b */
+	"Res 0x107 error",				/* 1_0111b */
+	"Res 0x108 error",				/* 1_1000b */
+	"Res 0x109 error",				/* 1_1001b */
+	"Res 0x10A error",				/* 1_1010b */
+	"Res 0x10B error",				/* 1_1011b */
+	"ECC error in L3 Cache Data",			/* 1_1100b */
+	"L3 Cache Tag error",				/* 1_1101b */
+	"L3 Cache LRU Parity error",			/* 1_1110b */
+	"Probe Filter error"				/* 1_1111b */
+};
+EXPORT_SYMBOL_GPL(ext_msgs);
+
+static void amd_decode_dc_mce(struct mce *m)
+{
+	u32 ec  = m->status & 0xffff;
+	u32 xec = (m->status >> 16) & 0xf;
+
+	pr_emerg(HW_ERR "Data Cache Error: ");
+
+	if (xec == 1 && TLB_ERROR(ec))
+		pr_cont(": %s TLB multimatch.\n", LL_MSG(ec));
+	else if (xec == 0) {
+		if (m->status & (1ULL << 40))
+			pr_cont(" during Data Scrub.\n");
+		else if (TLB_ERROR(ec))
+			pr_cont(": %s TLB parity error.\n", LL_MSG(ec));
+		else if (MEM_ERROR(ec)) {
+			u8 ll   = ec & 0x3;
+			u8 tt   = (ec >> 2) & 0x3;
+			u8 rrrr = (ec >> 4) & 0xf;
+
+			/* see F10h BKDG (31116), Table 92. */
+			if (ll == 0x1) {
+				if (tt != 0x1)
+					goto wrong_dc_mce;
+
+				pr_cont(": Data/Tag %s error.\n", RRRR_MSG(ec));
+
+			} else if (ll == 0x2 && rrrr == 0x3)
+				pr_cont(" during L1 linefill from L2.\n");
+			else
+				goto wrong_dc_mce;
+		} else if (BUS_ERROR(ec) && boot_cpu_data.x86 == 0xf)
+			pr_cont(" during system linefill.\n");
+		else
+			goto wrong_dc_mce;
+	} else
+		goto wrong_dc_mce;
+
+	return;
+
+wrong_dc_mce:
+	pr_emerg(HW_ERR "Corrupted DC MCE info?\n");
+}
+
+static void amd_decode_ic_mce(struct mce *m)
+{
+	u32 ec  = m->status & 0xffff;
+	u32 xec = (m->status >> 16) & 0xf;
+
+	pr_emerg(HW_ERR "Instruction Cache Error");
+
+	if (xec == 1 && TLB_ERROR(ec))
+		pr_cont(": %s TLB multimatch.\n", LL_MSG(ec));
+	else if (xec == 0) {
+		if (TLB_ERROR(ec))
+			pr_cont(": %s TLB Parity error.\n", LL_MSG(ec));
+		else if (BUS_ERROR(ec)) {
+			if (boot_cpu_data.x86 == 0xf &&
+			    (m->status & BIT(58)))
+				pr_cont(" during system linefill.\n");
+			else
+				pr_cont(" during attempted NB data read.\n");
+		} else if (MEM_ERROR(ec)) {
+			u8 ll   = ec & 0x3;
+			u8 rrrr = (ec >> 4) & 0xf;
+
+			if (ll == 0x2)
+				pr_cont(" during a linefill from L2.\n");
+			else if (ll == 0x1) {
+
+				switch (rrrr) {
+				case 0x5:
+					pr_cont(": Parity error during "
+					       "data load.\n");
+					break;
+
+				case 0x7:
+					pr_cont(": Copyback Parity/Victim"
+						" error.\n");
+					break;
+
+				case 0x8:
+					pr_cont(": Tag Snoop error.\n");
+					break;
+
+				default:
+					goto wrong_ic_mce;
+					break;
+				}
+			}
+		} else
+			goto wrong_ic_mce;
+	} else
+		goto wrong_ic_mce;
+
+	return;
+
+wrong_ic_mce:
+	pr_emerg(HW_ERR "Corrupted IC MCE info?\n");
+}
+
+static void amd_decode_bu_mce(struct mce *m)
+{
+	u32 ec = m->status & 0xffff;
+	u32 xec = (m->status >> 16) & 0xf;
+
+	pr_emerg(HW_ERR "Bus Unit Error");
+
+	if (xec == 0x1)
+		pr_cont(" in the write data buffers.\n");
+	else if (xec == 0x3)
+		pr_cont(" in the victim data buffers.\n");
+	else if (xec == 0x2 && MEM_ERROR(ec))
+		pr_cont(": %s error in the L2 cache tags.\n", RRRR_MSG(ec));
+	else if (xec == 0x0) {
+		if (TLB_ERROR(ec))
+			pr_cont(": %s error in a Page Descriptor Cache or "
+				"Guest TLB.\n", TT_MSG(ec));
+		else if (BUS_ERROR(ec))
+			pr_cont(": %s/ECC error in data read from NB: %s.\n",
+				RRRR_MSG(ec), PP_MSG(ec));
+		else if (MEM_ERROR(ec)) {
+			u8 rrrr = (ec >> 4) & 0xf;
+
+			if (rrrr >= 0x7)
+				pr_cont(": %s error during data copyback.\n",
+					RRRR_MSG(ec));
+			else if (rrrr <= 0x1)
+				pr_cont(": %s parity/ECC error during data "
+					"access from L2.\n", RRRR_MSG(ec));
+			else
+				goto wrong_bu_mce;
+		} else
+			goto wrong_bu_mce;
+	} else
+		goto wrong_bu_mce;
+
+	return;
+
+wrong_bu_mce:
+	pr_emerg(HW_ERR "Corrupted BU MCE info?\n");
+}
+
+static void amd_decode_ls_mce(struct mce *m)
+{
+	u32 ec  = m->status & 0xffff;
+	u32 xec = (m->status >> 16) & 0xf;
+
+	pr_emerg(HW_ERR "Load Store Error");
+
+	if (xec == 0x0) {
+		u8 rrrr = (ec >> 4) & 0xf;
+
+		if (!BUS_ERROR(ec) || (rrrr != 0x3 && rrrr != 0x4))
+			goto wrong_ls_mce;
+
+		pr_cont(" during %s.\n", RRRR_MSG(ec));
+	}
+	return;
+
+wrong_ls_mce:
+	pr_emerg(HW_ERR "Corrupted LS MCE info?\n");
+}
+
+void amd_decode_nb_mce(int node_id, struct mce *m, u32 nbcfg)
+{
+	u32 ec   = m->status & 0xffff;
+	u32 nbsh = (u32)(m->status >> 32);
+	u32 nbsl = (u32)m->status;
+
+	/*
+	 * GART TLB error reporting is disabled by default. Bail out early.
+	 */
+	if (TLB_ERROR(ec) && !report_gart_errors)
+		return;
+
+	pr_emerg(HW_ERR "Northbridge Error, node %d", node_id);
+
+	/*
+	 * F10h, revD can disable ErrCpu[3:0] so check that first and also the
+	 * value encoding has changed so interpret those differently
+	 */
+	if ((boot_cpu_data.x86 == 0x10) &&
+	    (boot_cpu_data.x86_model > 7)) {
+		if (nbsh & K8_NBSH_ERR_CPU_VAL)
+			pr_cont(", core: %u\n", (u8)(nbsh & 0xf));
+	} else {
+		u8 assoc_cpus = nbsh & 0xf;
+
+		if (assoc_cpus > 0)
+			pr_cont(", core: %d", fls(assoc_cpus) - 1);
+
+		pr_cont("\n");
+	}
+
+	pr_emerg(HW_ERR "%s.\n", EXT_ERR_MSG(nbsl));
+
+	if (BUS_ERROR(ec) && nb_bus_decoder)
+		nb_bus_decoder(node_id, m, nbcfg);
+}
+EXPORT_SYMBOL_GPL(amd_decode_nb_mce);
+
+static void amd_decode_fr_mce(struct mce *m)
+{
+	/* we have only one error signature so match all fields at once. */
+	if ((m->status & 0xffff) == 0x0f0f)
+		pr_emerg(HW_ERR " FR Error: CPU Watchdog timer expire.\n");
+	else
+		pr_emerg(HW_ERR "Corrupted FR MCE info?\n");
+}
+
+static inline void amd_decode_err_code(u16 ec)
+{
+	if (TLB_ERROR(ec)) {
+		pr_emerg(HW_ERR "Transaction: %s, Cache Level: %s\n",
+			 TT_MSG(ec), LL_MSG(ec));
+	} else if (MEM_ERROR(ec)) {
+		pr_emerg(HW_ERR "Transaction: %s, Type: %s, Cache Level: %s\n",
+			 RRRR_MSG(ec), TT_MSG(ec), LL_MSG(ec));
+	} else if (BUS_ERROR(ec)) {
+		pr_emerg(HW_ERR "Transaction: %s (%s), %s, Cache Level: %s, "
+			 "Participating Processor: %s\n",
+			  RRRR_MSG(ec), II_MSG(ec), TO_MSG(ec), LL_MSG(ec),
+			  PP_MSG(ec));
+	} else
+		pr_emerg(HW_ERR "Huh? Unknown MCE error 0x%x\n", ec);
+}
+
+int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
+{
+	struct mce *m = (struct mce *)data;
+	int node, ecc;
+
+	pr_emerg(HW_ERR "MC%d_STATUS: ", m->bank);
+
+	pr_cont("%sorrected error, other errors lost: %s, "
+		 "CPU context corrupt: %s",
+		 ((m->status & MCI_STATUS_UC) ? "Unc"  : "C"),
+		 ((m->status & MCI_STATUS_OVER) ? "yes"  : "no"),
+		 ((m->status & MCI_STATUS_PCC) ? "yes" : "no"));
+
+	/* do the two bits[14:13] together */
+	ecc = (m->status >> 45) & 0x3;
+	if (ecc)
+		pr_cont(", %sECC Error", ((ecc == 2) ? "C" : "U"));
+
+	pr_cont("\n");
+
+	switch (m->bank) {
+	case 0:
+		amd_decode_dc_mce(m);
+		break;
+
+	case 1:
+		amd_decode_ic_mce(m);
+		break;
+
+	case 2:
+		amd_decode_bu_mce(m);
+		break;
+
+	case 3:
+		amd_decode_ls_mce(m);
+		break;
+
+	case 4:
+		node = amd_get_nb_id(m->extcpu);
+		amd_decode_nb_mce(node, m, 0);
+		break;
+
+	case 5:
+		amd_decode_fr_mce(m);
+		break;
+
+	default:
+		break;
+	}
+
+	amd_decode_err_code(m->status & 0xffff);
+
+	return NOTIFY_STOP;
+}
+EXPORT_SYMBOL_GPL(amd_decode_mce);
+
+static struct notifier_block amd_mce_dec_nb = {
+	.notifier_call	= amd_decode_mce,
+};
+
+static int __init mce_amd_init(void)
+{
+	/*
+	 * We can decode MCEs for K8, F10h and F11h CPUs:
+	 */
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
+		return 0;
+
+	if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
+		return 0;
+
+	atomic_notifier_chain_register(&x86_mce_decoder_chain, &amd_mce_dec_nb);
+
+	return 0;
+}
+early_initcall(mce_amd_init);
+
+#ifdef MODULE
+static void __exit mce_amd_exit(void)
+{
+	atomic_notifier_chain_unregister(&x86_mce_decoder_chain, &amd_mce_dec_nb);
+}
+
+MODULE_DESCRIPTION("AMD MCE decoder");
+MODULE_ALIAS("edac-mce-amd");
+MODULE_LICENSE("GPL");
+module_exit(mce_amd_exit);
+#endif
diff --git a/drivers/edac/mce_amd.h b/drivers/edac/mce_amd.h
new file mode 100644
index 0000000..2712a90
--- /dev/null
+++ b/drivers/edac/mce_amd.h
@@ -0,0 +1,72 @@
+#ifndef _EDAC_MCE_AMD_H
+#define _EDAC_MCE_AMD_H
+
+#include <linux/notifier.h>
+
+#include <asm/mce.h>
+
+#define ERROR_CODE(x)			((x) & 0xffff)
+#define EXT_ERROR_CODE(x)		(((x) >> 16) & 0x1f)
+#define EXT_ERR_MSG(x)			ext_msgs[EXT_ERROR_CODE(x)]
+
+#define LOW_SYNDROME(x)			(((x) >> 15) & 0xff)
+#define HIGH_SYNDROME(x)		(((x) >> 24) & 0xff)
+
+#define TLB_ERROR(x)			(((x) & 0xFFF0) == 0x0010)
+#define MEM_ERROR(x)			(((x) & 0xFF00) == 0x0100)
+#define BUS_ERROR(x)			(((x) & 0xF800) == 0x0800)
+
+#define TT(x)				(((x) >> 2) & 0x3)
+#define TT_MSG(x)			tt_msgs[TT(x)]
+#define II(x)				(((x) >> 2) & 0x3)
+#define II_MSG(x)			ii_msgs[II(x)]
+#define LL(x)				(((x) >> 0) & 0x3)
+#define LL_MSG(x)			ll_msgs[LL(x)]
+#define TO(x)				(((x) >> 8) & 0x1)
+#define TO_MSG(x)			to_msgs[TO(x)]
+#define PP(x)				(((x) >> 9) & 0x3)
+#define PP_MSG(x)			pp_msgs[PP(x)]
+
+#define RRRR(x)				(((x) >> 4) & 0xf)
+#define RRRR_MSG(x)			((RRRR(x) < 9) ?  rrrr_msgs[RRRR(x)] : "Wrong R4!")
+
+#define K8_NBSH				0x4C
+
+#define K8_NBSH_VALID_BIT		BIT(31)
+#define K8_NBSH_OVERFLOW		BIT(30)
+#define K8_NBSH_UC_ERR			BIT(29)
+#define K8_NBSH_ERR_EN			BIT(28)
+#define K8_NBSH_MISCV			BIT(27)
+#define K8_NBSH_VALID_ERROR_ADDR	BIT(26)
+#define K8_NBSH_PCC			BIT(25)
+#define K8_NBSH_ERR_CPU_VAL		BIT(24)
+#define K8_NBSH_CECC			BIT(14)
+#define K8_NBSH_UECC			BIT(13)
+#define K8_NBSH_ERR_SCRUBER		BIT(8)
+
+extern const char *tt_msgs[];
+extern const char *ll_msgs[];
+extern const char *rrrr_msgs[];
+extern const char *pp_msgs[];
+extern const char *to_msgs[];
+extern const char *ii_msgs[];
+extern const char *ext_msgs[];
+
+/*
+ * relevant NB regs
+ */
+struct err_regs {
+	u32 nbcfg;
+	u32 nbsh;
+	u32 nbsl;
+	u32 nbeah;
+	u32 nbeal;
+};
+
+void amd_report_gart_errors(bool);
+void amd_register_ecc_decoder(void (*f)(int, struct mce *, u32));
+void amd_unregister_ecc_decoder(void (*f)(int, struct mce *, u32));
+void amd_decode_nb_mce(int, struct mce *, u32);
+int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data);
+
+#endif /* _EDAC_MCE_AMD_H */
diff --git a/drivers/edac/mce_amd_inj.c b/drivers/edac/mce_amd_inj.c
index 0e4f2dc..8d0688f 100644
--- a/drivers/edac/mce_amd_inj.c
+++ b/drivers/edac/mce_amd_inj.c
@@ -15,7 +15,7 @@
 #include <linux/edac.h>
 #include <asm/mce.h>
 
-#include "edac_mce_amd.h"
+#include "mce_amd.h"
 
 struct edac_mce_attr {
 	struct attribute attr;
-- 
1.7.3.1.50.g1e633

