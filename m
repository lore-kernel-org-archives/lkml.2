Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab2LRWyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:54:37 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:49412
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754307Ab2LRWye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:54:34 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(z551biz98dI936eI154dI1432Izz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h93fhd24hf0ah10d2h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1537h162dh1631h1758h1155h)
X-WSS-ID: 0MF90YO-02-7BY-02
X-M-MSG: 
Message-ID: <1355871266.21420.17.camel@sos-dev03.amd.com>
Subject: Re: [PATCH 1/1] Change IBS PMU to use perf_hw_context
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Reply-To: <suravee.suthikulpanit@amd.com>
To: Robert Richter <rric@kernel.org>, Ingo Molnar <mingo@kernel.org>
CC: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@ghostprotocols.net>, <tglx@linutronix.de>, <hpa@zytor.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <jacob.shin@amd.com>,
        <suravee.suthikulpanit@amd.com>
Date: Tue, 18 Dec 2012 16:54:26 -0600
In-Reply-To: <20121217094403.GF1893@rric.localhost>
References: <1355518662-32071-1-git-send-email-suravee.suthikulpanit@amd.com>
	 <20121216090410.GC21690@gmail.com> <20121217094403.GF1893@rric.localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Robert

I am including a set of output from "perf report" to help validating IBS in per-process mode. 
In this experiment I ran a couple test cases:

case 1. perf record -e cycles       (baseline per-process mode w/ regular counter)
case 2. perf record -a -e cycles:p  (baseline system-wide mode w/ IBS)
case 3. perf record -e cycles:p     (the proposed per-process mode w/IBS)

In all 3 test cases, the target application (classic) are showing about 27K samples.
I am also including the IBS OP MSRs (0xc00110[33-3a]) snapshots on all 32 cores 
(using rdmsr tools) from case 2 and 3 above.

------------------------------------------------------------
CASE1:

# ========
# captured on: Tue Dec 18 16:32:43 2012
# hostname : sos-dev02
# os release : 3.7.0-IBS+
# perf version : 3.7.rc8.g805f38
# arch : x86_64
# nrcpus online : 32
# nrcpus avail : 32
# cpudesc : AMD Eng Sample, 1S228145TGG54_31/22/20_2/16
# cpuid : AuthenticAMD,21,2,0
# total memory : 32863836 kB
# cmdline : /sandbox/kernels/suravee/tools/perf/perf record -e cycles taskset -c 31 src/classic 
# event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0, id = { 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229 }
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# pmu mappings: cpu = 4, software = 1, tracepoint = 2, ibs_fetch = 6, ibs_op = 7, breakpoint = 5
# ========
#
# Samples: 27K of event 'cycles'
# Event count (approx.): 20938245323
#
# Overhead      Samples  Command      Shared Object                                   Symbol
# ........  ...........  .......  .................  .......................................
#
    99.16%        26927  classic  classic            [.] multiply_matrices()      <--- TARGET APP 
     0.32%           78  classic  libc-2.15.so       [.] random                             
     0.10%           23  classic  libc-2.15.so       [.] random_r                           
     0.07%           16  classic  classic            [.] initialize_matrices()              
     0.04%           10  classic  [kernel.kallsyms]  [k] ttwu_do_wakeup                     
     0.03%            9  classic  [kernel.kallsyms]  [k] clear_page_c                       
     0.02%           11  classic  [kernel.kallsyms]  [k] native_write_msr_safe              
     0.02%            5  classic  libc-2.15.so       [.] rand                               
     0.02%            2  classic  ld-2.15.so         [.] 0x000000000000a456         

------------------------------------------------------------
CASE 2:

# ========
# captured on: Tue Dec 18 16:11:35 2012
# hostname : sos-dev02
# os release : 3.7.0-IBS+
# perf version : 3.7.rc8.g805f38
# arch : x86_64
# nrcpus online : 32
# nrcpus avail : 32
# cpudesc : AMD Eng Sample, 1S228145TGG54_31/22/20_2/16
# cpuid : AuthenticAMD,21,2,0
# total memory : 32863836 kB
# cmdline : /sandbox/kernels/suravee/tools/perf/perf record -a -e cycles:p taskset -c 31 src/classic 
# event : name = cycles:p, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 0, precise_ip = 1, id = { 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98 }
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# pmu mappings: cpu = 4, software = 1, tracepoint = 2, ibs_fetch = 6, ibs_op = 7, breakpoint = 5
# ========
#
# Samples: 189K of event 'cycles:p'
# Event count (approx.): 40504131338
#
# Overhead      Samples          Command                     Shared Object                                       Symbol
# ........  ...........  ...............  ................................  ...........................................
#
    51.07%        26959          classic  classic                           [.] multiply_matrices()       <------ TARGET APP 
    35.39%       131620          swapper  [kernel.kallsyms]                 [k] acpi_idle_do_entry                     
     2.10%         4673          swapper  [kernel.kallsyms]                 [k] native_safe_halt                       
     0.71%         1303            rdmsr  ld-2.15.so                        [.] 0x0000000000002a44                     
     0.33%          639            rdmsr  [kernel.kallsyms]                 [k] irq_return                             
     0.26%          499            rdmsr  libc-2.15.so                      [.] 0x0000000000131d80                     
     0.25%          440            rdmsr  [kernel.kallsyms]                 [k] generic_exec_single                    
     0.25%          470            rdmsr  [kernel.kallsyms]                 [k] __do_fault                             
     0.24%          478            rdmsr  [kernel.kallsyms]                 [k] unmap_single_vma                       

------------------------------------------------------------
CASE 3:

# ========
# captured on: Tue Dec 18 16:13:53 2012
# hostname : sos-dev02
# os release : 3.7.0-IBS+
# perf version : 3.7.rc8.g805f38
# arch : x86_64
# nrcpus online : 32
# nrcpus avail : 32
# cpudesc : AMD Eng Sample, 1S228145TGG54_31/22/20_2/16
# cpuid : AuthenticAMD,21,2,0
# total memory : 32863836 kB
# cmdline : /sandbox/kernels/suravee/tools/perf/perf record -e cycles:p taskset -c 31 src/classic 
# event : name = cycles:p, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 0, precise_ip = 1, id = { 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131 }
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# pmu mappings: cpu = 4, software = 1, tracepoint = 2, ibs_fetch = 6, ibs_op = 7, breakpoint = 5
# ========
#
# Samples: 27K of event 'cycles:p'
# Event count (approx.): 20851884446
#
# Overhead      Samples  Command      Shared Object                          Symbol
# ........  ...........  .......  .................  ..............................
#
    99.37%        27020  classic  classic            [.] multiply_matrices()      <--- TARGET APP 
     0.22%           58  classic  libc-2.15.so       [.] random_r                  
     0.13%           32  classic  classic            [.] initialize_matrices()     
     0.10%           26  classic  libc-2.15.so       [.] random                    
     0.03%            8  classic  libc-2.15.so       [.] rand                      
     0.03%            7  classic  [kernel.kallsyms]  [k] clear_page_c              
     0.01%            2  classic  ld-2.15.so         [.] 0x000000000000a423        
     0.01%            2  classic  [kernel.kallsyms]  [k] retint_swapgs             
     0.01%            2  classic  [kernel.kallsyms]  [k] ttwu_do_wakeup            

------------------------------------------------------------
IBS MSR VALUES FROM CASE 2:

core : 0xc0011033 0xc0011034 0xc0011035 0xc0011036 0xc0011037 0xc0011038 0xc0011039 0xc001103a
 0 : 0000002300040000 ffffffff813d8c6d 00000040000b0006 0000000000000000 0000000000040002 0000000000000000 000000fdfd300000 0000000000000100
 1 : 0000006200040000 ffffffff813d8c6d 00000058000b0002 0000000000000000 0000000000000000 0000000000000400 000000fdfd300400 0000000000000100
 2 : 0000006000040000 ffffffff813d8c6d 00000040000b0006 0000000000000000 0000000000040002 0000000000000000 000000fdfd300000 0000000000000100
 3 : 0000005000040000 ffffffff813d8c6d 00000040000b0002 0000000000000000 0000000000040001 0000000000000400 000000fdfd300400 0000000000000100
 4 : 0000005700040000 ffffffff813d8c6d 00000040000b0006 0000000000000000 0000000000000000 0000000000000000 000000fdfd300000 0000000000000100
 5 : 0000000000000000 ffffffff81043ea8 00000000000a0001 0000000000000000 0000000000000000 0000000000000514 000000fdfd300514 0000000000000100
 6 : 0000004200040000 ffffffff813d8c74 00000000000b0006 0000000000000000 0000000000000000 0000000000000000 000000fdfd300000 0000000000000100
 7 : 0000000000000000 ffffffff81043ea8 00000000000a0000 0000000000000000 0000000000000000 0000000000000514 000000fdfd300514 0000000000000100
 8 : 0000002300040000 ffffffff813d8c6d 00000040000b0006 0000000000000000 0000000000000000 0000000000000000 000000fdfd300000 0000000000000100
 9 : 0000004d00040000 ffffffff813d8c6d 00000040000b0006 0000000000000000 0000000000040002 0000000000000400 000000fdfd300400 0000000000000100
10 : 00001fe500000000 ffffffff813d8c6d 00000058000b0002 0000000000000000 0000000000000000 0000000000000000 000000fdfd300000 0000000000000100
11 : 0000000000000000 ffffffff81043ea8 00000000000a0001 0000000000000000 0000000000040001 0000000000000514 000000fdfd300514 0000000000000100
12 : 0000008100040000 ffffffff813d8c6d 00000040000b0006 0000000000000000 0000000000000000 0000000000000000 000000fdfd300000 0000000000000100
13 : 0000006900040000 ffffffff813d8c6d 00000040000b0006 0000000000000000 0000000000040002 0000000000000400 000000fdfd300400 0000000000000100
14 : 0000004900040000 ffffffff813d8c6d 00000040000b0002 0000000000000000 0000000000040001 0000000000000000 000000fdfd300000 0000000000000100
15 : 0000002300040000 ffffffff813d8c6d 00000040000b0002 0000000000000000 0000000000040001 0000000000000400 000000fdfd300400 0000000000000100
16 : 0000000f00040000 ffffffff813d8c6d 00000040000b0006 0000000000000000 0000000000000000 0000000000000000 000000fdfd300000 0000000000000100
17 : 0000004b00040000 ffffffff813d8c6d 00000058000b0002 0000000000000000 0000000000000000 0000000000000400 000000fdfd300400 0000000000000100
18 : 0000003d00040000 ffffffff813d8c6d 00000040000b0006 0000000000000000 0000000000000000 00000000000002b8 000000fdfd3002b8 0000000000000100
19 : 0000004400040000 ffffffff813d8c6d 00000040000b0006 0000000000000000 0000000000000000 0000000000000400 000000fdfd300400 0000000000000100
20 : 0000001800040000 ffffffff813d8d27 0000000000060001 0000000000000000 0000000000000000 0000000000000000 000000fdfd300000 0000000000000100
21 : 0000002900040000 ffffffff813d8c6d 00000040000b0006 0000000000000000 0000000000000000 0000000000000400 000000fdfd300400 0000000000000100
22 : 0000005900040000 ffffffff813d8c6d 00000040000b0002 0000000000000000 0000000000040001 0000000000000000 000000fdfd300000 0000000000000100
23 : 0000001500040000 ffffffff813d8c6d 00000058000b0002 0000000000000000 0000000000000000 0000000000000400 000000fdfd300400 0000000000000100
24 : 0000006100040000 ffffffff8133e844 00000028001e000f 0000000000000000 0000000000000000 0000000000000000 000000fdfd300000 0000000000000100
25 : 0000005400040000 ffffffff813d8c6d 00000040000b0006 0000000000000000 0000000000000000 0000000000000400 000000fdfd300400 0000000000000100
26 : 0000002900040000 ffffffff813d8c6d 00000040000b0002 0000000000000000 0000000000040001 0000000000000000 000000fdfd300000 0000000000000100
27 : 0000000e00040000 ffffffff813d8c6d 00000040000b0006 0000000000000000 0000000000000000 0000000000000400 000000fdfd300400 0000000000000100
28 : 0000007e00040000 ffffffff813d8c6d 00000040000b0006 0000000000000000 0000000000040042 0000000000000000 000000fdfd300000 0000000000000100
29 : 0000000000000000 ffffffff81043ea8 00000000000a0001 0000000000000000 0000000000040001 0000000000000514 000000fdfd300514 0000000000000100
30 : 00003f4a00000000 ffffffff813d8c6d 00000040000b0006 0000000000000000 000000000004000a 0000000000000000 000000fdfd300000 0000000000000100
31 : 0001147800000000 ffffffff810b9400 00000000003c0001 0000000000000000 0000000000040009 00000000000005dc 000000fdfd3005dc 0000000000000100

------------------------------------------------------------
IBS MSR VALUES FROM CASE 3:

core : 0xc0011033 0xc0011034 0xc0011035 0xc0011036 0xc0011037 0xc0011038 0xc0011039 0xc001103a
 0 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
 1 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
 2 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
 3 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
 4 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
 5 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
 6 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
 7 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
 8 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
 9 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
10 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
11 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
12 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
13 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
14 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
15 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
16 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
17 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
18 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
19 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
20 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
21 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
22 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
23 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
24 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
25 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
26 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
27 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
28 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
29 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
30 : 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000100
31 : 00034d8900000000 ffffffff811370cc 0000000000120000 0000000000000000 0000000000000008 ffff88082592bc58 000000082592bc58 0000000000000100


Suravee


On Mon, 2012-12-17 at 10:44 +0100, Robert Richter wrote:
> On 16.12.12 10:04:10, Ingo Molnar wrote:
> > 
> > * suravee.suthikulpanit@amd.com <suravee.suthikulpanit@amd.com> wrote:
> > 
> > > From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> > > 
> > > Currently, the AMD IBS PMU initialize pmu.task_ctx_nr to 
> > > perf_invalid_context which only allows IBS to be running only 
> > > in system-wide mode (e.g. perf record -a). IBS hardware is 
> > > available in each core and should be per-context.  This patch 
> > > modifies the task_ctx_nr to use the perf_hw_context (default) 
> > > instead.
> > 
> > I'm wondering how extensively was it tested/verified that it's 
> > safe to enable IBS in per context mode as well, and that the 
> > profiling results are precise and accurate?
> 
> From the implementation's point of view this is very similar to hw
> perf counters. I wouldn't expect any issues here. Since IBS can be
> immediatly started/stopped and there is no caching, there won't be any
> incomming sample that is not related to that context.
> 
> The only potential problem I see could be a security risk in a way
> that an IBS sample might expose data related to other contexts such as
> cache information. This is similar to uncore/northbridge events so I
> don't think this is an issue, but we might want to evaluate this.
> 
> > We never used the IBS hardware in this fashion before, so some 
> > extra care is prudent - and traces of that extra care should be 
> > visible in the changelog as well.
> 
> Yeah, a comparison of numbers for IBS and hw counter (-e r076:p,r076
> and -e r0C1:p,r0C1) in per-context mode would be useful here.
> 
> -Robert
> 



