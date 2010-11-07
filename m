Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0KGUl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 15:41:56 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39852 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab0KGUlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 15:41:55 -0500
Date: Sun, 7 Nov 2010 21:41:53 +0100
From: Andi Kleen <andi@firstfloor.org>
To: John Stultz <johnstul@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Clark Williams <williams@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Greatly improve TSC calibration using a delayed
 workqueue
Message-ID: <20101107204153.GA17592@basil.fritz.box>
References: <1289003985-29060-1-git-send-email-johnstul@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289003985-29060-1-git-send-email-johnstul@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

> +	/*
> +	 * Since the timer is started early in boot, we may be
> +	 * delayed the first time we expire. So set the timer
> +	 * again once we know timers are working.
> +	 */
> +	if (tsc_start == -1) {
> +		/*
> +		 * Only set hpet once, to avoid mixing hardware
> +		 * if the hpet becomes enabled later.
> +		 */
> +		hpet = is_hpet_enabled();
> +		schedule_delayed_work(&tsc_irqwork, HZ);
> +		tsc_start = tsc_read_refs(&ref_start, hpet);
> +		return;
> +	}
> +
> +	tsc_stop = tsc_read_refs(&ref_stop, hpet);

The HPET init code stops, starts the HPET. I think you need some
way to protect against that here, e.g. a variable and rearming the 
timer if it's true.

Another issue may be races against suspend, but that may be too
obscure.

I also worry a bit about NMIs etc. running later during this
and messing up the measurement, but I guess the longer period
makes up for it.

The rest of the patch looks ok to me.

-Andi
