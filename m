Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2EJCnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 22:43:45 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56256 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab2EJCnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 22:43:43 -0400
Message-ID: <4FAB2B5B.4020902@gmail.com>
Date: Wed, 09 May 2012 22:43:39 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, anton@samba.org,
        Arnd Bergmann <arnd@arndb.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PULL] cpumask: finally make them variable size w/ CPUMASK_OFFSTACK.
References: <87ipg5c2bk.fsf@rustcorp.com.au> <4FAB1AC9.1050306@gmail.com> <871umsdbm0.fsf@rustcorp.com.au>
In-Reply-To: <871umsdbm0.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/9/12 10:16 PM), Rusty Russell wrote:
> On Wed, 09 May 2012 21:32:57 -0400, KOSAKI Motohiro<kosaki.motohiro@gmail.com>  wrote:
>> (5/9/12 2:10 AM), Rusty Russell wrote:
>>> Hi Ingo,
>>>
>>>           I finally rebased this on top of your tip tree, and tested it
>>> locally.  Some more old-style cpumask usages have crept in, but it's a
>>> fairly simple series.
>>>
>>> The final result is that if you enable CONFIG_CPUMASK_OFFSTACK, then
>>> 'struct cpumask' becomes an undefined type.  You can't accidentally take
>>> the size of it, assign it, or pass it by value.  And thus it's safe for
>>> us to make it smaller if nr_cpu_ids<   NR_CPUS, as the final patch does.
>>>
>>> It unfortunately requires the lglock cleanup patch, which Al already has
>>> queued, so I've included it here.
>>
>> Hi
>>
>> Thanks this effort. This is very cleaner than I expected.
>> However I should NAK following one patch. sorry. because of, lru-drain is
>> called from memory reclaim context. It mean, additional allocation may not
>> work. Please just use bare NR_CPUS bitmap instead. space wasting is minor
>> issue than that.
>
> But if it fails the allocation, that's fine: we just send a few more
> IPIs to every CPU:
>
> +	if (!zalloc_cpumask_var(&cpus_with_pcps, GFP_KERNEL)) {
> +		on_each_cpu(drain_local_pages, NULL, 1);
> +		return;
> +	}
>
> We can do it the other way, but it sets a bad example, and after we get
> rid of cpumask, it becomes:
>
>          static DECLARE_BITMAP(cpus_with_pcps, NR_CPUS);
>
>          ......
>
>   		if (has_pcps)
> 			cpumask_set_cpu(cpu, to_cpumask(cpus_with_pcps));
> 		else
> 			cpumask_clear_cpu(cpu, to_cpumask(cpus_with_pcps));
>   	}
> 	on_each_cpu_mask(to_cpumask(cpus_with_pcps), drain_local_pages, NULL, 1);
>
> Or is there a reason we shouldn't even try to allocate here?

1) your code always use GFP_KERNEL. it is trouble maker when alloc_pages w/ GFP_ATOMIC.
2) When CONFIG_CPUMASK_OFFSTACK=n and NR_CPUS is relatively large, cpumask on stack may
cause stack overflow. because of, alloc_pages() can be called from very deep call stack.

Thought?


