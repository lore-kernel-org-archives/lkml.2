Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab1BSOOo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 09:14:44 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:55936 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab1BSOOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 09:14:43 -0500
X-AuditID: b753bd60-a42c8ba0000066fd-91-4d5fd04f836c
X-AuditID: b753bd60-a42c8ba0000066fd-91-4d5fd04f836c
Message-ID: <4D5FD04D.8020209@hitachi.com>
Date: Sat, 19 Feb 2011 23:14:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        ananth@in.ibm.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [PATCH] kprobes - do not allow optimized kprobes in entry code
References: <1297696354-6990-1-git-send-email-jolsa@redhat.com> <4D5A4A66.4010503@hitachi.com> <20110215123058.GB3135@jolsa.brq.redhat.com> <4D5AA209.7070309@hitachi.com> <20110215170507.GD3135@jolsa.brq.redhat.com> <4D5B4654.30407@hitachi.com> <20110217151103.GA11156@elte.hu> <20110218162619.GA9425@jolsa.brq.redhat.com>
In-Reply-To: <20110218162619.GA9425@jolsa.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/02/19 1:26), Jiri Olsa wrote:
[...]
>> The only worry would be that if we move the syscall entry code out of the regular 
>> text section fragments the icache layout a tiny bit, possibly hurting performance.
>>
>> It's probably not measurable, but we need to measure it:
>>
>> Testing could be done of some syscall but also cache-intense workload, like 
>> 'hackbench 10', via perf 'stat --repeat 30' and have a very close look at 
>> instruction cache eviction differences.
>>
>> Perhaps also explicitly enable measure one of these:
>>
>>   L1-icache-loads                            [Hardware cache event]
>>   L1-icache-load-misses                      [Hardware cache event]
>>   L1-icache-prefetches                       [Hardware cache event]
>>   L1-icache-prefetch-misses                  [Hardware cache event]
>>
>>   iTLB-loads                                 [Hardware cache event]
>>   iTLB-load-misses                           [Hardware cache event]
>>
>> to see whether there's any statistically significant difference in icache/iTLB 
>> evictions, with and without the patch.
>>
>> If such stats are included in the changelog - even if just to show that any change 
>> is within measurement accuracy, it would make it easier to apply this change.
>>
>> Thanks,
>>
>> 	Ingo
> 
> 
> hi,
> 
> I have some results, but need help with interpretation.. ;)
> 
> I ran following command (with repeat 100 and 500)
> 
> perf stat --repeat 100 -e L1-icache-load -e L1-icache-load-misses -e
> L1-icache-prefetches -e L1-icache-prefetch-misses -e iTLB-loads -e
> iTLB-load-misses ./hackbench/hackbench 10
> 
> I can tell just the obvious:
> - the cache load count is higher for the patched kernel,
>   but the cache misses count is lower
> - patched kernel has also lower count of prefetches,
>   other counts are bigger for patched kernel
> 
> there's still some variability in counter values each time I run the perf

Thanks, I've also tested. (But my machine has no L1-icache-prefetches* support)
What I can tell is both of L1-icache-load and L1-icache-load-misses is
reduced by the patch. ;-)

Thank you,
--------------------------------------------------------------------------
the results for current tip tree are:

$ ./perf stat --repeat 100 -e L1-icache-load -e L1-icache-
load-misses -e iTLB-loads -e iTLB-load-misses hackbench 10

 Performance counter stats for 'hackbench 10' (100 runs):

        16,949,055 L1-icache-load             ( +-   0.303% )
         1,237,453 L1-icache-load-misses      ( +-   0.254% )
        40,000,357 iTLB-loads                 ( +-   0.257% )
            14,545 iTLB-load-misses           ( +-   0.306% )

        0.171622060  seconds time elapsed   ( +-   0.196% )

$ ./perf stat --repeat 500 -e L1-icache-load -e L1-icache-
load-misses -e iTLB-loads -e iTLB-load-misses hackbench 10

 Performance counter stats for 'hackbench 10' (500 runs):

        16,896,081 L1-icache-load             ( +-   0.146% )
         1,234,272 L1-icache-load-misses      ( +-   0.105% )
        39,850,899 iTLB-loads                 ( +-   0.116% )
            14,455 iTLB-load-misses           ( +-   0.119% )

        0.171901412  seconds time elapsed   ( +-   0.083% )

--------------------------------------------------------------------------
the results for tip tree with the patch applied are:

$ ./perf stat --repeat 100 -e L1-icache-load -e L1-icache-
load-misses -e iTLB-loads -e iTLB-load-misses hackbench 10

 Performance counter stats for 'hackbench 10' (100 runs):

        16,819,190 L1-icache-load             ( +-   0.288% )
         1,162,386 L1-icache-load-misses      ( +-   0.269% )
        40,020,154 iTLB-loads                 ( +-   0.254% )
            14,440 iTLB-load-misses           ( +-   0.220% )

        0.169014989  seconds time elapsed   ( +-   0.361% )

$ ./perf stat --repeat 500 -e L1-icache-load -e L1-icache-
load-misses -e iTLB-loads -e iTLB-load-misses hackbench 10

 Performance counter stats for 'hackbench 10' (500 runs):

        16,783,970 L1-icache-load             ( +-   0.144% )
         1,155,816 L1-icache-load-misses      ( +-   0.113% )
        39,958,292 iTLB-loads                 ( +-   0.122% )
            14,462 iTLB-load-misses           ( +-   0.138% )

        0.168279115  seconds time elapsed   ( +-   0.089% )


--------------------------------------------------------------------------
Here is an entry of the /proc/cpuinfo.

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 26
model name      : Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz
stepping        : 4
cpu MHz         : 2673.700
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm
constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc
aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1
sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid
bogomips        : 5347.40
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
