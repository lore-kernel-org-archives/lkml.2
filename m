Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab0I0VOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 17:14:07 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37521 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752067Ab0I0VOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 17:14:05 -0400
Date: Mon, 27 Sep 2010 17:14:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH] x86: Barf when faults happen in NMI
Message-ID: <20100927211401.GA20402@Krystal>
References: <1285615833-5324-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285615833-5324-1-git-send-regression-fweisbec@gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:11:56 up 5 days,  1:14,  1 user,  load average: 0.38, 0.11,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> In x86, faults exit by executing the iret instruction, which then
> reenables NMIs if we faulted in NMI context. Then if a fault
> happens in NMI, another NMI can nest after the fault exits.
> 
> But we don't yet support nested NMIs because we have only one NMI
> stack. To prevent that, trigger a bug when a fault happens in NMI
> context.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> 
> I first thought about putting it in the vmalloc fault path only.
> But then I saw more occasions for the kernel to fault (kmemcheck
> or so), and so I thought it should be better put in the all in one
> path. But I suspect you won't like that conditional in the big
> x86 fault path.
> 
> 
>  arch/x86/mm/fault.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 4c4508e..80c997e 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -955,6 +955,8 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  	int write;
>  	int fault;
>  
> +	BUG_ON(in_nmi());

Alternative idea: we could put the test at the beginning of the NMI handler, so
if a NMI handler nests over a processor already "in_nmi", then we bug. I agree
that this will trigger less easily than bugging in the fault handler (because we
need to hit the actual nmi-coming-in-because-iret-reenabled-them-too-early
scenario, but it's far less intrusive.

Thoughts ?

Mathieu

> +
>  	tsk = current;
>  	mm = tsk->mm;
>  
> -- 
> 1.6.2.3
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
