Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab1C2Wib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:38:31 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:40034 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab1C2Wi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:38:29 -0400
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Eric Anholt <eric@anholt.net>
Subject: [PATCH resend] x86, mtrr, pat: fix one cpu getting out of sync during resume
Date: Tue, 29 Mar 2011 15:38:12 -0700
Message-Id: <1301438292-28370-1-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>

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
Signed-off-by: Eric Anholt <eric@anholt.net>
Tested-by: Keith Packard <keithp@keithp.com>
Cc: stable@kernel.org	[v2.6.32+]
---

Failed to cc maintainers with this the first time, hopefully it gets
picked up now.  Impact of the patch is fixing a 100x graphics
performance regression after resume when a process ends up on the
unlucky CPU.

 arch/x86/kernel/cpu/mtrr/main.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 307dfbb..929739a 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -293,14 +293,24 @@ set_mtrr(unsigned int reg, unsigned long base, unsigned long size, mtrr_type typ
 
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
-- 
1.7.4.1

