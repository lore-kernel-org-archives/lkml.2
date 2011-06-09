Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab1FIVdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:33:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:46547 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab1FIVdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:33:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,343,1304319600"; 
   d="scan'208";a="10300030"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Borislav Petkov" <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
        "Avi Kivity" <avi@redhat.com>
In-Reply-To: <4df13a522720782e51@agluck-desktop.sc.intel.com>
Subject: [PATCH 05/10] MCE: Mask out address mask bits below address granuality
Date: Thu, 09 Jun 2011 14:33:42 -0700
Message-Id: <4df13c362729376e2@agluck-desktop.sc.intel.com>
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
index 0349e87..ffc8d11 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -539,8 +539,18 @@ static void mce_read_aux(struct mce *m, int i)
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

