Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab1GGRJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 13:09:06 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:37336 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754797Ab1GGRJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 13:09:01 -0400
From: Kevin Hilman <khilman@ti.com>
To: Todd Poynor <toddpoynor@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] ARM: Call idle notifiers
Organization: Texas Instruments, Inc.
References: <1309229190-25006-1-git-send-email-toddpoynor@google.com>
	<1309229190-25006-3-git-send-email-toddpoynor@google.com>
Date: Thu, 07 Jul 2011 10:08:55 -0700
In-Reply-To: <1309229190-25006-3-git-send-email-toddpoynor@google.com> (Todd
	Poynor's message of "Mon, 27 Jun 2011 19:46:29 -0700")
Message-ID: <874o2ydnmg.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Todd Poynor <toddpoynor@google.com> writes:

> Change-Id: Id833e61c13baa1783705ac9e9046d1f0cc90c95e
> Signed-off-by: Todd Poynor <toddpoynor@google.com>

I don't think the notifiers should be called in ARM-generic code.
As discussed w/Colin in his proposal for the CPU PM notifiers, the
platform-specific code should decide when to run notifier chain.

To give an example, on OMAP we wouldn't want the notifier chain to be
run until the OMAP PM core has programmed the next states of the various
power domains.  That way the notifier functions could check the next
state to determine if their powerdomain is going to retention or off and
decide whether or not a context save/restore will be needed.

Kevin


> ---
>  arch/arm/kernel/process.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index 5e1e541..1b9101e 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -184,6 +184,7 @@ void cpu_idle(void)
>  	while (1) {
>  		tick_nohz_stop_sched_tick(1);
>  		leds_event(led_idle_start);
> +		idle_notifier_call_chain(IDLE_START);
>  		while (!need_resched()) {
>  #ifdef CONFIG_HOTPLUG_CPU
>  			if (cpu_is_offline(smp_processor_id()))
> @@ -208,6 +209,7 @@ void cpu_idle(void)
>  			}
>  		}
>  		leds_event(led_idle_end);
> +		idle_notifier_call_chain(IDLE_END);
>  		tick_nohz_restart_sched_tick();
>  		preempt_enable_no_resched();
>  		schedule();
