Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761891Ab2FELYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:24:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab2FELYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:24:19 -0400
Date: Tue, 5 Jun 2012 13:24:13 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 5/8] x86: apic: Try to spread IRQ vectors to different
 priority levels
Message-ID: <20120605112408.GA11466@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When assigning a new vector it is primarially done by adding 8 to the
previously given out vector number. Hence, two consequently allocated
vector numbers would likely fall into the same priority level. Try to
spread vector numbers to different priority levels better by changing
the step from 8 to 16.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/apic/io_apic.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1afedef..f043d6a 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1163,7 +1163,7 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
 	static int current_vector = FIRST_EXTERNAL_VECTOR + VECTOR_OFFSET_START;
-	static int current_offset = VECTOR_OFFSET_START % 8;
+	static int current_offset = VECTOR_OFFSET_START % 16;
 	unsigned int old_vector;
 	int cpu, err;
 	cpumask_var_t tmp_mask;
@@ -1195,10 +1195,9 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 		vector = current_vector;
 		offset = current_offset;
 next:
-		vector += 8;
+		vector += 16;
 		if (vector >= first_system_vector) {
-			/* If out of vectors on large boxen, must share them. */
-			offset = (offset + 1) % 8;
+			offset = (offset + 1) % 16;
 			vector = FIRST_EXTERNAL_VECTOR + offset;
 		}
 		if (unlikely(current_vector == vector))
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
