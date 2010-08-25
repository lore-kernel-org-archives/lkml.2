Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab0HYJRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 05:17:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:51327 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab0HYJRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 05:17:23 -0400
Message-ID: <4C74DE62.6040208@kernel.org>
Date: Wed, 25 Aug 2010 11:12:02 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: fix cwq->nr_active underflow
References: <4C74D9E4.5070403@kernel.org> <1282727501.3685.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1282727501.3685.7.camel@jlt3.sipsolutions.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 Aug 2010 09:17:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/25/2010 11:11 AM, Johannes Berg wrote:
> Thanks Tejun. Come to think of it, since it's an underflow it should be
> easier for me to change the BUG_ON into a printk + BUG_ON() to print out
> the current value, and then reproduce -- that way I'll know when I hit
> the situation, which isn't trivial, and also whether I hit the
> underflow. Does that sound like a good thing to try to you?

Yeap, without the fix patch applied, that should confirm that we're
seeing the same failure, and with the patch applied, you can add a
printk in the else part of !delayed check in cwq_dec_nr_in_flight().
If the printk triggers and later rmmod dosen't trigger BUG_ON(), we
can be fairly sure the problem is fixed.

Thanks.

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a2dccfc..b0d6ca4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1702,7 +1702,9 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color,
 			if (cwq->nr_active < cwq->max_active)
 				cwq_activate_first_delayed(cwq);
 		}
-	}
+	} else
+		printk("XXX %s: cwq_dec_nr_in_flight for a delayed work\n",
+		       cwq->wq->name);

 	/* is flush in progress and are we at the flushing tip? */
 	if (likely(cwq->flush_color != color))

-- 
tejun
