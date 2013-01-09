Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab3AIOFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:05:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33637 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863Ab3AIOFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:05:31 -0500
Date: Wed, 9 Jan 2013 15:05:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>, lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] RAS UAPI fix for 3.8
Message-ID: <20130109140527.GC5980@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Tony Luck <tony.luck@intel.com>,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

the patch below retracts a bunch of defines and structs which went into
the uapi/mce.h header needlessly. See commit message below for more
details.

The thing is, this patch needs to go in 3.8 so that the changes the UAPI
merge added to mce.h can be reverted and thus 3.8 can be released with
proper header exports.

So please pull,
thanks.

--
The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:

  Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/ras_for_3.8

for you to fetch changes up to f51bde6f0d66ab6a80eb1a05b6fe8d90c4960486:

  x86, MCE: Retract most UAPI exports (2013-01-09 14:49:02 +0100)

----------------------------------------------------------------
Retract MCE-specific UAPI exports which are unused and shouldn't be
used.

----------------------------------------------------------------
Borislav Petkov (1):
      x86, MCE: Retract most UAPI exports

 arch/x86/include/asm/mce.h      | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/mce.h | 87 ---------------------------------------------------------------------------------------
 2 files changed, 84 insertions(+), 87 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index ecdfee60ee4a..f4076af1f4ed 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -3,6 +3,90 @@
 
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
+
+#define MCE_LOG_LEN 32
+#define MCE_LOG_SIGNATURE	"MACHINECHECK"
+
+/*
+ * This structure contains all data related to the MCE log.  Also
+ * carries a signature to make it easier to find from external
+ * debugging tools.  Each entry is only valid when its finished flag
+ * is set.
+ */
+struct mce_log {
+	char signature[12]; /* "MACHINECHECK" */
+	unsigned len;	    /* = MCE_LOG_LEN */
+	unsigned next;
+	unsigned flags;
+	unsigned recordlen;	/* length of struct mce */
+	struct mce entry[MCE_LOG_LEN];
+};
 
 struct mca_config {
 	bool dont_log_ce;
diff --git a/arch/x86/include/uapi/asm/mce.h b/arch/x86/include/uapi/asm/mce.h
index 58c829871c31..a0eab85ce7b8 100644
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
@@ -87,35 +27,8 @@ struct mce {
 	__u64 mcgcap;	/* MCGCAP MSR: machine check capabilities of CPU */
 };
 
-/*
- * This structure contains all data related to the MCE log.  Also
- * carries a signature to make it easier to find from external
- * debugging tools.  Each entry is only valid when its finished flag
- * is set.
- */
-
-#define MCE_LOG_LEN 32
-
-struct mce_log {
-	char signature[12]; /* "MACHINECHECK" */
-	unsigned len;	    /* = MCE_LOG_LEN */
-	unsigned next;
-	unsigned flags;
-	unsigned recordlen;	/* length of struct mce */
-	struct mce entry[MCE_LOG_LEN];
-};
-
-#define MCE_OVERFLOW 0		/* bit 0 in flags means overflow */
-
-#define MCE_LOG_SIGNATURE	"MACHINECHECK"
-
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
1.8.1.rc3



-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
