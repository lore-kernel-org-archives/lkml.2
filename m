Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab2C0Taw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 15:30:52 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:32138
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754300Ab2C0Tau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 15:30:50 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1K673-02-3XA-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH] x86, amd: Be more verbose about LVT offset assignments
Date: Tue, 27 Mar 2012 21:30:15 +0200
Message-ID: <1332876615-29219-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add information about LVT offset assignments to better debug firmware
bug messages related to this.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/apic/apic.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 2eec05b..11544d8 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -383,20 +383,25 @@ static inline int eilvt_entry_is_changeable(unsigned int old, unsigned int new)
 
 static unsigned int reserve_eilvt_offset(int offset, unsigned int new)
 {
-	unsigned int rsvd;			/* 0: uninitialized */
+	unsigned int rsvd, vector;
 
 	if (offset >= APIC_EILVT_NR_MAX)
 		return ~0;
 
-	rsvd = atomic_read(&eilvt_offsets[offset]) & ~APIC_EILVT_MASKED;
+	rsvd = atomic_read(&eilvt_offsets[offset]);
 	do {
-		if (rsvd &&
-		    !eilvt_entry_is_changeable(rsvd, new))
+		vector = rsvd & ~APIC_EILVT_MASKED;	/* 0: unassigned */
+		if (vector && !eilvt_entry_is_changeable(vector, new))
 			/* may not change if vectors are different */
 			return rsvd;
 		rsvd = atomic_cmpxchg(&eilvt_offsets[offset], rsvd, new);
 	} while (rsvd != new);
 
+	rsvd &= ~APIC_EILVT_MASKED;
+	if (rsvd && rsvd != vector)
+		pr_info("LVT offset %d assigned for vector 0x%02x\n",
+			offset, rsvd);
+
 	return new;
 }
 
-- 
1.7.8.4


