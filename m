Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab2CGD0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 22:26:37 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:43433 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab2CGD0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 22:26:36 -0500
Message-ID: <1331090790.2191.173.camel@work-vm>
Subject: Re: [PATCH] x86, tsc: Skip refined tsc calibration on systems with
 reliable TSC.
From: john stultz <johnstul@us.ibm.com>
To: Alok Kataria <akataria@vmware.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>, dirk.brandewie@gmail.com,
        alan@linux.intel.com, stable@kernel.org, Dan Hecht <dhecht@vmware.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 06 Mar 2012 19:26:30 -0800
In-Reply-To: <1331085930.8086.33.camel@ank32.eng.vmware.com>
References: <1329876964.10380.28.camel@ank32.eng.vmware.com>
	 <1329877195.10380.33.camel@ank32.eng.vmware.com>
	 <1331083933.2191.172.camel@work-vm>
	 <1331085930.8086.33.camel@ank32.eng.vmware.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030703-7408-0000-0000-00000342B9B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 18:05 -0800, Alok Kataria wrote:
> Hi John,
> 
> On Tue, 2012-03-06 at 17:32 -0800, john stultz wrote:
> > On Tue, 2012-02-21 at 18:19 -0800, Alok Kataria wrote:
> > > [Oops forgot to copy LKML, now it is, sorry for the duplicates]
> > > 
> > > While running the latest Linux as guest under VMware in highly
> > > over-committed situations, we have seen cases when the refined TSC
> > > algorithm fails to get a valid tsc_start value in
> > > tsc_refine_calibration_work from multiple attempts. As a result the
> > > kernel keeps on scheduling the tsc_irqwork task for later. Subsequently
> > > after several attempts when it gets a valid start value it goes through
> > > the refined calibration and either bails out or uses the new results.
> > > Given that the kernel originally read the TSC frequency from the
> > > platform, which is the best it can get, I don't think there is much
> > > value in refining it. 
> > > 
> > > So IMO, for systems which get the TSC frequency from the platform we
> > > should skip the refined tsc algorithm.
> > >         
> > > We can use the TSC_RELIABLE cpu cap flag to detect this, right now it is
> > > set only on VMware and for Moorestown Penwell both of which have there
> > > own TSC calibration methods.
> > 
> > So this looks ok to me, only one nit below...
> > 
> > > 
> > > Index: linux-2.6/arch/x86/kernel/tsc.c
> > > ===================================================================
> > > --- linux-2.6.orig/arch/x86/kernel/tsc.c	2012-02-21 17:31:01.000000000 -0800
> > > +++ linux-2.6/arch/x86/kernel/tsc.c	2012-02-21 17:39:05.000000000 -0800
> > > @@ -874,6 +874,13 @@ static void tsc_refine_calibration_work(
> > >  		goto out;
> > > 
> > >  	/*
> > > +	 * Trust the results of the earlier calibration on systems
> > > +	 * exporting a reliable TSC.
> > > +	 */
> > > +	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE))
> > > +		goto out;
> > > +
> > > +	/*
> > 
> > Instead of dropping out in the function called by the work-queue, why
> > not just avoid scheduling the work-queue to begin with?
> > 
> > The FEATURE_TSC_RELIABLE isn't something that is set late, and needs the
> > delay, right?
> 
> Right, but the reason I did it as part of work-queue was because on the
> "out" path it still registered the tsc clocksource for us, the patch you
> suggested doesn't do that. Please find below a patch on similar lines,
> which registers the clocksource on RELIABLE_TSC systems, instead of
> relying on irq_work to do that. 

Ah, yes. Thanks for pointing that out!

I'll go ahead and queue your revision.

thanks
-john


