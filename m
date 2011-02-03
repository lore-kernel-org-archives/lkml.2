Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab1BCOSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:18:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:33159 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288Ab1BCOSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:18:00 -0500
Message-Id: <20110203141548.250432913@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 03 Feb 2011 15:09:43 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Faisal Latif <faisal.latif@intel.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/4] workqueue: Use mod_timer for queue_delayed_work()
References: <20110203140940.072679794@chello.nl>
Content-Disposition: inline; filename=workqueue-mod_timer_on.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mod_timer for queue_delayed_work(), this allows us to avoid
calling cancel_delayed_work() prior to calling queue_delayed_work()
when changing a work's expiration time.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c
+++ linux-2.6/kernel/workqueue.c
@@ -1107,8 +1107,15 @@ static void delayed_work_timer_fn(unsign
 int queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *dwork, unsigned long delay)
 {
-	if (delay == 0)
+	if (delay == 0) {
+		/*
+		 * If the timer callback is currently running the work
+		 * is already being enqueued and we don't actually have
+		 * to do anything to make it run now...
+		 */
+		__cancel_delayed_work(dwork);
 		return queue_work(wq, &dwork->work);
+	}
 
 	return queue_delayed_work_on(-1, wq, dwork, delay);
 }
@@ -1160,9 +1167,9 @@ int queue_delayed_work_on(int cpu, struc
 		timer->function = delayed_work_timer_fn;
 
 		if (unlikely(cpu >= 0))
-			add_timer_on(timer, cpu);
+			mod_timer_on(timer, cpu);
 		else
-			add_timer(timer);
+			mod_timer(timer);
 		ret = 1;
 	}
 	return ret;


