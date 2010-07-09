Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab0GIJOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 05:14:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:65025 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab0GIJOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 05:14:48 -0400
Date: Fri, 9 Jul 2010 17:11:38 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 27/35] workqueue: implement concurrency managed dynamic
 worker pool
Message-ID: <20100709091138.GA7304@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <1277759063-24607-1-git-send-email-tj@kernel.org>
 <1277759063-24607-28-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1277759063-24607-28-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 09 Jul 2010 09:11:41.0491 (UTC) FILETIME=[BE877030:01CB1F46]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 11:04:15PM +0200, Tejun Heo wrote:
> +static bool maybe_create_worker(struct global_cwq *gcwq)
> +{
> +	if (!need_to_create_worker(gcwq))
> +		return false;
> +restart:
> +	/* if we don't make progress in MAYDAY_INITIAL_TIMEOUT, call for help */
> +	mod_timer(&gcwq->mayday_timer, jiffies + MAYDAY_INITIAL_TIMEOUT);
> +
> +	while (true) {
> +		struct worker *worker;
> +
> +		spin_unlock_irq(&gcwq->lock);
> +
> +		worker = create_worker(gcwq, true);
> +		if (worker) {
> +			del_timer_sync(&gcwq->mayday_timer);
> +			spin_lock_irq(&gcwq->lock);
> +			start_worker(worker);
> +			BUG_ON(need_to_create_worker(gcwq));
> +			return true;
> +		}
> +
> +		if (!need_to_create_worker(gcwq))
> +			break;
> +
> +		spin_unlock_irq(&gcwq->lock);
> +		__set_current_state(TASK_INTERRUPTIBLE);
> +		schedule_timeout(CREATE_COOLDOWN);
> +		spin_lock_irq(&gcwq->lock);
> +		if (!need_to_create_worker(gcwq))
> +			break;
> +	}
> +
> +	spin_unlock_irq(&gcwq->lock);

A little worried about the lock operation. We may call spin_unlock_irq() twice
under some special situation. Couldn't that happen? Or Am I missing something?

And a rough patch for this issue if needed:
---
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2eb9fbd..84a9cb9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1427,10 +1427,11 @@ restart:
 			return true;
 		}
 
-		if (!need_to_create_worker(gcwq))
+		if (!need_to_create_worker(gcwq)) {
+			spin_lock_irq(&gcwq->lock);
 			break;
+		}
 
-		spin_unlock_irq(&gcwq->lock);
 		__set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(CREATE_COOLDOWN);
 		spin_lock_irq(&gcwq->lock);

> +	del_timer_sync(&gcwq->mayday_timer);
> +	spin_lock_irq(&gcwq->lock);
> +	if (need_to_create_worker(gcwq))
> +		goto restart;
> +	return true;
> +}
> +
