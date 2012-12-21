Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab2LUQfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 11:35:07 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60975 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab2LUQe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 11:34:59 -0500
Date: Fri, 21 Dec 2012 17:34:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: x86, MCE: Retract most UAPI exports
Message-ID: <20121221163455.GG15204@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

we talked about this already and now that -rc1 is imminent, here's what
I'm thinking of hiding back from UAPI so that there are no conflicts
with userspace. I've left structs mce and mce_log since I know they're
used in mcelog. Please take a look and let me know if I'm being too
overzealous. I'd like to send this out for 3.8 still so that no exports
get cast in stone.

Thanks.

--
From: Borislav Petkov <bp@alien8.de>
Date: Fri, 21 Dec 2012 17:03:58 +0100
Subject: [PATCH] x86, MCE: Retract most UAPI exports

Retract back most macro definitions which went into the
user-visible mce.h header. Even though those bits are mostly
hardware-defined/-architectural, their naming is not. If we export them
to userspace, any kernel unification/renaming/cleanup cannot be done
anymore since those are effectively cast in stone. Besides, if userspace
wants those definitions, they can write their own defines and go crazy.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/include/asm/mce.h      | 66 +++++++++++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/mce.h | 72 ++---------------------------------------
 2 files changed, 68 insertions(+), 70 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index ecdfee60ee4a..ea85a4107307 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -3,6 +3,72 @@
 
 #include <uapi/asm/mce.h>
 
+/*
+ * Machine Check support for x86
+ */
+
+/* MCG_CAP register defines */
+#define MCG_BANKCNT_MASK	0xff         /* Number of Banks */
+#define MCG_CTL_P		(1ULL<<8)    /* MCG_CTL register available */
+#define MCG_EXT_P		(1ULL<<9)    /* Extended registers available */
+#define MCG_CMCI_P		(1ULL<<10)   /* CMCI supported */
+#define MCG_EXT_CNT_MASK	0xff0000     /* Number of Extended registers */
+#define MCG_EXT_CNT_SHIFT	16
+#define MCG_EXT_CNT(c)		(((c) & MCG_EXT_CNT_MASK) >> MCG_EXT_CNT_SHIFT)
+#define MCG_SER_P		(1ULL<<24)   /* MCA recovery/new status bits */
+
+/* MCG_STATUS register defines */
+#define MCG_STATUS_RIPV  (1ULL<<0)   /* restart ip valid */
+#define MCG_STATUS_EIPV  (1ULL<<1)   /* ip points to correct instruction */
+#define MCG_STATUS_MCIP  (1ULL<<2)   /* machine check in progress */
+
+/* MCi_STATUS register defines */
+#define MCI_STATUS_VAL   (1ULL<<63)  /* valid error */
+#define MCI_STATUS_OVER  (1ULL<<62)  /* previous errors lost */
+#define MCI_STATUS_UC    (1ULL<<61)  /* uncorrected error */
+#define MCI_STATUS_EN    (1ULL<<60)  /* error enabled */
+#define MCI_STATUS_MISCV (1ULL<<59)  /* misc error reg. valid */
+#define MCI_STATUS_ADDRV (1ULL<<58)  /* addr reg. valid */
+#define MCI_STATUS_PCC   (1ULL<<57)  /* processor context corrupt */
+#define MCI_STATUS_S	 (1ULL<<56)  /* Signaled machine check */
+#define MCI_STATUS_AR	 (1ULL<<55)  /* Action required */
+#define MCACOD		  0xffff     /* MCA Error Code */
+
+/* Architecturally defined codes from SDM Vol. 3B Chapter 15 */
+#define MCACOD_SCRUB	0x00C0	/* 0xC0-0xCF Memory Scrubbing */
+#define MCACOD_SCRUBMSK	0xfff0
+#define MCACOD_L3WB	0x017A	/* L3 Explicit Writeback */
+#define MCACOD_DATA	0x0134	/* Data Load */
+#define MCACOD_INSTR	0x0150	/* Instruction Fetch */
+
+/* MCi_MISC register defines */
+#define MCI_MISC_ADDR_LSB(m)	((m) & 0x3f)
+#define MCI_MISC_ADDR_MODE(m)	(((m) >> 6) & 7)
+#define  MCI_MISC_ADDR_SEGOFF	0	/* segment offset */
+#define  MCI_MISC_ADDR_LINEAR	1	/* linear address */
+#define  MCI_MISC_ADDR_PHYS	2	/* physical address */
+#define  MCI_MISC_ADDR_MEM	3	/* memory address */
+#define  MCI_MISC_ADDR_GENERIC	7	/* generic */
+
+/* CTL2 register defines */
+#define MCI_CTL2_CMCI_EN		(1ULL << 30)
+#define MCI_CTL2_CMCI_THRESHOLD_MASK	0x7fffULL
+
+#define MCJ_CTX_MASK		3
+#define MCJ_CTX(flags)		((flags) & MCJ_CTX_MASK)
+#define MCJ_CTX_RANDOM		0    /* inject context: random */
+#define MCJ_CTX_PROCESS		0x1  /* inject context: process */
+#define MCJ_CTX_IRQ		0x2  /* inject context: IRQ */
+#define MCJ_NMI_BROADCAST	0x4  /* do NMI broadcasting */
+#define MCJ_EXCEPTION		0x8  /* raise as exception */
+#define MCJ_IRQ_BRAODCAST	0x10 /* do IRQ broadcasting */
+
+#define MCE_OVERFLOW 0		/* bit 0 in flags means overflow */
+
+/* Software defined banks */
+#define MCE_EXTENDED_BANK	128
+#define MCE_THERMAL_BANK	(MCE_EXTENDED_BANK + 0)
+#define K8_MCE_THRESHOLD_BASE   (MCE_EXTENDED_BANK + 1)
 
 struct mca_config {
 	bool dont_log_ce;
diff --git a/arch/x86/include/uapi/asm/mce.h b/arch/x86/include/uapi/asm/mce.h
index 58c829871c31..803785c7b21c 100644
--- a/arch/x86/include/uapi/asm/mce.h
+++ b/arch/x86/include/uapi/asm/mce.h
@@ -4,66 +4,6 @@
 #include <linux/types.h>
 #include <asm/ioctls.h>
 
-/*
- * Machine Check support for x86
- */
-
-/* MCG_CAP register defines */
-#define MCG_BANKCNT_MASK	0xff         /* Number of Banks */
-#define MCG_CTL_P		(1ULL<<8)    /* MCG_CTL register available */
-#define MCG_EXT_P		(1ULL<<9)    /* Extended registers available */
-#define MCG_CMCI_P		(1ULL<<10)   /* CMCI supported */
-#define MCG_EXT_CNT_MASK	0xff0000     /* Number of Extended registers */
-#define MCG_EXT_CNT_SHIFT	16
-#define MCG_EXT_CNT(c)		(((c) & MCG_EXT_CNT_MASK) >> MCG_EXT_CNT_SHIFT)
-#define MCG_SER_P	 	(1ULL<<24)   /* MCA recovery/new status bits */
-
-/* MCG_STATUS register defines */
-#define MCG_STATUS_RIPV  (1ULL<<0)   /* restart ip valid */
-#define MCG_STATUS_EIPV  (1ULL<<1)   /* ip points to correct instruction */
-#define MCG_STATUS_MCIP  (1ULL<<2)   /* machine check in progress */
-
-/* MCi_STATUS register defines */
-#define MCI_STATUS_VAL   (1ULL<<63)  /* valid error */
-#define MCI_STATUS_OVER  (1ULL<<62)  /* previous errors lost */
-#define MCI_STATUS_UC    (1ULL<<61)  /* uncorrected error */
-#define MCI_STATUS_EN    (1ULL<<60)  /* error enabled */
-#define MCI_STATUS_MISCV (1ULL<<59)  /* misc error reg. valid */
-#define MCI_STATUS_ADDRV (1ULL<<58)  /* addr reg. valid */
-#define MCI_STATUS_PCC   (1ULL<<57)  /* processor context corrupt */
-#define MCI_STATUS_S	 (1ULL<<56)  /* Signaled machine check */
-#define MCI_STATUS_AR	 (1ULL<<55)  /* Action required */
-#define MCACOD		  0xffff     /* MCA Error Code */
-
-/* Architecturally defined codes from SDM Vol. 3B Chapter 15 */
-#define MCACOD_SCRUB	0x00C0	/* 0xC0-0xCF Memory Scrubbing */
-#define MCACOD_SCRUBMSK	0xfff0
-#define MCACOD_L3WB	0x017A	/* L3 Explicit Writeback */
-#define MCACOD_DATA	0x0134	/* Data Load */
-#define MCACOD_INSTR	0x0150	/* Instruction Fetch */
-
-/* MCi_MISC register defines */
-#define MCI_MISC_ADDR_LSB(m)	((m) & 0x3f)
-#define MCI_MISC_ADDR_MODE(m)	(((m) >> 6) & 7)
-#define  MCI_MISC_ADDR_SEGOFF	0	/* segment offset */
-#define  MCI_MISC_ADDR_LINEAR	1	/* linear address */
-#define  MCI_MISC_ADDR_PHYS	2	/* physical address */
-#define  MCI_MISC_ADDR_MEM	3	/* memory address */
-#define  MCI_MISC_ADDR_GENERIC	7	/* generic */
-
-/* CTL2 register defines */
-#define MCI_CTL2_CMCI_EN		(1ULL << 30)
-#define MCI_CTL2_CMCI_THRESHOLD_MASK	0x7fffULL
-
-#define MCJ_CTX_MASK		3
-#define MCJ_CTX(flags)		((flags) & MCJ_CTX_MASK)
-#define MCJ_CTX_RANDOM		0    /* inject context: random */
-#define MCJ_CTX_PROCESS		0x1  /* inject context: process */
-#define MCJ_CTX_IRQ		0x2  /* inject context: IRQ */
-#define MCJ_NMI_BROADCAST	0x4  /* do NMI broadcasting */
-#define MCJ_EXCEPTION		0x8  /* raise as exception */
-#define MCJ_IRQ_BRAODCAST	0x10 /* do IRQ broadcasting */
-
 /* Fields are zero when not available */
 struct mce {
 	__u64 status;
@@ -87,15 +27,14 @@ struct mce {
 	__u64 mcgcap;	/* MCGCAP MSR: machine check capabilities of CPU */
 };
 
+#define MCE_LOG_LEN 32
+
 /*
  * This structure contains all data related to the MCE log.  Also
  * carries a signature to make it easier to find from external
  * debugging tools.  Each entry is only valid when its finished flag
  * is set.
  */
-
-#define MCE_LOG_LEN 32
-
 struct mce_log {
 	char signature[12]; /* "MACHINECHECK" */
 	unsigned len;	    /* = MCE_LOG_LEN */
@@ -105,17 +44,10 @@ struct mce_log {
 	struct mce entry[MCE_LOG_LEN];
 };
 
-#define MCE_OVERFLOW 0		/* bit 0 in flags means overflow */
-
 #define MCE_LOG_SIGNATURE	"MACHINECHECK"
 
 #define MCE_GET_RECORD_LEN   _IOR('M', 1, int)
 #define MCE_GET_LOG_LEN      _IOR('M', 2, int)
 #define MCE_GETCLEAR_FLAGS   _IOR('M', 3, int)
 
-/* Software defined banks */
-#define MCE_EXTENDED_BANK	128
-#define MCE_THERMAL_BANK	MCE_EXTENDED_BANK + 0
-#define K8_MCE_THRESHOLD_BASE      (MCE_EXTENDED_BANK + 1)
-
 #endif /* _UAPI_ASM_X86_MCE_H */
-- 
1.8.1.rc2


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
