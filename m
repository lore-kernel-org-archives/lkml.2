Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab0KHWFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:05:04 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:49045 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab0KHWFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:05:03 -0500
Subject: Re: [PATCH] Greatly improve TSC calibration using a delayed
 workqueue
From: john stultz <johnstul@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Clark Williams <williams@redhat.com>
In-Reply-To: <20101107204153.GA17592@basil.fritz.box>
References: <1289003985-29060-1-git-send-email-johnstul@us.ibm.com>
	 <20101107204153.GA17592@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 14:04:47 -0800
Message-ID: <1289253887.2798.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-07 at 21:41 +0100, Andi Kleen wrote:
> Hi John,
> 
> > +	/*
> > +	 * Since the timer is started early in boot, we may be
> > +	 * delayed the first time we expire. So set the timer
> > +	 * again once we know timers are working.
> > +	 */
> > +	if (tsc_start == -1) {
> > +		/*
> > +		 * Only set hpet once, to avoid mixing hardware
> > +		 * if the hpet becomes enabled later.
> > +		 */
> > +		hpet = is_hpet_enabled();
> > +		schedule_delayed_work(&tsc_irqwork, HZ);
> > +		tsc_start = tsc_read_refs(&ref_start, hpet);
> > +		return;
> > +	}
> > +
> > +	tsc_stop = tsc_read_refs(&ref_stop, hpet);
> 
> The HPET init code stops, starts the HPET. I think you need some
> way to protect against that here, e.g. a variable and rearming the 
> timer if it's true.

Interesting. Thanks for pointing that out! Couldn't I just start the
calibration after fs_initcall (when the hpet_late_init runs) to avoid
this as well? 

> Another issue may be races against suspend, but that may be too
> obscure.

Yea, that seems fairly obscure. Basically you'd have to suspend in the
first second as the system came up. In that case the code will throw out
any calibration refinement that's over 1% off of the initial boot
calibration, so I think this is ok trade off.

> I also worry a bit about NMIs etc. running later during this
> and messing up the measurement, but I guess the longer period
> makes up for it.

Yea, the 1 second period should help minimize any disturbance, and
again, this is just a refinement over the existing calibration, so if
its more then 1% off of the boot time fast calibration, we'll throw it
out.

> The rest of the patch looks ok to me.

Thanks for the review!
-john

