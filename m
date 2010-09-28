Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0I1Kga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 06:36:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54684 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab0I1Kg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 06:36:27 -0400
Date: Tue, 28 Sep 2010 12:36:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH] x86: Barf when faults happen in NMI
Message-ID: <20100928103618.GB8514@elte.hu>
References: <1285615833-5324-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285615833-5324-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> In x86, faults exit by executing the iret instruction, which then 
> reenables NMIs if we faulted in NMI context. Then if a fault happens 
> in NMI, another NMI can nest after the fault exits.
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
> I first thought about putting it in the vmalloc fault path only. But 
> then I saw more occasions for the kernel to fault (kmemcheck or so), 
> and so I thought it should be better put in the all in one path. But I 
> suspect you won't like that conditional in the big x86 fault path.
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
> +

Hm, this is a fastpath, so it would be nice to put this into the vmalloc 
and kmemcheck paths (even though it's less clean that way).

Also, a WARN_ON_ONCE() would probably help more in getting bug reports 
out of such systems, than a BUG_ON() crashed kernel.

Thanks,

	Ingo
