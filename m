Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab2LLScw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:32:52 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:57297 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab2LLScv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:32:51 -0500
Message-ID: <50C8CD52.8040808@linux.vnet.ibm.com>
Date: Thu, 13 Dec 2012 00:00:42 +0530
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
References: <20121211140314.23621.64088.stgit@srivatsabhat.in.ibm.com> <20121211140358.23621.97011.stgit@srivatsabhat.in.ibm.com> <20121212171720.GA22289@redhat.com> <50C8C4A5.4080104@linux.vnet.ibm.com> <20121212180248.GA24882@redhat.com>
In-Reply-To: <20121212180248.GA24882@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121218-1618-0000-0000-00000303C50D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 11:32 PM, Oleg Nesterov wrote:
> On 12/12, Srivatsa S. Bhat wrote:
>>
>> On 12/12/2012 10:47 PM, Oleg Nesterov wrote:
>>>
>>> Why it needs to be per-cpu? It can be global and __read_mostly to avoid
>>> the false-sharing. OK, perhaps to put reader_percpu_refcnt/writer_signal
>>> into a single cacheline...
>>
>> Even I realized this (that we could use a global) after posting out the
>> series.. But do you think that it would be better to retain the per-cpu
>> variant itself, due to the cache effects?
> 
> I don't really know, up to you. This was the question ;)

OK :-)

> 
>>> Do we really need local_irq_save/restore in put_ ?
>>>
>>
>> Hmm.. good point! I don't think we need it.
> 
> And _perhaps_ get_ can avoid it too?
> 
> I didn't really try to think, probably this is not right, but can't
> something like this work?
> 
> 	#define XXXX	(1 << 16)
> 	#define MASK	(XXXX -1)
> 
> 	void get_online_cpus_atomic(void)
> 	{
> 		preempt_disable();
> 
> 		// only for writer
> 		__this_cpu_add(reader_percpu_refcnt, XXXX);
> 
> 		if (__this_cpu_read(reader_percpu_refcnt) & MASK) {
> 			__this_cpu_inc(reader_percpu_refcnt);
> 		} else {
> 			smp_wmb();
> 			if (writer_active()) {
> 				...
> 			}
> 		}
> 
> 		__this_cpu_dec(reader_percpu_refcnt, XXXX);
> 	}
> 

Sorry, may be I'm too blind to see, but I didn't understand the logic
of how the mask helps us avoid disabling interrupts.. Can you kindly
elaborate?

> 	void put_online_cpus_atomic(void)
> 	{
> 		if (__this_cpu_read(reader_percpu_refcnt) & MASK)
> 			__this_cpu_dec(reader_percpu_refcnt);
> 		else
> 			read_unlock(&hotplug_rwlock);
> 		preempt_enable();
> 	}
> 

Regards,
Srivatsa S. Bhat

