Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab0ENIJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:09:53 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:41360 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab0ENIJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:09:50 -0400
Message-ID: <4BED049C.5040409@ct.jp.nec.com>
Date: Fri, 14 May 2010 17:06:52 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Alasdair Kergon <agk@redhat.com>
Subject: Re: [RFC PATCH 2/2] dm: only initialize full request_queue for request-based
 device
References: <1273532139-23043-1-git-send-email-snitzer@redhat.com> <1273532139-23043-2-git-send-email-snitzer@redhat.com> <4BE8DBB0.5060701@ct.jp.nec.com> <20100511131502.GA25211@redhat.com> <4BEA659F.9050206@ct.jp.nec.com> <20100513035750.GA25523@redhat.com>
In-Reply-To: <20100513035750.GA25523@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 05/13/2010 12:57 PM +0900, Mike Snitzer wrote:
> On Wed, May 12 2010 at  4:23am -0400,
> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> 
>> Hi Mike,
>>
>> On 05/11/2010 10:15 PM +0900, Mike Snitzer wrote:
>>> It is clear we need to resolve the current full request_queue
>>> initialization that occurs even for bio-based DM devices.
>>>
>>> I believe the 2 patches I posted accomplish this in a stright-forward
>>> way.  We can always improve on it (by looking at what you proposed
>>> below) but we need a minimlaist fix that doesn't depend on userspace
>>> LVM2 changes right now.
>> Humm, OK.
>> Indeed, showing iosched directory in bio-based device's sysfs is
>> confusing users actually, and we need something to resolve that soon.
>> So I don't strongly object to your approach as the first step, as long
>> as we can accept the risk of the maintenance cost which I mentioned.
> 
> OK, I understand your concern (especially after having gone through this
> further over the past couple days).  I'm hopeful maintenance will be
> minimal.
> 
>> By the way, your current patch has a problem below.
>> It needs to be fixed at least.
> 
> Thanks for the review.  I've addressed both your points with additional
> changes (split between 2 patches).

I found another bug; blk_init_allocated_queue() overwrites q->unplug_fn
with generic one. (Although it's currently harmless for multipath target.)

I feel your patch-set is growing and becoming complex fix rather than
minimalist/simple fix.
I think touching mapped_device/queue at table loading time makes
things complex.  It is natural that table's arguments are reflected
to mapped_device/queue at table binding time instead.

> I confirmed with Alasdair that we don't want to conditionally relax DM's
> allocation constraints for request-based DM.  Best to be consistent
> about not allowing allocations during resume.

OK.
Then, how about the patch below?
It still fully initializes queue at device creation time for both
bio-based and request-based.  Then, it drops elevator when the device
type is decided as bio-based at table binding time.
So no memory allocation during resume (freeing instead).

I hope this simple work-around approach is acceptable for you and
Alasdair (and others).
(Then, let's focus on making a right fix rather than hacking
 the block layer.)


[PATCH] dm: drop elevator when the device is bio-based

I/O scheduler affects nothing for bio-based dm device.
Showing I/O scheduler's attributes in sysfs for bio-based dm devices
is confusing users.
So drop them from sysfs when a dm device is decided as bio-based.

This patch depends on the commit below in the for-2.6.35 of Jens'
linux-2.6-block git:
commit 01effb0dc1451fad55925873ffbfb88fa4eadce0
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Tue May 11 08:57:42 2010 +0200

    block: allow initialization of previously allocated request_queue

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: 2.6.34-rc7/drivers/md/dm.c
===================================================================
--- 2.6.34-rc7.orig/drivers/md/dm.c
+++ 2.6.34-rc7/drivers/md/dm.c
@@ -2410,6 +2410,14 @@ struct dm_table *dm_swap_table(struct ma
 		goto out;
 	}
 
+	/* drop elevator when the device type is decided as bio-based */
+	if (!md->map && dm_table_get_type(table) == DM_TYPE_BIO_BASED) {
+		elv_unregister_queue(md->queue);
+		elevator_exit(md->queue->elevator);
+		md->queue->request_fn = NULL;
+		md->queue->elevator = NULL;
+	}
+
 	map = __bind(md, table, &limits);
 
 out:
