Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161997Ab1FAIQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:16:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:43928 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161986Ab1FAIQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:16:23 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:10:57 2011
Message-Id: <20110601081056.829966346@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:09:45 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Milton Miller <miltonm@bga.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [015/165] powerpc/kexec: Fix memory corruption from unallocated slaves
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 2281
Lines: 70

From: Milton Miller <miltonm@bga.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/misc_64.S |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/arch/powerpc/kernel/misc_64.S
+++ b/arch/powerpc/kernel/misc_64.S
@@ -462,7 +462,8 @@ _GLOBAL(disable_kernel_fp)
  * wait for the flag to change, indicating this kernel is going away but
  * the slave code for the next one is at addresses 0 to 100.
  *
- * This is used by all slaves.
+ * This is used by all slaves, even those that did not find a matching
+ * paca in the secondary startup code.
  *
  * Physical (hardware) cpu id should be in r3.
  */
@@ -471,10 +472,6 @@ _GLOBAL(kexec_wait)
 1:	mflr	r5
 	addi	r5,r5,kexec_flag-1b
 
-	li	r4,KEXEC_STATE_REAL_MODE
-	stb	r4,PACAKEXECSTATE(r13)
-	SYNC
-
 99:	HMT_LOW
 #ifdef CONFIG_KEXEC		/* use no memory without kexec */
 	lwz	r4,0(r5)
@@ -499,11 +496,17 @@ kexec_flag:
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


