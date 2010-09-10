Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab0IJVCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 17:02:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:13957 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579Ab0IJVCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 17:02:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,347,1280732400"; 
   d="scan'208";a="836676734"
Subject: Re: [PATCH] x86, tsc: Fix a preemption leak in
 restore_sched_clock_state()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
        Nico Schottelius <nico-nospam@schottelius.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Nico Schottelius <nico-linux-20100709@schottelius.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Florian Pritz <flo@xssn.at>, "stable@kernel.org" <stable@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "Brown, Len" <lenb@kernel.org>
In-Reply-To: <1284150773.402.122.camel@laptop>
References: <Pine.LNX.4.64.1009101324280.3056@boston.corp.fedex.com>
	 <1284104920.402.21.camel@laptop>
	 <AANLkTinBwfLXi0Bv0_gzSWRsdDPzHFQFZFwEYjbwkNs4@mail.gmail.com>
	 <1284120353.402.39.camel@laptop>
	 <AANLkTikKmsM2kunB_ocwRawLUiuP4-_nz-mPsiapw7TJ@mail.gmail.com>
	 <1284150773.402.122.camel@laptop>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 10 Sep 2010 14:01:31 -0700
Message-Id: <1284152491.2681.3.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 13:32 -0700, Peter Zijlstra wrote:
> D'0h !! *facepalm*
> 
> Shame on me for not spotting that sooner.
> 
> ---
> Subject: x86, tsc: Fix a preemption leak in restore_sched_clock_state()
> 
> A real life genuine preemption leak..
> 
> Reported-by: Jeff Chua <jeff.chua.linux@gmail.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/kernel/tsc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 873a321..4496315 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -655,7 +655,7 @@ void restore_sched_clock_state(void)
>  
>  	local_irq_save(flags);
>  
> -	get_cpu_var(cyc2ns_offset) = 0;
> +	__get_cpu_var(cyc2ns_offset) = 0;
>  	offset = cyc2ns_suspend - sched_clock();
>  
>  	for_each_possible_cpu(cpu)

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

Before heading for lunch, I was scratching my head and thinking that I
might be doing something wrong with the local_irq_disable() and
local_irq_enable() in that patch. But you got it right.

Thanks for looking at this and thanks to Jeff for reporting.

Original patch was marked as stable for 2.6.32+, so we need to make sure
that Greg picks up this piece too along with the original patch.

