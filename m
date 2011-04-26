Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab1DZVif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:38:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:9586 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758483Ab1DZVNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="738831574"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: suresh.b.siddha@intel.com, ak@linux.intel.com, eric@anholt.net,
        keithp@keithp.com, hpa@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [16/106] x86, mtrr, pat: Fix one cpu getting out of sync during resume
Message-Id: <20110426211254.939123E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:12:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Suresh Siddha <suresh.b.siddha@intel.com>

commit 84ac7cdbdd0f04df6b96153f7a79127fd6e45467 upstream.

On laptops with core i5/i7, there were reports that after resume
graphics workloads were performing poorly on a specific AP, while
the other cpu's were ok. This was observed on a 32bit kernel
specifically.

Debug showed that the PAT init was not happening on that AP
during resume and hence it contributing to the poor workload
performance on that cpu.

On this system, resume flow looked like this:

1. BP starts the resume sequence and we reinit BP's MTRR's/PAT
   early on using mtrr_bp_restore()

2. Resume sequence brings all AP's online

3. Resume sequence now kicks off the MTRR reinit on all the AP's.

4. For some reason, between point 2 and 3, we moved from BP
   to one of the AP's. My guess is that printk() during resume
   sequence is contributing to this. We don't see similar
   behavior with the 64bit kernel but there is no guarantee that
   at this point the remaining resume sequence (after AP's bringup)
   has to happen on BP.

5. set_mtrr() was assuming that we are still on BP and skipped the
   MTRR/PAT init on that cpu (because of 1 above)

6. But we were on an AP and this led to not reprogramming PAT
   on this cpu leading to bad performance.

Fix this by doing unconditional mtrr_if->set_all() in set_mtrr()
during MTRR/PAT init. This might be unnecessary if we are still
running on BP. But it is of no harm and will guarantee that after
resume, all the cpu's will be in sync with respect to the
MTRR/PAT registers.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1301438292-28370-1-git-send-email-eric@anholt.net>
Signed-off-by: Eric Anholt <eric@anholt.net>
Tested-by: Keith Packard <keithp@keithp.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/mtrr/main.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

Index: linux-2.6.35.y/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6.35.y/arch/x86/kernel/cpu/mtrr/main.c
@@ -292,14 +292,24 @@ set_mtrr(unsigned int reg, unsigned long
 
 	/*
 	 * HACK!
-	 * We use this same function to initialize the mtrrs on boot.
-	 * The state of the boot cpu's mtrrs has been saved, and we want
-	 * to replicate across all the APs.
-	 * If we're doing that @reg is set to something special...
+	 *
+	 * We use this same function to initialize the mtrrs during boot,
+	 * resume, runtime cpu online and on an explicit request to set a
+	 * specific MTRR.
+	 *
+	 * During boot or suspend, the state of the boot cpu's mtrrs has been
+	 * saved, and we want to replicate that across all the cpus that come
+	 * online (either at the end of boot or resume or during a runtime cpu
+	 * online). If we're doing that, @reg is set to something special and on
+	 * this cpu we still do mtrr_if->set_all(). During boot/resume, this
+	 * is unnecessary if at this point we are still on the cpu that started
+	 * the boot/resume sequence. But there is no guarantee that we are still
+	 * on the same cpu. So we do mtrr_if->set_all() on this cpu aswell to be
+	 * sure that we are in sync with everyone else.
 	 */
 	if (reg != ~0U)
 		mtrr_if->set(reg, base, size, type);
-	else if (!mtrr_aps_delayed_init)
+	else
 		mtrr_if->set_all();
 
 	/* Wait for the others */
