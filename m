Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab1IAICT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 04:02:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58953 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab1IAICQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 04:02:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 1 Sep 2011 16:54:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Rajan Aggarwal <rajan.aggarwal85@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] fs-writeback: Using spin_lock to check for
 work_list empty
Message-Id: <20110901165447.6a5f45b7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1314767509-17862-1-git-send-email-rajan.aggarwal85@gmail.com>
References: <1314767509-17862-1-git-send-email-rajan.aggarwal85@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Aug 2011 10:41:49 +0530
Rajan Aggarwal <rajan.aggarwal85@gmail.com> wrote:

> The bdi_writeback_thread function does not use spin_lock to
> see if the work_list is empty.
> 
> If the list is not empty, and if an interrupt happens before we
> set the current->state to TASK_RUNNING then we could be stuck in
> a schedule() due to kernel preemption.
> 
> This patch acquires and releases the wb_lock to avoid this scenario.
> 
> Signed-off-by: Rajan Aggarwal <rajan.aggarwal85@gmail.com>

Hmm, even if it sleeps, bdi_wakeup_flusher() will wake up the thread.
But it seems there is an useful function schedule_timeout_interruptible().

Then, how about this ? Your concern will go away with this ?

==
>From 5558d23b72004a890dc37411aa7515996c8592fa Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 1 Sep 2011 17:02:13 +0900
Subject: [PATCH] use schedule_timeout_interruptible() in bdi_writeback_thread

Use schedule_timeout_interruptible() rather than

 	set_current_state(TASK_INTERRUPTIBLE);
 	do some work
 	schedule_timeout()

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/fs-writeback.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 04cf3b9..c538bda 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -936,22 +936,18 @@ int bdi_writeback_thread(void *data)
 		if (pages_written)
 			wb->last_active = jiffies;
 
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (!list_empty(&bdi->work_list) || kthread_should_stop()) {
-			__set_current_state(TASK_RUNNING);
+		if (!list_empty(&bdi->work_list) || kthread_should_stop())
 			continue;
-		}
 
+		/*
+		 * If we have nothing to do, we can go sleep without any
+		 * timeout and save power. When a work is queued or
+		 * something is made dirty - we will be woken up.
+		 */
+		timeout = MAX_SCHEDULE_TIMEOUT;
 		if (wb_has_dirty_io(wb) && dirty_writeback_interval)
-			schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
-		else {
-			/*
-			 * We have nothing to do, so can go sleep without any
-			 * timeout and save power. When a work is queued or
-			 * something is made dirty - we will be woken up.
-			 */
-			schedule();
-		}
+			timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
+		schedule_timeout_interruptible(timeout);
 
 		try_to_freeze();
 	}
-- 
1.7.4.1


