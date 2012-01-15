Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab2AOK33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 05:29:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58711 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab2AOK32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 05:29:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAOAMb1AUHV6mHwkUbX4+0wfOJpnMuVj_vr9jvb=h-Q4+6HKFzg@mail.gmail.com>
References: <CAOAMb1AUHV6mHwkUbX4+0wfOJpnMuVj_vr9jvb=h-Q4+6HKFzg@mail.gmail.com>
From: Rabin Vincent <rabin@rab.in>
Date: Sun, 15 Jan 2012 15:58:43 +0530
X-Google-Sender-Auth: 79n_brEp9KIPLfZZNlosK9AuWAI
Message-ID: <CAH+eYFB8xBPLJdN+jfqpESsqjkxdeRQD7oyfU8qHewzfmbqHow@mail.gmail.com>
Subject: Re: [PATCH] mm/backing-dev.c: fix crash when USB/SCSI device is detached
To: Chanho Min <chanho0207@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 14:19, Chanho Min <chanho0207@gmail.com> wrote:
>>On Tue, Jan 03, 2012 at 12:23:44PM +0900, Chanho Min wrote:
>>> >On Mon, Jan 02, 2012 at 06:38:21PM +0900,wrote:
>>> >> from Chanho Min <chanho.min@lge.com>
>>> >>
>>> >> System may crash in backing-dev.c when removal SCSI device is detached.
>>> >> bdi task is killed by bdi_unregister()/'khubd', but task's point
>>remains.
>>> >> Shortly afterward, If 'wb->wakeup_timer' is expired before
>>> >> del_timer()/bdi_forker_thread,
>>> >> wakeup_timer_fn() may wake up the dead thread which cause the crash.
>>> >> 'bdi->wb.task' should be NULL as this patch.
>>
>>I noticed a related fix is merged recently, does your test kernel
>>contain this commit?
>>
> No, I will try to reproduce with this patch.
> But, bdi_destroy is not called during write-access. Same result is expected.

I agree. 7a401a972df8e184b3d1a3fc958c0a4ddee8d312 only addressed the
problem of the bdi being destroyed with an active timer, but there are
other races that could happen before that.

>>This patch makes no guarantee wakeup_timer_fn() will see NULL
>>bdi->wb.task before the task is stopped, so there is still race
>>conditions. And still, the complete fix would be to prevent
>>wakeup_timer_fn() from being called at all.
>
> If wakeup_timer_fn() see NULL bdi->wb.task, wakeup_timer_fn regards
> task as killed
> and wake up forker thread instead of the defined thread.
> Is this intended behavior of the bdi?

This appears to be the intended behaviour before, but certainly not
after the bdi is unregistered, since anyway the forker thread will not
find the bdi on the list.  In fact, if tracing is enabled the kernel
crashes because dev_name() is called on a NULL bdi->dev from the
wake_forker_thread tracepoint.

The following patch should address these issues:

8<---------------------------
>From 271f92d34b661d701eaad9b262423de5dba1cc11 Mon Sep 17 00:00:00 2001
From: Rabin Vincent <rabin@rab.in>
Date: Sun, 15 Jan 2012 15:30:40 +0530
Subject: [PATCH] backing-dev: fix wakeup timer races with bdi_unregister()

While 7a401a972df8e18 ("backing-dev: ensure wakeup_timer is deleted")
addressed the problem of the bdi being freed with a queued wakeup
timer, there are other races that could happen if the wakeup timer
expires after/during bdi_unregister(), before bdi_destroy() is called.

wakeup_timer_fn() could attempt to wakeup a task which has already has
been freed, or could access a NULL bdi->dev via the wake_forker_thread
tracepoint.

Reported-by: Chanho Min <chanho.min@lge.com>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 mm/backing-dev.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 71034f4..a39ad70 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -318,7 +318,7 @@ static void wakeup_timer_fn(unsigned long data)
 	if (bdi->wb.task) {
 		trace_writeback_wake_thread(bdi);
 		wake_up_process(bdi->wb.task);
-	} else {
+	} else if (bdi->dev) {
 		/*
 		 * When bdi tasks are inactive for long time, they are killed.
 		 * In this case we have to wake-up the forker thread which
@@ -584,6 +584,8 @@ EXPORT_SYMBOL(bdi_register_dev);
  */
 static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 {
+	struct task_struct *task = NULL;
+
 	if (!bdi_cap_writeback_dirty(bdi))
 		return;

@@ -604,9 +606,14 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	 * unfreeze of the thread before calling kthread_stop(), otherwise
 	 * it would never exet if it is currently stuck in the refrigerator.
 	 */
-	if (bdi->wb.task) {
-		thaw_process(bdi->wb.task);
-		kthread_stop(bdi->wb.task);
+	spin_lock_bh(&bdi->wb_lock);
+	task = bdi->wb.task;
+	bdi->wb.task = NULL;
+	spin_unlock_bh(&bdi->wb_lock);
+
+	if (task) {
+		thaw_process(task);
+		kthread_stop(task);
 	}
 }

@@ -637,7 +644,9 @@ void bdi_unregister(struct backing_dev_info *bdi)
 			bdi_wb_shutdown(bdi);
 		bdi_debug_unregister(bdi);
 		device_unregister(bdi->dev);
+		spin_lock_bh(&bdi->wb_lock);
 		bdi->dev = NULL;
+		spin_unlock_bh(&bdi->wb_lock);
 	}
 }
 EXPORT_SYMBOL(bdi_unregister);
-- 
1.7.7.3
