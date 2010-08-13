Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761794Ab0HMPml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 11:42:41 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:52101 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab0HMPmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 11:42:39 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz1432N98dN936eM4015Lzz1202hzz8275bh8275dhz32i2a8h43h)
X-WSS-ID: 0L73KT8-02-6S0-02
X-M-MSG: 
Date: Fri, 13 Aug 2010 17:39:10 +0200
From: Robert Richter <robert.richter@amd.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Carl E. Love" <cel@us.ibm.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [PATCH] oprofile: fix crash when accessing freed task structs
Message-ID: <20100813153910.GD26154@erda.amd.com>
References: <1279775680.1970.13.camel@pasglop>
 <20100728122111.GO26154@erda.amd.com>
 <1280799573.1902.81.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1280799573.1902.81.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.08.10 21:39:33, Benjamin Herrenschmidt wrote:

> I can't tell that much about the workload, I don't have access to it
> either, let's say that from my point of view it's a "customer" binary
> blob.
> 
> I can re-trigger it though.

Benjamin,

can you try the patch below?

Thanks,

-Robert

>From 4435322debc38097e9e863e14597ab3f78814d14 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Fri, 13 Aug 2010 16:29:04 +0200
Subject: [PATCH] oprofile: fix crash when accessing freed task structs

This patch fixes a crash during shutdown reported below. The crash is
caused be accessing already freed task structs. The fix changes the
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
---
 drivers/oprofile/buffer_sync.c |   27 ++++++++++++++-------------
 drivers/oprofile/cpu_buffer.c  |    2 --
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index a9352b2..b7e755f 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -141,16 +141,6 @@ static struct notifier_block module_load_nb = {
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
 
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 219f79e..f179ac2 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -120,8 +120,6 @@ void end_cpu_work(void)
 
 		cancel_delayed_work(&b->work);
 	}
-
-	flush_scheduled_work();
 }
 
 /*
-- 
1.7.1.1



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

