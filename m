Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab2ABJhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 04:37:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab2ABJhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 04:37:38 -0500
Message-ID: <4F017AD2.3090504@redhat.com>
Date: Mon, 02 Jan 2012 11:37:22 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com> <20111230095147.GA10543@elte.hu> <878vlu4bgh.fsf@linux.vnet.ibm.com> <87pqf5mqg4.fsf@abhimanyu.in.ibm.com>
In-Reply-To: <87pqf5mqg4.fsf@abhimanyu.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2011 04:21 AM, Nikunj A Dadhania wrote:
> Here is the results collected from the 64bit VM runs. 

Thanks, the data is clearer now.

> Avi, x2apic is enabled in the both guest/host. 
>
> One more change in the test setup is I am creating and destroying the VM
> for each benchmark run. Earlier, I used to create 2/4/8 VMs and run 5
> benchmarks one by one(VM was not fresh for some benchmark)
>
>     PLE - Test Setup:
>     =================
>     - x3850x5 machine - PLE enabled
>     - 8 CPUs (HT disabled)
>     - 264GB memory
>     - VM details:
>        - Guest kernel: 2.6.32 based enterprise kernel
>        - 1024MB memory
>        - 8 VCPUs
>     - During gang runs, vcpus are pinned
>
>     Results:
>      * GangVsBase - Gang vs Baseline kernel
>      * GangVsPin  - Gang vs Baseline kernel + vcpus pinned
>      * V1 - Using set_next_buddy
>      * V2 - Using set_gang_buddy
>      * Results are % improvement/degradation
>     +-------------+-----------------------+----------------------+
>     |             |          V1           |           V2         |
>     +  Benchmarks +-----------+-----------+-----------+----------+
>     |             | GngVsBase | GngVsPin  | GngVsBase | GngVsPin |
>     +-------------+-----------+-----------+-----------+----------+
>     |  kbench-2vm |       -4  |       -5  |       -1  |       -1 |
>     |  kbench-4vm |      -13  |       -3  |        3  |       12 |
>     |  kbench-8vm |      -11  |        0  |       -5  |        5 |
>     +-------------+-----------+-----------+-----------+----------+
>     |  ebizzy-2vm |       -1  |       -2  |       17  |       16 |
>     |  ebizzy-4vm |        4  |        6  |       58  |       61 |
>     |  ebizzy-8vm |        3  |       25  |       68  |      103 |
>     +-------------+-----------+-----------+-----------+----------+
>     | specjbb-2vm |       -7  |        0  |       -6  |        1 |
>     | specjbb-4vm |       19  |       30  |       -5  |        3 |
>     | specjbb-8vm |       -6  |        1  |        5  |       15 |
>     +-------------+-----------+-----------+-----------+----------+
>     |  hbench-2vm |       -1  |       -6  |       18  |       14 |
>     |  hbench-4vm |      -64  |       -9  |       -2  |       31 |
>     |  hbench-8vm |      -28  |       10  |       32  |       53 |
>     +-------------+-----------+-----------+-----------+----------+
>     |  dbench-2vm |       -3  |       -5  |       -2  |       -3 |
>     |  dbench-4vm |        9  |        0  |        3  |       -5 |
>     |  dbench-8vm |       -3  |      -23  |       -8  |      -26 |
>     +-------------+-----------+-----------+-----------+----------+
>
>     The best and worst case in V2(GangVsBase). 
>
>     ebizzy 8vm (improved 68%)
>     +------------+--------------------+--------------------+----------+
>     |                               Ebizzy                            |
>     +------------+--------------------+--------------------+----------+
>     | Parameter  | GangBase           |   Gang V2          | % imprv  |
>     +------------+--------------------+--------------------+----------+
>     |      ebizzy|            2531.75 |            4268.12 |       68 |
>     |    EbzyUser|              32.60 |              60.70 |       86 |
>     |     EbzySys|             165.48 |             171.05 |       -3 |
>     |    EbzyReal|              60.00 |              60.00 |        0 |
>     |     BwUsage|    568645533105.00 |    767186043286.00 |       34 |
>     |    HostIdle|              89.00 |              89.00 |        0 |
>     |     UsrTime|               2.00 |               4.00 |      100 |
>     |     SysTime|              12.00 |              13.00 |       -8 |
>     |      IOWait|               3.00 |               4.00 |      -33 |
>     |    IdleTime|              81.00 |              77.00 |       -4 |
>     |         TPS|              12.00 |              12.00 |        0 |
>     +-----------------------------------------------------------------+
>
>     GangV2:
>     27.45%       ebizzy  libc-2.12.so            [.] __memcpy_ssse3_back
>     12.12%       ebizzy  [kernel.kallsyms]       [k] clear_page
>      9.22%       ebizzy  [kernel.kallsyms]       [k] __do_page_fault
>      6.91%       ebizzy  [kernel.kallsyms]       [k] flush_tlb_others_ipi
>      4.06%       ebizzy  [kernel.kallsyms]       [k] get_page_from_freelist
>      4.04%       ebizzy  [kernel.kallsyms]       [k] ____pagevec_lru_add
>
>     GangBase:
>     45.08%       ebizzy  [kernel.kallsyms]       [k] flush_tlb_others_ipi
>     15.38%       ebizzy  libc-2.12.so            [.] __memcpy_ssse3_back
>      7.00%       ebizzy  [kernel.kallsyms]       [k] clear_page
>      4.88%       ebizzy  [kernel.kallsyms]       [k] __do_page_fault

Looping in flush_tlb_others().  Rik, what trace an we run to find out
why PLE directed yield isn't working as expected?

>
>     dbench 8vm (degraded -8%)
>     +------------+--------------------+--------------------+----------+
>     |                               Dbench                            |
>     +------------+--------------------+--------------------+----------+
>     | Parameter  | GangBase           |   Gang V2          | % imprv  |
>     +------------+--------------------+--------------------+----------+
>     |      dbench|               2.27 |               2.09 |       -8 |
>     |     BwUsage|    138973336762.00 |    187382519973.00 |       34 |
>     |    HostIdle|              95.00 |              93.00 |        2 |
>     |      IOWait|              20.00 |              19.00 |        5 |
>     |    IdleTime|              78.00 |              78.00 |        0 |
>     |         TPS|              13.00 |              14.00 |        7 |
>     | CacheMisses|        81611667.00 |        72959014.00 |       10 |
>     |   CacheRefs|      4990591975.00 |      4624251595.00 |       -7 |
>     |BranchMisses|       812569051.00 |      1162137278.00 |      -43 |
>     |    Branches|     20196543212.00 |     30318934960.00 |       50 |
>     |Instructions|     99519592926.00 |    152169154440.00 |      -52 |
>     |      Cycles|    265699995531.00 |    330718402913.00 |      -24 |
>     |     PageFlt|           36083.00 |           35897.00 |        0 |
>     |   ContextSW|         3170710.00 |         8304284.00 |     -161 |
>     |   CPUMigrat|           63387.00 |          155521.00 |     -145 |
>     +-----------------------------------------------------------------+
>     dbench needs some more love, i will get the perf top caller for
>     that.
>
>     non-PLE - Test Setup:
>     =====================
>     - x3650 M2 machine
>     - 8 CPUs (HT disabled)
>     - 64GB memory
>     - VM details:
>        - Guest kernel: 2.6.32 based enterprise kernel
>        - 1024MB memory
>        - 8 VCPUs
>     - During gang runs, vcpus are pinned
>
>     Results:
>      * GangVsBase - Gang vs Baseline kernel
>      * GangVsPin  - Gang vs Baseline kernel + vcpus pinned
>      * V1 - using set_next_buddy
>      * V2 - using set_gang_buddy
>      * Results are % improvement/degradation
>     +-------------+-----------------------+----------------------+
>     |             |          V1           |           V2         |
>     +  Benchmarks +-----------+-----------+-----------+----------+
>     |             | GngVsBase | GngVsPin  | GngVsBase | GngVsPin |
>     +-------------+-----------+-----------+-----------+----------+
>     |  kbench-2vm |        0  |        2  |       -7  |       -5 |
>     |  kbench-4vm |        2  |       -3  |        7  |        2 |
>     |  kbench-8vm |        0  |       -1  |       -1  |       -3 |
>     +-------------+-----------+-----------+-----------+----------+
>     |  ebizzy-2vm |      221  |      109  |      241  |      122 |
>     |  ebizzy-4vm |      215  |      173  |      366  |      304 |
>     |  ebizzy-8vm |      225  |       88  |      331  |      149 |
>     +-------------+-----------+-----------+-----------+----------+
>     | specjbb-2vm |       -5  |       -3  |       -7  |       -5 |
>     | specjbb-4vm |       29  |       -4  |        3  |      -23 |
>     | specjbb-8vm |        6  |       -6  |       16  |        2 |
>     +-------------+-----------+-----------+-----------+----------+
>     |  hbench-2vm |      -16  |        2  |       15  |       29 |
>     |  hbench-4vm |      -25  |        2  |       32  |       47 |
>     |  hbench-8vm |      -46  |      -19  |       35  |       47 |
>     +-------------+-----------+-----------+-----------+----------+
>     |  dbench-2vm |        0  |        1  |       -5  |       -3 |
>     |  dbench-4vm |       -9  |       -4  |       -2  |        2 |
>     |  dbench-8vm |      -52  |       17  |      -30  |       69 |
>     +-------------+-----------+-----------+-----------+----------+
>
>     The best and worst case in V2(GangVsBase). 
>
>     ebizzy 8vm (improved 331%)
>     +------------+--------------------+--------------------+----------+
>     |                               Ebizzy                            |
>     +------------+--------------------+--------------------+----------+
>     | Parameter  | GangBase           |   Gang V2          | % imprv  |
>     +------------+--------------------+--------------------+----------+
>     |      ebizzy|             719.50 |            3101.38 |      331 |
>     |    EbzyUser|               3.79 |              58.04 |     1432 |
>     |     EbzySys|              66.61 |             140.04 |     -110 |
>     |    EbzyReal|              60.00 |              60.00 |        0 |
>     |     BwUsage|    526550032993.00 |    652012141757.00 |       23 |
>     |    HostIdle|              59.00 |              62.00 |       -5 |
>     |     SysTime|               5.00 |              11.00 |     -120 |
>     |      IOWait|               4.00 |               4.00 |        0 |
>     |    IdleTime|              89.00 |              79.00 |      -11 |
>     |         TPS|              11.00 |              12.00 |        9 |
>     +-----------------------------------------------------------------+
>
>     GangV2:
>     27.96%       ebizzy  libc-2.12.so            [.] __memcpy_ssse3_back
>     12.13%       ebizzy  [kernel.kallsyms]       [k] clear_page
>     11.66%       ebizzy  [kernel.kallsyms]       [k] __bitmap_empty
>     11.54%       ebizzy  [kernel.kallsyms]       [k] flush_tlb_others_ipi
>      5.93%       ebizzy  [kernel.kallsyms]       [k] __do_page_fault
>
>     GangBase;
>     36.34%       ebizzy  [kernel.kallsyms]  [k] __bitmap_empty
>     35.95%       ebizzy  [kernel.kallsyms]  [k] flush_tlb_others_ipi
>      8.52%       ebizzy  libc-2.12.so       [.] __memcpy_ssse3_back

Same thing.  __bitmap_empty() is likely the cpumask_empty() called from
flush_tlb_others_ipi(), so 70% of time is spent in this loop.

Xen works around this particular busy loop by having a hypercall for
flushing the tlb, but this is very fragile (and broken wrt
get_user_pages_fast() IIRC).

>
>     dbench 8vm (degraded -30%)
>     +------------+--------------------+--------------------+----------+
>     |                               Dbench                            |
>     +------------+--------------------+--------------------+----------+
>     | Parameter  | GangBase           |   Gang V2          | % imprv  |
>     +------------+--------------------+--------------------+----------+
>     |      dbench|               2.01 |               1.38 |      -30 |
>     |     BwUsage|    100408068913.00 |    176095548113.00 |       75 |
>     |    HostIdle|              82.00 |              74.00 |        9 |
>     |      IOWait|              25.00 |              23.00 |        8 |
>     |    IdleTime|              74.00 |              71.00 |       -4 |
>     |         TPS|              13.00 |              13.00 |        0 |
>     | CacheMisses|       137351386.00 |       267116184.00 |      -94 |
>     |   CacheRefs|      4347880250.00 |      5830408064.00 |       34 |
>     |BranchMisses|       602120546.00 |      1110592466.00 |      -84 |
>     |    Branches|     22275747114.00 |     39163309805.00 |       75 |
>     |Instructions|    107942079625.00 |    195313721170.00 |      -80 |
>     |      Cycles|    271014283494.00 |    481886203993.00 |      -77 |
>     |     PageFlt|           44373.00 |           47679.00 |       -7 |
>     |   ContextSW|         3318033.00 |        11598234.00 |     -249 |
>     |   CPUMigrat|           82475.00 |          423066.00 |     -412 |
>     +-----------------------------------------------------------------+
>

Rik, what's going on?  ContextSW is relatively low in the base load,
looks like PLE is asleep on the wheel.

-- 
error compiling committee.c: too many arguments to function

