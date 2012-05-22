Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab2EVGND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 02:13:03 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35852 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab2EVGNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 02:13:00 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1205171346070.1169-100000@iolanthe.rowland.org>
References: <1337269686-3781-3-git-send-email-ming.m.lin@intel.com>
	<Pine.LNX.4.44L0.1205171346070.1169-100000@iolanthe.rowland.org>
Date: Tue, 22 May 2012 14:12:58 +0800
X-Google-Sender-Auth: 6_re_dSWa5NTwxmmWZMzW7jiSGI
Message-ID: <CAF1ivSYVznOU43XT9_5d-EMNp1TQwBiYfG=PL6J1KPdmQx9pgw@mail.gmail.com>
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

On Fri, May 18, 2012 at 2:29 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 17 May 2012, Lin Ming wrote:
>
>> Add runtime pm suspend/resume callbacks to request queue.
>> As an example, implement these callbacks in sd driver.
>
> This is not the way to do it.  The block subsystem should not use
> suspend/resume callbacks.
>
> Instead, there should be block functions that can be called by client
> drivers: block_pre_runtime_suspend, block_post_runtime_suspend,
> bock_pre_runtime_resume, and block_post_runtime_resume.
>
> They should do something like this:
>
>        block_pre_runtime_suspend:
>                If any requests are in the queue, return -EBUSY.
>                Otherwise set q->rpm_status to RPM_SUSPENDING and
>                return 0.
>
>        block_post_runtime_suspend:
>                If the suspend succeeded then set q->rpm_status to
>                RPM_SUSPENDED.  Otherwise set it to RPM_ACTIVE and
>                call pm_runtime_mark_last_busy().
>
>        block_pre_runtime_resume:
>                Set q->rpm_status to RPM_RESUMING.
>
>        block_post_runtime_resume:
>                If the resume succeeded then set q->rpm_status to
>                RPM_ACTIVE and call pm_runtime_mark_last_busy() and
>                pm_runtime_request_autosuspend().
>                Otherwise set q->rpm_status to RPM_SUSPENDED.
>
> There should also be an initialization function for client drivers to
> call.  block_runtime_pm_init() should call pm_runtime_mark_last_busy(),
> pm_runtime_use_autosuspend(), and pm_runtime_autosuspend().
>
> Next, you have to modify the parts of the block layer that run when a
> new request is added to the queue or a request is removed.
>
>        When a request is added:
>                If q->rpm_status is RPM_SUSPENDED, or if q->rpm_status
>                is RPM_SUSPENDING and the REQ_PM flag isn't set, call
>                pm_runtime_request_resume().
>
>        When a request finishes:
>                Call pm_runtime_mark_last_busy().
>
> Next, you have to change the parts of the block layer responsible for
> taking a request from the queue and handing it to the lower-level
> driver (both peek and get).  If q->rpm_status is RPM_SUSPENDED, they
> shouldn't do anything -- act as though the queue is empty.  If
> q->rpm_status is RPM_SUSPENDING or RPM_RESUMING, they should hand over
> the request only if it has the REQ_PM flag set.
>
> For this to work, the block layer has to know what struct device
> pointer to pass to the pm_runtime_* routines.  You'll have to add that
> information to the request_queue structure; I guess q->dev can get set
> by block_pm_runtime_init().  In fact, when that's done you won't need
> q->rpm_status any more.  You'll be able to use c
> directly, and you won't have to update it because the PM core does that
> for you.
>
> (Or maybe it would be easier to make q->rpm_status be a pointer to
> q->dev->power.rpm_status.  That way, if CONFIG_PM_RUNTIME isn't enabled
> or block_runtime_pm_init() hasn't been called, you can have
> q->rpm_status simply point to a static value that is permanently set to
> RPM_ACTIVE.)

I think we need q->rpm_status.
Block layer check ->rpm_status and client driver set this status.
And the status is synchronized with queue's spin lock.

If we use q->dev->power.rpm_status then how to sync it between block
layer and client driver?
Do you mean block layer will need to acquire q->dev->power.lock?

Lin Ming

>
> I may have left some parts out from this brief description.  Hopefully
> you'll be able to figure out the general idea and get it to work.
>
> Alan Stern
