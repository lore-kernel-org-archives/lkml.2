Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1ABHjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:39:23 -0500
Received: from mail.windriver.com ([147.11.1.11]:36726 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab1ABHYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:55 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
        Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 189/260] x86, AMD, MCE thresholding: Fix the MCi_MISCj iteration order
Date: Sun,  2 Jan 2011 02:18:05 -0500
Message-Id: <1293952756-15010-190-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:37.0854 (UTC) FILETIME=[F918B1E0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

commit 6dcbfe4f0b4e17e289d56fa534b7ce5a6b7f63a3 upstream.

This fixes possible cases of not collecting valid error info in
the MCE error thresholding groups on F10h hardware.

The current code contains a subtle problem of checking only the
Valid bit of MSR0000_0413 (which is MC4_MISC0 - DRAM
thresholding group) in its first iteration and breaking out if
the bit is cleared.

But (!), this MSR contains an offset value, BlkPtr[31:24], which
points to the remaining MSRs in this thresholding group which
might contain valid information too. But if we bail out only
after we checked the valid bit in the first MSR and not the
block pointer too, we miss that other information.

The thing is, MC4_MISC0[BlkPtr] is not predicated on
MCi_STATUS[MiscV] or MC4_MISC0[Valid] and should be checked
prior to iterating over the MCI_MISCj thresholding group,
irrespective of the MC4_MISC0[Valid] setting.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 224392d..f80ff85 100644
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
1.7.3.3

