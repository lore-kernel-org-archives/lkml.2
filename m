Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab0FJKzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 06:55:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43230 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab0FJKzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 06:55:37 -0400
Subject: Re: [PATCH 3/5] perf: New PERF_EVENT_STATE_PAUSED event state
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1276141760-11590-4-git-send-regression-fweisbec@gmail.com>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com>
	 <1276141760-11590-4-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 12:55:17 +0200
Message-ID: <1276167317.2077.109.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 05:49 +0200, Frederic Weisbecker wrote:
> This brings a new PERF_EVENT_STATE_PAUSED state. It means the events
> is enabled but we don't want it to run, it must be in the same state
> than after a pmu->stop() call. So the event has been reserved and
> allocated and it is ready to start after a pmu->start() call.
> 
> It is deemed for hardware events when we want them to be reserved on
> the cpu and ready to be started anytime. This is going to be useful
> for the new context exclusion that will follow.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/kernel/cpu/perf_event.c |    6 ++++--
>  include/linux/perf_event.h       |    3 ++-
>  kernel/perf_event.c              |    7 ++++---
>  3 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index f2da20f..9b0e52f 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -839,7 +839,8 @@ void hw_perf_enable(void)
>  			    match_prev_assignment(hwc, cpuc, i))
>  				continue;
>  
> -			x86_pmu_stop(event);
> +			if (event->state != PERF_EVENT_STATE_PAUSED)
> +				x86_pmu_stop(event);
>  		}
>  
>  		for (i = 0; i < cpuc->n_events; i++) {
> @@ -851,7 +852,8 @@ void hw_perf_enable(void)
>  			else if (i < n_running)
>  				continue;
>  
> -			x86_pmu_start(event);
> +			if (event->state != PERF_EVENT_STATE_PAUSED)
> +				x86_pmu_start(event);
>  		}
>  		cpuc->n_added = 0;
>  		perf_events_lapic_init();

Shouldn't that latter be == PAUSED?

Also, you'll have to audit all struct pmu implementations that
stop/disable or disable/disable is good.

Also, I'd rather keep the whole event->state knowledge in the generic
code.
