Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab0LYTH1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 14:07:27 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15060 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab0LYTH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 14:07:26 -0500
Date: Sat, 25 Dec 2010 19:57:41 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Shaohua Li <shaohua.li@intel.com>,
        Tigran Aivazian <tigran@veritas.com>
Subject: [PATCH] Intel CPU Microcode Update Driver: Fix double vfree() and
 remove redundant pointer checks before vfree()
Message-ID: <alpine.LNX.2.00.1012251946100.10759@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In arch/x86/kernel/microcode_intel.c::generic_load_microcode() we have 
this:

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

This will cause a double free of 'mc'. This patch fixes that by just 
removing the vfree() call in the loop since 'mc' will be freed nicely just 
after we break out of the loop.

There's also a second change in the patch. I noticed a lot of checks for 
pointers being NULL before passing them to vfree(). That's completely 
redundant since vfree() deals gracefully with being passed a NULL pointer. 
Removing the redundant checks yields a nice size decrease for the object 
file.

Size before the patch:
   text    data     bss     dec     hex filename
   4578     240    1032    5850    16da arch/x86/kernel/microcode_intel.o
Size after the patch:
   text    data     bss     dec     hex filename
   4489     240     984    5713    1651 arch/x86/kernel/microcode_intel.o


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 microcode_intel.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index dcb65cc..1a1b606 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -364,8 +364,7 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 
 		/* For performance reasons, reuse mc area when possible */
 		if (!mc || mc_size > curr_mc_size) {
-			if (mc)
-				vfree(mc);
+			vfree(mc);
 			mc = vmalloc(mc_size);
 			if (!mc)
 				break;
@@ -374,13 +373,11 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 
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
@@ -390,12 +387,10 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
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
@@ -405,8 +400,7 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 		goto out;
 	}
 
-	if (uci->mc)
-		vfree(uci->mc);
+	vfree(uci->mc);
 	uci->mc = (struct microcode_intel *)new_mc;
 
 	pr_debug("CPU%d found a matching microcode update with version 0x%x (current=0x%x)\n",



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

