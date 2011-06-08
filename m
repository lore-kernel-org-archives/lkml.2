Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab1FHB5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 21:57:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54829 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1FHB5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 21:57:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DEED6E8.9090509@jp.fujitsu.com>
Date: Wed, 08 Jun 2011 10:56:56 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@gmail.com>
Subject: [PATCH 06/12] x86, mce: replace MCM_ to MCI_MISC_
References: <4DEED509.1040504@jp.fujitsu.com>
In-Reply-To: <4DEED509.1040504@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow other MCi_* register defines.
Plus define MCI_MISC_ADDR_LSB() and MCI_MISC_ADDR_MODE().

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/mce.h       |   17 +++++++++++------
 arch/x86/kernel/cpu/mcheck/mce.c |    4 ++--
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 021979a..bbb328f 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -8,6 +8,7 @@
  * Machine Check support for x86
  */
 
+/* MCG_CAP register defines */
 #define MCG_BANKCNT_MASK	0xff         /* Number of Banks */
 #define MCG_CTL_P		(1ULL<<8)    /* MCG_CTL register available */
 #define MCG_EXT_P		(1ULL<<9)    /* Extended registers available */
@@ -17,10 +18,12 @@
 #define MCG_EXT_CNT(c)		(((c) & MCG_EXT_CNT_MASK) >> MCG_EXT_CNT_SHIFT)
 #define MCG_SER_P	 	(1ULL<<24)   /* MCA recovery/new status bits */
 
+/* MCG_STATUS register defines */
 #define MCG_STATUS_RIPV  (1ULL<<0)   /* restart ip valid */
 #define MCG_STATUS_EIPV  (1ULL<<1)   /* ip points to correct instruction */
 #define MCG_STATUS_MCIP  (1ULL<<2)   /* machine check in progress */
 
+/* MCi_STATUS register defines */
 #define MCI_STATUS_VAL   (1ULL<<63)  /* valid error */
 #define MCI_STATUS_OVER  (1ULL<<62)  /* previous errors lost */
 #define MCI_STATUS_UC    (1ULL<<61)  /* uncorrected error */
@@ -31,12 +34,14 @@
 #define MCI_STATUS_S	 (1ULL<<56)  /* Signaled machine check */
 #define MCI_STATUS_AR	 (1ULL<<55)  /* Action required */
 
-/* MISC register defines */
-#define MCM_ADDR_SEGOFF  0	/* segment offset */
-#define MCM_ADDR_LINEAR  1	/* linear address */
-#define MCM_ADDR_PHYS	 2	/* physical address */
-#define MCM_ADDR_MEM	 3	/* memory address */
-#define MCM_ADDR_GENERIC 7	/* generic */
+/* MCi_MISC register defines */
+#define MCI_MISC_ADDR_LSB(m)	((m) & 0x3f)
+#define MCI_MISC_ADDR_MODE(m)	(((m) >> 6) & 7)
+#define  MCI_MISC_ADDR_SEGOFF	0	/* segment offset */
+#define  MCI_MISC_ADDR_LINEAR	1	/* linear address */
+#define  MCI_MISC_ADDR_PHYS	2	/* physical address */
+#define  MCI_MISC_ADDR_MEM	3	/* memory address */
+#define  MCI_MISC_ADDR_GENERIC	7	/* generic */
 
 /* CTL2 register defines */
 #define MCI_CTL2_CMCI_EN		(1ULL << 30)
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index e81d48b..e807508 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -844,9 +844,9 @@ static int mce_usable_address(struct mce *m)
 {
 	if (!(m->status & MCI_STATUS_MISCV) || !(m->status & MCI_STATUS_ADDRV))
 		return 0;
-	if ((m->misc & 0x3f) > PAGE_SHIFT)
+	if (MCI_MISC_ADDR_LSB(m->misc) > PAGE_SHIFT)
 		return 0;
-	if (((m->misc >> 6) & 7) != MCM_ADDR_PHYS)
+	if (MCI_MISC_ADDR_MODE(m->misc) != MCI_MISC_ADDR_PHYS)
 		return 0;
 	return 1;
 }
-- 
1.7.1


