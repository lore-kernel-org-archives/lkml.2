Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1AFAb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:31:57 -0500
Received: from kroah.org ([198.145.64.141]:36145 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828Ab1AFAbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:55 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:10 2011
Message-Id: <20110106002310.372154284@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:24:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesper Juhl <jj@chaosbits.net>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [146/152] x86/microcode: Fix double vfree() and remove redundant pointer checks before vfree()
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
Cc: Shaohua Li <shaohua.li@intel.com>
LKML-Reference: <alpine.LNX.2.00.1012251946100.10759@swampdragon.chaosbits.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/microcode_intel.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
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


