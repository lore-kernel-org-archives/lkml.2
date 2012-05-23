Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738Ab2EWP7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:59:11 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43190 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab2EWP7I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:59:08 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1205231054150.1566-100000@iolanthe.rowland.org>
References: <CAF1ivSa_hYFu2JXLUOv2k+AhqUZWUvY-uzmocQKh_RUJJUP5Ag@mail.gmail.com>
	<Pine.LNX.4.44L0.1205231054150.1566-100000@iolanthe.rowland.org>
Date: Wed, 23 May 2012 23:59:07 +0800
X-Google-Sender-Auth: 6ynRP9SY0HtKZZyvitfoBFJueew
Message-ID: <CAF1ivSbSv+pWFxgf8LrHdamxSQZuJh5S5_0L82DWfy34Si7iLg@mail.gmail.com>
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

On Wed, May 23, 2012 at 10:58 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 23 May 2012, Lin Ming wrote:
>
>> Let's consider below code.
>>
>> @@ -587,6 +591,11 @@ void __elv_add_request(struct request_queue *q,
>> struct request *rq, int where)
>>  {
>>        trace_block_rq_insert(q, rq);
>>
>> +       if (!(rq->cmd_flags & REQ_PM))
>> +               if (q->nr_pending++ == 0 && (q->rpm_status == RPM_SUSPENDED ||
>> +                               q->rpm_status == RPM_SUSPENDING) && q->dev)
>> +                       pm_request_resume(q->dev);
>> +
>>        rq->q = q;
>>
>>        if (rq->cmd_flags & REQ_SOFTBARRIER) {
>>
>> Block layer reads runtime status and pm core writes this status.
>> PM core uses dev->power.lock to protect this status.
>>
>> I was thinking will it have problem if block layer does not acquire
>> dev->power.lock?
>> From your explanation below, it seems does not have problem.
>
> I don't think it's a problem, because all you're doing is reading
> dev->power.rpm_status -- you're not writing it.
>
> On the other hand, there's nothing really wrong with keeping your own
> local copy of rpm_status.  You could think of it as being the queue's
> status as opposed to the device's status.  (Also, some people might
> argue that dev->power.rpm_status is supposed to be private to the
> runtime PM core and shouldn't be used by other code.)

Agree.
So I'd like to keep local copy of rpm_status.
