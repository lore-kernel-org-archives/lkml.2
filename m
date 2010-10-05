Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab0JELB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 07:01:59 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:14902
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751832Ab0JELB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 07:01:58 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zzzz1202hzz8275bh8275dh15d4Rz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9TDA6-01-00X-02
X-M-MSG: 
Date: Tue, 5 Oct 2010 13:03:12 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
CC: x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] AMD, MCE thresholding: Fix the MCi_MISCj iteration order
Message-ID: <20101005110312.GA20693@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code contains a subtle problem of checking only the Valid
bit of MSR0000_0413 (which is MC4_MISC0) in its first iteration and
breaking out if the bit is cleared.

However, MC4_MISC0[BlkPtr] is not predicated on MCi_STATUS[MiscV] or
MC4_MISC0[Valid] and should be checked prior to iterating over the
MCI_MISCj thresholding group only.

Fix this by decoupling the Valid bit check, which is part of the DRAM
thresholding group on F10h in the first iteration of the loop, from the
BlkPtr check.

Cc: <stable@kernel.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 5e97529..39aaee5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -141,6 +141,7 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 				address = (low & MASK_BLKPTR_LO) >> 21;
 				if (!address)
 					break;
+
 				address += MCG_XBLK_ADDR;
 			} else
 				++address;
@@ -148,12 +149,8 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 			if (rdmsr_safe(address, &low, &high))
 				break;
 
-			if (!(high & MASK_VALID_HI)) {
-				if (block)
-					continue;
-				else
-					break;
-			}
+			if (!(high & MASK_VALID_HI))
+				continue;
 
 			if (!(high & MASK_CNTP_HI)  ||
 			     (high & MASK_LOCKED_HI))
-- 
1.7.3.1.50.g1e633


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

