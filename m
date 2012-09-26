Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab2IZKrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 06:47:12 -0400
Received: from [216.32.180.12] ([216.32.180.12]:20621 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754467Ab2IZKqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 06:46:31 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MAYDUU-02-548-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/19] x86, apic: Mask IO-APIC and PIC unconditionally on LAPIC resume
Date: Wed, 26 Sep 2012 12:44:34 +0200
Message-ID: <1348656291-10375-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
References: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IO-APIC and PIC use the same resume routines when IRQ
remapping is enabled or disabled. So it should be safe to
mask the other APICs for the IRQ-remapping-disabled case
too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/apic/apic.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 41681b3..109380a 100644
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


