Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab0GLIzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 04:55:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:60426 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab0GLIzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 04:55:03 -0400
Message-ID: <4C3AD7FE.2050702@kernel.org>
Date: Mon, 12 Jul 2010 10:53:18 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Yong Zhang <yong.zhang@windriver.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
        jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
        cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
        oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
        dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
        andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Subject: [PATCH] workqueue: fix locking in retry path of maybe_create_worker()
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-28-git-send-email-tj@kernel.org> <20100709091138.GA7304@windriver.com>
In-Reply-To: <20100709091138.GA7304@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 12 Jul 2010 08:53:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

maybe_create_worker() mismanaged locking when worker creation fails
and it has to retry.  Fix locking and simplify lock manipulation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Yong Zhang <yong.zhang@windriver.com>
---
Heh, that was stupid.  Thanks a lot for spotting it.  I simplified
things a bit there as there's no reason to repeatedly lock and unlock
there.  Does this look good to you?

 kernel/workqueue.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: work/kernel/workqueue.c
===================================================================
--- work.orig/kernel/workqueue.c
+++ work/kernel/workqueue.c
@@ -1442,14 +1442,14 @@ static bool maybe_create_worker(struct g
 	if (!need_to_create_worker(gcwq))
 		return false;
 restart:
+	spin_unlock_irq(&gcwq->lock);
+
 	/* if we don't make progress in MAYDAY_INITIAL_TIMEOUT, call for help */
 	mod_timer(&gcwq->mayday_timer, jiffies + MAYDAY_INITIAL_TIMEOUT);

 	while (true) {
 		struct worker *worker;

-		spin_unlock_irq(&gcwq->lock);
-
 		worker = create_worker(gcwq, true);
 		if (worker) {
 			del_timer_sync(&gcwq->mayday_timer);
@@ -1462,15 +1462,13 @@ restart:
 		if (!need_to_create_worker(gcwq))
 			break;

-		spin_unlock_irq(&gcwq->lock);
 		__set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(CREATE_COOLDOWN);
-		spin_lock_irq(&gcwq->lock);
+
 		if (!need_to_create_worker(gcwq))
 			break;
 	}

-	spin_unlock_irq(&gcwq->lock);
 	del_timer_sync(&gcwq->mayday_timer);
 	spin_lock_irq(&gcwq->lock);
 	if (need_to_create_worker(gcwq))
