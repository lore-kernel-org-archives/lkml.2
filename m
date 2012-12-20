Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab2LTOIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 09:08:46 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:40443 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab2LTOIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 09:08:43 -0500
Message-ID: <50D31B81.4090601@linux.vnet.ibm.com>
Date: Thu, 20 Dec 2012 19:36:57 +0530
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
References: <20121212180248.GA24882@redhat.com> <50C8CD52.8040808@linux.vnet.ibm.com> <20121212184849.GA26784@redhat.com> <50C8D739.6030903@linux.vnet.ibm.com> <50C9F38F.3020005@linux.vnet.ibm.com> <50D0CCB3.10105@linux.vnet.ibm.com> <20121219163900.GA18516@redhat.com> <50D2047A.1040606@linux.vnet.ibm.com> <20121219191436.GA25829@redhat.com> <50D21A5F.4040604@linux.vnet.ibm.com> <20121220134203.GB10813@redhat.com>
In-Reply-To: <20121220134203.GB10813@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12122014-4790-0000-0000-00000621114A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 07:12 PM, Oleg Nesterov wrote:
> On 12/20, Srivatsa S. Bhat wrote:
>>
>> On 12/20/2012 12:44 AM, Oleg Nesterov wrote:
>>>
>>> We need 2 helpers for writer, the 1st one does synchronize_sched() and the
>>> 2nd one takes rwlock. A generic percpu_write_lock() simply calls them both.
>>>
>>
>> Ah, that's the problem no? Users of reader-writer locks expect to run in
>> atomic context (ie., they don't want to sleep).
> 
> Ah, I misunderstood.
> 
> Sure, percpu_write_lock() should be might_sleep(), and this is not
> symmetric to percpu_read_lock().
> 
>> We can't expose an API that
>> can make the task go to sleep under the covers!
> 
> Why? Just this should be documented. However I would not worry until we
> find another user. Until then we do not even need to add percpu_write_lock
> or try to generalize this code too much.
> 

Hmm.. But considering the disable_nonboot_cpus() case you mentioned below, I'm
only getting farther away from using synchronize_sched() ;-) And that also makes
it easier to expose a generic percpu rwlock API, like Tejun was suggesting.
So I'll give it a shot.

>>> To me, the main question is: can we use synchronize_sched() in cpu_down?
>>> It is slow.
>>>
>>
>> Haha :-) So we don't want smp_mb() in the reader,
> 
> We need mb() + rmb(). Plust cli/sti unless this arch has optimized
> this_cpu_add() like x86 (as you pointed out).
> 
>> *and* also don't want
>> synchronize_sched() in the writer! Sounds like saying we want to have the cake
>> and eat it too ;-) :P
> 
> Personally I'd vote for synchronize_sched() but I am not sure. And I do
> not really understand the problem space.
> 
>> And moreover, since I'm still not convinced about the writer API part if use
>> synchronize_sched(), I'd rather avoid synchronize_sched().)
> 
> Understand.
> 
> And yes, synchronize_sched() adds more problems. For example, where should
> we call it? I do not this _cpu_down() should do this, in this case, say,
> disable_nonboot_cpus() needs num_online_cpus() synchronize_sched's.
> 

Ouch! I should have seen that coming!

> So probably cpu_down() should call it before cpu_maps_update_begin(), this
> makes the locking even less obvious.
> 

True.

> In short. What I am trying to say is, don't ask me I do not know ;)
>

OK then, I'll go with what I believe is a reasonably good way (not necessarily
the best way) to deal with this:

I'll avoid the use of synchronize_sched(), expose a decent-looking percpu
rwlock implementation, use it in CPU hotplug and get rid of stop_machine().
That would certainly be a good starting base, IMHO.

Regards,
Srivatsa S. Bhat

