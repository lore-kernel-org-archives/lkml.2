Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab1DUGeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 02:34:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:9428 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab1DUGeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 02:34:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,250,1301900400"; 
   d="scan'208";a="736383618"
Subject: Re: [PATCH -tip] perf, x86: P4 PMU - Don't forget to clear
 cpuc->active_mask on overflow
From: Lin Ming <ming.m.lin@intel.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
In-Reply-To: <4DAEF821.4050103@openvz.org>
References: <4DAEF821.4050103@openvz.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 14:34:08 +0800
Message-ID: <1303367648.28930.57.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-20 at 23:13 +0800, Cyrill Gorcunov wrote:
> It's not enough to simply disable event on overflow the cpuc->active_mask
> should be cleared as well otherwise counter may stall in "active" even
> in real being already disabled (which potentially may lead to the situation
> that user may not use this counter further).
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
> 
> Ming, iirc you were testing this one, but without unknown nmi fix. So
> patch from Don should fix unknown nmi issue, please give this patch a
> shot again if you have some time (Don's patch is here
> https://lkml.org/lkml/2011/4/18/404 but I think you have it already in mailbox).

Tested the 2 patches with nmi watchdog enabled and no unknown nmi was
seen when running perf tool.

Nice.

Thanks,
Lin Ming

> 
>  arch/x86/kernel/cpu/perf_event_p4.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -946,7 +946,7 @@ static int p4_pmu_handle_irq(struct pt_r
>  		if (!x86_perf_event_set_period(event))
>  			continue;
>  		if (perf_event_overflow(event, 1, &data, regs))
> -			p4_pmu_disable_event(event);
> +			x86_pmu_stop(event, 0);
>  	}
> 
>  	if (handled) {
> 


