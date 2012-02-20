Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab2BTJi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 04:38:28 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:45146 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2BTJiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 04:38:25 -0500
Date: Mon, 20 Feb 2012 10:37:54 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.3-rc4
Message-ID: <20120220103754.40c113b2@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12022009-5024-0000-0000-000001BE9199
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:

Heiko Carstens (1):
      [S390] idle: avoid RCU usage in extended quiescent state

Martin Schwidefsky (3):
      [S390] incorrect PageTables counter for kvm page tables
      [S390] 3215 deadlock with tty_wakeup
      [S390] correct ktime to tod clock comparator conversion

 arch/s390/kernel/process.c  |    5 +++--
 arch/s390/kernel/time.c     |    7 +++++--
 arch/s390/mm/pgtable.c      |    2 +-
 drivers/s390/char/con3215.c |   22 +++++++++++++++-------
 4 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 3201ae4..4261aa7 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -76,7 +76,6 @@ static void default_idle(void)
 	if (test_thread_flag(TIF_MCCK_PENDING)) {
 		local_mcck_enable();
 		local_irq_enable();
-		s390_handle_mcck();
 		return;
 	}
 	trace_hardirqs_on();
@@ -93,10 +92,12 @@ void cpu_idle(void)
 	for (;;) {
 		tick_nohz_idle_enter();
 		rcu_idle_enter();
-		while (!need_resched())
+		while (!need_resched() && !test_thread_flag(TIF_MCCK_PENDING))
 			default_idle();
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
+		if (test_thread_flag(TIF_MCCK_PENDING))
+			s390_handle_mcck();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index fa02f44..14da278 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -113,11 +113,14 @@ static void fixup_clock_comparator(unsigned long long delta)
 static int s390_next_ktime(ktime_t expires,
 			   struct clock_event_device *evt)
 {
+	struct timespec ts;
 	u64 nsecs;
 
-	nsecs = ktime_to_ns(ktime_sub(expires, ktime_get_monotonic_offset()));
+	ts.tv_sec = ts.tv_nsec = 0;
+	monotonic_to_bootbased(&ts);
+	nsecs = ktime_to_ns(ktime_add(timespec_to_ktime(ts), expires));
 	do_div(nsecs, 125);
-	S390_lowcore.clock_comparator = TOD_UNIX_EPOCH + (nsecs << 9);
+	S390_lowcore.clock_comparator = sched_clock_base_cc + (nsecs << 9);
 	set_clock_comparator(S390_lowcore.clock_comparator);
 	return 0;
 }
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 9a4d02f..51b0738 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -574,7 +574,7 @@ static inline void page_table_free_pgste(unsigned long *table)
 	page = pfn_to_page(__pa(table) >> PAGE_SHIFT);
 	mp = (struct gmap_pgtable *) page->index;
 	BUG_ON(!list_empty(&mp->mapper));
-	pgtable_page_ctor(page);
+	pgtable_page_dtor(page);
 	atomic_set(&page->_mapcount, -1);
 	kfree(mp);
 	__free_page(page);
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 934458a..e71a50d 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -87,6 +87,7 @@ struct raw3215_info {
 	struct tty_struct *tty;	      /* pointer to tty structure if present */
 	struct raw3215_req *queued_read; /* pointer to queued read requests */
 	struct raw3215_req *queued_write;/* pointer to queued write requests */
+	struct tasklet_struct tlet;   /* tasklet to invoke tty_wakeup */
 	wait_queue_head_t empty_wait; /* wait queue for flushing */
 	struct timer_list timer;      /* timer for delayed output */
 	int line_pos;		      /* position on the line (for tabs) */
@@ -334,19 +335,23 @@ static inline void raw3215_try_io(struct raw3215_info *raw)
 }
 
 /*
+ * Call tty_wakeup from tasklet context
+ */
+static void raw3215_wakeup(unsigned long data)
+{
+	struct raw3215_info *raw = (struct raw3215_info *) data;
+	tty_wakeup(raw->tty);
+}
+
+/*
  * Try to start the next IO and wake up processes waiting on the tty.
  */
 static void raw3215_next_io(struct raw3215_info *raw)
 {
-	struct tty_struct *tty;
-
 	raw3215_mk_write_req(raw);
 	raw3215_try_io(raw);
-	tty = raw->tty;
-	if (tty != NULL &&
-	    RAW3215_BUFFER_SIZE - raw->count >= RAW3215_MIN_SPACE) {
-	    	tty_wakeup(tty);
-	}
+	if (raw->tty && RAW3215_BUFFER_SIZE - raw->count >= RAW3215_MIN_SPACE)
+		tasklet_schedule(&raw->tlet);
 }
 
 /*
@@ -682,6 +687,7 @@ static int raw3215_probe (struct ccw_device *cdev)
 		return -ENOMEM;
 	}
 	init_waitqueue_head(&raw->empty_wait);
+	tasklet_init(&raw->tlet, raw3215_wakeup, (unsigned long) raw);
 
 	dev_set_drvdata(&cdev->dev, raw);
 	cdev->handler = raw3215_irq;
@@ -901,6 +907,7 @@ static int __init con3215_init(void)
 
 	raw->flags |= RAW3215_FIXED;
 	init_waitqueue_head(&raw->empty_wait);
+	tasklet_init(&raw->tlet, raw3215_wakeup, (unsigned long) raw);
 
 	/* Request the console irq */
 	if (raw3215_startup(raw) != 0) {
@@ -966,6 +973,7 @@ static void tty3215_close(struct tty_struct *tty, struct file * filp)
 	tty->closing = 1;
 	/* Shutdown the terminal */
 	raw3215_shutdown(raw);
+	tasklet_kill(&raw->tlet);
 	tty->closing = 0;
 	raw->tty = NULL;
 }

