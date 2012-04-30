Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab2D3EZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 00:25:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:17902 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab2D3EZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 00:25:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="138127210"
Message-ID: <4F9E144A.8070901@intel.com>
Date: Mon, 30 Apr 2012 12:25:46 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: andi.kleen@intel.com, tim.c.chen@linux.intel.com, jeremy@goop.org,
        chrisw@sous-sol.org, akataria@vmware.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, paul.gortmaker@windriver.com, dhowells@redhat.com,
        fenghua.yu@intel.com, yinghai@kernel.org, cpw@sgi.com, steiner@sgi.com,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com
Subject: Re: [PATCH 1/3] x86/tlb_info: get last level TLB entry number of
 CPU
References: <1335603099-2624-1-git-send-email-alex.shi@intel.com> <1335603099-2624-2-git-send-email-alex.shi@intel.com> <20120429135529.GA2713@aftab.osrc.amd.com>
In-Reply-To: <20120429135529.GA2713@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>

>> +enum tlb_infos {
>> +	ENTRIES,
>> +	/* ASS_WAYS, */
> 
> We don't need associativity?




Detailed associative ways type(set,skewed etc) should effect the cache
behavior, but I don't know the detailed associate type for each kind of
CPU, and also don't know the detailed CPU hardware optimization for
associative ways. (Some one said there is hardware hash to map memory
into cache). But I don't know details, and can not do optimizing
accordingly.
and another reason is: according to this chart:
http://en.wikipedia.org/wiki/File:Cache,missrate.png that from
http://en.wikipedia.org/wiki/CPU_cache
, seems we needn't care too much about the associative ways.


>> +
>> +	for (i = 0 ; i < n ; i++) {
>> +		cpuid(2, &regs[0], &regs[1], &regs[2], &regs[3]);
> 
> Ok, getting TLB sizes on AMD is easier :), see dirty patch below.
> 
> Also, there's cpuinfo_x86.x86_tlbsize which is L1 iTLB + L1 dTLB 4K
> entries. The tlb sizes below could probably be integrated/cached there
> too if this proves to bring some speedup. 


I have tried to fill the info into cpuinfo_x86 first, but got the info
from there instead of 'read_mostly' area is hart performance.

BTW, I didn't see x86_tlbsize was printed under Intel's CPUs.

> 
> But initial testing looks good:
> 
> This is Linus' git from today:
> 
> my pid is 2798 n=32 l=1024 p=512 t=1
> get 256K pages with one byte writing uses 689ms, 2629ns/time
> mprotect use 71ms 2178ns/time, 14103 times/thread/ms, cost 70ns/time
> my pid is 2800 n=32 l=1024 p=512 t=2
> get 256K pages with one byte writing uses 686ms, 2620ns/time
> mprotect use 82ms 2508ns/time, 14272 times/thread/ms, cost 70ns/time
> my pid is 2803 n=32 l=1024 p=512 t=4
> get 256K pages with one byte writing uses 686ms, 2620ns/time
> mprotect use 102ms 3120ns/time, 15332 times/thread/ms, cost 65ns/time
> my pid is 2808 n=32 l=1024 p=512 t=8
> get 256K pages with one byte writing uses 686ms, 2617ns/time
> mprotect use 142ms 4350ns/time, 16930 times/thread/ms, cost 59ns/time
> my pid is 2817 n=32 l=1024 p=512 t=16
> get 256K pages with one byte writing uses 671ms, 2562ns/time
> mprotect use 226ms 6925ns/time, 20508 times/thread/ms, cost 48ns/time
> my pid is 2834 n=32 l=1024 p=512 t=32
> get 256K pages with one byte writing uses 679ms, 2593ns/time
> mprotect use 497ms 15182ns/time, 31891 times/thread/ms, cost 31ns/time
> my pid is 2867 n=32 l=1024 p=512 t=64
> get 256K pages with one byte writing uses 675ms, 2575ns/time
> mprotect use 394ms 12031ns/time, 12727 times/thread/ms, cost 78ns/time
> my pid is 2932 n=32 l=1024 p=512 t=128
> get 256K pages with one byte writing uses 680ms, 2597ns/time
> mprotect use 1425ms 43506ns/time, 11718 times/thread/ms, cost 85ns/time
> 
> and this is with your patches ontop:
> 
> my pid is 2817 n=32 l=1024 p=512 t=1
> get 256K pages with one byte writing uses 680ms, 2597ns/time
> mprotect use 120ms 3691ns/time, 35043 times/thread/ms, cost 28ns/time
> my pid is 2819 n=32 l=1024 p=512 t=2
> get 256K pages with one byte writing uses 678ms, 2588ns/time
> mprotect use 133ms 4079ns/time, 36233 times/thread/ms, cost 27ns/time
> my pid is 2822 n=32 l=1024 p=512 t=4
> get 256K pages with one byte writing uses 675ms, 2578ns/time
> mprotect use 162ms 4953ns/time, 38283 times/thread/ms, cost 26ns/time
> my pid is 2827 n=32 l=1024 p=512 t=8
> get 256K pages with one byte writing uses 680ms, 2593ns/time
> mprotect use 243ms 7425ns/time, 42101 times/thread/ms, cost 23ns/time
> my pid is 2836 n=32 l=1024 p=512 t=16
> get 256K pages with one byte writing uses 673ms, 2570ns/time
> mprotect use 356ms 10869ns/time, 45748 times/thread/ms, cost 21ns/time
> my pid is 2853 n=32 l=1024 p=512 t=32
> get 256K pages with one byte writing uses 667ms, 2545ns/time
> mprotect use 460ms 14063ns/time, 35435 times/thread/ms, cost 28ns/time
> my pid is 2886 n=32 l=1024 p=512 t=64
> get 256K pages with one byte writing uses 672ms, 2564ns/time
> mprotect use 1298ms 39641ns/time, 23971 times/thread/ms, cost 41ns/time
> my pid is 2951 n=32 l=1024 p=512 t=128
> get 256K pages with one byte writing uses 673ms, 2567ns/time
> mprotect use 2682ms 81873ns/time, 12956 times/thread/ms, cost 77ns/time


The data looks so great! :)

> 
> and I definitely like those numbers.
> 
> So, assuming others don't have a problem with this approach, I like
> this. Haven't looked at the other two patches yet though.
> 

>> +	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n" \
>> +		"Last level dTLB entires: 4KB %d, 2MB %d, 4MB %d\n",
> 
> I'm sure you mean "entries" :-)


Sure, a typo.

> 
> 
> From: Borislav Petkov <borislav.petkov@amd.com>
> Date: Sun, 29 Apr 2012 15:23:36 +0200
> Subject: [PATCH 2/4] x86: Add AMD TLB size detection
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/cpu/common.c |   47 +++++++++++++++++++++++++++++-------------
>  arch/x86/kernel/cpu/cpu.h    |    2 +-
>  2 files changed, 34 insertions(+), 15 deletions(-)


It looks fine. Thanks for the patch.


