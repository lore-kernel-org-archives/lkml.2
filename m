Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0FKRcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 13:32:31 -0400
Received: from mail.vyatta.com ([76.74.103.46]:34556 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab0FKRc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 13:32:29 -0400
Date: Fri, 11 Jun 2010 10:32:23 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] floppy: use single threaded workqueue
Message-ID: <20100611103223.799d3ce0@nehalam>
In-Reply-To: <alpine.LFD.2.00.1006091203190.4506@i5.linux-foundation.org>
References: <20100609183449.110905403@vyatta.com>
	<alpine.LFD.2.00.1006091144120.4506@i5.linux-foundation.org>
	<20100609115403.75ebb6cb@nehalam>
	<alpine.LFD.2.00.1006091203190.4506@i5.linux-foundation.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix races between timers and bottom half by using delayed work
and a single threaded queue.

Still needs more testing.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

---
 drivers/block/floppy.c |  172 ++++++++++++++++++++++++++-----------------------
 1 file changed, 94 insertions(+), 78 deletions(-)

--- a/drivers/block/floppy.c	2010-06-11 09:47:59.000000000 -0700
+++ b/drivers/block/floppy.c	2010-06-11 10:06:01.451555907 -0700
@@ -553,7 +553,7 @@ static void floppy_ready(void);
 static void floppy_start(void);
 static void process_fd_request(void);
 static void recalibrate_floppy(void);
-static void floppy_shutdown(unsigned long);
+static void floppy_shutdown(struct work_struct *);
 
 static int floppy_request_regions(int);
 static void floppy_release_regions(int);
@@ -590,6 +590,8 @@ static int buffer_max = -1;
 static struct floppy_fdc_state fdc_state[N_FDC];
 static int fdc;			/* current fdc */
 
+static struct workqueue_struct *floppy_workq;
+
 static struct floppy_struct *_floppy = floppy_type;
 static unsigned char current_drive;
 static long current_count_sectors;
@@ -626,16 +628,15 @@ static inline void set_debugt(void) { }
 static inline void debugt(const char *func, const char *msg) { }
 #endif /* DEBUGT */
 
-typedef void (*timeout_fn)(unsigned long);
-static DEFINE_TIMER(fd_timeout, floppy_shutdown, 0, 0);
 
+static DECLARE_DELAYED_WORK(fd_timeout, floppy_shutdown);
 static const char *timeout_message;
 
 static void is_alive(const char *func, const char *message)
 {
 	/* this routine checks whether the floppy driver is "alive" */
 	if (test_bit(0, &fdc_busy) && command_status < 2 &&
-	    !timer_pending(&fd_timeout)) {
+	    !delayed_work_pending(&fd_timeout)) {
 		DPRINT("%s: timeout handler died.  %s\n", func, message);
 	}
 }
@@ -663,15 +664,18 @@ static int output_log_pos;
 
 static void __reschedule_timeout(int drive, const char *message)
 {
+	unsigned long delay;
+
 	if (drive == current_reqD)
 		drive = current_drive;
-	del_timer(&fd_timeout);
+
 	if (drive < 0 || drive >= N_DRIVE) {
-		fd_timeout.expires = jiffies + 20UL * HZ;
+		delay = 20UL * HZ;
 		drive = 0;
 	} else
-		fd_timeout.expires = jiffies + UDP->timeout;
-	add_timer(&fd_timeout);
+		delay = UDP->timeout;
+
+	queue_delayed_work(floppy_workq, &fd_timeout, delay);
 	if (UDP->flags & FD_DEBUG)
 		DPRINT("reschedule timeout %s\n", message);
 	timeout_message = message;
@@ -886,11 +890,11 @@ static int _lock_fdc(int drive, bool int
 
 		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&fdc_wait, &wait);
-		flush_scheduled_work();
+		flush_workqueue(floppy_workq);
 	}
 	command_status = FD_COMMAND_NONE;
 
-	__reschedule_timeout(drive, "lock fdc");
+	reschedule_timeout(drive, "lock fdc");
 	set_fdc(drive);
 	return 0;
 }
@@ -901,23 +905,15 @@ static int _lock_fdc(int drive, bool int
 /* unlocks the driver */
 static void unlock_fdc(void)
 {
-	unsigned long flags;
-
-	raw_cmd = NULL;
 	if (!test_bit(0, &fdc_busy))
 		DPRINT("FDC access conflict!\n");
 
-	if (do_floppy)
-		DPRINT("device interrupt still active at FDC release: %pf!\n",
-		       do_floppy);
+	raw_cmd = NULL;
 	command_status = FD_COMMAND_NONE;
-	spin_lock_irqsave(&floppy_lock, flags);
-	del_timer(&fd_timeout);
+	__cancel_delayed_work(&fd_timeout);
+	do_floppy = NULL;
 	cont = NULL;
 	clear_bit(0, &fdc_busy);
-	if (current_req || blk_peek_request(floppy_queue))
-		do_fd_request(floppy_queue);
-	spin_unlock_irqrestore(&floppy_lock, flags);
 	wake_up(&fdc_wait);
 }
 
@@ -989,26 +985,24 @@ static DECLARE_WORK(floppy_work, NULL);
 
 static void schedule_bh(void (*handler)(void))
 {
+	WARN_ON(work_pending(&floppy_work));
+
 	PREPARE_WORK(&floppy_work, (work_func_t)handler);
-	schedule_work(&floppy_work);
+	queue_work(floppy_workq, &floppy_work);
 }
 
-static DEFINE_TIMER(fd_timer, NULL, 0, 0);
+static DECLARE_DELAYED_WORK(fd_timer, NULL);
 
 static void cancel_activity(void)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&floppy_lock, flags);
 	do_floppy = NULL;
-	PREPARE_WORK(&floppy_work, (work_func_t)empty);
-	del_timer(&fd_timer);
-	spin_unlock_irqrestore(&floppy_lock, flags);
+	cancel_delayed_work_sync(&fd_timer);
+	cancel_work_sync(&floppy_work);
 }
 
 /* this function makes sure that the disk stays in the drive during the
  * transfer */
-static void fd_watchdog(void)
+static void fd_watchdog(struct work_struct *arg)
 {
 	debug_dcl(DP->flags, "calling disk change from watchdog\n");
 
@@ -1018,21 +1012,21 @@ static void fd_watchdog(void)
 		cont->done(0);
 		reset_fdc();
 	} else {
-		del_timer(&fd_timer);
-		fd_timer.function = (timeout_fn)fd_watchdog;
-		fd_timer.expires = jiffies + HZ / 10;
-		add_timer(&fd_timer);
+		cancel_delayed_work(&fd_timer);
+		PREPARE_DELAYED_WORK(&fd_timer, fd_watchdog);
+		queue_delayed_work(floppy_workq,
+				   &fd_timer, HZ / 10);
 	}
 }
 
 static void main_command_interrupt(void)
 {
-	del_timer(&fd_timer);
+	cancel_delayed_work(&fd_timer);
 	cont->interrupt();
 }
 
 /* waits for a delay (spinup or select) to pass */
-static int fd_wait_for_completion(unsigned long delay, timeout_fn function)
+static int fd_wait_for_completion(unsigned long expires, work_func_t function)
 {
 	if (FDCS->reset) {
 		reset_fdc();	/* do the reset during sleep to win time
@@ -1041,11 +1035,11 @@ static int fd_wait_for_completion(unsign
 		return 1;
 	}
 
-	if (time_before(jiffies, delay)) {
-		del_timer(&fd_timer);
-		fd_timer.function = function;
-		fd_timer.expires = delay;
-		add_timer(&fd_timer);
+	if (time_before(jiffies, expires)) {
+		cancel_delayed_work(&fd_timer);
+		PREPARE_DELAYED_WORK(&fd_timer, function);
+		queue_delayed_work(floppy_workq, &fd_timer,
+				   expires - jiffies);
 		return 1;
 	}
 	return 0;
@@ -1394,7 +1388,7 @@ static int fdc_dtr(void)
 	 */
 	FDCS->dtr = raw_cmd->rate & 3;
 	return fd_wait_for_completion(jiffies + 2UL * HZ / 100,
-				      (timeout_fn)floppy_ready);
+				      (work_func_t)floppy_ready);
 }				/* fdc_dtr */
 
 static void tell_sector(void)
@@ -1499,7 +1493,7 @@ static void setup_rw_floppy(void)
 	int flags;
 	int dflags;
 	unsigned long ready_date;
-	timeout_fn function;
+	work_func_t function;
 
 	flags = raw_cmd->flags;
 	if (flags & (FD_RAW_READ | FD_RAW_WRITE))
@@ -1513,9 +1507,9 @@ static void setup_rw_floppy(void)
 		 */
 		if (time_after(ready_date, jiffies + DP->select_delay)) {
 			ready_date -= DP->select_delay;
-			function = (timeout_fn)floppy_start;
+			function = (work_func_t)floppy_start;
 		} else
-			function = (timeout_fn)setup_rw_floppy;
+			function = (work_func_t)setup_rw_floppy;
 
 		/* wait until the floppy is spinning fast enough */
 		if (fd_wait_for_completion(ready_date, function))
@@ -1545,7 +1539,7 @@ static void setup_rw_floppy(void)
 		inr = result();
 		cont->interrupt();
 	} else if (flags & FD_RAW_NEED_DISK)
-		fd_watchdog();
+		fd_watchdog(NULL);
 }
 
 static int blind_seek;
@@ -1855,20 +1849,22 @@ static void show_floppy(void)
 		pr_info("do_floppy=%pf\n", do_floppy);
 	if (work_pending(&floppy_work))
 		pr_info("floppy_work.func=%pf\n", floppy_work.func);
-	if (timer_pending(&fd_timer))
-		pr_info("fd_timer.function=%pf\n", fd_timer.function);
-	if (timer_pending(&fd_timeout)) {
-		pr_info("timer_function=%pf\n", fd_timeout.function);
-		pr_info("expires=%lu\n", fd_timeout.expires - jiffies);
-		pr_info("now=%lu\n", jiffies);
-	}
+	if (delayed_work_pending(&fd_timer))
+		pr_info("delayed work.function=%p expires=%ld\n",
+		       fd_timer.work.func,
+		       fd_timer.timer.expires - jiffies);
+	if (delayed_work_pending(&fd_timeout))
+		pr_info("timer_function=%p expires=%ld\n",
+		       fd_timeout.work.func,
+		       fd_timeout.timer.expires - jiffies);
+
 	pr_info("cont=%p\n", cont);
 	pr_info("current_req=%p\n", current_req);
 	pr_info("command_status=%d\n", command_status);
 	pr_info("\n");
 }
 
-static void floppy_shutdown(unsigned long data)
+static void floppy_shutdown(struct work_struct *arg)
 {
 	unsigned long flags;
 
@@ -1923,7 +1919,7 @@ static int start_motor(void (*function)(
 
 	/* wait_for_completion also schedules reset if needed. */
 	return fd_wait_for_completion(DRS->select_date + DP->select_delay,
-				      (timeout_fn)function);
+				      (work_func_t)function);
 }
 
 static void floppy_ready(void)
@@ -2853,6 +2849,20 @@ static int make_raw_rw_request(void)
 	return 2;
 }
 
+static struct request *get_fd_request(void)
+{
+	struct request *req;
+
+	spin_lock_bh(floppy_queue->queue_lock);
+	req = blk_fetch_request(floppy_queue);
+	if (!req)
+		unlock_fdc();
+	spin_unlock_bh(floppy_queue->queue_lock);
+
+	return req;
+}
+
+
 static void redo_fd_request(void)
 {
 	int drive;
@@ -2864,16 +2874,10 @@ static void redo_fd_request(void)
 
 do_request:
 	if (!current_req) {
-		struct request *req;
+		struct request *req = get_fd_request();
 
-		spin_lock_irq(floppy_queue->queue_lock);
-		req = blk_fetch_request(floppy_queue);
-		spin_unlock_irq(floppy_queue->queue_lock);
-		if (!req) {
-			do_floppy = NULL;
-			unlock_fdc();
+		if (!req)
 			return;
-		}
 		current_req = req;
 	}
 	drive = (long)current_req->rq_disk->private_data;
@@ -2949,13 +2953,17 @@ static void do_fd_request(struct request
 			current_req->cmd_flags);
 		return;
 	}
-	if (test_bit(0, &fdc_busy)) {
+	if (test_and_set_bit(0, &fdc_busy)) {
 		/* fdc busy, this new request will be treated when the
 		   current one is done */
 		is_alive(__func__, "old request running");
 		return;
 	}
-	lock_fdc(MAXTIMEOUT, false);
+
+	command_status = FD_COMMAND_NONE;
+
+	__reschedule_timeout(MAXTIMEOUT, "fd_request");
+	set_fdc(0);
 	process_fd_request();
 	is_alive(__func__, "");
 }
@@ -4211,10 +4219,16 @@ static int __init floppy_init(void)
 	if (err)
 		goto out_unreg_blkdev;
 
+	floppy_workq = create_singlethread_workqueue("floppy");
+	if (!floppy_workq) {
+		err = -ENOMEM;
+		goto out_unreg_driver;
+	}
+
 	floppy_queue = blk_init_queue(do_fd_request, &floppy_lock);
 	if (!floppy_queue) {
 		err = -ENOMEM;
-		goto out_unreg_driver;
+		goto out_destroy_workq;
 	}
 	blk_queue_max_hw_sectors(floppy_queue, 64);
 
@@ -4247,7 +4261,7 @@ static int __init floppy_init(void)
 	use_virtual_dma = can_use_virtual_dma & 1;
 	fdc_state[0].address = FDC1;
 	if (fdc_state[0].address == -1) {
-		del_timer(&fd_timeout);
+		cancel_delayed_work(&fd_timeout);
 		err = -ENODEV;
 		goto out_unreg_region;
 	}
@@ -4258,7 +4272,7 @@ static int __init floppy_init(void)
 	fdc = 0;		/* reset fdc in case of unexpected interrupt */
 	err = floppy_grab_irq_and_dma();
 	if (err) {
-		del_timer(&fd_timeout);
+		cancel_delayed_work(&fd_timeout);
 		err = -EBUSY;
 		goto out_unreg_region;
 	}
@@ -4315,13 +4329,13 @@ static int __init floppy_init(void)
 		user_reset_fdc(-1, FD_RESET_ALWAYS, false);
 	}
 	fdc = 0;
-	del_timer(&fd_timeout);
+	cancel_delayed_work(&fd_timeout);
 	current_drive = 0;
 	initialized = true;
 	if (have_no_fdc) {
 		DPRINT("no floppy controllers found\n");
 		err = have_no_fdc;
-		goto out_flush_work;
+		goto out_release_dma;
 	}
 
 	for (drive = 0; drive < N_DRIVE; drive++) {
@@ -4336,7 +4350,7 @@ static int __init floppy_init(void)
 
 		err = platform_device_register(&floppy_device[drive]);
 		if (err)
-			goto out_flush_work;
+			goto out_release_dma;
 
 		err = device_create_file(&floppy_device[drive].dev,
 					 &dev_attr_cmos);
@@ -4355,13 +4369,14 @@ static int __init floppy_init(void)
 
 out_unreg_platform_dev:
 	platform_device_unregister(&floppy_device[drive]);
-out_flush_work:
-	flush_scheduled_work();
+out_release_dma:
 	if (atomic_read(&usage_count))
 		floppy_release_irq_and_dma();
 out_unreg_region:
 	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
 	blk_cleanup_queue(floppy_queue);
+out_destroy_workq:
+	destroy_workqueue(floppy_workq);
 out_unreg_driver:
 	platform_driver_unregister(&floppy_driver);
 out_unreg_blkdev:
@@ -4426,7 +4441,7 @@ static int floppy_grab_irq_and_dma(void)
 	 * We might have scheduled a free_irq(), wait it to
 	 * drain first:
 	 */
-	flush_scheduled_work();
+	flush_workqueue(floppy_workq);
 
 	if (fd_request_irq()) {
 		DPRINT("Unable to grab IRQ%d for the floppy driver\n",
@@ -4518,9 +4533,9 @@ static void floppy_release_irq_and_dma(v
 			pr_info("motor off timer %d still active\n", drive);
 #endif
 
-	if (timer_pending(&fd_timeout))
+	if (delayed_work_pending(&fd_timeout))
 		pr_info("floppy timer still active:%s\n", timeout_message);
-	if (timer_pending(&fd_timer))
+	if (delayed_work_pending(&fd_timer))
 		pr_info("auxiliary floppy timer still active\n");
 	if (work_pending(&floppy_work))
 		pr_info("work still pending\n");
@@ -4580,8 +4595,9 @@ static void __exit floppy_module_exit(vo
 		put_disk(disks[drive]);
 	}
 
-	del_timer_sync(&fd_timeout);
-	del_timer_sync(&fd_timer);
+	cancel_delayed_work_sync(&fd_timeout);
+	cancel_delayed_work_sync(&fd_timer);
+	destroy_workqueue(floppy_workq);
 	blk_cleanup_queue(floppy_queue);
 
 	if (atomic_read(&usage_count))
