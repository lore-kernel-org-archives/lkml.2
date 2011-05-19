Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab1ESIn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 04:43:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:46754 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727Ab1ESIn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 04:43:26 -0400
Date: Thu, 19 May 2011 10:43:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/7] clocksource: Get rid of the hardcoded 5 seconds
 sleep time limit
In-Reply-To: <1305766655.2915.187.camel@work-vm>
Message-ID: <alpine.LFD.2.02.1105191041030.3078@ionos>
References: <20110518205713.947614271@linutronix.de>  <20110518210136.109811585@linutronix.de> <1305766655.2915.187.camel@work-vm>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 May 2011, John Stultz wrote:
> On Wed, 2011-05-18 at 21:33 +0000, Thomas Gleixner wrote:
> > -	 * Ideally we want to use  some of the limits used in
> > -	 * clocksource_max_deferment, to provide a more informed
> > -	 * MAX_UPDATE_LENGTH. But for now this just gets the
> > -	 * register interface working properly.
> > +	 * Calc the maximum number of seconds which we can run before
> > +	 * wrapping around. For clocksources which have a mask > 32bit
> > +	 * we need to limit the max sleep time to have a good
> > +	 * conversion precision. 10 minutes is still a reasonable
> > +	 * amount. That results in a shift value of 24 for a
> > +	 * clocksource with mask >= 40bit and f >= 4GHz. That maps to
> > +	 * ~ 0.06ppm granularity for NTP. We apply the same 12.5%
> > +	 * margin as we do in clocksource_max_deferment()
> >  	 */
> 
> So, its not clear to me that the 12.5% margin really needed, since we
> take it out when we calculate clocksource_max_deferment(). Although with
> or without the margin I get the same mult/shift/max_idle_ns values for
> the hardware I'm testing.
> 
> Another nice detail from the change: It doesn't affect clocksources that
> normally wrap quickly:
> 
> Without your patch:
> --------------
> JDB: hpet mult: 2684354560 shift: 26 max_idle: 83214991360
> JDB: acpi_pm mult: 2343484437 shift: 23 max_idle: 4540500826
> JDB: tsc mult: 1342183991 shift: 31 max_idle: 2600481483
> 
> With your patch:
> ---------------
> JDB: hpet mult: 2684354560 shift: 26 max_idle: 83214991360
> JDB: acpi_pm mult: 2343484437 shift: 23 max_idle: 4540500826
> JDB: tsc mult: 10485812 shift: 24 max_idle: 332861616128
> 
> Although interestingly 332 secs calculated for the max idle is more then
> 12% off of 600.

We probably need to look at the math of clocksource_max_deferment()
again.
 
> Overall it looks good. I'm doing some NTP testing with the TSC shift
> change to make sure we don't get any odd side effects. I'll let you know
> how those go.

Ok.

Thanks,

	tglx
