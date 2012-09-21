Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab2IUSaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:30:23 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:52390 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab2IUSaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:30:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120921174952.GF7264@google.com>
References: <CAHCeSFpar4ykz5cr9dLrO5J4r3ZXkwbNkU1O3q=QZs9rFEyB6w@mail.gmail.com>
	<20120921174952.GF7264@google.com>
Date: Fri, 21 Sep 2012 19:30:21 +0100
Message-ID: <CAHCeSFo0QtOc4GYfMqJy4R60G_Yy+1psidUbZ2=ym8XWraGvcw@mail.gmail.com>
Subject: Re: Work queue questions
From: Deepawali Verma <dverma249@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Actually I want to make parallelization of one task into three tasks.
Therefore I created three single threaded work queues means divide the
task into three tasks. You are right that I can use one work queue as
well. But when I am doing three times schedule on different work
queues, I am seeing only one worker thread is processing the three
times schedule though I created three different workqueues and I
believe from previous kernel versions that there is one worker thread
associated with one queue. If one thread does this task then there is
no difference between doing the same task in one thread and using
three threads.

If we create different work queues, why always one worker thread is
processing the all tasks instead I want another two threads also work
in parallel?

Regards,
Deepa

On Fri, Sep 21, 2012 at 6:49 PM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Sep 21, 2012 at 06:35:25PM +0100, Dinky Verma wrote:
>> I have one question regarding concurrency managed workqueue. In the
>> previous kernel versions, I was using
>> create_singlethread_workqueue("driver_wq") e.g workqueue name is
>> driver_wq. In my device driver with the latest kernel version, I am
>> doing the same to have a support in my device driver for previous
>> kernel versions and new kernel version, I started using
>> alloc_workqueue (in intention to create single threaded workqueue)
>> e.g.
>>
>> wq = alloc_workqueue("driver_wq", WQ_UNBOUND,1);
>>
>> create_singlethread_workqueue (Depricated) and alloc_workqueue creates
>> work queue both work on the newer kernel versions.
>
> You can use alloc_ordered_workqueue() instead but do you really need
> strict ordering among different work items?  If not, it's likely that
> you don't need to create separate workqueues at all.
>
>> I have created 3 single threaded workqueues. when I do ps on linux
>> console, I see the workqueue thread with process id. When I am queuing
>> the work simultaneously on these worker threads, I found that threads
>> named with Kworker/X.Y will process the work from the work queue not
>> the one that had been created create_singlethread_workqueue.
>>
>> When I schedule the three works at the same time, I saw sometimes one
>> Kworker/X.Y thread processes all work items.
>>
>> The question is why the main worker thread that I created does not
>> process the work that is intended for it why instead kworker will
>> process it? I have queued the work using queue_work(wq,
>> worker_struct).
>
> The kthread named after the workqueue is the rescuer which kicks in
> iff work execution can't make forward progress due to memory pressure.
> Normally all work items are served by worker threads in shared worker
> pool.  What kind of driver is it?  Does it sit in memory reclaim path?
>
> Thanks.
>
> --
> tejun
