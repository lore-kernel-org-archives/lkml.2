Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab2KTNNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:13:16 -0500
Received: from 8bytes.org ([85.214.48.195]:58215 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab2KTNNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:13:05 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 02/19] x86, apic: Mask IO-APIC and PIC unconditionally on LAPIC resume
Date: Tue, 20 Nov 2012 14:12:39 +0100
Message-Id: <1353417176-18945-3-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353417176-18945-1-git-send-email-joro@8bytes.org>
References: <1353417176-18945-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Nov 20 14:13:04 2012
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50ab81e022971810917846
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IO-APIC and PIC use the same resume routines when IRQ
remapping is enabled or disabled. So it should be safe to
mask the other APICs for the IRQ-remapping-disabled case
too.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
Acked-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/kernel/apic/apic.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 69cba83..31b5afd 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2233,16 +2233,15 @@ static void lapic_resume(void)
 		return;
 
 	local_irq_save(flags);
-	if (irq_remapping_enabled) {
-		/*
-		 * IO-APIC and PIC have their own resume routines.
-		 * We just mask them here to make sure the interrupt
-		 * subsystem is completely quiet while we enable x2apic
-		 * and interrupt-remapping.
-		 */
-		mask_ioapic_entries();
-		legacy_pic->mask_all();
-	}
+
+	/*
+	 * IO-APIC and PIC have their own resume routines.
+	 * We just mask them here to make sure the interrupt
+	 * subsystem is completely quiet while we enable x2apic
+	 * and interrupt-remapping.
+	 */
+	mask_ioapic_entries();
+	legacy_pic->mask_all();
 
 	if (x2apic_mode)
 		enable_x2apic();
-- 
1.7.9.5


