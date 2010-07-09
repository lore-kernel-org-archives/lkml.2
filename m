Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab0GIXfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:35:00 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:43610 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755118Ab0GIXe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:34:58 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
Subject: Re: [RFC][PATCH 00/13] perf pmu interface changes -v3
In-Reply-To: <1278690734.1900.232.camel@laptop>
References: <20100709082117.631541128@chello.nl> <1278688302.9864.9.camel@e102144-lin.cambridge.arm.com> <1278690734.1900.232.camel@laptop>
User-Agent: Notmuch/0.3.1-61-g3f63bb6 (http://notmuchmail.org) Emacs/23.1.90.2 (x86_64-unknown-linux-gnu)
Date: Sat, 10 Jul 2010 00:34:56 +0100
Message-ID: <87vd8o8c0v.fsf@linux-g6p1.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jul 2010 17:52:14 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
> Index: linux-2.6/arch/sh/kernel/perf_event.c
> ===================================================================
> --- linux-2.6.orig/arch/sh/kernel/perf_event.c
> +++ linux-2.6/arch/sh/kernel/perf_event.c
> @@ -256,11 +256,14 @@ static int sh_pmu_add(struct perf_event 
>  	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>  	struct hw_perf_event *hwc = &event->hw;
>  	int idx = hwc->idx;
> +	int ret = -EAGAIN;
> +
> +	perf_pmu_disable(event->pmu);
>  
>  	if (__test_and_set_bit(idx, cpuc->used_mask)) {
>  		idx = find_first_zero_bit(cpuc->used_mask, sh_pmu->num_events);
>  		if (idx == sh_pmu->num_events)
> -			return -EAGAIN;
> +			goto ret;
>  
>  		__set_bit(idx, cpuc->used_mask);
>  		hwc->idx = idx;
> @@ -273,8 +276,11 @@ static int sh_pmu_add(struct perf_event 
>  		sh_pmu_start(event, PERF_EF_RELOAD);
>  
>  	perf_event_update_userpage(event);
> +	ret = 0;
>  
> -	return 0;
> +out:
> +	perf_pmu_enable(event->pmu);
> +	return ret;
>  }
>  
>  static void sh_pmu_read(struct perf_event *event)

This patch results in the following compilation error,

  CC      arch/sh/kernel/perf_event.o
cc1: warnings being treated as errors
arch/sh/kernel/perf_event.c: In function 'sh_pmu_add':
arch/sh/kernel/perf_event.c:281: error: label 'out' defined but not used
arch/sh/kernel/perf_event.c:266: error: label 'ret' used but not defined
arch/sh/kernel/perf_event.c: In function 'sh_pmu_setup':
arch/sh/kernel/perf_event.c:343: error: parameter 'cpuhw' is initialized
arch/sh/kernel/perf_event.c:343: error: 'cpu' undeclared (first use in this function)
arch/sh/kernel/perf_event.c:343: error: (Each undeclared identifier is reported only once
arch/sh/kernel/perf_event.c:343: error: for each function it appears in.)
arch/sh/kernel/perf_event.c:343: error: left-hand operand of comma expression has no effect
arch/sh/kernel/perf_event.c:345: error: expected declaration specifiers before 'memset'
arch/sh/kernel/perf_event.c:346: error: expected declaration specifiers before '}' token
arch/sh/kernel/perf_event.c:350: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
arch/sh/kernel/perf_event.c:366: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
arch/sh/kernel/perf_event.c:378: error: old-style parameter declarations in prototyped function definition
arch/sh/kernel/perf_event.c:378: error: expected '{' at end of input
make[1]: *** [arch/sh/kernel/perf_event.o] Error 1
make: *** [arch/sh/kernel/perf_event.o] Error 2

You can pick up a CodeSourcery SH toolchain from
http://www.codesourcery.com/sgpp/lite/superh/portal/release1298 in case
you wanted to build any further changes.

Does this patch look OK? It fixes the above compilation error for me.

diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 3bfd70b..bcfb325 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -263,7 +263,7 @@ static int sh_pmu_add(struct perf_event *event, int flags)
 	if (__test_and_set_bit(idx, cpuc->used_mask)) {
 		idx = find_first_zero_bit(cpuc->used_mask, sh_pmu->num_events);
 		if (idx == sh_pmu->num_events)
-			goto ret;
+			goto out;
 
 		__set_bit(idx, cpuc->used_mask);
 		hwc->idx = idx;
@@ -339,7 +339,7 @@ static struct pmu pmu = {
 };
 
 static void sh_pmu_setup(int cpu)
-
+{
 	struct cpu_hw_events *cpuhw = &per_cpu(cpu_hw_events, cpu);
 
 	memset(cpuhw, 0, sizeof(struct cpu_hw_events));
