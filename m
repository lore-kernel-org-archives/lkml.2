Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964889Ab1DNSTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:19:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:41521 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933692Ab1DNR5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:57:49 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 128/209] nmi: fix clock comparator revalidation
Date: Thu, 14 Apr 2011 13:54:46 -0400
Message-Id: <1302803767-9715-15-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit e8129c642155616d9e2160a75f103e127c8c3708 upstream.

On each machine check all registers are revalidated. The save area for
the clock comparator however only contains the upper most seven bytes
of the former contents, if valid.
Therefore the machine check handler uses a store clock instruction to
get the current time and writes that to the clock comparator register
which in turn will generate an immediate timer interrupt.
However within the lowcore the expected time of the next timer
interrupt is stored. If the interrupt happens before that time the
handler won't be called. In turn the clock comparator won't be
reprogrammed and therefore the interrupt condition stays pending which
causes an interrupt loop until the expected time is reached.

On NOHZ machines this can result in unresponsive machines since the
time of the next expected interrupted can be a couple of days in the
future.

To fix this just revalidate the clock comparator register with the
expected value.
In addition the special handling for udelay must be changed as well.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/s390/kernel/nmi.c |   10 ++++------
 arch/s390/lib/delay.c  |   14 +++++++++-----
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index 015e27d..31bc708 100644
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -95,7 +95,6 @@ EXPORT_SYMBOL_GPL(s390_handle_mcck);
 static int notrace s390_revalidate_registers(struct mci *mci)
 {
 	int kill_task;
-	u64 tmpclock;
 	u64 zero;
 	void *fpt_save_area, *fpt_creg_save_area;
 
@@ -214,11 +213,10 @@ static int notrace s390_revalidate_registers(struct mci *mci)
 			: "0", "cc");
 #endif
 	/* Revalidate clock comparator register */
-	asm volatile(
-		"	stck	0(%1)\n"
-		"	sckc	0(%1)"
-		: "=m" (tmpclock) : "a" (&(tmpclock)) : "cc", "memory");
-
+	if (S390_lowcore.clock_comparator == -1)
+		set_clock_comparator(S390_lowcore.mcck_clock);
+	else
+		set_clock_comparator(S390_lowcore.clock_comparator);
 	/* Check if old PSW is valid */
 	if (!mci->wp)
 		/*
diff --git a/arch/s390/lib/delay.c b/arch/s390/lib/delay.c
index 752b362..7c37ec3 100644
--- a/arch/s390/lib/delay.c
+++ b/arch/s390/lib/delay.c
@@ -29,17 +29,21 @@ static void __udelay_disabled(unsigned long long usecs)
 {
 	unsigned long mask, cr0, cr0_saved;
 	u64 clock_saved;
+	u64 end;
 
+	mask = psw_kernel_bits | PSW_MASK_WAIT | PSW_MASK_EXT;
+	end = get_clock() + (usecs << 12);
 	clock_saved = local_tick_disable();
-	set_clock_comparator(get_clock() + (usecs << 12));
 	__ctl_store(cr0_saved, 0, 0);
 	cr0 = (cr0_saved & 0xffff00e0) | 0x00000800;
 	__ctl_load(cr0 , 0, 0);
-	mask = psw_kernel_bits | PSW_MASK_WAIT | PSW_MASK_EXT;
 	lockdep_off();
-	trace_hardirqs_on();
-	__load_psw_mask(mask);
-	local_irq_disable();
+	do {
+		set_clock_comparator(end);
+		trace_hardirqs_on();
+		__load_psw_mask(mask);
+		local_irq_disable();
+	} while (get_clock() < end);
 	lockdep_on();
 	__ctl_load(cr0_saved, 0, 0);
 	local_tick_enable(clock_saved);
-- 
1.7.4.4

