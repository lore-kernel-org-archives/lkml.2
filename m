Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab2EBJZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 05:25:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:41522 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab2EBJZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 05:25:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="136069170"
Message-ID: <4FA0FD39.9060908@intel.com>
Date: Wed, 02 May 2012 17:24:09 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: andi.kleen@intel.com, tim.c.chen@linux.intel.com, jeremy@goop.org,
        chrisw@sous-sol.org, akataria@vmware.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, paul.gortmaker@windriver.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        cpw@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com
Subject: Re: [PATCH 2/3] x86/flush_tlb: try flush_tlb_single one by one in
 flush_tlb_range
References: <1335603099-2624-1-git-send-email-alex.shi@intel.com> <1335603099-2624-3-git-send-email-alex.shi@intel.com> <20120430105440.GC9303@aftab.osrc.amd.com>
In-Reply-To: <20120430105440.GC9303@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 06:54 PM, Borislav Petkov wrote:

> On Sat, Apr 28, 2012 at 04:51:38PM +0800, Alex Shi wrote:
>> x86 has no flush_tlb_range support in instruction level. Currently the
>> flush_tlb_range just implemented by flushing all page table. That is not
>> the best solution for all scenarios. In fact, if we just use 'invlpg' to
>> flush few lines from TLB, we can get the performance gain from later
>> remain TLB lines accessing.
>>
>> But the 'invlpg' instruction costs much of time. Its execution time can
>> compete with cr3 rewriting, and even a bit more on SNB CPU.
>>
>> So, on a 512 4KB TLB entries CPU, the balance points is at:
>> 512 * 100ns(assumed TLB refill cost) =
>> x(TLB flush entries) * 140ns(assumed invlpg cost)
>>
>> Here, x is about 360, that is about 5/8 of 512 entries.
>>
>> But with the mysterious CPU pre-fetcher and page miss handler Unit, the
>> assumed TLB refill cost is far lower then 100ns in sequential access. And
>> 2 HT siblings in one core makes the memory access more faster if they are
>> accessing the same memory. So, in the patch, I just do the change when
>> the target entries is less than 1/16 of whole active tlb entries.
>> Actually, I have no data support for the percentage '1/16', so any
>> suggestions are welcomed.
> 
> You could find the proper value empirically here by replacing the
> FLUSHALL_BAR thing with a variable and exporting it through procfs or
> sysfs or whatever, only for testing purposes, and letting mprotect.c
> set it to a different value each time. Then run a bunch of times with
> different thread counts and invalidation entries count and see which
> combination performs best.



For some of scenario, above equation can be modified as:
(512 - X) * 100ns(assumed TLB refill cost) = X * 140ns(assumed invlpg cost)

When thread number less than cpu numbers, balance point can up to 1/2
TLB entries.

When thread number is equal to cpu number with HT, on our SNB EP
machine, the balance point is 1/16 TLB entries, on NHM EP machine,
balance at 1/32. So, need to change FLUSHALL_BAR to 32.

when thread number is bigger than cpu number, context switch eat all
improvement. the memory access latency is same as unpatched kernel.

