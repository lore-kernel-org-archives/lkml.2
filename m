Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1BHODf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 09:03:35 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:5640 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab1BHODe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 09:03:34 -0500
X-IronPort-AV: E=Sophos;i="4.60,442,1291611600"; 
   d="scan'208";a="134825004"
Subject: Re: [patch 0/4] XEN: Interrupt cleanups
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4D506AE6.6080900@goop.org>
References: <20110205200108.921707839@linutronix.de>
	 <4D50641B.2090006@goop.org>
	 <alpine.LFD.2.00.1102072231220.31804@localhost6.localdomain6>
	 <4D506AE6.6080900@goop.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 8 Feb 2011 14:03:31 +0000
Message-ID: <1297173811.9388.95.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-07 at 13:57 -0800, Jeremy Fitzhardinge wrote:
> On 02/07/2011 01:33 PM, Thomas Gleixner wrote:
> > Ok. The irq_chip conversion is mostly mechanical, but I'm really
> > concerned about that IRQ_SUSPENDED hackery. It'd be nice if you
> > resp. Ian could give that a test ride. That would allow me to cleanup
> > stuff in the core code.
> 
> Ian notes: "tglx's 4 patch interrupt cleanup series on LKML causes some
> oddities on PV migration. Will dig further tomorrow..."
> 
> So it looks like there's still something amiss.

The patches missed an indirect use of IRQF_NO_SUSPEND pulled in via
IRQF_TIMER. The following fixed things for me (probably belongs in your
patch 4/4).

With this fixlet PV guest migration works just fine. I also booted the
entire series as a dom0 kernel and it appeared fine.

I also tested alongside the cleanup patches Jeremy mentioned before and
as expected there is no interaction.

So, with the fixes to 2/4 (irq_move_irq think from yesterday) and 4/4
(below), the entire series is:
Acked-by: Ian Campbell <ian.campbell@citrix.com>

Ian.

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 067759e..2e2d370 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -397,7 +397,9 @@ void xen_setup_timer(int cpu)
 		name = "<timer kasprintf failed>";
 
 	irq = bind_virq_to_irqhandler(VIRQ_TIMER, cpu, xen_timer_interrupt,
-				      IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING|IRQF_TIMER,
+				      IRQF_DISABLED|IRQF_PERCPU|
+				      IRQF_NOBALANCING|IRQF_TIMER|
+				      IRQF_FORCE_RESUME,
 				      name, NULL);
 
 	evt = &per_cpu(xen_clock_events, cpu);


