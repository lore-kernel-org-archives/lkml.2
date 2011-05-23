Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030214Ab1EWWN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:13:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:3705 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab1EWWN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:13:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,258,1304319600"; 
   d="scan'208";a="7369439"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Ingo Molnar" <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        "Andi Kleen" <andi@firstfloor.org>, "Borislav Petkov" <bp@alien8.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
Subject: [RFC 5/9] MCE: Mask out address mask bits below address granuality
Date: Mon, 23 May 2011 15:13:58 -0700
Message-Id: <4ddadc261716628e0@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

SER enabled systems report the address granuality for each
reported address in a machine check. But the bits below
the granuality are undefined. Mask them out before
logging the machine check.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index f4924dc..a9a0e25 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -532,8 +532,18 @@ static void mce_read_aux(struct mce *m, int i)
 {
 	if (m->status & MCI_STATUS_MISCV)
 		m->misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
-	if (m->status & MCI_STATUS_ADDRV)
+	if (m->status & MCI_STATUS_ADDRV) {
 		m->addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
+
+		/*
+		 * Mask the reported address by the reported granuality.
+		 */
+		if (mce_ser && (m->status & MCI_STATUS_MISCV)) {
+			u8 shift = m->misc & 0x1f;
+			m->addr >>= shift;
+			m->addr <<= shift;
+		}
+	}
 }
 
 DEFINE_PER_CPU(unsigned, mce_poll_count);
-- 
1.7.3.1

