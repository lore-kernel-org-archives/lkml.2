Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab0IRT25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:28:57 -0400
Received: from kroah.org ([198.145.64.141]:43547 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756886Ab0IRTP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:28 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:03 2010
Message-Id: <20100918191303.003444672@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robert Richter <robert.richter@amd.com>
Subject: [066/129] oprofile: fix crash when accessing freed task structs
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robert Richter <robert.richter@amd.com>

commit 750d857c682f4db60d14722d430c7ccc35070962 upstream.

This patch fixes a crash during shutdown reported below. The crash is
caused by accessing already freed task structs. The fix changes the
order for registering and unregistering notifier callbacks.

All notifiers must be initialized before buffers start working. To
stop buffer synchronization we cancel all workqueues, unregister the
notifier callback and then flush all buffers. After all of this we
finally can free all tasks listed.

This should avoid accessing freed tasks.

On 22.07.10 01:14:40, Benjamin Herrenschmidt wrote:

> So the initial observation is a spinlock bad magic followed by a crash
> in the spinlock debug code:
>
> [ 1541.586531] BUG: spinlock bad magic on CPU#5, events/5/136
> [ 1541.597564] Unable to handle kernel paging request for data at address 0x6b6b6b6b6b6b6d03
>
> Backtrace looks like:
>
>       spin_bug+0x74/0xd4
>       ._raw_spin_lock+0x48/0x184
>       ._spin_lock+0x10/0x24
>       .get_task_mm+0x28/0x8c
>       .sync_buffer+0x1b4/0x598
>       .wq_sync_buffer+0xa0/0xdc
>       .worker_thread+0x1d8/0x2a8
>       .kthread+0xa8/0xb4
>       .kernel_thread+0x54/0x70
>
> So we are accessing a freed task struct in the work queue when
> processing the samples.

Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/oprofile/buffer_sync.c |   27 ++++++++++++++-------------
 drivers/oprofile/cpu_buffer.c  |    2 --
 2 files changed, 14 insertions(+), 15 deletions(-)

--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -141,16 +141,6 @@ static struct notifier_block module_load
 	.notifier_call = module_load_notify,
 };
 
-
-static void end_sync(void)
-{
-	end_cpu_work();
-	/* make sure we don't leak task structs */
-	process_task_mortuary();
-	process_task_mortuary();
-}
-
-
 int sync_start(void)
 {
 	int err;
@@ -158,7 +148,7 @@ int sync_start(void)
 	if (!zalloc_cpumask_var(&marked_cpus, GFP_KERNEL))
 		return -ENOMEM;
 
-	start_cpu_work();
+	mutex_lock(&buffer_mutex);
 
 	err = task_handoff_register(&task_free_nb);
 	if (err)
@@ -173,7 +163,10 @@ int sync_start(void)
 	if (err)
 		goto out4;
 
+	start_cpu_work();
+
 out:
+	mutex_unlock(&buffer_mutex);
 	return err;
 out4:
 	profile_event_unregister(PROFILE_MUNMAP, &munmap_nb);
@@ -182,7 +175,6 @@ out3:
 out2:
 	task_handoff_unregister(&task_free_nb);
 out1:
-	end_sync();
 	free_cpumask_var(marked_cpus);
 	goto out;
 }
@@ -190,11 +182,20 @@ out1:
 
 void sync_stop(void)
 {
+	/* flush buffers */
+	mutex_lock(&buffer_mutex);
+	end_cpu_work();
 	unregister_module_notifier(&module_load_nb);
 	profile_event_unregister(PROFILE_MUNMAP, &munmap_nb);
 	profile_event_unregister(PROFILE_TASK_EXIT, &task_exit_nb);
 	task_handoff_unregister(&task_free_nb);
-	end_sync();
+	mutex_unlock(&buffer_mutex);
+	flush_scheduled_work();
+
+	/* make sure we don't leak task structs */
+	process_task_mortuary();
+	process_task_mortuary();
+
 	free_cpumask_var(marked_cpus);
 }
 
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -120,8 +120,6 @@ void end_cpu_work(void)
 
 		cancel_delayed_work(&b->work);
 	}
-
-	flush_scheduled_work();
 }
 
 /*


