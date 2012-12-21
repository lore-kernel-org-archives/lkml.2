Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334Ab2LUOro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 09:47:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:41824 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab2LUOrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 09:47:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,329,1355126400"; 
   d="scan'208";a="235197553"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Yinghai Lu" <yinghai@kernel.org>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v5 07/12] x86/tlbflush.h: Define __native_flush_tlb_global_irq_disabled()
Date: Thu, 20 Dec 2012 23:44:27 -0800
Message-Id: <1356075872-3054-8-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com>
References: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

This function is called in __native_flush_tlb_global() and after
apply_microcode_early().

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/tlbflush.h | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 0fee48e..50a7fc0 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -20,10 +20,20 @@ static inline void __native_flush_tlb(void)
 	native_write_cr3(native_read_cr3());
 }
 
+static inline void __native_flush_tlb_global_irq_disabled(void)
+{
+	unsigned long cr4;
+
+	cr4 = native_read_cr4();
+	/* clear PGE */
+	native_write_cr4(cr4 & ~X86_CR4_PGE);
+	/* write old PGE again and flush TLBs */
+	native_write_cr4(cr4);
+}
+
 static inline void __native_flush_tlb_global(void)
 {
 	unsigned long flags;
-	unsigned long cr4;
 
 	/*
 	 * Read-modify-write to CR4 - protect it from preemption and
@@ -32,11 +42,7 @@ static inline void __native_flush_tlb_global(void)
 	 */
 	raw_local_irq_save(flags);
 
-	cr4 = native_read_cr4();
-	/* clear PGE */
-	native_write_cr4(cr4 & ~X86_CR4_PGE);
-	/* write old PGE again and flush TLBs */
-	native_write_cr4(cr4);
+	__native_flush_tlb_global_irq_disabled();
 
 	raw_local_irq_restore(flags);
 }
-- 
1.8.0.1

