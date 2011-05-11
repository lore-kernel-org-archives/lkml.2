Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab1EKQhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:37:11 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:44458 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab1EKQhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:37:06 -0400
Date: Wed, 11 May 2011 09:49:31 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.39-rc7
Message-ID: <20110511094931.1a3aa2c5@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
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

Christian Borntraeger (1):
      [S390] disassembler: handle b280/spp instruction

Heiko Carstens (1):
      [S390] sclp/memory hotplug: fix initial usecount of increments

Martin Schwidefsky (2):
      [S390] oprofile: fix min/max interval query checks
      [S390] fix alloc_pgste check in init_new_context

Michael Holzheu (2):
      [S390] kernel: Initialize register 14 when starting new CPU
      [S390] replace diag10() with diag10_range() function

Stefan Haberland (1):
      [S390] dasd: prevent IO error during reserve/release loop

 arch/s390/include/asm/diag.h        |   17 +++++++++++++++--
 arch/s390/include/asm/mmu_context.h |    2 +-
 arch/s390/kernel/diag.c             |   21 ---------------------
 arch/s390/kernel/dis.c              |    1 +
 arch/s390/kernel/entry.S            |    2 +-
 arch/s390/kernel/entry64.S          |    2 +-
 arch/s390/mm/cmm.c                  |    2 +-
 arch/s390/oprofile/hwsampler.c      |   14 ++++----------
 arch/s390/oprofile/hwsampler.h      |    4 ++--
 arch/s390/oprofile/init.c           |    8 ++------
 drivers/s390/block/dasd.c           |   11 ++++++++++-
 drivers/s390/char/sclp_cmd.c        |    2 ++
 12 files changed, 40 insertions(+), 46 deletions(-)

diff --git a/arch/s390/include/asm/diag.h b/arch/s390/include/asm/diag.h
index 72b2e2f..7e91c58 100644
--- a/arch/s390/include/asm/diag.h
+++ b/arch/s390/include/asm/diag.h
@@ -9,9 +9,22 @@
 #define _ASM_S390_DIAG_H
 
 /*
- * Diagnose 10: Release pages
+ * Diagnose 10: Release page range
  */
-extern void diag10(unsigned long addr);
+static inline void diag10_range(unsigned long start_pfn, unsigned long num_pfn)
+{
+	unsigned long start_addr, end_addr;
+
+	start_addr = start_pfn << PAGE_SHIFT;
+	end_addr = (start_pfn + num_pfn - 1) << PAGE_SHIFT;
+
+	asm volatile(
+		"0:	diag	%0,%1,0x10\n"
+		"1:\n"
+		EX_TABLE(0b, 1b)
+		EX_TABLE(1b, 1b)
+		: : "a" (start_addr), "a" (end_addr));
+}
 
 /*
  * Diagnose 14: Input spool file manipulation
diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index a6f0e7c..8c277ca 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -23,7 +23,7 @@ static inline int init_new_context(struct task_struct *tsk,
 #ifdef CONFIG_64BIT
 	mm->context.asce_bits |= _ASCE_TYPE_REGION3;
 #endif
-	if (current->mm->context.alloc_pgste) {
+	if (current->mm && current->mm->context.alloc_pgste) {
 		/*
 		 * alloc_pgste indicates, that any NEW context will be created
 		 * with extended page tables. The old context is unchanged. The
diff --git a/arch/s390/kernel/diag.c b/arch/s390/kernel/diag.c
index c032d11..8237fc0 100644
--- a/arch/s390/kernel/diag.c
+++ b/arch/s390/kernel/diag.c
@@ -9,27 +9,6 @@
 #include <asm/diag.h>
 
 /*
- * Diagnose 10: Release pages
- */
-void diag10(unsigned long addr)
-{
-	if (addr >= 0x7ff00000)
-		return;
-	asm volatile(
-#ifdef CONFIG_64BIT
-		"	sam31\n"
-		"	diag	%0,%0,0x10\n"
-		"0:	sam64\n"
-#else
-		"	diag	%0,%0,0x10\n"
-		"0:\n"
-#endif
-		EX_TABLE(0b, 0b)
-		: : "a" (addr));
-}
-EXPORT_SYMBOL(diag10);
-
-/*
  * Diagnose 14: Input spool file manipulation
  */
 int diag14(unsigned long rx, unsigned long ry1, unsigned long subcode)
diff --git a/arch/s390/kernel/dis.c b/arch/s390/kernel/dis.c
index c83726c..3d4a78f 100644
--- a/arch/s390/kernel/dis.c
+++ b/arch/s390/kernel/dis.c
@@ -672,6 +672,7 @@ static struct insn opcode_b2[] = {
 	{ "rp", 0x77, INSTR_S_RD },
 	{ "stcke", 0x78, INSTR_S_RD },
 	{ "sacf", 0x79, INSTR_S_RD },
+	{ "spp", 0x80, INSTR_S_RD },
 	{ "stsi", 0x7d, INSTR_S_RD },
 	{ "srnm", 0x99, INSTR_S_RD },
 	{ "stfpc", 0x9c, INSTR_S_RD },
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 648f642..1b67fc6 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -836,7 +836,7 @@ restart_base:
 	stosm	__SF_EMPTY(%r15),0x04	# now we can turn dat on
 	basr	%r14,0
 	l	%r14,restart_addr-.(%r14)
-	br	%r14			# branch to start_secondary
+	basr	%r14,%r14		# branch to start_secondary
 restart_addr:
 	.long	start_secondary
 	.align	8
diff --git a/arch/s390/kernel/entry64.S b/arch/s390/kernel/entry64.S
index 9d3603d..9fd8645 100644
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -841,7 +841,7 @@ restart_base:
 	mvc	__LC_SYSTEM_TIMER(8),__TI_system_timer(%r1)
 	xc	__LC_STEAL_TIMER(8),__LC_STEAL_TIMER
 	stosm	__SF_EMPTY(%r15),0x04	# now we can turn dat on
-	jg	start_secondary
+	brasl	%r14,start_secondary
 	.align	8
 restart_vtime:
 	.long	0x7fffffff,0xffffffff
diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index c66ffd8..1f1dba9 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -91,7 +91,7 @@ static long cmm_alloc_pages(long nr, long *counter,
 			} else
 				free_page((unsigned long) npa);
 		}
-		diag10(addr);
+		diag10_range(addr >> PAGE_SHIFT, 1);
 		pa->pages[pa->index++] = addr;
 		(*counter)++;
 		spin_unlock(&cmm_lock);
diff --git a/arch/s390/oprofile/hwsampler.c b/arch/s390/oprofile/hwsampler.c
index 4952872..33cbd37 100644
--- a/arch/s390/oprofile/hwsampler.c
+++ b/arch/s390/oprofile/hwsampler.c
@@ -1021,20 +1021,14 @@ deallocate_exit:
 	return rc;
 }
 
-long hwsampler_query_min_interval(void)
+unsigned long hwsampler_query_min_interval(void)
 {
-	if (min_sampler_rate)
-		return min_sampler_rate;
-	else
-		return -EINVAL;
+	return min_sampler_rate;
 }
 
-long hwsampler_query_max_interval(void)
+unsigned long hwsampler_query_max_interval(void)
 {
-	if (max_sampler_rate)
-		return max_sampler_rate;
-	else
-		return -EINVAL;
+	return max_sampler_rate;
 }
 
 unsigned long hwsampler_get_sample_overflow_count(unsigned int cpu)
diff --git a/arch/s390/oprofile/hwsampler.h b/arch/s390/oprofile/hwsampler.h
index 8c72b59..1912f3b 100644
--- a/arch/s390/oprofile/hwsampler.h
+++ b/arch/s390/oprofile/hwsampler.h
@@ -102,8 +102,8 @@ int hwsampler_setup(void);
 int hwsampler_shutdown(void);
 int hwsampler_allocate(unsigned long sdbt, unsigned long sdb);
 int hwsampler_deallocate(void);
-long hwsampler_query_min_interval(void);
-long hwsampler_query_max_interval(void);
+unsigned long hwsampler_query_min_interval(void);
+unsigned long hwsampler_query_max_interval(void);
 int hwsampler_start_all(unsigned long interval);
 int hwsampler_stop_all(void);
 int hwsampler_deactivate(unsigned int cpu);
diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
index c63d7e5..5995e9b 100644
--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -145,15 +145,11 @@ static int oprofile_hwsampler_init(struct oprofile_operations *ops)
 	 * create hwsampler files only if hwsampler_setup() succeeds.
 	 */
 	oprofile_min_interval = hwsampler_query_min_interval();
-	if (oprofile_min_interval < 0) {
-		oprofile_min_interval = 0;
+	if (oprofile_min_interval == 0)
 		return -ENODEV;
-	}
 	oprofile_max_interval = hwsampler_query_max_interval();
-	if (oprofile_max_interval < 0) {
-		oprofile_max_interval = 0;
+	if (oprofile_max_interval == 0)
 		return -ENODEV;
-	}
 
 	if (oprofile_timer_init(ops))
 		return -ENODEV;
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 475e603..86b6f1c 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -1742,11 +1742,20 @@ int dasd_sleep_on_interruptible(struct dasd_ccw_req *cqr)
 static inline int _dasd_term_running_cqr(struct dasd_device *device)
 {
 	struct dasd_ccw_req *cqr;
+	int rc;
 
 	if (list_empty(&device->ccw_queue))
 		return 0;
 	cqr = list_entry(device->ccw_queue.next, struct dasd_ccw_req, devlist);
-	return device->discipline->term_IO(cqr);
+	rc = device->discipline->term_IO(cqr);
+	if (!rc)
+		/*
+		 * CQR terminated because a more important request is pending.
+		 * Undo decreasing of retry counter because this is
+		 * not an error case.
+		 */
+		cqr->retries++;
+	return rc;
 }
 
 int dasd_sleep_on_immediatly(struct dasd_ccw_req *cqr)
diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index 4b60ede..be55fb2 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -518,6 +518,8 @@ static void __init insert_increment(u16 rn, int standby, int assigned)
 		return;
 	new_incr->rn = rn;
 	new_incr->standby = standby;
+	if (!standby)
+		new_incr->usecount = 1;
 	last_rn = 0;
 	prev = &sclp_mem_list;
 	list_for_each_entry(incr, &sclp_mem_list, list) {
