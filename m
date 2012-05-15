Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965181Ab2EOCR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:26 -0400
Received: from mail1.windriver.com ([147.11.146.13]:52769 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964834Ab2EOCQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 005/179] powerpc/kexec: Fix memory corruption from unallocated slaves
Date: Mon, 14 May 2012 22:11:41 -0400
Message-ID: <1337048075-6132-6-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milton Miller <miltonm@bga.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3d2cea732d68aa270c360f55d8669820ebce188a upstream.

Commit 1fc711f7ffb01089efc58042cfdbac8573d1b59a (powerpc/kexec: Fix race
in kexec shutdown) moved the write to signal the cpu had exited the kernel
from before the transition to real mode in kexec_smp_wait to kexec_wait.

Unfornately it missed that kexec_wait is used both by cpus leaving the
kernel and by secondary slave cpus that were not allocated a paca for
what ever reason -- they could be beyond nr_cpus or not described in
the current device tree for whatever reason (for example, kexec-load
was not refreshed after a cpu hotplug operation).  Cpus coming through
that path they will write to paca[NR_CPUS] which is beyond the space
allocated for the paca data and overwrite memory not allocated to pacas
but very likely still real mode accessable).

Move the write back to kexec_smp_wait, which is used only by cpus that
found their paca, but after the transition to real mode.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/kernel/misc_64.S |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
index a2b18df..9161338 100644
--- a/arch/powerpc/kernel/misc_64.S
+++ b/arch/powerpc/kernel/misc_64.S
@@ -463,7 +463,8 @@ _GLOBAL(disable_kernel_fp)
  * wait for the flag to change, indicating this kernel is going away but
  * the slave code for the next one is at addresses 0 to 100.
  *
- * This is used by all slaves.
+ * This is used by all slaves, even those that did not find a matching
+ * paca in the secondary startup code.
  *
  * Physical (hardware) cpu id should be in r3.
  */
@@ -472,10 +473,6 @@ _GLOBAL(kexec_wait)
 1:	mflr	r5
 	addi	r5,r5,kexec_flag-1b
 
-	li	r4,KEXEC_STATE_REAL_MODE
-	stb	r4,PACAKEXECSTATE(r13)
-	SYNC
-
 99:	HMT_LOW
 #ifdef CONFIG_KEXEC		/* use no memory without kexec */
 	lwz	r4,0(r5)
@@ -500,11 +497,17 @@ kexec_flag:
  *
  * get phys id from paca
  * switch to real mode
+ * mark the paca as no longer used
  * join other cpus in kexec_wait(phys_id)
  */
 _GLOBAL(kexec_smp_wait)
 	lhz	r3,PACAHWCPUID(r13)
 	bl	real_mode
+
+	li	r4,KEXEC_STATE_REAL_MODE
+	stb	r4,PACAKEXECSTATE(r13)
+	SYNC
+
 	b	.kexec_wait
 
 /*
-- 
1.7.9.6

