Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab1GKTuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:50:11 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61263 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519Ab1GKTuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:50:09 -0400
Date: Mon, 11 Jul 2011 21:50:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Todd Poynor <toddpoynor@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] ARM: Call idle notifiers
Message-ID: <20110711195000.GH4109@somewhere.redhat.com>
References: <1309229190-25006-1-git-send-email-toddpoynor@google.com>
 <1309229190-25006-3-git-send-email-toddpoynor@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309229190-25006-3-git-send-email-toddpoynor@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 07:46:29PM -0700, Todd Poynor wrote:
> Change-Id: Id833e61c13baa1783705ac9e9046d1f0cc90c95e
> Signed-off-by: Todd Poynor <toddpoynor@google.com>
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

You seem to use this notifier with different semantics than x86.
x86 notifies idle state when it knows it goes to sleep and exit it any
time it gets interrupted. And it does that every time in the need_resched()
loop.

But here in ARM you enter idle only once before the loop (and you don't even
know if you will enter the loop). And you don't notify idle exit state on interrupts.

So if in the end this idle notifier is something that is really wanted, it needs
to have a consistant behaviour across archs.
