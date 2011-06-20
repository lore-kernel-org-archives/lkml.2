Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab1FTIVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 04:21:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61271 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1FTIU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 04:20:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 11/19] OpenRISC: Idle/Power management
Date: Mon, 20 Jun 2011 10:20:39 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1308483825-6023-1-git-send-email-jonas@southpole.se> <1308483825-6023-12-git-send-email-jonas@southpole.se>
In-Reply-To: <1308483825-6023-12-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106201020.39097.arnd@arndb.de>
X-Provags-ID: V02:K0:K4Blfxe+lumEC4bhfuxXL6f2zYCy/7fMlvRlMM/TRLP
 SkBniKVBAPaOFU3UhC6brw0ePZP+EDYMpN6LjQcscnEcV5PPgQ
 gxGn726pg4+0fGyUzv4ecPSYKBIV7ZkmK1hp1/p15qgSTW51Q0
 +VmF0AJTG1vOMTNylAuEjb2jdl5rLzBYYaT/z6En6G/uU0ixk/
 2j9OeUBek8DPM8Zt1R5fw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 June 2011 13:43:37 Jonas Bonn wrote:
> +void cpu_idle(void)
> +{
> +        unsigned int cpu = smp_processor_id();
> +
> +        set_thread_flag(TIF_POLLING_NRFLAG);
> +
> +        /* endless idle loop with no priority at all */
> +        while (1) {
> +                tick_nohz_stop_sched_tick(1);
> +
> +                while (!need_resched()) {
> +                        check_pgt_cache();
> +                        rmb();
> +
> +/*                        if (cpu_is_offline(cpu))
> +                                play_dead();
> +*/
> +                       clear_thread_flag(TIF_POLLING_NRFLAG);
> +
> +                        local_irq_disable();
> +                        /* Don't trace irqs off for idle */
> +                        stop_critical_timings();
> +                       if (powersave != NULL )
> +                               powersave();
> +                       start_critical_timings();
> +                       local_irq_enable();
> +                       set_thread_flag(TIF_POLLING_NRFLAG);
> +                }
> +
> +                tick_nohz_restart_sched_tick();
> +                preempt_enable_no_resched();
> +                schedule();
> +                preempt_disable();
> +        }

Shouldn't you check need_resched() inside of local_irq_disable? Otherwise
you may get interrupted between the check at the start of the loop and
the irq_disable, which tries to wake up another process just before you go
to sleep indefinitely.

	Arnd
