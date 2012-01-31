Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab2AaMny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:43:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49204 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab2AaMnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:43:53 -0500
Date: Tue, 31 Jan 2012 13:43:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, arjanvandeven@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: x86: clean up smpboot.c's use of udelay+schedule
Message-ID: <20120131124341.GC4408@elte.hu>
References: <20120130205304.0e10b05e@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130205304.0e10b05e@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> >From 9f8dd2b15ff19ad73ee0eb235b4fdde9277185e8 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Mon, 30 Jan 2012 20:38:09 -0800
> Subject: [PATCH] x86: clean up smpboot.c's use of udelay+schedule
> 
> smpboot.c does a udelay() followed by a schedule(); to yield
> the CPU to other threads. This comes from the time when the kernel
> did not yet have usleep_*() style APIs...
> 
> ... nowadays, the kernel can do better than this, and this
> patch replaces this code sequence with a usleep_range(),
> so that the CPU is actually yielded for some real time.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  arch/x86/kernel/smpboot.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 66d250c..0b794c6 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -781,14 +781,13 @@ do_rest:
>  		for (timeout = 0; timeout < 50000; timeout++) {
>  			if (cpumask_test_cpu(cpu, cpu_callin_mask))
>  				break;	/* It has booted */
> -			udelay(100);
>  			/*
>  			 * Allow other tasks to run while we wait for the
>  			 * AP to come online. This also gives a chance
>  			 * for the MTRR work(triggered by the AP coming online)
>  			 * to be completed in the stop machine context.
>  			 */
> -			schedule();
> +			usleep_range(100, 200);

I'm wondering whether we could shorten this delay to say 10 
usecs and thus save 0.1 msecs (or more) from a typical SMP 
bootup?

Thanks,

	Ingo
