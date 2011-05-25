Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab1EYWXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 18:23:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:55508 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab1EYWXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 18:23:43 -0400
Date: Thu, 26 May 2011 00:23:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kasper Pedersen <kkp2010@kasperkp.dk>
cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John Stultz <johnstul@us.ibm.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH v3] x86: tsc: make TSC calibration immune to interrupts
In-Reply-To: <4DDD7D9E.60100@kasperkp.dk>
Message-ID: <alpine.LFD.2.02.1105260021570.3078@ionos>
References: <4DDC0B4F.6060202@kasperkp.dk> <alpine.LFD.2.02.1105251243330.3078@ionos> <4DDD7D9E.60100@kasperkp.dk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011, Kasper Pedersen wrote:

> On 05/25/2011 12:51 PM, Thomas Gleixner wrote:
> >> The 8 additional samples costs us 28 microseconds in startup
> >> time.
> > 
> > That's a good reason to avoid the whole conditional thing and just do
> > the best of 5 always.
> 
> I do not mind removing it again.
> The additional 170us only happen when quick_pit_calibrate fails,
> and then native_calibrate_tsc burns 30ms extra anyway.

Yes, not worth the extra conditional.
 
> >> +
> >> +	*p = tp;
> > 
> > The value is completely uninteresting when we return ULLONG_MAX.
> > 
> 
> native_calibrate_tsc() depends on *p being written regardless of
> whether we can get a SMI-free reading:
> 
> 	/* We don't have an alternative source, disable TSC */
> 	if (!hpet && !ref1 && !ref2) {
> 		printk("TSC: No reference (HPET/PMTIMER) available\n");
> 		return 0;
> 	}
> 
> this works since acpi_pm_read_early() returns 0 when pmtmr_ioport 
> is 0, or CONFIG_X86_PM_TIMER is not set.
> 
> Without it we would report "calibration failed" rather than 
> "No reference" or "Using PIT" when there is neither pmtimer nor 
> hpet.

Fair enough. So a comment might be in order :) That code is fricking
complex just to figure out on which frequency that damn thing runs :(

Thanks,

	tglx
