Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab1HaNpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:45:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53294 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab1HaNpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:45:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 15/35] Hexagon: Add init_task and process functions
Date: Wed, 31 Aug 2011 15:45:14 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
References: <20110830190729.923334292@codeaurora.org> <20110830190801.159310885@codeaurora.org>
In-Reply-To: <20110830190801.159310885@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311545.14797.arnd@arndb.de>
X-Provags-ID: V02:K0:be13LbqM9o/VnkN07Gzj6ksTswTcB0YbgFENfTZ46ZC
 UjGKOV5OIfybOYCPEOj105kFCpYCndIkZFDtw0621Y+Y67LVDM
 FBEwipWrAMV3R8iG0/+XhlN4A7qhKq5HCYzKwJ+NU66UiygT3+
 9/FLfFvUeuUVAijTPZ7xN/bJd7LoyJEYVySR4Y72RQhEdELYQL
 gtCCFjxB4dZjTFS0bV2KgCLPgOe/ZXG0yqcEnz4JXgbnklFMHn
 277BX9Vj436BgYwkKE0clX6RChcjuhEwPWeqmvuxUNBsMQxftY
 hhdWBzU/MdmBPaN9W+1QxZEoDZ8zh5NUFeLiqv7u/79jXQ2yTn
 BpNfmYneSrzbAEeMweuY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> Fixed potential race-to-sleep condition in cpu_idle().  I hope.
> 
> If called with interrupts disabled, our __vmwait() actually just returns
> without servicing it.  Let me know if there's any other condition that
> I've missed...

The race should be gone now, but

> +void cpu_idle(void)
> +{
> +	while (1) {
> +		tick_nohz_stop_sched_tick(1);
> +		local_irq_disable();
> +		while (!need_resched()) {
> +			idle_sleep();
> +			/*  interrupts wake us up, but aren't serviced  */
> +			local_irq_enable();	/* service interrupt   */
> +			local_irq_disable();
> +		}
> +		tick_nohz_restart_sched_tick();
> +		schedule();
> +	}
> +}

you now call schedule() with interrupts disabled, which isn't strictly
allowed.

I think it should all be fine if you write it as

	while (1) {
		tick_nohz_stop_sched_tick(1);
		local_irq_disable();
		while (!need_resched()) {
			idle_sleep();
		}
		local_irq_enable();
		tick_nohz_restart_sched_tick();
		schedule();
	}


	Arnd
