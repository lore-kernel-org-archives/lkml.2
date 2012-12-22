Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab2LVUTZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 15:19:25 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:48266 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab2LVUTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 15:19:22 -0500
Message-ID: <50D61561.7090805@linux.vnet.ibm.com>
Date: Sun, 23 Dec 2012 01:47:37 +0530
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
x-cbid: 12122220-0260-0000-0000-00000253627F
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
>>> To me, the main question is: can we use synchronize_sched() in cpu_down?
>>> It is slow.
>>>
>>
>> Haha :-) So we don't want smp_mb() in the reader,
> 
> We need mb() + rmb(). Plust cli/sti unless this arch has optimized
> this_cpu_add() like x86 (as you pointed out).
> 

Hey, IIUC, we actually don't need mb() in the reader!! Just an rmb() will do.

This is the reader code I have so far:

#define reader_nested_percpu()						\
	     (__this_cpu_read(reader_percpu_refcnt) & READER_REFCNT_MASK)

#define writer_active()							\
				(__this_cpu_read(writer_signal))


#define READER_PRESENT		(1UL << 16)
#define READER_REFCNT_MASK	(READER_PRESENT - 1)

void get_online_cpus_atomic(void)
{
	preempt_disable();

	/*
	 * First and foremost, make your presence known to the writer.
	 */
	this_cpu_add(reader_percpu_refcnt, READER_PRESENT);

	/*
	 * If we are already using per-cpu refcounts, it is not safe to switch
	 * the synchronization scheme. So continue using the refcounts.
	 */
	if (reader_nested_percpu()) {
		this_cpu_inc(reader_percpu_refcnt);
	} else {
		smp_rmb();
		if (unlikely(writer_active())) {
			... //take hotplug_rwlock
		}
	}

	...

	/* Prevent reordering of any subsequent reads of cpu_online_mask. */
	smp_rmb();
}

The smp_rmb() before writer_active() ensures that LOAD(writer_signal) follows
LOAD(reader_percpu_refcnt) (at the 'if' condition). And in turn, that load is
automatically going to follow the STORE(reader_percpu_refcnt) (at this_cpu_add())
due to the data dependency. So it is something like a transitive relation.

So, the result is that, we mark ourselves as active in reader_percpu_refcnt before
we check writer_signal. This is exactly what we wanted to do right?
And luckily, due to the dependency, we can achieve it without using the heavy
smp_mb(). And, we can't crib about the smp_rmb() because it is unavoidable anyway
(because we want to prevent reordering of the reads to cpu_online_mask, like you
pointed out earlier).

I hope I'm not missing anything...

Regards,
Srivatsa S. Bhat

