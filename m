Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2LLRzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 12:55:37 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:45725 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab2LLRzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 12:55:35 -0500
Message-ID: <50C8C4A5.4080104@linux.vnet.ibm.com>
Date: Wed, 12 Dec 2012 23:23:41 +0530
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
References: <20121211140314.23621.64088.stgit@srivatsabhat.in.ibm.com> <20121211140358.23621.97011.stgit@srivatsabhat.in.ibm.com> <20121212171720.GA22289@redhat.com>
In-Reply-To: <20121212171720.GA22289@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121217-6102-0000-0000-000002B4AE72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 10:47 PM, Oleg Nesterov wrote:
> On 12/11, Srivatsa S. Bhat wrote:
>>
>> IOW, the hotplug readers just increment/decrement their per-cpu refcounts
>> when no writer is active.
> 
> plus cli/sti ;)

Of course, forgot to mention it, again! :)

> and increment/decrement are atomic.
> 
> At first glance looks correct to me, but I'll try to read it carefully
> later.
> 
> A couple of minor nits,
> 
>> +static DEFINE_PER_CPU(bool, writer_signal);
> 
> Why it needs to be per-cpu? It can be global and __read_mostly to avoid
> the false-sharing. OK, perhaps to put reader_percpu_refcnt/writer_signal
> into a single cacheline...
> 

Even I realized this (that we could use a global) after posting out the
series.. But do you think that it would be better to retain the per-cpu
variant itself, due to the cache effects?

>> +void get_online_cpus_atomic(void)
>> +{
>> +	unsigned long flags;
>> +
>> +	preempt_disable();
>> +
>> +	if (cpu_hotplug.active_writer == current)
>> +		return;
>> +
>> +	local_irq_save(flags);
> 
> Yes... this is still needed, we are going to increment reader_percpu_refcnt
> unconditionally and this makes reader_nested_percpu() == T.
> 
> But,
> 
>> +void put_online_cpus_atomic(void)
>> +{
>> +	unsigned long flags;
>> +
>> +	if (cpu_hotplug.active_writer == current)
>> +		goto out;
>> +
>> +	local_irq_save(flags);
>> +
>> +	/*
>> +	 * We never allow heterogeneous nesting of readers. So it is trivial
>> +	 * to find out the kind of reader we are, and undo the operation
>> +	 * done by our corresponding get_online_cpus_atomic().
>> +	 */
>> +	if (__this_cpu_read(reader_percpu_refcnt))
>> +		__this_cpu_dec(reader_percpu_refcnt);
>> +	else
>> +		read_unlock(&hotplug_rwlock);
>> +
>> +	local_irq_restore(flags);
>> +out:
>> +	preempt_enable();
>> +}
> 
> Do we really need local_irq_save/restore in put_ ?
>

Hmm.. good point! I don't think we need it.
 

Regards,
Srivatsa S. Bhat


