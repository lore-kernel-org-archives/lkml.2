Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562Ab0JFUwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:52:20 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59739 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab0JFUwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:52:19 -0400
Date: Wed, 6 Oct 2010 15:55:19 -0500
From: Sonny Rao <sonnyrao@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, miltonm@bga.com,
        Ian Campbell <ian.campbell@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        linux-kernel@vger.kernel.org, sonnyrao@linux.vnet.ibm.com
Subject: Re: [RESEND PATCH 1/2] IRQ: use cpu_possible_mask rather than
 online_mask in setup_affinity
Message-ID: <20101006205519.GP13726@us.ibm.com>
References: <1285968378-12805-1-git-send-email-nacc@us.ibm.com>
 <1285968378-12805-2-git-send-email-nacc@us.ibm.com>
 <alpine.LFD.2.00.1010021248150.14550@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010021248150.14550@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 02, 2010 at 12:57:10PM +0200, Thomas Gleixner wrote:
> On Fri, 1 Oct 2010, Nishanth Aravamudan wrote:
> 
> > The use of online_mask requires architecture code to be hotplug-aware to
> > account for IRQ round-robin'ing. With user-driven dynamic SMT, this
> > could commonly occur even without physical hotplug. Without this change
> > and "pseries/xics: use cpu_possible_mask rather than cpu_all_mask", IRQs
> > are all routed to CPU0 on power machines with XICS not running
> > irqbalance.
> > 
> > Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> > ---
> > I have boot-tested this on ppc64, but not yet on x86/x86_64. This is
> > generic-code, and perhaps an audit of all .set_affinity functions should
> > occur before upstream acceptance?
> > ---
> >  kernel/irq/manage.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> > index c3003e9..ef85b95 100644
> > --- a/kernel/irq/manage.c
> > +++ b/kernel/irq/manage.c
> > @@ -175,7 +175,7 @@ static int setup_affinity(unsigned int irq, struct irq_desc *desc)
> >  			desc->status &= ~IRQ_AFFINITY_SET;
> >  	}
> >  
> > -	cpumask_and(desc->affinity, cpu_online_mask, irq_default_affinity);
> > +	cpumask_and(desc->affinity, cpu_possible_mask, irq_default_affinity);
> 
> Hmm, that looks dangerous. And auditing everything is rather horrible
> especially when we need to add cpumask_and(..., cpu_online_mask, ..)
> all over the place.

I'm not sure it's that dangerous, because we already have a code path
today which should force the lower level arch code to sanity check vs
online_mask -- namely when a user sets the affinity from /proc/ 

irq_affinity_proc_write() -> irq_set_affinity() ->
     desc->chip->set_affinity(irq, cpumask)

The proc code does check to see that there is at least some
intersection with online_cpus -- but it's not strong enough to tell us
whether there are any offline cpus in the mask. 

It will obviously depend on the specific interrupt controller
architectures -- I guess it's possible that some would allow offline
cpus to be in the mask and intelligently skip over them.

So that makes me think the arch code has to check this _anyway_
since the generic code can't make assumptions about how interrupt
controllers operate.  

But, I started wondering if we're already broken here..

and I did a bit of reviewing of the arch code which implements that
set_affinity function just to see what various architecutres are doing


x86 has: 
kernel/apic/io_apic.c:  .set_affinity   = set_ioapic_affinity_irq,
kernel/apic/io_apic.c:  .set_affinity   = set_ir_ioapic_affinity_irq,
kernel/apic/io_apic.c:  .set_affinity   = set_msi_irq_affinity,
kernel/apic/io_apic.c:  .set_affinity   = ir_set_msi_irq_affinity,
kernel/apic/io_apic.c:  .set_affinity = dmar_msi_set_affinity,
kernel/apic/io_apic.c:  .set_affinity = ir_set_msi_irq_affinity,
kernel/apic/io_apic.c:  .set_affinity = hpet_msi_set_affinity,
kernel/apic/io_apic.c:  .set_affinity   = set_ht_irq_affinity,
kernel/uv_irq.c:        .set_affinity   = uv_set_irq_affinity,

all of these end up checking vs online by calling set_desc_affinity()
with the exception of set_ir_ioapic_affinity_irq which does the check 
by calling migrate_ioapic_irq_desc()


powerpc has:

platforms/pseries/xics.c:       .set_affinity = xics_set_affinity
platforms/pseries/xics.c:       .set_affinity = xics_set_affinity
sysdev/mpic_u3msi.c:    .set_affinity   = mpic_set_affinity,
sysdev/mpic_pasemi_msi.c:       .set_affinity   = mpic_set_affinity,
sysdev/mpic.c:          mpic->hc_irq.set_affinity = mpic_set_affinity;
sysdev/mpic.c:          mpic->hc_ht_irq.set_affinity = mpic_set_affinity;

both xics_set_affinity and  mpic_set_affinity both AND the mask
parameter with cpu_online_mask 

in mips:

cavium-octeon/octeon-irq.c:     .set_affinity = octeon_irq_ciu0_set_affinity_v2,
cavium-octeon/octeon-irq.c:     .set_affinity = octeon_irq_ciu0_set_affinity,
cavium-octeon/octeon-irq.c:     .set_affinity = octeon_irq_ciu1_set_affinity_v2,
cavium-octeon/octeon-irq.c:     .set_affinity = octeon_irq_ciu1_set_affinity,
kernel/irq-gic.c:       .set_affinity   =       gic_set_affinity,
kernel/i8259.c: .set_affinity   = plat_set_irq_affinity,
sibyte/bcm1480/irq.c:   .set_affinity = bcm1480_set_affinity
sibyte/sb1250/irq.c:    .set_affinity = sb1250_set_affinity


octeon functions are iterating over online cpus
gic_set_affinity is anding with cpu_online_mask
plat_set_irq_affinity is checking for online

bcm1480_set_affinity and sb1250_set_affinity are _not_ checking vs online explicitly

in ia64:

hp/sim/hpsim_irq.c:     .set_affinity = hpsim_set_affinity_noop,
kernel/iosapic.c:       .set_affinity = iosapic_set_affinity
kernel/iosapic.c:       .set_affinity = iosapic_set_affinity
kernel/msi_ia64.c:      .set_affinity   = ia64_set_msi_irq_affinity,
kernel/msi_ia64.c:      .set_affinity = dmar_msi_set_affinity,
sn/kernel/msi_sn.c:     .set_affinity   = sn_set_msi_irq_affinity,
sn/kernel/irq.c:        .set_affinity   = sn_set_affinity_irq

 iosapic_set_affinity() does a check by anding the mask with cpu_online_mask

 ia64_set_msi_irq_affinity and dmar_msi_set_affinity
  both only check to see that the first cpu in the mask is online --
  (not sure why, maybe that's the only requirement for their interrupt controller?)

 in sn_set_msi_irq_affinity -- is _not_ doing explicit checking vs
 online mask (maybe their firmware will tell them if they're
 doing something illegal?)

in sparc:
kernel/irq_64.c:        .set_affinity   = sun4u_set_affinity,
kernel/irq_64.c:        .set_affinity   = sun4v_set_affinity,
kernel/irq_64.c:        .set_affinity   = sun4v_virt_set_affinity,
 
does no explicit checks of online cpus, but they seem to be making firmware
calls which can return an error 


other architectures including:
arm
alpha
blackfin
cris

do _not_ appear to be checking the online mask
I'm not sure that these architectures support CPU hotplug either
though so perhaps it's not an issue... does hotplug because of power
management make it a broader problem ?

So, my basic point is that many of the low level arch specific
functions are checking, some do not and that *might* be a problem 
for people trying to set affinity via proc
also that the generic code is making an assumption that
cpu_online_mask is the correct mask -- which I believe may not be
correct for everybody -- especially not for some powerpc platforms.


Sonny
