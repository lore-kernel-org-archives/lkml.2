Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab2HTN4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:56:15 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:1145
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820Ab2HTN4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:56:12 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah11b5h)
X-WSS-ID: 0M9241L-01-3DC-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/19] [RFC] x86, apic: Mask IO-APIC and PIC unconditionally on LAPIC resume
Date: Mon, 20 Aug 2012 15:55:48 +0200
Message-ID: <1345470965-24410-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
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


