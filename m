Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab2AKLNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 06:13:31 -0500
Received: from lunge.queued.net ([173.255.254.236]:57082 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab2AKLNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 06:13:16 -0500
Date: Wed, 11 Jan 2012 02:10:22 -0800
From: Andres Salomon <dilinger@queued.net>
To: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Subject: Re: [PATCH] cs5535-clockevt: don't ignore MFGPT on SMP-capable
 kernels
Message-ID: <20120111021022.16ba5c93@debxo>
In-Reply-To: <4EF1FE5C.6040101@LiPPERTEmbedded.de>
References: <4EE620A5.7080402@LiPPERTEmbedded.de>
	<20111212123131.502be350@queued.net>
	<4EE77416.8090907@LiPPERTEmbedded.de>
	<4EE8ECF3.6000900@LiPPERTEmbedded.de>
	<20111214104724.292b02d4@queued.net>
	<4EF1FE5C.6040101@LiPPERTEmbedded.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 16:42:20 +0100
Jens Rottmann <JRottmann@LiPPERTEmbedded.de> wrote:

> cs5535-clockevt: don't ignore MFGPT on SMP-capable kernels
> 
> On SMP-capable kernels (e.g. generic distro kernel) the
> cs5535-clockevt driver loads but is not actually used.
> 
> Setting cpumask to cpu_all_mask works for UP-only kernels, but if
> compiled for SMP - though still running on the same UP hardware -
> kernel/time/tick-common.c:tick_check_new_device() reads this as
> "non-cpu-local" and silently ignores the device.
> 
> If we leave cpumask unset clockevents_register_device() will
> initialize it and the cs5535-clockevt driver will be used no matter
> how the kernel was compiled. Should anyone ever manage to stick a
> CS553x in an SMP system (is this even possible?) then a warning will
> be printed.  This is fine as the cs5535-clockevt driver was never
> written/tested for SMP.
> 
> If bisecting led you here this patch may have exposed a pre-existing
> MFGPT problem.  Configure for UP-only and re-check.
> 
> Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
> ---
> 
> --- linux-3.2-rc6/drivers/clocksource/cs5535-clockevt.c
> +++ use_mfgpt_on_smp_kernels/drivers/clocksource/cs5535-clockevt.c
> @@ -100,7 +100,6 @@ static struct clock_event_device cs5535_
>  	.set_mode = mfgpt_set_mode,
>  	.set_next_event = mfgpt_next_event,
>  	.rating = 250,
> -	.cpumask = cpu_all_mask,
>  	.shift = 32
>  };
> 
> _
> 

Hm, have you tried setting cpumask to cpumask_of(0), like a bunch of
the other clock_event_device drivers do?

