Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab2EWIlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:41:21 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33537 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab2EWIlO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:41:14 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1205221142570.2100-100000@iolanthe.rowland.org>
References: <CAF1ivSYVznOU43XT9_5d-EMNp1TQwBiYfG=PL6J1KPdmQx9pgw@mail.gmail.com>
	<Pine.LNX.4.44L0.1205221142570.2100-100000@iolanthe.rowland.org>
Date: Wed, 23 May 2012 16:41:13 +0800
X-Google-Sender-Auth: vHNeZk8JTWqCAFil39piXQuWlWQ
Message-ID: <CAF1ivSa_hYFu2JXLUOv2k+AhqUZWUvY-uzmocQKh_RUJJUP5Ag@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 11:56 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 22 May 2012, Lin Ming wrote:
>
>> > (Or maybe it would be easier to make q->rpm_status be a pointer to
>> > q->dev->power.rpm_status.  That way, if CONFIG_PM_RUNTIME isn't enabled
>> > or block_runtime_pm_init() hasn't been called, you can have
>> > q->rpm_status simply point to a static value that is permanently set to
>> > RPM_ACTIVE.)
>>
>> I think we need q->rpm_status.
>> Block layer check ->rpm_status and client driver set this status.
>
> No, the client driver should not have to set any status values.  The
> client driver should do as little as possible.

Ah, I mean runtime pm core will set the status, not the client driver.

>
>> And the status is synchronized with queue's spin lock.
>
> Right, and the client driver should not need to acquire the queue's
> lock.
>
>> If we use q->dev->power.rpm_status then how to sync it between block
>> layer and client driver?
>> Do you mean block layer will need to acquire q->dev->power.lock?
>
> That's not what I mean.
>
> What synchronization are you concerned about?  The most important race

Let's consider below code.

@@ -587,6 +591,11 @@ void __elv_add_request(struct request_queue *q,
struct request *rq, int where)
 {
       trace_block_rq_insert(q, rq);

+       if (!(rq->cmd_flags & REQ_PM))
+               if (q->nr_pending++ == 0 && (q->rpm_status == RPM_SUSPENDED ||
+                               q->rpm_status == RPM_SUSPENDING) && q->dev)
+                       pm_request_resume(q->dev);
+
       rq->q = q;

       if (rq->cmd_flags & REQ_SOFTBARRIER) {

Block layer reads runtime status and pm core writes this status.
PM core uses dev->power.lock to protect this status.

I was thinking will it have problem if block layer does not acquire
dev->power.lock?
>From your explanation below, it seems does not have problem.

Thanks,
Lin Ming

> seems to be when a new request is added to the queue at the same time
> as a runtime suspend begins.
>
> If q->dev->power.rpm_status has already been set to RPM_SUSPENDING or
> RPM_SUSPENDED when the request is submitted, the block layer should
> call pm_runtime_request_resume().  Thus if the suspend succeeds, the
> device will be resumed immediately afterward.  And if the suspend
> fails, the new request will be handled as usual (note that the
> block_*_runtime_* routines might need to kick-start the queue to get it
> going again).
>
> Alternatively, if q->dev->power.rpm_status is still equal to RPM_ACTIVE
> when the request is submitted, the block layer will simply accept the
> request.  If the request is still on the queue when
> block_pre_runtime_suspend is called, it will return -EBUSY and the
> suspend will fail.
>
> The only synchronization needed to make this work is that the
> block_{pre,post}_runtime_suspend routines need to hold the queue's lock
> while checking to see if any requests are in the queue.  You'd expect
> that anyway.
>
> Alan Stern
