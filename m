Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab0L1W1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 17:27:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37993 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab0L1W1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 17:27:30 -0500
Date: Tue, 28 Dec 2010 23:27:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fix
Message-ID: <20101228222718.GA27822@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Jesper Juhl (1):
      x86/microcode: Fix double vfree() and remove redundant pointer checks before vfree()


 arch/x86/kernel/microcode_intel.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

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
