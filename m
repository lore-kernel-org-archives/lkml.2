Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab0DAFQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 01:16:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab0DAFQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 01:16:42 -0400
Message-ID: <4BB42D05.4060207@redhat.com>
Date: Thu, 01 Apr 2010 13:20:05 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Patch] workqueue: move lockdep annotations up to	destroy_workqueue()
References: <20100331105534.5601.50813.sendpatchset@localhost.localdomain> <20100331112559.GA17747@redhat.com> <4BB408AF.4080908@redhat.com> <4BB41988.1030400@kernel.org> <4BB41C72.3090909@redhat.com> <4BB41DAE.3010605@kernel.org> <4BB420D6.7050401@redhat.com> <4BB42822.30607@kernel.org>
In-Reply-To: <4BB42822.30607@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> On 04/01/2010 01:28 PM, Cong Wang wrote:
>>> Hmmm... can you please try to see whether this circular locking
>>> warning involving wq->lockdep_map is reproducible w/ the bonding
>>> locking fixed?  I still can't see where wq -> cpu_add_remove_lock
>>> dependency is created.
>>>
>> I thought this is obvious.
>>
>> Here it is:
>>
>> void destroy_workqueue(struct workqueue_struct *wq)
>> {
>>         const struct cpumask *cpu_map = wq_cpu_map(wq);
>>         int cpu;
>>
>>         cpu_maps_update_begin();        <----------------- Hold
>> cpu_add_remove_lock here
>>         spin_lock(&workqueue_lock);
>>         list_del(&wq->list);
>>         spin_unlock(&workqueue_lock);
>>
>>         for_each_cpu(cpu, cpu_map)
>>                 cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu)); 
>> <------ See below
>>         cpu_maps_update_done();        <----------------- Release
>> cpu_add_remove_lock here
>>
>> ...
>> static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
>> {
>>         /*
>>          * Our caller is either destroy_workqueue() or CPU_POST_DEAD,
>>          * cpu_add_remove_lock protects cwq->thread.
>>          */
>>         if (cwq->thread == NULL)
>>                 return;
>>
>>         lock_map_acquire(&cwq->wq->lockdep_map); <-------------- Lockdep
>> complains here.
>>         lock_map_release(&cwq->wq->lockdep_map);
>> ...
> 
> Yeap, the above is cpu_add_remove_lock -> wq->lockdep_map dependency.
> I can see that but I'm failing to see where the dependency the other
> direction is created.
> 

Hmm, it looks like I misunderstand lock_map_acquire()? From the changelog,
I thought it was added to complain its caller is holding a lock when invoking
it, thus cpu_add_remove_lock is not an exception.

Thanks!
