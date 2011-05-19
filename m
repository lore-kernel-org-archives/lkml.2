Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab1ESJd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:33:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60990 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629Ab1ESJdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:33:25 -0400
Date: Thu, 19 May 2011 11:33:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [patch 7/7] x86: hpet: Cleanup the clockevents init and register
 code
Message-ID: <20110519093318.GC6251@elte.hu>
References: <20110518205713.947614271@linutronix.de>
 <20110518210136.646482357@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518210136.646482357@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> @@ -884,6 +835,14 @@ int __init hpet_enable(void)
>  		goto out_nohpet;
>  
>  	/*
> +	 * The period is a femto seconds value. Convert it to a
> +	 * frequency.
> +	 */
> +	freq = FSEC_PER_SEC;
> +	do_div(freq, hpet_period);
> +	hpet_freq = freq;

Something i just noticed: with a typical hpet frequency of around 14 MHz we get 
a period of 71428571 femtoseconds.

Our HPET_MAX_PERIOD is 100000000 at the moment, so our limits look like this:

    100000
  71428571
 100000000

Note how close the max period (lowest frequency) is to our typical value!

So if there's a 10 MHz hpet somewhere, with just slightly below spec, we'd fail 
due to:

        if (hpet_period < HPET_MIN_PERIOD || hpet_period > HPET_MAX_PERIOD)
                goto out_nohpet;

unless i got my numbers wrong it might be worth upping the max period to 
1000000000, to allow down to 1 MHz hpet frequencies. Or at least up it enough 
to make 10 MHz possible modulo small noise.

Patch looks good:

Reviewed-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
