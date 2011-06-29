Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab1F2QJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:09:03 -0400
Received: from mail.candelatech.com ([208.74.158.172]:52016 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab1F2QI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:08:59 -0400
Message-ID: <4E0B4C95.6080409@candelatech.com>
Date: Wed, 29 Jun 2011 09:02:29 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: workqueue question.
References: <4E0A23E7.1000606@candelatech.com> <20110629084329.GI3386@htj.dyndns.org>
In-Reply-To: <20110629084329.GI3386@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 01:43 AM, Tejun Heo wrote:
> Hello,
>
> On Tue, Jun 28, 2011 at 11:56:39AM -0700, Ben Greear wrote:
>> Is it OK to call INIT_WORK(&foo, bar)
>> if we are currently being called by the work-queue
>> using foo?
>
> Yes, but if flush_work*() races with it, flushing can finish before
> execution is complete.

It appears that the code just wants to (re)add itself to the
work queue with a different callback method:

static void rpc_final_put_task(struct rpc_task *task,
		struct workqueue_struct *q)
{
	if (q != NULL) {
		INIT_WORK(&task->u.tk_work, rpc_async_release);
		queue_work(q, &task->u.tk_work);
	} else
		rpc_free_task(task);
}

My debugging leads me to believe that the rpc_async_release
is (very rarely) called on a task object that has already been logically
freed.

Is there a better way to queue this up that might have less chance
of some strange race?

>
>> Also, is it valid to free the memory containing foo
>> in a workqueue callback?
>
> Yeap.

Is there a method that can be called from a workqueue callback
to verify that the item has not been re-added to the work-queue?

I tried doing a cancel, but that caused recursive locking issues.

I'd like to call this right before freeing the object and BUG_ON()
if the object is actually still on on a work-queue.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

