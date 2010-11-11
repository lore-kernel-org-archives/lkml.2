Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab0KKLRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:17:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51740 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483Ab0KKLR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:17:29 -0500
Date: Thu, 11 Nov 2010 12:17:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dongdong Deng <dongdong.deng@windriver.com>
Cc: dzickus@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V3 PATCH] x86: avoid calling arch_trigger_all_cpu_backtrace()
 at the same time on SMP
Message-ID: <20101111111702.GA12644@elte.hu>
References: <1289473307-7965-1-git-send-email-dongdong.deng@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289473307-7965-1-git-send-email-dongdong.deng@windriver.com>
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


Hm, another thing i noticed is that there's two of these:

>  #ifdef ARCH_HAS_NMI_WATCHDOG
> +/* "in progress" flag of arch_trigger_all_cpu_backtrace */
> +static unsigned long backtrace_flag;
> +
>  void arch_trigger_all_cpu_backtrace(void)
>  {
>  	int i;
> +	unsigned long flags;
> +
> +	/*
> +	 * Have to disable irq here, as the
> +	 * arch_trigger_all_cpu_backtrace() could be
> +	 * triggered by "spin_lock()" with irqs on.
> +	 */
> +	local_irq_save(flags);

> +/* "in progress" flag of arch_trigger_all_cpu_backtrace */
> +static unsigned long backtrace_flag;
> +
>  void arch_trigger_all_cpu_backtrace(void)
>  {
>  	int i;
> +	unsigned long flags;
> +
> +	/*
> +	 * Have to disable irq here, as the
> +	 * arch_trigger_all_cpu_backtrace() could be
> +	 * triggered by "spin_lock()" with irqs on.
> +	 */
> +	local_irq_save(flags);
> +
> +	if (test_and_set_bit(0, &backtrace_flag))

A fair amount of code is being duplicated in two places - which is not nice. Lets 
try to create a shared facility instead?

Thanks,

	Ingo
