Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab2LAOjd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:39:33 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42949 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab2LAOjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:39:31 -0500
Date: Sat, 1 Dec 2012 06:39:26 -0800
From: Tejun Heo <tj@kernel.org>
To: Anders Kaseorg <andersk@MIT.EDU>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Wireless regression in workqueue: use mod_delayed_work() instead
 of __cancel + queue
Message-ID: <20121201143926.GB2685@htj.dyndns.org>
References: <alpine.DEB.2.00.1211280953350.26602@dr-wily.mit.edu>
 <alpine.DEB.2.00.1211281016320.26602@dr-wily.mit.edu>
 <20121130211435.GJ3873@htj.dyndns.org>
 <20121130225619.GD6021@htj.dyndns.org>
 <alpine.DEB.2.00.1211302234410.25064@dr-wily.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211302234410.25064@dr-wily.mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Anders.

On Fri, Nov 30, 2012 at 11:15:50PM -0500, Anders Kaseorg wrote:
> Yes.  I tested that both directly on top of the bad commit, and on 
> v3.7-rc7, and it fixes the bug in both cases.

Can you please test this one too?  Thanks!

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 042d221..94964d1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1364,6 +1364,11 @@ static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
 	BUG_ON(timer_pending(timer));
 	BUG_ON(!list_empty(&work->entry));
 
+	if (!delay) {
+		__queue_work(cpu, wq, &dwork->work);
+		return;
+	}
+
 	timer_stats_timer_set_start_info(&dwork->timer);
 
 	/*
@@ -1417,9 +1422,6 @@ bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	bool ret = false;
 	unsigned long flags;
 
-	if (!delay)
-		return queue_work_on(cpu, wq, &dwork->work);
-
 	/* read the comment in __queue_work() */
 	local_irq_save(flags);
 
