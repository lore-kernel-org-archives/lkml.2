Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab1IUQYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 12:24:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53843 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab1IUQYC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 12:24:02 -0400
MIME-Version: 1.0
In-Reply-To: <20110921155444.GA27121@suse.de>
References: <1316619573-9104-1-git-send-email-consul.kautuk@gmail.com>
	<20110921155444.GA27121@suse.de>
Date: Wed, 21 Sep 2011 21:54:01 +0530
Message-ID: <CAFPAmTR1bHBronJqVWh_osjJvsPi_gWqJ50Ls-WgCi7CMAViUA@mail.gmail.com>
Subject: Re: [PATCH 1/1] Trivial: devtmpfsd: Setting task running/interruptible
 states
From: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Jiri Kosina <trivial@kernel.org>, jkosina@suse.cz,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, Sep 21, 2011 at 9:24 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Sep 21, 2011 at 09:09:33PM +0530, Kautuk Consul wrote:
>> This trivial patch makes the following changes in devtmpfsd() :
>
> This is not the definition of "trivial" in that you are changing the
> logic of the code, not just doing spelling changes.

Well, I didn't really change the performance/functionality so I called
it trivial.

>
>> - Set the state to TASK_INTERRUPTIBLE using __set_current_state
>>   instead of set_current_state as the spin_unlock is an implicit
>>   memory barrier.
>
> Why?  What is this hurting with the original code?

Nothing really hurting, that's why I called this patch trivial.
There is an extra memory barrier we have to go through by way of
set_current_state, which is mb().
That would lead to more overhead on the parallel pipelines of the processor
as they will have to cease being parallel for instructions before and after
the memory barrier despite the fact that the spin_unlock already covers this.
We can do without this because as per the Documentation/memory-barriers.txt,
atomic operations and unlocks give reliable ordering to instructions.

>
>> - After return from schedule(), there is no need to set the current
>>   state to TASK_RUNNING as the wake_up_process() function call will
>>   do this for us.
>
> Are you sure?

Yes. wake_up_process()->ttwu_queue()->ttwu_do_activate()->ttwu_do_wakeup()
will set the task state to TASK_RUNNING. Before that,
ttwu_activate()->activate_task()->enqueue_task() will have put the task struct
onto the run-queue.

Of course, the rq->lock is held during this which does not allow there
to be any race
conditions between the above process and the task actually waking up on a CPU
and then proceeding to execute without its task state set to TASK_RUNNING.

>
> Have you tested this patch and everything works properly?

Yes. It does so on my system. But I did not try any stress tests.
If you want me to try out any stress test cases I can do so, but I was
convinced after reading the code, documentation and creating a
separate kernel module
with a thread and this kind of state setting behavior and things
seemed fine then in the sense
that the thread did not sleep due to the task state being continued to
be set to
TASK_INTERRUPTIBLE after returning from the schedule() function.

Please correct me if I am wrong in any technical assumptions or any point which
I might have overlooked.

>
> greg k-h
>
