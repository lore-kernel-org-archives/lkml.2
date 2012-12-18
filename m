Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2LRUHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 15:07:50 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:36556 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab2LRUHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 15:07:49 -0500
Message-ID: <50D0CCB3.10105@linux.vnet.ibm.com>
Date: Wed, 19 Dec 2012 01:36:11 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/9] CPU hotplug: Provide APIs to prevent CPU offline
 from atomic context
References: <50C8C4A5.4080104@linux.vnet.ibm.com> <20121212180248.GA24882@redhat.com> <50C8CD52.8040808@linux.vnet.ibm.com> <20121212184849.GA26784@redhat.com> <50C8D739.6030903@linux.vnet.ibm.com> <50C9F38F.3020005@linux.vnet.ibm.com> <20121213161709.GA19125@redhat.com> <50CA0317.90501@linux.vnet.ibm.com> <20121214180345.GA22024@redhat.com> <50D09180.4080703@linux.vnet.ibm.com> <20121218194357.GA27972@redhat.com>
In-Reply-To: <20121218194357.GA27972@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121820-5564-0000-0000-000005D9BCA0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 01:13 AM, Oleg Nesterov wrote:
> On 12/18, Srivatsa S. Bhat wrote:
>>
>> So now that we can't avoid disabling and enabling interrupts,
> 
> Still I think it would be better to not use local_irq_save/restore
> directly.

Sure, we can use this_cpu_add() itself. I explicitly used
local_irq_save/restore here just to explain my question.

> And,
> 
>> I was
>> wondering if we could exploit this to avoid the smp_mb()..
>>
>> Maybe this is a stupid question, but I'll shoot it anyway...
>> Does local_irq_disable()/enable provide any ordering guarantees by any chance?
> 
> Oh, I do not know.
> 
> But please look at the comment above prepare_to_wait(). It assumes
> that even spin_unlock_irqrestore() is not the full barrier.
> 

Semi-permeable barrier.. Hmm.. 

> In any case. get_online_cpus_atomic() has to use irq_restore, not
> irq_enable. And _restore does nothing "special" if irqs were already
> disabled, so I think we can't rely on sti.
> 

Right, I forgot about the _restore part.

>> I tried thinking about other ways to avoid that smp_mb() in the reader,
> 
> Just in case, I think there is no way to avoid mb() in _get (although
> perhaps it can be "implicit").
> 

Actually, I was trying to avoid mb() in the _fastpath_, when there is no
active writer. I missed stating that clearly, sorry.

> The writer changes cpu_online_mask and drops the lock. We need to ensure
> that the reader sees the change in cpu_online_mask after _get returns.
> 

The write_unlock() will ensure the completion of the update to cpu_online_mask,
using the same semi-permeable logic that you pointed above. So readers will
see the update as soon as the writer releases the lock, right?

>> but was unsuccessful. So if the above assumption is wrong, I guess we'll
>> just have to go with the version that uses synchronize_sched() at the
>> writer-side.
> 
> In this case we can also convert get_online_cpus() to use percpu_rwsem
> and avoid mutex_lock(&cpu_hotplug.lock), but this is minor I guess.
> I do not think get_online_cpus() is called too often.
> 

Yes, we could do that as well. I remember you saying that you had some
patches for percpu_rwsem to help use it in cpu hotplug code (to make it
recursive, IIRC).

So, I guess we'll go with the synchronize_sched() approach for percpu rwlocks
then. Tejun, it is still worthwhile to expose this as a generic percpu rwlock
and then use it inside cpu hotplug code, right?


Regards,
Srivatsa S. Bhat

