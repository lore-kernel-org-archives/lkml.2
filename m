Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab2EXIdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:33:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:27774 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab2EXIdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 04:33:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="147815787"
Message-ID: <4FBDF200.7060608@intel.com>
Date: Thu, 24 May 2012 16:32:00 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Jan Beulich <JBeulich@suse.com>, borislav.petkov@amd.com, arnd@arndb.de,
        akinobu.mita@gmail.com, eric.dumazet@gmail.com, fweisbec@gmail.com,
        rostedt@goodmis.org, hughd@google.com, jeremy@goop.org,
        len.brown@intel.com, tony.luck@intel.com, yongjie.ren@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
        penberg@kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, ak@linux.intel.com, luto@mit.edu,
        avi@redhat.com, dhowells@redhat.com, mingo@redhat.com, riel@redhat.com,
        cpw@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, hpa@zytor.com
Subject: Re: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of siblings
 of SMT
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com>  <1337782555-8088-9-git-send-email-alex.shi@intel.com>  <4FBD18D20200007800085951@nat28.tlf.novell.com> <1337792984.9783.37.camel@laptop>
In-Reply-To: <1337792984.9783.37.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 01:09 AM, Peter Zijlstra wrote:

> On Wed, 2012-05-23 at 16:05 +0100, Jan Beulich wrote:
>>>>> On 23.05.12 at 16:15, Alex Shi <alex.shi@intel.com> wrote:
>>> +	/* doing flush on both siblings of SMT is just wasting time */
>>> +	cpumask_copy(&flush_mask, cpumask);
>>> +	if (likely(smp_num_siblings > 1)) {
>>> +		rand = jiffies;
>>> +		/* See "Numerical Recipes in C", second edition, p. 284 */
>>> +		rand = rand * 1664525L + 1013904223L;
>>> +		rand &= 0x1;
>>> +
>>> +		for_each_cpu(cpu, &flush_mask) {
>>> +			sblmask = cpu_sibling_mask(cpu);
>>> +			if (cpumask_subset(sblmask, &flush_mask)) {
>>> +				if (rand == 0)
>>> +					cpu_clear(cpu, flush_mask);
>>> +				else
>>> +					cpu_clear(cpumask_next(cpu, sblmask),
>>> +								flush_mask);
>>> +			}
>>> +		}
>>> +	}
>>> +
>>
>> There is no comment or anything else indicating that this is
>> suitable for dual-thread CPUs only - when there are more than
>> 2 threads per core, the intended effect won't be achieved.
> 
> Why would that be? Won't higher thread count still share the same
> resources just more so?
> 
>>  I'd
>> recommend making the logic generic from the beginning, but if
>> that doesn't seem feasible to you, at least a comment stating
>> the limitation should be added imo.


Sure. but just want to know how many commercial x86 CPU uses >2 SMTs?
Write a short, quick function to do random selection in SMT is quite
complicate considering cpumask maybe just contain random number SMT
siblings in a core.

> 
> My objection to the whole lot is that its looks mightily expensive on
> large machines, cpumask operations aren't cheap when you've got 4k cpus
> etc..
> 
> Also, you very much cannot put cpumask_t on stack.


Sure, and do you has related data for this?

I just measured the cost of this function on my Romely EP(32 LCPUs) with
cpumask_t and NR_CPUS = 32/256/512/4096, the cost are similar with
256/512/4096 and that increased about 20% time cost from 32.

I also tried to use cpumask_var_t and alloc it in heap(use
CPUMASK_OFFSTACK), actually, it cost same time with cpumask_t in stack.
But, the allocation bring another big cost. So, I use cpumask_t in stack.
The performance gain data in commit log is getting with NR_CPUS = 256.


