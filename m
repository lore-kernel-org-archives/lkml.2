Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1BBAri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:47:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:58271 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965Ab1BBApV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883418474"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: jj@chaosbits.net, tigran@aivazian.fsnet.co.uk, ak@linux.intel.com,
        shaohua.li@intel.com, mingo@elte.hu, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [132/139] x86/microcode: Fix double vfree() and remove redundant pointer checks before vfree()
Message-Id: <20110202004531.DCDC73E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jesper Juhl <jj@chaosbits.net>

commit 5cdd2de0a76d0ac47f107c8a7b32d75d25768dc1 upstream.

In arch/x86/kernel/microcode_intel.c::generic_load_microcode()
we have  this:

	while (leftover) {
		...
		if (get_ucode_data(mc, ucode_ptr, mc_size) ||
		    microcode_sanity_check(mc) < 0) {
			vfree(mc);
			break;
		}
		...
	}

	if (mc)
		vfree(mc);

This will cause a double free of 'mc'. This patch fixes that by
just  removing the vfree() call in the loop since 'mc' will be
freed nicely just  after we break out of the loop.

There's also a second change in the patch. I noticed a lot of
checks for  pointers being NULL before passing them to vfree().
That's completely  redundant since vfree() deals gracefully with
being passed a NULL pointer.  Removing the redundant checks
yields a nice size decrease for the object  file.

Size before the patch:
   text    data     bss     dec     hex filename
   4578     240    1032    5850    16da arch/x86/kernel/microcode_intel.o
Size after the patch:
   text    data     bss     dec     hex filename
   4489     240     984    5713    1651 arch/x86/kernel/microcode_intel.o

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Acked-by: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Shaohua Li <shaohua.li@intel.com>
LKML-Reference: <alpine.LNX.2.00.1012251946100.10759@swampdragon.chaosbits.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/microcode_intel.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

Index: linux-2.6.35.y/arch/x86/kernel/microcode_intel.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/microcode_intel.c
+++ linux-2.6.35.y/arch/x86/kernel/microcode_intel.c
@@ -364,8 +364,7 @@ static enum ucode_state generic_load_mic
 
 		/* For performance reasons, reuse mc area when possible */
 		if (!mc || mc_size > curr_mc_size) {
-			if (mc)
-				vfree(mc);
+			vfree(mc);
 			mc = vmalloc(mc_size);
 			if (!mc)
 				break;
@@ -374,13 +373,11 @@ static enum ucode_state generic_load_mic
 
 		if (get_ucode_data(mc, ucode_ptr, mc_size) ||
 		    microcode_sanity_check(mc) < 0) {
-			vfree(mc);
 			break;
 		}
 
 		if (get_matching_microcode(&uci->cpu_sig, mc, new_rev)) {
-			if (new_mc)
-				vfree(new_mc);
+			vfree(new_mc);
 			new_rev = mc_header.rev;
 			new_mc  = mc;
 			mc = NULL;	/* trigger new vmalloc */
@@ -390,12 +387,10 @@ static enum ucode_state generic_load_mic
 		leftover  -= mc_size;
 	}
 
-	if (mc)
-		vfree(mc);
+	vfree(mc);
 
 	if (leftover) {
-		if (new_mc)
-			vfree(new_mc);
+		vfree(new_mc);
 		state = UCODE_ERROR;
 		goto out;
 	}
@@ -405,8 +400,7 @@ static enum ucode_state generic_load_mic
 		goto out;
 	}
 
-	if (uci->mc)
-		vfree(uci->mc);
+	vfree(uci->mc);
 	uci->mc = (struct microcode_intel *)new_mc;
 
 	pr_debug("CPU%d found a matching microcode update with version 0x%x (current=0x%x)\n",
