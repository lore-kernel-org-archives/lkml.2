Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab1C3AhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 20:37:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:51964 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab1C3AhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 20:37:14 -0400
Date: Wed, 30 Mar 2011 00:36:58 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: eric@anholt.net, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, keithp@keithp.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric@anholt.net, keithp@keithp.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1301438292-28370-1-git-send-email-eric@anholt.net>
References: <1301438292-28370-1-git-send-email-eric@anholt.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mtrr, pat: Fix one cpu getting out of sync during resume
Message-ID: <tip-84ac7cdbdd0f04df6b96153f7a79127fd6e45467@git.kernel.org>
Git-Commit-ID: 84ac7cdbdd0f04df6b96153f7a79127fd6e45467
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 30 Mar 2011 00:36:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84ac7cdbdd0f04df6b96153f7a79127fd6e45467
Gitweb:     http://git.kernel.org/tip/84ac7cdbdd0f04df6b96153f7a79127fd6e45467
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 29 Mar 2011 15:38:12 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Mar 2011 16:17:42 -0700

x86, mtrr, pat: Fix one cpu getting out of sync during resume

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
LKML-Reference: <1301438292-28370-1-git-send-email-eric@anholt.net>
Signed-off-by: Eric Anholt <eric@anholt.net>
Tested-by: Keith Packard <keithp@keithp.com>
Cc: stable@kernel.org	[v2.6.32+]
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
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
