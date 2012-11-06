Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab2KFP6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:58:04 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:58009 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2KFP6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:58:01 -0500
MIME-Version: 1.0
In-Reply-To: <20121106155028.GB13629@infradead.org>
References: <1352123463-7346-1-git-send-email-eranian@google.com>
	<1352123463-7346-15-git-send-email-eranian@google.com>
	<20121106154446.GA13629@infradead.org>
	<20121106155028.GB13629@infradead.org>
Date: Tue, 6 Nov 2012 16:57:59 +0100
Message-ID: <CABPqkBR-MACL4-yqE1AMWAbvQ_bfUSDgoQi-w9OcyN8SJYhx5w@mail.gmail.com>
Subject: Re: [PATCH v2 14/16] perf tools: add new mem command for memory
 access profiling
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 4:50 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Tue, Nov 06, 2012 at 12:44:46PM -0300, Arnaldo Carvalho de Melo escreveu:
>> [root@sandy ~]# perf record -g -a -e cpu/mem-stores/
>> ^C[ perf record: Woken up 25 times to write data ]
>> [ perf record: Captured and wrote 7.419 MB perf.data (~324160 samples) ]
>>
>> Yay, got some numbers.
>
> But then the results out of:
>
> $ perf mem -t load rep --stdio
>
> Are bogus at least on the callchains:
>
I think it's because we are not using the period in the hist_entry but
the cost and there
is no cost for stores.

I think you should start with loads and no callchain. I am interested
in your toughts on how to
fix the data symbol resolution problem in perf. In V2, I modified the
kernel to at least
help perf distinguish MAP__FUNCTION from MAP__VARIABLE. But there is
still something
wrong.


> # ========
> # captured on: Tue Nov  6 12:46:21 2012
> # hostname : sandy.ghostprotocols.net
> # os release : 3.7.0-rc2+
> # perf version : 3.7.rc4.gfaa41f
> # arch : x86_64
> # nrcpus online : 8
> # nrcpus avail : 8
> # cpudesc : Intel(R) Core(TM) i7-2920XM CPU @ 2.50GHz
> # cpuid : GenuineIntel,6,42,7
> # total memory : 16220228 kB
> # cmdline : /home/acme/bin/perf record -g -a -e cpu/mem-stores/
> # event : name = cpu/mem-stores/, type = 4, config = 0x2cd, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_ho
> # HEADER_CPU_TOPOLOGY info available, use -I to display
> # HEADER_NUMA_TOPOLOGY info available, use -I to display
> # pmu mappings: cpu = 4, software = 1, tracepoint = 2, uncore_cbox_0 = 6, uncore_cbox_1 = 7, uncore_cbox_2 = 8, uncore_cbox_3
> # ========
> #
> # Samples: 98  of event 'cpu/mem-stores/'
> # Total cost : 98
> # Sort order : cost,mem,sym,dso,symbol_daddr,dso_daddr,snoop,tlb,locked
> #
> # Overhead      Samples     Cost             Memory access                                          Symbol               Share
> # ........  ...........  .......  ........................  ..............................................  ..................
> #
>     19.39%           19      N/A                            [k] csd_unlock                                  [kernel.kallsyms]
>             |
>             --- csd_unlock
>                |
>                |--6242.11%-- generic_smp_call_function_single_interrupt
>                |          smp_call_function_single_interrupt
>                |          call_function_single_interrupt
>                |          cpuidle_enter
>                |          cpuidle_enter_state
>                |          cpuidle_idle_call
>                |          cpu_idle
>                |          |
>                |          |--85.08%-- start_secondary
>                |          |
>                |           --14.92%-- rest_init
>                |                     start_kernel
>                |                     x86_64_start_reservations
>                |                     x86_64_start_kernel
>                |
>                |--100.00%-- smp_call_function_single_interrupt
>                |          call_function_single_interrupt
>                |          cpuidle_enter
>                |          cpuidle_enter_state
>                |          cpuidle_idle_call
>                |          cpu_idle
>                |          start_secondary
>                 --97088126703734472704.00%-- [...]
>
>      5.10%            5      N/A                            [k] _raw_spin_lock_irqsave                      [kernel.kallsyms]
>             |
>
>
>
> Ideas?
>
> - Arnaldo
