Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab2IVEYz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 00:24:55 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51098 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2IVEYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 00:24:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAHCeSFrN6VketFq3vmA1S0O1GTOGNW41ZirZs5dGkiTXLbizkA@mail.gmail.com>
References: <CAHCeSFpar4ykz5cr9dLrO5J4r3ZXkwbNkU1O3q=QZs9rFEyB6w@mail.gmail.com>
	<20120921174952.GF7264@google.com>
	<CAHCeSFo0QtOc4GYfMqJy4R60G_Yy+1psidUbZ2=ym8XWraGvcw@mail.gmail.com>
	<20120921183515.GI7264@google.com>
	<CAHCeSFpa28d-7ruMKSw6z2EYKYN-5udVouUJOi4cnj4dPad-TA@mail.gmail.com>
	<20120921192720.GJ7264@google.com>
	<CAHCeSFrN6VketFq3vmA1S0O1GTOGNW41ZirZs5dGkiTXLbizkA@mail.gmail.com>
Date: Sat, 22 Sep 2012 09:54:53 +0530
Message-ID: <CAK7N6vpuJnnAp2xCUG_20aSVzT9aXhZRFrkVtfO3qOKE7gZ0Eg@mail.gmail.com>
Subject: Re: Work queue questions
From: anish singh <anish198519851985@gmail.com>
To: Deepawali Verma <dverma249@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 1:05 AM, Deepawali Verma <dverma249@gmail.com> wrote:
> Hi Tajun,
>
> These three tasks are writing the three chunks of data in parallel. I
> am not getting improvement here otherwise what is difference between
> writing these chunks one by one in single thread instead of trying to
> write the data by scheduling the work on three different workqueues
> means 3 worker threads?
You should have carefully read "If none of them blocks, there
isn't much point in throwing more threads at them.  What are those
thread doing?" what Tejun said.

I think what he means is that concurrency is the concept of keeping the
system busy.
If you see the below logs:
kworker/u:1-21    [000]   110.964895: task_event: MYTASKJOB2381 XStarted
kworker/u:1-21    [000]   110.964909: task_event: MYTASKJOB2381 Xstopped
Here your first worker thread blocked.

So the system will try to get other workqueue started which is:
kworker/u:1-21    [000]   110.965137: task_event: MYTASKJOB2382 XStarted
kworker/u:1-21    [000]   110.965154: task_event: MYTASKJOB2382 Xstopped
Here again your second worker thread blocked.

So on so forth.
Anyway how can you write chunks of data in parallel when already some worker
thread is writing i.e. the system is busy.
Analogy: Suppose you are ambidextrous and you are eating.Can you eat with
both of your hands at a time?So worker thread are like your hands and keeping
you fed all the time is the concept of concurrency.

I am not an expert on this but from Tejun's reply I could make out this.
Please correct me If I have wrongly understood the concept based on this mail
chain.
>
> Regards,
> Deepa
>
> On Fri, Sep 21, 2012 at 8:27 PM, Tejun Heo <tj@kernel.org> wrote:
>> On Fri, Sep 21, 2012 at 08:26:01PM +0100, Deepawali Verma wrote:
>>>      kworker/u:1-21    [000]   110.964895: task_event: MYTASKJOB2381 XStarted
>>>      kworker/u:1-21    [000]   110.964909: task_event: MYTASKJOB2381 Xstopped
>>>      kworker/u:1-21    [000]   110.965137: task_event: MYTASKJOB2382 XStarted
>>>      kworker/u:1-21    [000]   110.965154: task_event: MYTASKJOB2382 Xstopped
>>>      kworker/u:5-3724  [000]   110.965311: task_event: MYTASKJOB2383 XStarted
>>>      kworker/u:5-3724  [000]   110.965325: task_event: MYTASKJOB2383 Xstopped
>>>
>>> I have this one big task to whom I divided into small sub tasks. These
>>> are numbered 2381, 2382 and 2383, what was I expecting that task 2381,
>>> 2382, 2383 run in parallel. I have put start and stop markers here so
>>> that I can see how this concurrency managed work queue is distributing
>>> the load.
>>>
>>> I found that task no 2381 is started first and exited before starting
>>> task 2382 and so on. What I expected that it should start the three
>>> sub tasks in parallel, not one by one.
>>>
>>> Where is concurrency here?
>>
>> If none of them blocks, there isn't much point in throwing more
>> threads at them.  What are those thread doing?
>>
>> Thanks.
>>
>> --
>> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
