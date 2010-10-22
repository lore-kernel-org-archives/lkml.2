Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab0JVSue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:50:34 -0400
Received: from kroah.org ([198.145.64.141]:45734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757154Ab0JVSii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:38 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:35:59 2010
Message-Id: <20101022183559.080271578@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:34:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>
Subject: [32/66] x86, AMD, MCE thresholding: Fix the MCi_MISCj iteration order
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -140,6 +140,7 @@ void mce_amd_feature_init(struct cpuinfo
 				address = (low & MASK_BLKPTR_LO) >> 21;
 				if (!address)
 					break;
+
 				address += MCG_XBLK_ADDR;
 			} else
 				++address;
@@ -147,12 +148,8 @@ void mce_amd_feature_init(struct cpuinfo
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


