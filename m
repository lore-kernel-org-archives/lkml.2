Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab1L1VHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 16:07:55 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51323 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab1L1VHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 16:07:53 -0500
Message-ID: <4EFB8523.6080708@gmail.com>
Date: Wed, 28 Dec 2011 16:07:47 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Yasunori Goto <y-goto@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
References: <1324633794.24803.48.camel@twins> <20111223154137.GA27901@redhat.com> <20111226172357.CE4D.E1E9C6FF@jp.fujitsu.com> <20111226171151.GA4472@redhat.com>
In-Reply-To: <20111226171151.GA4472@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(12/26/11 12:11 PM), Oleg Nesterov wrote:
> On 12/26, Yasunori Goto wrote:
>>
>>>
>>> IIRC, this was already discussed a bit. Say, try_to_wake_up(TASK_INTERRUPTIBLE)
>>> can wakeup a TASK_UNINTERRUPTIBLE task if it temporary sets INTERRUPTIBLE but
>>> doesn't call schedule() in this state.
>>
>> Oleg-san,
>>
>> Could you point the discussion?
>> I don't understand yet how it occurred...
>
> Suppose that the task T does
>
> 	set_current_state(TASK_INTERRUPTIBLE);
>
> 	set_current_state(TASK_UNINTERRUPTIBLE);
> 	schedule();
>
> try_to_wake_up(TASK_UNINTERRUPTIBLE) in between can observe this task
> in TASK_INTERRUPTIBLE state. Then it can set RUNNING/WAKING after T
> sets ->state = TASK_UNINTERRUPTIBLE.
>
> For example, this is possibly if T simply does wait_event() twice when
> the the 1st wait_event() doesn't sleep.
>
> Basically this is the same race you described, but I think you found
> the case when we can't tolerate the spurious wakeup.

Hi

I looked at scheduler code today briefly. now I'm afraid following code 
have similar race.


         if (task_contributes_to_load(p))
                 rq->nr_uninterruptible--;



Can't following schenario be happen?


CPU0                    CPU1
--------------------------------------------------------
deactivate_task()
                        task->state = TASK_UNINTERRUPTIBLE;
activate_task()
   rq->nr_uninterruptible--;

                        schedule()
                          deactivate_task()
                            rq->nr_uninterruptible++;

Totally, nr_uninterruptible wasn't incremented.


I'm still not sure. I need to read more sched code.



