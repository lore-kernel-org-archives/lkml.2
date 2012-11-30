Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2K3W40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 17:56:26 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2K3W4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 17:56:24 -0500
Date: Fri, 30 Nov 2012 14:56:19 -0800
From: Tejun Heo <tj@kernel.org>
To: Anders Kaseorg <andersk@MIT.EDU>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Wireless regression in workqueue: use mod_delayed_work() instead
 of __cancel + queue
Message-ID: <20121130225619.GD6021@htj.dyndns.org>
References: <alpine.DEB.2.00.1211280953350.26602@dr-wily.mit.edu>
 <alpine.DEB.2.00.1211281016320.26602@dr-wily.mit.edu>
 <20121130211435.GJ3873@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130211435.GJ3873@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, again.

Can you please test whether the following patch makes any difference?

Thanks!

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 042d221..26368ef 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1477,7 +1477,10 @@ bool mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	} while (unlikely(ret == -EAGAIN));
 
 	if (likely(ret >= 0)) {
-		__queue_delayed_work(cpu, wq, dwork, delay);
+		if (!delay)
+			__queue_work(cpu, wq, &dwork->work);
+		else
+			__queue_delayed_work(cpu, wq, dwork, delay);
 		local_irq_restore(flags);
 	}
 
