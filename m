Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab1HQUmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:42:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49458 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab1HQUjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:39:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: Re: [patch 15/36] Hexagon: Add init_task and process functions
Date: Wed, 17 Aug 2011 21:45:10 +0200
Message-ID: <1903508.hihLuMSVUz@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110817163521.257943209@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org> <20110817163521.257943209@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:jM7EEsmpHLDotNAzq+sWWA+kaOOnDDuyVVbTyUU26aq
 N7Pp0I41YX3/B5ekRouxk0SkHzxiRMlnk9ufnAvrIayQHAvdqJ
 TA1C17LIZpaK/2lNKblD0En8xGmJTOK9bTFOogd2ToAJRiGYff
 W8yrYxN45y3OCbeLpbQcgIg96larOnTzNRiP8mnZO6X7COODYb
 jNc35aypSM6sYZ3GJ0v1g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011 11:35:12 Richard Kuo wrote:
> +/*
> + *  Spin, or better still, do a hardware or VM wait instruction
> + *  If hardware or VM offer wait termination even though interrupts
> + *  are disabled.
> + */
> +static void default_idle(void)
> +{
> +       __vmwait();
> +}
> +
> +void (*idle_sleep)(void) = default_idle;
> +
> +void cpu_idle(void)
> +{
> +       while (1) {
> +               tick_nohz_stop_sched_tick(1);
> +               while (!need_resched())
> +                       idle_sleep();
> +               tick_nohz_restart_sched_tick();
> +               schedule();
> +       }
> +}

This looks like you have the classic going to sleep race in here:

You need to disable hardware interrupts before checking need_resched(),
otherwise an interrupt might hit just after you have checked it and
before you call __vmwait(). The definition of the __vmwait call
must atomically reenable interrupts and suspend the CPU.

	Arnd
