Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab1AHRPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 12:15:01 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44864 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab1AHRO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 12:14:59 -0500
Date: Sat, 8 Jan 2011 17:13:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Cc: tglx@linutronix.de, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: interrupt latency while resuming.
Message-ID: <20110108171332.GB31708@n2100.arm.linux.org.uk>
References: <4D2897D1.3040609@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2897D1.3040609@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 08, 2011 at 08:58:57AM -0800, Abhijeet Dharmapurikar wrote:
>
> I am trying to address an issue of not handling a wakeup interrupt quick  
> enough while resuming. It is an edge triggered interrupt with the  
> IRQ_WAKEUP flag set. The interrupt controller implements lazy disabling  
> of interrupts, IOW does not have a disable callback in the irq_chip.
>
> So while going in to supend that interrupt is marked  IRQ_DISABLED in  
> dpm_suspend_noirq().
>
> On resume handle_edge_trigger is run right after  
> arch_suspend_enable_irqs(). It finds the interrupt marked  IRQ_DISABLED  
> and it sets the IRQ_PENDING flag and does not call the handler.
>
> As the resume path unrolls, non boot cpus  are enabled,  
> dpm_resume_noirq() is run. At that time it finds the IRQ_PENDING flag is  
> set on this interrupt and the interrupt handler is run.

The reason it's after non-boot CPUs are enabled is that the affinity
settings may require it to be run on one of these CPUs, so we need to
ensure that those CPUs are up.

We know it takes something like 200ms to run the lpg calibration, and
this is responsible for the majority of the time when bringing a CPU
online.

One solution is to sort out whether we need to re-run the lpj calibration
each time we resume a CPU.  At the moment, we're just using the boot CPU
loops_per_jiffy for every udelay(), assuming that all CPUs are running
at the same clock rate - so we _could_ skip the calibration as its
never used.

Or we could fix things so that it is used (which also sorts udelay for
asymetrically clocked secondary CPUs) but then we always have to re-run
the calibration, or we have to stipulate that secondary CPUs come up at
the same clock rate as they went down.  I suspect there's systems out
there where the latter is not true at present, so it's not something we
can impose - which means we're stuck having to do 200ms of recalibration
per CPU.

Another solution is to check whether we can run the handler before other
CPUs are online - it may mean we're breaking IRQ affinity, but any
non-boot affinity has already been broken by taking the other CPUs
offline.
