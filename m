Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab2HPPRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:17:41 -0400
Received: from sym2.noone.org ([178.63.92.236]:35607 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757333Ab2HPPRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:17:38 -0400
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2012 11:17:38 EDT
Date: Thu, 16 Aug 2012 17:09:39 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 07/31] arm64: Process management
Message-ID: <20120816150939.GH7141@distanz.ch>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-8-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344966752-16102-8-git-send-email-catalin.marinas@arm.com>
X-Editor: Vi IMproved 7.2
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-08-14 at 19:52:08 +0200, Catalin Marinas <catalin.marinas@arm.com> wrote:
> +void cpu_idle(void)
> +{
> +	local_fiq_enable();
> +
> +	/* endless idle loop with no priority at all */
> +	while (1) {
> +		tick_nohz_idle_enter();
> +		rcu_idle_enter();
> +		while (!need_resched()) {
> +			/*
> +			 * We need to disable interrupts here to ensure
> +			 * we don't miss a wakeup call.
> +			 */
> +			local_irq_disable();
> +			if (!need_resched()) {
> +				stop_critical_timings();
> +				pm_idle();
> +				start_critical_timings();
> +				/*
> +				 * pm_idle functions should always return
> +				 * with IRQs enabled.
> +				 */
> +				WARN_ON(irqs_disabled());
> +			} else {
> +				local_irq_enable();
> +			}
> +		}
> +		rcu_idle_exit();
> +		tick_nohz_idle_exit();
> +		preempt_enable_no_resched();
> +		schedule();
> +		preempt_disable();

You could use schedule_preempt_disabled() instead of the above 3 calls.
See http://lkml.kernel.org/n/tip-24swm5zut3h9c4a6s46x8rws@git.kernel.org

Cheers
Tobias
