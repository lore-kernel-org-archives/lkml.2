Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586Ab2EPHhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:37:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40629 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759534Ab2EPHhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:37:02 -0400
Date: Wed, 16 May 2012 09:36:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] floppy: convert to delayed work and single-thread wq
Message-ID: <alpine.LNX.2.00.1205160932280.8796@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several races in floppy driver between bottom half 
(scheduled_work) and timers (fd_timeout, fd_timer). Due to slowness of the 
actual floppy devices, those races are never (at least to my knowledge) 
triggered on a bare floppy metal. However on virtualized (emulated) floppy 
drives, which are of course magnitudes faster than the real ones, these 
races trigger reliably. They usually exhibit themselves as NULL pointer 
dereferences during DMA setup, such as

	BUG: unable to handle kernel NULL pointer dereference at 0000000a
	[ ... snip ... ]
	EIP: 0060:[<c02053d5>] EFLAGS: 00010293 CPU: 0
	EAX: ffffe000 EBX: 0000000a ECX: 00000000 EDX: 0000000a
	ESI: c05d2718 EDI: 00000000 EBP: 00000000 ESP: f540fe44
	 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
	Process swapper (pid: 0, ti=f540e000 task=c082d5a0 task.ti=c0826000)
	Stack:
	 ffffe000 00001ffc 00000000 00000000 00000000 c05d2718 c0708b40 f540fe80
	 c020470f c05d2718 c0708b40 00000000 f540fe80 0000000a f540fee4 00000000
	 c0708b40 f540fee4 00000000 00000000 c020526b 00000000 c05d2718 c0708b40
	Call Trace:
	 [<c020470f>] dump_trace+0xaf/0x110
	 [<c020526b>] show_trace_log_lvl+0x4b/0x60
	 [<c0205298>] show_trace+0x18/0x20
	 [<c05c5811>] dump_stack+0x6d/0x72
	 [<c0248527>] warn_slowpath_common+0x77/0xb0
	 [<c02485f3>] warn_slowpath_fmt+0x33/0x40
	 [<f7ec593c>] setup_DMA+0x14c/0x210 [floppy]
	 [<f7ecaa95>] setup_rw_floppy+0x105/0x190 [floppy]
	 [<c0256d08>] run_timer_softirq+0x168/0x2a0
	 [<c024e762>] __do_softirq+0xc2/0x1c0
	 [<c02042ed>] do_softirq+0x7d/0xb0
	 [<f54d8a00>] 0xf54d89ff

but other instances can be easily seen as well. This can be observed at 
least under VMWare, VirtualBox and KVM.

This patch converts all the timers and bottom halfs to be processed in a 
single workqueue. This aproach has been already discussed back in 2010 and 
Acked by Linus [1], but it then never made it to the tree.

This all is based on original idea and code of Stephen Hemminger.  I have 
ported original Stepen's code to the current state of the floppy driver, 
and performed quite some testing (on real hardware), which didn't reveal 
any issues (this includes not only writing and reading data, but also 
formatting (unfortunately I didn't find any Double-Density disks any 
more)). Ability to handle errors properly (supplying known bad floppies) 
has also been verified.

[1] http://kerneltrap.org/mailarchive/linux-kernel/2010/6/11/4582092

Based-on-patch-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/block/floppy.c |  143 ++++++++++++++++++++++++------------------------
 1 files changed, 72 insertions(+), 71 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index b0b00d7..9fffb03 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -551,7 +551,7 @@ static void floppy_ready(void);
 static void floppy_start(void);
 static void process_fd_request(void);
 static void recalibrate_floppy(void);
-static void floppy_shutdown(unsigned long);
+static void floppy_shutdown(struct work_struct *);
 
 static int floppy_request_regions(int);
 static void floppy_release_regions(int);
@@ -588,6 +588,8 @@ static int buffer_max = -1;
 static struct floppy_fdc_state fdc_state[N_FDC];
 static int fdc;			/* current fdc */
 
+static struct workqueue_struct *floppy_wq;
+
 static struct floppy_struct *_floppy = floppy_type;
 static unsigned char current_drive;
 static long current_count_sectors;
@@ -629,16 +631,15 @@ static inline void set_debugt(void) { }
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
@@ -666,15 +667,18 @@ static int output_log_pos;
 
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
+	queue_delayed_work(floppy_wq, &fd_timeout, delay);
 	if (UDP->flags & FD_DEBUG)
 		DPRINT("reschedule timeout %s\n", message);
 	timeout_message = message;
@@ -872,7 +876,7 @@ static int lock_fdc(int drive, bool interruptible)
 
 	command_status = FD_COMMAND_NONE;
 
-	__reschedule_timeout(drive, "lock fdc");
+	reschedule_timeout(drive, "lock fdc");
 	set_fdc(drive);
 	return 0;
 }
@@ -880,23 +884,15 @@ static int lock_fdc(int drive, bool interruptible)
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
-	if (current_req || set_next_request())
-		do_fd_request(current_req->q);
-	spin_unlock_irqrestore(&floppy_lock, flags);
 	wake_up(&fdc_wait);
 }
 
@@ -969,25 +965,21 @@ static DECLARE_WORK(floppy_work, NULL);
 static void schedule_bh(void (*handler)(void))
 {
 	PREPARE_WORK(&floppy_work, (work_func_t)handler);
-	schedule_work(&floppy_work);
+	queue_work(floppy_wq, &floppy_work);
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
+static void fd_watchdog(struct work_struct wq)
 {
 	debug_dcl(DP->flags, "calling disk change from watchdog\n");
 
@@ -997,21 +989,20 @@ static void fd_watchdog(void)
 		cont->done(0);
 		reset_fdc();
 	} else {
-		del_timer(&fd_timer);
-		fd_timer.function = (timeout_fn)fd_watchdog;
-		fd_timer.expires = jiffies + HZ / 10;
-		add_timer(&fd_timer);
+		cancel_delayed_work(&fd_timer);
+		PREPARE_DELAYED_WORK(&fd_timer, fd_watchdog);
+		queue_delayed_work(floppy_wq, &fd_timer, HZ / 10);
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
+static int fd_wait_for_completion(unsigned long expires, work_func_t func)
 {
 	if (FDCS->reset) {
 		reset_fdc();	/* do the reset during sleep to win time
@@ -1020,11 +1011,10 @@ static int fd_wait_for_completion(unsigned long delay, timeout_fn function)
 		return 1;
 	}
 
-	if (time_before(jiffies, delay)) {
-		del_timer(&fd_timer);
-		fd_timer.function = function;
-		fd_timer.expires = delay;
-		add_timer(&fd_timer);
+	if (time_before(jiffies, expires)) {
+		cancel_delayed_work(&fd_timer);
+		PREPARE_DELAYED_WORK(&fd_timer, func);
+		queue_delayed_work(floppy_wq, &fd_timer, expires - jiffies);
 		return 1;
 	}
 	return 0;
@@ -1342,7 +1332,7 @@ static int fdc_dtr(void)
 	 */
 	FDCS->dtr = raw_cmd->rate & 3;
 	return fd_wait_for_completion(jiffies + 2UL * HZ / 100,
-				      (timeout_fn)floppy_ready);
+				      (work_func_t)floppy_ready);
 }				/* fdc_dtr */
 
 static void tell_sector(void)
@@ -1447,7 +1437,7 @@ static void setup_rw_floppy(void)
 	int flags;
 	int dflags;
 	unsigned long ready_date;
-	timeout_fn function;
+	work_func_t func;
 
 	flags = raw_cmd->flags;
 	if (flags & (FD_RAW_READ | FD_RAW_WRITE))
@@ -1461,12 +1451,12 @@ static void setup_rw_floppy(void)
 		 */
 		if (time_after(ready_date, jiffies + DP->select_delay)) {
 			ready_date -= DP->select_delay;
-			function = (timeout_fn)floppy_start;
+			func = (work_func_t)floppy_start;
 		} else
-			function = (timeout_fn)setup_rw_floppy;
+			func = (work_func_t)setup_rw_floppy;
 
 		/* wait until the floppy is spinning fast enough */
-		if (fd_wait_for_completion(ready_date, function))
+		if (fd_wait_for_completion(ready_date, func))
 			return;
 	}
 	dflags = DRS->flags;
@@ -1493,7 +1483,7 @@ static void setup_rw_floppy(void)
 		inr = result();
 		cont->interrupt();
 	} else if (flags & FD_RAW_NEED_DISK)
-		fd_watchdog();
+		fd_watchdog(NULL);
 }
 
 static int blind_seek;
@@ -1802,20 +1792,22 @@ static void show_floppy(void)
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
+	if (delayed_work_pending(&fd_timeout))
+		pr_info("timer_function=%p expires=%ld\n",
+		       fd_timeout.work.func,
+		       fd_timeout.timer.expires - jiffies);
+	if (delayed_work_pending(&fd_timer))
+		pr_info("delayed work.function=%p expires=%ld\n",
+		       fd_timer.work.func,
+		       fd_timer.timer.expires - jiffies);
+
 	pr_info("cont=%p\n", cont);
 	pr_info("current_req=%p\n", current_req);
 	pr_info("command_status=%d\n", command_status);
 	pr_info("\n");
 }
 
-static void floppy_shutdown(unsigned long data)
+static void floppy_shutdown(struct work_struct *wq)
 {
 	unsigned long flags;
 
@@ -1868,7 +1860,7 @@ static int start_motor(void (*function)(void))
 
 	/* wait_for_completion also schedules reset if needed. */
 	return fd_wait_for_completion(DRS->select_date + DP->select_delay,
-				      (timeout_fn)function);
+				      (work_func_t)function);
 }
 
 static void floppy_ready(void)
@@ -2821,7 +2813,6 @@ do_request:
 		spin_lock_irq(&floppy_lock);
 		pending = set_next_request();
 		spin_unlock_irq(&floppy_lock);
-
 		if (!pending) {
 			do_floppy = NULL;
 			unlock_fdc();
@@ -2898,13 +2889,15 @@ static void do_fd_request(struct request_queue *q)
 		 current_req->cmd_flags))
 		return;
 
-	if (test_bit(0, &fdc_busy)) {
+	if (test_and_set_bit(0, &fdc_busy)) {
 		/* fdc busy, this new request will be treated when the
 		   current one is done */
 		is_alive(__func__, "old request running");
 		return;
 	}
-	lock_fdc(MAXTIMEOUT, false);
+	command_status = FD_COMMAND_NONE;
+	__reschedule_timeout(MAXTIMEOUT, "fd_request");
+	set_fdc(0);
 	process_fd_request();
 	is_alive(__func__, "");
 }
@@ -4159,10 +4152,16 @@ static int __init floppy_init(void)
 			goto out_put_disk;
 		}
 
+		floppy_wq = create_singlethread_workqueue("floppy");
+		if (!floppy_wq) {
+			err = -ENOMEM;
+			goto out_put_disk;
+		}
+
 		disks[dr]->queue = blk_init_queue(do_fd_request, &floppy_lock);
 		if (!disks[dr]->queue) {
 			err = -ENOMEM;
-			goto out_put_disk;
+			goto out_destroy_workq;
 		}
 
 		blk_queue_max_hw_sectors(disks[dr]->queue, 64);
@@ -4213,7 +4212,7 @@ static int __init floppy_init(void)
 	use_virtual_dma = can_use_virtual_dma & 1;
 	fdc_state[0].address = FDC1;
 	if (fdc_state[0].address == -1) {
-		del_timer_sync(&fd_timeout);
+		cancel_delayed_work(&fd_timeout);
 		err = -ENODEV;
 		goto out_unreg_region;
 	}
@@ -4224,7 +4223,7 @@ static int __init floppy_init(void)
 	fdc = 0;		/* reset fdc in case of unexpected interrupt */
 	err = floppy_grab_irq_and_dma();
 	if (err) {
-		del_timer_sync(&fd_timeout);
+		cancel_delayed_work(&fd_timeout);
 		err = -EBUSY;
 		goto out_unreg_region;
 	}
@@ -4281,13 +4280,13 @@ static int __init floppy_init(void)
 		user_reset_fdc(-1, FD_RESET_ALWAYS, false);
 	}
 	fdc = 0;
-	del_timer_sync(&fd_timeout);
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
@@ -4302,7 +4301,7 @@ static int __init floppy_init(void)
 
 		err = platform_device_register(&floppy_device[drive]);
 		if (err)
-			goto out_flush_work;
+			goto out_release_dma;
 
 		err = device_create_file(&floppy_device[drive].dev,
 					 &dev_attr_cmos);
@@ -4320,13 +4319,14 @@ static int __init floppy_init(void)
 
 out_unreg_platform_dev:
 	platform_device_unregister(&floppy_device[drive]);
-out_flush_work:
-	flush_work_sync(&floppy_work);
+out_release_dma:
 	if (atomic_read(&usage_count))
 		floppy_release_irq_and_dma();
 out_unreg_region:
 	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
 	platform_driver_unregister(&floppy_driver);
+out_destroy_workq:
+	destroy_workqueue(floppy_wq);
 out_unreg_blkdev:
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 out_put_disk:
@@ -4397,7 +4397,7 @@ static int floppy_grab_irq_and_dma(void)
 	 * We might have scheduled a free_irq(), wait it to
 	 * drain first:
 	 */
-	flush_work_sync(&floppy_work);
+	flush_workqueue(floppy_wq);
 
 	if (fd_request_irq()) {
 		DPRINT("Unable to grab IRQ%d for the floppy driver\n",
@@ -4488,9 +4488,9 @@ static void floppy_release_irq_and_dma(void)
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
@@ -4560,8 +4560,9 @@ static void __exit floppy_module_exit(void)
 		put_disk(disks[drive]);
 	}
 
-	del_timer_sync(&fd_timeout);
-	del_timer_sync(&fd_timer);
+	cancel_delayed_work_sync(&fd_timeout);
+	cancel_delayed_work_sync(&fd_timer);
+	destroy_workqueue(floppy_wq);
 
 	if (atomic_read(&usage_count))
 		floppy_release_irq_and_dma();

-- 
Jiri Kosina
SUSE Labs
