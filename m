Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0I3LA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:00:58 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41673 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab0I3LA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:00:56 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 4/8] EDAC, MCE: Sanitize error codes
Date: Thu, 30 Sep 2010 13:01:45 +0200
Message-Id: <1285844509-27120-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285844509-27120-1-git-send-email-bp@amd64.org>
References: <1285844509-27120-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Clean up error codes names, shorten to mnemonics, add RRRR boundary
checking.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/edac_mce_amd.c |   63 +++++++++++--------------------------------
 drivers/edac/edac_mce_amd.h |    5 ++-
 2 files changed, 19 insertions(+), 49 deletions(-)

diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 765d7fb..d0e850e 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -30,62 +30,31 @@ EXPORT_SYMBOL_GPL(amd_unregister_ecc_decoder);
  * string representation for the different MCA reported error types, see F3x48
  * or MSR0000_0411.
  */
-const char *tt_msgs[] = {        /* transaction type */
-	"instruction",
-	"data",
-	"generic",
-	"reserved"
-};
+
+/* transaction type */
+const char *tt_msgs[] = { "INSN", "DATA", "GEN", "RESV" };
 EXPORT_SYMBOL_GPL(tt_msgs);
 
-const char *ll_msgs[] = {	/* cache level */
-	"L0",
-	"L1",
-	"L2",
-	"L3/generic"
-};
+/* cache level */
+const char *ll_msgs[] = { "RESV", "L1", "L2", "L3/GEN" };
 EXPORT_SYMBOL_GPL(ll_msgs);
 
+/* memory transaction type */
 const char *rrrr_msgs[] = {
-	"generic",
-	"generic read",
-	"generic write",
-	"data read",
-	"data write",
-	"inst fetch",
-	"prefetch",
-	"evict",
-	"snoop",
-	"reserved RRRR= 9",
-	"reserved RRRR= 10",
-	"reserved RRRR= 11",
-	"reserved RRRR= 12",
-	"reserved RRRR= 13",
-	"reserved RRRR= 14",
-	"reserved RRRR= 15"
+       "GEN", "RD", "WR", "DRD", "DWR", "IRD", "PRF", "EV", "SNP"
 };
 EXPORT_SYMBOL_GPL(rrrr_msgs);
 
-const char *pp_msgs[] = {	/* participating processor */
-	"local node originated (SRC)",
-	"local node responded to request (RES)",
-	"local node observed as 3rd party (OBS)",
-	"generic"
-};
+/* participating processor */
+const char *pp_msgs[] = { "SRC", "RES", "OBS", "GEN" };
 EXPORT_SYMBOL_GPL(pp_msgs);
 
-const char *to_msgs[] = {
-	"no timeout",
-	"timed out"
-};
+/* request timeout */
+const char *to_msgs[] = { "no timeout",	"timed out" };
 EXPORT_SYMBOL_GPL(to_msgs);
 
-const char *ii_msgs[] = {	/* memory or i/o */
-	"mem access",
-	"reserved",
-	"i/o access",
-	"generic"
-};
+/* memory or i/o */
+const char *ii_msgs[] = { "MEM", "RESV", "IO", "GEN" };
 EXPORT_SYMBOL_GPL(ii_msgs);
 
 /*
@@ -336,16 +305,16 @@ static void amd_decode_fr_mce(u64 mc5_status)
 		pr_emerg(HW_ERR "Corrupted FR MCE info?\n");
 }
 
-static inline void amd_decode_err_code(unsigned int ec)
+static inline void amd_decode_err_code(u16 ec)
 {
 	if (TLB_ERROR(ec)) {
 		pr_emerg(HW_ERR "Transaction: %s, Cache Level: %s\n",
 			 TT_MSG(ec), LL_MSG(ec));
 	} else if (MEM_ERROR(ec)) {
-		pr_emerg(HW_ERR "Transaction: %s, Type: %s, Cache Level: %s",
+		pr_emerg(HW_ERR "Transaction: %s, Type: %s, Cache Level: %s\n",
 			 RRRR_MSG(ec), TT_MSG(ec), LL_MSG(ec));
 	} else if (BUS_ERROR(ec)) {
-		pr_emerg(HW_ERR "Transaction type: %s(%s), %s, Cache Level: %s, "
+		pr_emerg(HW_ERR "Transaction: %s (%s), %s, Cache Level: %s, "
 			 "Participating Processor: %s\n",
 			  RRRR_MSG(ec), II_MSG(ec), TO_MSG(ec), LL_MSG(ec),
 			  PP_MSG(ec));
diff --git a/drivers/edac/edac_mce_amd.h b/drivers/edac/edac_mce_amd.h
index 8920133..2ee499d 100644
--- a/drivers/edac/edac_mce_amd.h
+++ b/drivers/edac/edac_mce_amd.h
@@ -20,13 +20,14 @@
 #define II_MSG(x)			ii_msgs[II(x)]
 #define LL(x)				(((x) >> 0) & 0x3)
 #define LL_MSG(x)			ll_msgs[LL(x)]
-#define RRRR(x)				(((x) >> 4) & 0xf)
-#define RRRR_MSG(x)			rrrr_msgs[RRRR(x)]
 #define TO(x)				(((x) >> 8) & 0x1)
 #define TO_MSG(x)			to_msgs[TO(x)]
 #define PP(x)				(((x) >> 9) & 0x3)
 #define PP_MSG(x)			pp_msgs[PP(x)]
 
+#define RRRR(x)				(((x) >> 4) & 0xf)
+#define RRRR_MSG(x)			((RRRR(x) < 9) ?  rrrr_msgs[RRRR(x)] : "Wrong R4!")
+
 #define K8_NBSH				0x4C
 
 #define K8_NBSH_VALID_BIT		BIT(31)
-- 
1.7.1

