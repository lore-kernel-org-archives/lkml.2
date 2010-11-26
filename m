Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab0KZLLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:11:21 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:44861 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab0KZLLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:11:19 -0500
Date: Fri, 26 Nov 2010 12:11:15 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.37-rc3
Message-ID: <20101126121115.1db1848b@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Heiko Carstens (1):
      [S390] nmi: fix clock comparator revalidation

Jan Glauber (1):
      [S390] qdio: free indicator after reset is finished

 arch/s390/kernel/nmi.c          |   10 ++++------
 arch/s390/lib/delay.c           |   14 +++++++++-----
 drivers/s390/cio/qdio_thinint.c |    2 +-
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index ac15139..1995c17 100644
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
diff --git a/drivers/s390/cio/qdio_thinint.c b/drivers/s390/cio/qdio_thinint.c
index 752dbee..5d9c666 100644
--- a/drivers/s390/cio/qdio_thinint.c
+++ b/drivers/s390/cio/qdio_thinint.c
@@ -292,8 +292,8 @@ void qdio_shutdown_thinint(struct qdio_irq *irq_ptr)
 		return;
 
 	/* reset adapter interrupt indicators */
-	put_indicator(irq_ptr->dsci);
 	set_subchannel_ind(irq_ptr, 1);
+	put_indicator(irq_ptr->dsci);
 }
 
 void __exit tiqdio_unregister_thinints(void)
