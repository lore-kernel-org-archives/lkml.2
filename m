Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab1F3RS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 13:18:56 -0400
Received: from mail.candelatech.com ([208.74.158.172]:58714 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab1F3RSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 13:18:54 -0400
Message-ID: <4E0CAFFC.4000902@candelatech.com>
Date: Thu, 30 Jun 2011 10:18:52 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: workqueue question.
References: <4E0A23E7.1000606@candelatech.com> <20110629084329.GI3386@htj.dyndns.org> <4E0B4C95.6080409@candelatech.com> <20110630100031.GP3386@htj.dyndns.org>
In-Reply-To: <20110630100031.GP3386@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2011 03:00 AM, Tejun Heo wrote:
> Hello,
>
> On Wed, Jun 29, 2011 at 09:02:29AM -0700, Ben Greear wrote:
>> On 06/29/2011 01:43 AM, Tejun Heo wrote:
>> It appears that the code just wants to (re)add itself to the
>> work queue with a different callback method:
>>
>> static void rpc_final_put_task(struct rpc_task *task,
>> 		struct workqueue_struct *q)
>> {
>> 	if (q != NULL) {
>> 		INIT_WORK(&task->u.tk_work, rpc_async_release);
>> 		queue_work(q,&task->u.tk_work);
>> 	} else
>> 		rpc_free_task(task);
>> }
>
> Ummm... so, at the time of INIT_WORK(), the tk_work could be already
> pending or running?

This method is indirectly called by the worker-thread.  The
trace below shows it taking the else branch, but I'm not
sure it always does so.

         __slab_free+0x57/0x150
         kfree+0x107/0x13a
         rpcb_map_release+0x3f/0x44 [sunrpc]
         rpc_release_calldata+0x12/0x14 [sunrpc]
         rpc_free_task+0x59/0x61 [sunrpc]
         rpc_final_put_task+0x82/0x8a [sunrpc]
         __rpc_execute+0x23c/0x24b [sunrpc]
         rpc_async_schedule+0x10/0x12 [sunrpc]
         process_one_work+0x230/0x41d
         worker_thread+0x133/0x217
         kthread+0x7d/0x85
         kernel_thread_helper+0x4/0x10

>> My debugging leads me to believe that the rpc_async_release
>> is (very rarely) called on a task object that has already been logically
>> freed.
>
> What do you mean "logically freed"?  Do you mean the rpc_task struct
> is freed twice?

Yes it seems so..though it's really just poked back into a mempool
instead of kfreed.

>
>> Is there a better way to queue this up that might have less chance
>> of some strange race?
>
> Why not just use a separate work item?

No idea, this is from existing net/sunrpc/* code.  If the
you think that is more proper way to do this logic, I can try that.

>>>> Also, is it valid to free the memory containing foo
>>>> in a workqueue callback?
>>>
>>> Yeap.
>>
>> Is there a method that can be called from a workqueue callback
>> to verify that the item has not been re-added to the work-queue?
>
> Can you be a bit more specific?  Are you saying that queue_work() and
> INIT_WORK() may race?

No, I don't think that is racing.  Basically, when I'm about
to logically free (put back into mempool) the task struct, I
would like to add a sanity check to make sure it's not currently
scheduled on a work queue.  If it were, that would explain the
backtraces I was seeing from slub memory debugging logic and
I'd be closer to understanding the problem.

>> I tried doing a cancel, but that caused recursive locking issues.
>>
>> I'd like to call this right before freeing the object and BUG_ON()
>> if the object is actually still on on a work-queue.
>
> That may be useful as a debugging feature but is inherently racy.
> Nothing guarantees the work item won't be queued after BUG_ON() but
> before actual freeing.  The guarantee that the work item is no longer
> in use should come from the wq user.  There are good number of use
> cases where work item frees itself or the containing data structure
> and they all work fine.

At this point I have no reason to believe the work-queues are buggy,
but due to state machines and callbacks and method pointers, it is
quite difficult to know the method flow in the rpc code.  So an
extra sanity check might be quite useful.  I'll try to code something
up for the work-queue logic when I get a chance.

Thanks,
Ben

>
> Thanks.
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

