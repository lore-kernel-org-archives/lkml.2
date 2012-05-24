Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab2EXOEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 10:04:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:42632 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab2EXOEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 10:04:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="170876332"
Message-ID: <4FBE3FC6.2080600@intel.com>
Date: Thu, 24 May 2012 22:03:50 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jan Beulich <JBeulich@suse.com>,
        borislav.petkov@amd.com, arnd@arndb.de, akinobu.mita@gmail.com,
        eric.dumazet@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
        hughd@google.com, jeremy@goop.org, len.brown@intel.com,
        tony.luck@intel.com, yongjie.ren@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
        penberg@kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, ak@linux.intel.com, luto@mit.edu,
        avi@redhat.com, dhowells@redhat.com, mingo@redhat.com, riel@redhat.com,
        cpw@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, hpa@zytor.com
Subject: Re: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of siblings
 of SMT
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com>  <1337782555-8088-9-git-send-email-alex.shi@intel.com>  <4FBD18D20200007800085951@nat28.tlf.novell.com>  <1337792984.9783.37.camel@laptop>  <4FBDF200.7060608@intel.com> <1337848970.9783.72.camel@laptop> <4FBDF5E5.7010806@intel.com> <87boldyfp3.fsf@rustcorp.com.au>
In-Reply-To: <87boldyfp3.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 07:35 PM, Rusty Russell wrote:

> On Thu, 24 May 2012 16:48:37 +0800, Alex Shi <alex.shi@intel.com> wrote:
>> On 05/24/2012 04:42 PM, Peter Zijlstra wrote:
>>
>>> On Thu, 2012-05-24 at 16:32 +0800, Alex Shi wrote:
>>>> So, I use cpumask_t in stack.
>>>
>>> cpumask_t is 512 bytes with NR_CPUS=4096, that's generally considered
>>> too big to be on stack.
>>>
>>> A number of people spend a lot of time removing cpumask_t from stacks a
>>> while ago, I'm very sure they'll not be happy if you're going to add it
>>> back.
>>
>>
>> In my testing, allocate a cpumask_var_t is more worse than cpumask_t.
>> So, another choice is using percpu pre-allocatd cpumask for this, but I
>> am wondering if it is acceptable. What's suggestion for this point?
> 
> Thanks for the ping Peter!
> 
> Please don't use cpus_ operations: they're deprecated.  Use cpumask_.
> Similarly, avoid cpumask_t.


Thanks, Rusty and Peter!

> 
> And yes, if you configure for thousands of CPUs, it's not free!  If it's
> a significant, you will want to use a per-cpu cpumask_var_t.


I see.

> 
> My other thought: your patch seems optimal as far as avoiding IPIs goes,
> but I wonder how often it folds down to a single CPU?  That case is
> easier to fast-path without using a new cpumask.


It will be quite often if threads number of user level APP is more than
a half of LCPUs.
It needs a new cpumask because we can not remove SMT bit on
mm->cpu_vm_mask_var directly.

> 
> Cheers,
> Rusty.


