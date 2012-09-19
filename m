Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab2ISKL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 06:11:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26661 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756081Ab2ISKLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 06:11:25 -0400
X-IronPort-AV: E=Sophos;i="4.80,448,1344182400"; 
   d="scan'208";a="5871667"
Message-ID: <50599AC4.303@cn.fujitsu.com>
Date: Wed, 19 Sep 2012 18:13:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] workqueue: Keep activate-order equals to queue_work()-order
References: <1347957414-6692-1-git-send-email-laijs@cn.fujitsu.com> <1347957414-6692-2-git-send-email-laijs@cn.fujitsu.com> <20120918170519.GB8474@google.com> <20120918170802.GC8474@google.com>
In-Reply-To: <20120918170802.GC8474@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/19 18:11:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/19 18:11:35,
	Serialize complete at 2012/09/19 18:11:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 01:08 AM, Tejun Heo wrote:
> On Tue, Sep 18, 2012 at 10:05:19AM -0700, Tejun Heo wrote:
>> On Tue, Sep 18, 2012 at 04:36:53PM +0800, Lai Jiangshan wrote:
>>> The whole workqueue.c keeps activate-order equals to queue_work()-order
>>> in any given cwq except workqueue_set_max_active().
>>>
>>> If this order is not kept, something may be not good:
>>>
>>> first_work_fn() { release some resource; }
>>> second_work_fn() { wait and request the resource; use resource; }
>>>
>>> 1. user queues the first work.	# ->max_active is low, is queued on ->delayed_works.
>>> 2. someone increases the >max_active via workqueue_set_max_active()
>>> 3. user queues the second work.	# queued on cwq->pool.
>>>
>>> When the second work is launched to execute, it waits the first work
>>> to release the resource. But the first work is still in ->delayed_works,
>>> it waits the first work to finish and them it can be activated.
>>>
>>> It is bad. we fix it by activating the first work in the step 2.
>>>
>>> I can't fully determine that it is workqueue's responsibility
>>> or the user's responsibility.
>>> If it is workqueue's responsibility, the patch needs go to -stable.
>>> If it is user's responsibility. it is a nice cleanup, it can go to for-next.
>>> I prefer it is workqueue's responsibility.
>>
>> Unless max_active == 1, workqueue doesn't give any guarantee on
>> execution order.  I don't think we need to care about this.
> 
> That said, I kinda like the patches.  Can you please update the
> description on the second patch to something along the line of "use
> common set_max_active logic which immediately makes use of the newly
> increased max_mactive if there are delayed work items and also happens
> to keep activation ordering"?
> 
> Thanks.
> 

Updated.
Thanks,
Lai

>From 314d43f087c85b11a29be0555f32deeb742bf18e Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Tue, 18 Sep 2012 16:26:30 +0800
Subject: [PATCH] workqueue: use common cwq_set_max_active() for
 workqueue_set_max_active()

workqueue_set_max_active() may increase ->max_active without activating
delayed works. And it may cause the activation order doesn't equal to
to queue_work()-order.

To make things consist, we use common cwq_set_max_active() logic which
immediately makes use of the newly increased max_mactive if there are
delayed work items and also keep activation ordering.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d0ca063..8783414 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3458,7 +3458,7 @@ void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 
 		if (!(wq->flags & WQ_FREEZABLE) ||
 		    !(gcwq->flags & GCWQ_FREEZING))
-			get_cwq(gcwq->cpu, wq)->max_active = max_active;
+			cwq_set_max_active(get_cwq(gcwq->cpu, wq), max_active);
 
 		spin_unlock_irq(&gcwq->lock);
 	}
-- 
1.7.4.4
