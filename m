Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab1DUEcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 00:32:52 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:40508 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab1DUEcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 00:32:51 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.15.19
Date: Wed, 20 Apr 2011 21:32:23 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Kasper Pedersen <kernel@kasperkp.dk>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: x86: tsc: v2 make TSC calibration more immune to interrupts
Message-ID: <20110421043223.GA17753@feather>
References: <4DAF2B57.6010100@kasperkp.dk>
 <1303326959.2796.136.camel@work-vm>
 <4DAF37B4.3040408@kasperkp.dk>
 <1303331280.2796.154.camel@work-vm>
 <4DAF4E8B.6030506@kasperkp.dk>
 <20110420223929.GB5563@feather>
 <1303352368.2796.191.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303352368.2796.191.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 07:19:28PM -0700, john stultz wrote:
> On Wed, 2011-04-20 at 15:39 -0700, Josh Triplett wrote:
> > On Wed, Apr 20, 2011 at 11:22:19PM +0200, Kasper Pedersen wrote:
> > > When a SMI or plain interrupt occurs during the delayed part
> > > of TSC calibration, and the SMI/irq handler is good and fast
> > > so that is does not exceed SMI_TRESHOLD, tsc_khz can be a bit
> > > off (10-30ppm).
> > > 
> > > We should not depend on interrupts being longer than 50000
> > > clocks, so, in the refined calibration, always do the 5
> > > tries, and use the best sample we get.
> > > 
> > > This should work always for any four periodic or rate-limited
> > > interrupt sources. If we get 5 interrupts with 500ns gaps in
> > > a row, behaviour should be as without this patch.
> > > 
> > > It is safe to use the first value that passes SMI_TRESHOLD
> > > for the initial calibration: As long as tsc_khz is above
> > > 100MHz, SMI_TRESHOLD represents less than 1% of error.
> > > 
> > > The 8 additional samples costs us 28 microseconds in startup
> > > time.
> > > 
> > > measurements:
> > > On a 700MHz P3 I see t2-t1=~22000, and 31ppm error.
> > > A Core2 is similar: http://n1.taur.dk/tscdeviat.png
> > > (while mostly t2-t1=~1000, in about 1 of 3000 tests
> > > I see t2-t1=~20000 for both machines.)
> > > vmware ESX4 has t2-t1=~8000 and up.
> > > 
> > > v2: John Stulz suggested limiting best uncertainty to
> > > where it is needed, saving ~170usec startup time.
> > 
> > Have you considered disabling interrupts while calibrating?  That would
> > ensure that you only have to care about SMIs, not arbitrary interrupts.
> 
> This calibration is actually timer based (and runs for 1 second,
> allowing the system to continue booting in the meantime), so disabling
> irqs wouldn't work. You could just disable irqs during the tsc_getref,
> but that still has the possibility to get hit by SMIs, which are the
> real issue.

Ah, I see.  But it sounds like disabling IRQs during the critical region
would at least control all the sources of jitter that the kernel has
control over, and if tsc_getref only lasts for a few microseconds then
it has a very good chance of avoiding SMIs, as evidenced by the rarity
of the original problem reported in this thread ("about 1 in 3000").

> > Also, on more recent x86 systems you could look at MSR_SMI_COUNT (MSR
> > 0x34) to detect if any SMIs have occurred during the sample period.
> > rdmsr, start sample period, stop sample period, rdmsr, if delta of 0
> > then no SMIs occurred.  Exists on Nehalem and newer, at least.
> 
> That's interesting... but probably still too machine specific to be
> generally useful.

It seems like something usable as an enhancement if available: if the
MSR exists, use it to detect a lack of SMIs, and if no SMIs occur then
you don't need to keep sampling.  If the MSR doesn't exist, then go
ahead and sample a few times.

- Josh Triplett
