Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab1CRJYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 05:24:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:50360 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab1CRJYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 05:24:18 -0400
Subject: Re: perf, x86: Fix PEBS enable/disable vs cpuc->enabled
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arun Sharma <asharma@fb.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-perf-user@vger.kernel.org
In-Reply-To: <20110317005944.GA13308@dev1756.snc6.facebook.com>
References: <20110317005944.GA13308@dev1756.snc6.facebook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 18 Mar 2011 10:24:02 +0100
Message-ID: <1300440242.21794.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 17:59 -0700, Arun Sharma wrote:
> This commit:
> 
> commit 4807e3d5dc7bb7057dd6ca3abb09f3da2eb8c323
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Sat Mar 6 13:47:07 2010 +0100
> 
>     perf, x86: Fix PEBS enable/disable vs cpuc->enabled
> 
>     We should never call ->enable with the pmu enabled, and we _can_ have
>     ->disable called with the pmu enabled.
> 
> introduced a new warning that's triggering on one of my test machines when I tried
> counter multiplexing (more events than number of general purpose counters):
> 
> perf stat -e cycles,instructions,cache-misses,cache-misses,cache-misses,cache-misses,branch-misses -a -- sleep 10
> 
> The trace looks as follows:
> 
> WARNING: at arch/x86/kernel/cpu/perf_event_intel_ds.c:499 intel_pmu_enable_event+0x18f/0x2bc()

What warning is that, 499 isn't a WARN or even close to one in any tree
I checked.

> Pid: 0, comm: kworker/0:1 Not tainted 2.6.38-00029-g0d3bcb8 #12
> Call Trace:
> <IRQ> [<ffffffff8103c810>] ? warn_slowpath_common+0x80/0x98
> [<ffffffff8103c83d>] ? warn_slowpath_null+0x15/0x17
> [<ffffffff8100f3cb>] ? intel_pmu_enable_event+0x18f/0x2bc
> [<ffffffff8100f939>] ? x86_pmu_start+0xf7/0x108
> [<ffffffff8109dd33>] ? perf_adjust_period+0x141/0x15c
> [<ffffffff810a44ce>] ? perf_ctx_adjust_freq+0xd2/0x10a
> [<ffffffff810a45f0>] ? perf_event_task_tick+0xea/0x1f0
> [<ffffffff810389e9>] ? scheduler_tick+0xc8/0x258
> [<ffffffff8104920f>] ? update_process_times+0x62/0x72
> [<ffffffff810628bd>] ? tick_nohz_handler+0x8d/0xd6
> [<ffffffff8101bfbc>] ? smp_apic_timer_interrupt+0x83/0x96
> [<ffffffff81003253>] ? apic_timer_interrupt+0x13/0x20
> <EOI> [<ffffffff81209eb5>] ? intel_idle+0xc3/0xe9
> [<ffffffff81209e98>] ? intel_idle+0xa6/0xe9
> [<ffffffff81375a12>] ? cpuidle_idle_call+0x112/0x1b8
> [<ffffffff81001c15>] ? cpu_idle+0x5a/0x91
> [<ffffffff8143168b>] ? start_secondary+0x180/0x184
> ---[ end trace 0717acdc46c926b2 ]---
> 
> This was 2.6.38 + a few perf patches from the x86 tip. I believe stock 2.6.38 will behave similarly.
> 
> static void x86_pmu_start(struct perf_event *event, int flags)
> {
> ...
>        if (flags & PERF_EF_RELOAD) {
>                 WARN_ON_ONCE(!(event->hw.state & PERF_HES_UPTODATE));
>                 x86_perf_event_set_period(event); 
> 		// missing return here?
>         }
> 	..
> }
> 
> I wonder if the code should return for the PERF_EF_RELOAD case, rather than falling through.

definitely not, calling start on a running event will bail due to the
initial:

   if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
     return;

clause, not having seen that, we therefore know the event is indeed
stopped and we need start it. Therefore we always need to execute the
code you want to omit.

PERF_EF_RELOAD indicates that aside from writing the control register to
enable the event, we also need to write the count register because our
counter might also have been wrecked.


