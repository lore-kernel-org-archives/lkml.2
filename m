Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab0JTFCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 01:02:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:37198 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab0JTFCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 01:02:07 -0400
Date: Wed, 20 Oct 2010 05:01:30 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1286360874-1471-2-git-send-email-robert.richter@amd.com>
References: <1286360874-1471-2-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] apic, x86: Check if EILVT APIC registers are available (AMD only)
Message-ID: <tip-a68c439b1966c91f0ef474e2bf275d6792312726@git.kernel.org>
Git-Commit-ID: a68c439b1966c91f0ef474e2bf275d6792312726
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Oct 2010 05:01:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a68c439b1966c91f0ef474e2bf275d6792312726
Gitweb:     http://git.kernel.org/tip/a68c439b1966c91f0ef474e2bf275d6792312726
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 6 Oct 2010 12:27:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 20 Oct 2010 04:42:13 +0200

apic, x86: Check if EILVT APIC registers are available (AMD only)

This patch implements checks for the availability of LVT entries
(APIC500-530) and reserves it if used. The check becomes
necessary since we want to let the BIOS provide the LVT offsets.
 The offsets should be determined by the subsystems using it
like those for MCE threshold or IBS.  On K8 only offset 0
(APIC500) and MCE interrupts are supported. Beginning with
family 10h at least 4 offsets are available.

Since offsets must be consistent for all cores, we keep track of
the LVT offsets in software and reserve the offset for the same
vector also to be used on other cores. An offset is freed by
setting the entry to APIC_EILVT_MASKED.

If the BIOS is right, there should be no conflicts. Otherwise a
"[Firmware Bug]: ..." error message is generated. However, if
software does not properly determines the offsets, it is not
necessarily a BIOS bug.

Signed-off-by: Robert Richter <robert.richter@amd.com>
LKML-Reference: <1286360874-1471-2-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apicdef.h |    1 +
 arch/x86/kernel/apic/apic.c    |   83 +++++++++++++++++++++++++++++++++++----
 2 files changed, 75 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 7fe3b30..a859ca4 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -131,6 +131,7 @@
 #define APIC_EILVTn(n)	(0x500 + 0x10 * n)
 #define		APIC_EILVT_NR_AMD_K8	1	/* # of extended interrupts */
 #define		APIC_EILVT_NR_AMD_10H	4
+#define		APIC_EILVT_NR_MAX	APIC_EILVT_NR_AMD_10H
 #define		APIC_EILVT_LVTOFF(x)	(((x) >> 4) & 0xF)
 #define		APIC_EILVT_MSG_FIX	0x0
 #define		APIC_EILVT_MSG_SMI	0x2
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 8cf86fb..2bfeafd 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -52,6 +52,7 @@
 #include <asm/mce.h>
 #include <asm/kvm_para.h>
 #include <asm/tsc.h>
+#include <asm/atomic.h>
 
 unsigned int num_processors;
 
@@ -370,24 +371,88 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 }
 
 /*
- * Setup extended LVT, AMD specific (K8, family 10h)
+ * Setup extended LVT, AMD specific
  *
- * Vector mappings are hard coded. On K8 only offset 0 (APIC500) and
- * MCE interrupts are supported. Thus MCE offset must be set to 0.
+ * Software should use the LVT offsets the BIOS provides.  The offsets
+ * are determined by the subsystems using it like those for MCE
+ * threshold or IBS.  On K8 only offset 0 (APIC500) and MCE interrupts
+ * are supported. Beginning with family 10h at least 4 offsets are
+ * available.
  *
- * If mask=1, the LVT entry does not generate interrupts while mask=0
- * enables the vector. See also the BKDGs.
+ * Since the offsets must be consistent for all cores, we keep track
+ * of the LVT offsets in software and reserve the offset for the same
+ * vector also to be used on other cores. An offset is freed by
+ * setting the entry to APIC_EILVT_MASKED.
+ *
+ * If the BIOS is right, there should be no conflicts. Otherwise a
+ * "[Firmware Bug]: ..." error message is generated. However, if
+ * software does not properly determines the offsets, it is not
+ * necessarily a BIOS bug.
  */
 
 #define APIC_EILVT_LVTOFF_MCE 0
 #define APIC_EILVT_LVTOFF_IBS 1
 
-static void setup_APIC_eilvt(u8 lvt_off, u8 vector, u8 msg_type, u8 mask)
+static atomic_t eilvt_offsets[APIC_EILVT_NR_MAX];
+
+static inline int eilvt_entry_is_changeable(unsigned int old, unsigned int new)
+{
+	return (old & APIC_EILVT_MASKED)
+		|| (new == APIC_EILVT_MASKED)
+		|| ((new & ~APIC_EILVT_MASKED) == old);
+}
+
+static unsigned int reserve_eilvt_offset(int offset, unsigned int new)
+{
+	unsigned int rsvd;			/* 0: uninitialized */
+
+	if (offset >= APIC_EILVT_NR_MAX)
+		return ~0;
+
+	rsvd = atomic_read(&eilvt_offsets[offset]) & ~APIC_EILVT_MASKED;
+	do {
+		if (rsvd &&
+		    !eilvt_entry_is_changeable(rsvd, new))
+			/* may not change if vectors are different */
+			return rsvd;
+		rsvd = atomic_cmpxchg(&eilvt_offsets[offset], rsvd, new);
+	} while (rsvd != new);
+
+	return new;
+}
+
+/*
+ * If mask=1, the LVT entry does not generate interrupts while mask=0
+ * enables the vector. See also the BKDGs.
+ */
+
+static int setup_APIC_eilvt(u8 offset, u8 vector, u8 msg_type, u8 mask)
 {
-	unsigned long reg = (lvt_off << 4) + APIC_EILVTn(0);
-	unsigned int  v   = (mask << 16) | (msg_type << 8) | vector;
+	unsigned long reg = APIC_EILVTn(offset);
+	unsigned int new, old, reserved;
+
+	new = (mask << 16) | (msg_type << 8) | vector;
+	old = apic_read(reg);
+	reserved = reserve_eilvt_offset(offset, new);
 
-	apic_write(reg, v);
+	if (reserved != new) {
+		pr_err(FW_BUG "cpu %d, try to setup vector 0x%x, but "
+		       "vector 0x%x was already reserved by another core, "
+		       "APIC%lX=0x%x\n",
+		       smp_processor_id(), new, reserved, reg, old);
+		return -EINVAL;
+	}
+
+	if (!eilvt_entry_is_changeable(old, new)) {
+		pr_err(FW_BUG "cpu %d, try to setup vector 0x%x but "
+		       "register already in use, APIC%lX=0x%x\n",
+		       smp_processor_id(), new, reg, old);
+		return -EBUSY;
+	}
+
+	apic_write(reg, new);
+
+	return 0;
 }
 
 u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask)
