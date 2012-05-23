Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183Ab2EWIXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:23:23 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34455 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab2EWIXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:23:19 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1205221210360.2100-100000@iolanthe.rowland.org>
References: <1337671292-15583-4-git-send-email-ming.m.lin@intel.com>
	<Pine.LNX.4.44L0.1205221210360.2100-100000@iolanthe.rowland.org>
Date: Wed, 23 May 2012 16:23:18 +0800
X-Google-Sender-Auth: 0HdRVqMlcPh9yGxVQpUilWUqeP4
Message-ID: <CAF1ivSbukHBZJsguAcUVDbQotyvE5iAfccgfv+-bGw1v6Z3Dvw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/4] block: implement runtime pm strategy
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 12:14 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 22 May 2012, Lin Ming wrote:
>
>> When a request is added:
>>     If device is suspended or is suspending and the request is not a
>>     PM request, resume the device.
>>
>> When a request finishes:
>>     Call pm_runtime_mark_last_busy().
>>
>> When pick a request:
>>     If device is not active, then only PM request is allowed to go.
>>     Return NULL for other request.
>
> You've got the right idea.  There are a few things that need fixing, in
> this patch and in 4/4.
>
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -1130,6 +1130,10 @@ void __blk_put_request(struct request_queue *q, struct request *req)
>>       if (unlikely(--req->ref_count))
>>               return;
>>
>> +     /* PM request is not accounted */
>> +     if (!(req->cmd_flags & REQ_PM) && !(--q->nr_pending) && q->dev)
>
> I don't see that it makes any difference.  You might as well count PM
> requests along with the others, here and elsewhere.

Need to think about this.

>
>> +             pm_runtime_mark_last_busy(q->dev);
>> +
>>       elv_completed_request(q, req);
>>
>>       /* this is a bio leak */
>> @@ -1918,6 +1922,12 @@ struct request *blk_peek_request(struct request_queue *q)
>>       int ret;
>>
>>       while ((rq = __elv_next_request(q)) != NULL) {
>> +             /* Only PM request is allowed to go if the queue is suspended */
>> +             if (q->rpm_status != RPM_ACTIVE && !(rq->cmd_flags & REQ_PM)) {
>> +                     rq = NULL;
>> +                     break;
>> +             }
>
> Not even PM requests should be allowed to go if the status is
> RPM_SUSPENDED.

PM requests are used to wake up the device.
If they are not allowed to go, then how to wake up the device?

>
> Is this the only interface by which a client driver can get a request
> from the queue?

I searched __elv_next_request and it's only called in blk_peek_request.

Jens,
Could you confirm this?

Thanks,
Lin Ming

>
> Alan Stern
