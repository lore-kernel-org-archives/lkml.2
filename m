Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab2LQTju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:39:50 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:31941
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514Ab2LQTjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:39:47 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1155h)
X-WSS-ID: 0MF6XA5-01-43N-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>, Doug Thompson <dougthompson@xmission.com>
CC: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 2/2] MCE, AMD: MCE decoding support for AMD Family 16h
Date: Mon, 17 Dec 2012 13:39:48 -0600
Message-ID: <1355773188-5241-2-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
References: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MCE decoding logic for AMD Family 16h processors.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 drivers/edac/mce_amd.c |  120 ++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/edac/mce_amd.h |    6 +++
 2 files changed, 122 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 84320f9..7d2d037 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -64,6 +64,10 @@ EXPORT_SYMBOL_GPL(to_msgs);
 const char * const ii_msgs[] = { "MEM", "RESV", "IO", "GEN" };
 EXPORT_SYMBOL_GPL(ii_msgs);
 
+/* internal error type */
+const char * const uu_msgs[] = { "RESV", "RESV", "HWA", "RESV" };
+EXPORT_SYMBOL_GPL(uu_msgs);
+
 static const char * const f15h_mc1_mce_desc[] = {
 	"UC during a demand linefill from L2",
 	"Parity error during data load from IC",
@@ -275,6 +279,23 @@ static bool f15h_mc0_mce(u16 ec, u8 xec)
 	return ret;
 }
 
+static bool f16h_mc0_mce(u16 ec, u8 xec)
+{
+	u8 r4 = R4(ec);
+
+	if (MEM_ERROR(ec) && TT(ec) == TT_DATA && LL(ec) == LL_L1 &&
+	    (r4 == R4_DRD || r4 == R4_DWR)) {
+
+		pr_cont("%s parity error due to %s.\n",
+			(xec == 0x0    ? "Data" : "Tag"),
+			(r4  == R4_DRD ? "load" : "store"));
+
+		return true;
+	}
+
+	return f14h_mc0_mce(ec, xec);
+}
+
 static void decode_mc0_mce(struct mce *m)
 {
 	u16 ec = EC(m->status);
@@ -379,6 +400,36 @@ static bool f15h_mc1_mce(u16 ec, u8 xec)
 	return ret;
 }
 
+static bool f16h_mc1_mce(u16 ec, u8 xec)
+{
+	u8 r4    = R4(ec);
+	bool ret = true;
+
+	if (MEM_ERROR(ec)) {
+		if (TT(ec) != TT_INSTR)
+			ret = false;
+
+		else if (r4 == R4_IRD)
+			pr_cont("%s array parity error for a tag hit.\n",
+				(xec == 0x0 ? "Data" : "Tag"));
+
+		else if (r4 == R4_SNOOP)
+			pr_cont("Tag error during snoop/victimization.\n");
+
+		else if (xec == 0x0)
+			pr_cont("Tag parity error from victim castout.\n");
+
+		else if (xec == 0x2)
+			pr_cont("Microcode patch RAM parity error.\n");
+
+		else
+			ret = false;
+	} else
+		ret = false;
+
+	return ret;
+}
+
 static void decode_mc1_mce(struct mce *m)
 {
 	u16 ec = EC(m->status);
@@ -469,6 +520,48 @@ static bool f15h_mc2_mce(u16 ec, u8 xec)
 	return ret;
 }
 
+static bool f16h_mc2_mce(u16 ec, u8 xec)
+{
+	u8 r4    = R4(ec);
+	bool ret = true;
+
+	if (MEM_ERROR(ec) && TT(ec) == TT_GEN && LL(ec) == LL_L2) {
+		switch (xec) {
+		case 0x04 ... 0x05:
+			pr_cont("Parity error in %s.\n",
+				(r4 == R4_RD ? "IBUFF" : "OBUFF"));
+			break;
+
+		case 0x09 ... 0x0b:
+		case 0x0d ... 0x0f:
+			pr_cont("ECC error in L2 tag (%s).\n",
+				(r4 == R4_GEN   ? "BankReq" :
+				(r4 == R4_SNOOP ? "Probe"   : "Fill")));
+			break;
+
+		case 0x10 ... 0x1b:
+			pr_cont("ECC error in L2 data array (%s).\n",
+				(r4 == R4_RD    ? "Hit"  :
+				(r4 == R4_GEN   ? "Attr" :
+				(r4 == R4_EVICT ? "Vict" : "Fill"))));
+			break;
+
+		case 0x1c ... 0x1f:
+			pr_cont("Parity error in L2 attribute bits (%s).\n",
+				(r4 == R4_RD  ? "Hit"  :
+				(r4 == R4_GEN ? "Attr" : "Fill")));
+			break;
+
+		default:
+			ret = false;
+			break;
+		}
+	} else
+		ret = false;
+
+	return ret;
+}
+
 static void decode_mc2_mce(struct mce *m)
 {
 	u16 ec = EC(m->status);
@@ -548,7 +641,7 @@ static void decode_mc4_mce(struct mce *m)
 		return;
 
 	case 0x19:
-		if (boot_cpu_data.x86 == 0x15)
+		if (boot_cpu_data.x86 == 0x15 || boot_cpu_data.x86 == 0x16)
 			pr_cont("Compute Unit Data Error.\n");
 		else
 			goto wrong_mc4_mce;
@@ -634,6 +727,10 @@ static void decode_mc6_mce(struct mce *m)
 
 static inline void amd_decode_err_code(u16 ec)
 {
+	if (INT_ERROR(ec)) {
+		pr_emerg(HW_ERR "internal: %s\n", LL_MSG(ec));
+		return;
+	}
 
 	pr_emerg(HW_ERR "cache level: %s", LL_MSG(ec));
 
@@ -738,10 +835,18 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
 		((m->status & MCI_STATUS_PCC)	? "PCC"	  : "-"),
 		((m->status & MCI_STATUS_ADDRV)	? "AddrV" : "-"));
 
-	if (c->x86 == 0x15)
-		pr_cont("|%s|%s",
+	if (c->x86 == 0x15 || c->x86 == 0x16) {
+		char coreid[16];
+
+		if (m->status & MCI_STATUS_COREIDV)
+			sprintf(coreid, "CoreIdV(Core%d)",
+				(int)ERR_CORE_ID(m->status));
+
+		pr_cont("|%s|%s|%s",
+			((m->status & MCI_STATUS_COREIDV)  ? coreid     : "-"),
 			((m->status & MCI_STATUS_DEFERRED) ? "Deferred" : "-"),
 			((m->status & MCI_STATUS_POISON)   ? "Poison"   : "-"));
+	}
 
 	/* do the two bits[14:13] together */
 	ecc = (m->status >> 45) & 0x3;
@@ -770,7 +875,7 @@ static int __init mce_amd_init(void)
 	if (c->x86_vendor != X86_VENDOR_AMD)
 		return 0;
 
-	if (c->x86 < 0xf || c->x86 > 0x15)
+	if (c->x86 < 0xf || c->x86 > 0x16)
 		return 0;
 
 	fam_ops = kzalloc(sizeof(struct amd_decoder_ops), GFP_KERNEL);
@@ -816,6 +921,13 @@ static int __init mce_amd_init(void)
 		fam_ops->mc2_mce = f15h_mc2_mce;
 		break;
 
+	case 0x16:
+		xec_mask = 0x1f;
+		fam_ops->mc0_mce = f16h_mc0_mce;
+		fam_ops->mc1_mce = f16h_mc1_mce;
+		fam_ops->mc2_mce = f16h_mc2_mce;
+		break;
+
 	default:
 		printk(KERN_WARNING "Huh? What family is it: 0x%x?!\n", c->x86);
 		kfree(fam_ops);
diff --git a/drivers/edac/mce_amd.h b/drivers/edac/mce_amd.h
index 000f6e2..af2d20d 100644
--- a/drivers/edac/mce_amd.h
+++ b/drivers/edac/mce_amd.h
@@ -11,9 +11,12 @@
 #define LOW_SYNDROME(x)			(((x) >> 15) & 0xff)
 #define HIGH_SYNDROME(x)		(((x) >> 24) & 0xff)
 
+#define ERR_CORE_ID(x)			(((x) >> 32) & 0xf)
+
 #define TLB_ERROR(x)			(((x) & 0xFFF0) == 0x0010)
 #define MEM_ERROR(x)			(((x) & 0xFF00) == 0x0100)
 #define BUS_ERROR(x)			(((x) & 0xF800) == 0x0800)
+#define INT_ERROR(x)			(((x) & 0xF4FF) == 0x0400)
 
 #define TT(x)				(((x) >> 2) & 0x3)
 #define TT_MSG(x)			tt_msgs[TT(x)]
@@ -25,10 +28,13 @@
 #define TO_MSG(x)			to_msgs[TO(x)]
 #define PP(x)				(((x) >> 9) & 0x3)
 #define PP_MSG(x)			pp_msgs[PP(x)]
+#define UU(x)				(((x) >> 8) & 0x3)
+#define UU_MSG(x)			uu_msgs[UU(x)]
 
 #define R4(x)				(((x) >> 4) & 0xf)
 #define R4_MSG(x)			((R4(x) < 9) ?  rrrr_msgs[R4(x)] : "Wrong R4!")
 
+#define MCI_STATUS_COREIDV		BIT_64(56)
 #define MCI_STATUS_DEFERRED		BIT_64(44)
 #define MCI_STATUS_POISON		BIT_64(43)
 
-- 
1.7.9.5


