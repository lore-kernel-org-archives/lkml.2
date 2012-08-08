Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030651Ab2HHTT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:19:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:25890 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932896Ab2HHTTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:19:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,734,1336374000"; 
   d="scan'208";a="183281689"
Subject: Re: do_IRQ: 1.55 No irq handler for vector (irq -1)
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Robert Richter <robert.richter@amd.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, mingo@kernel.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Date: Wed, 08 Aug 2012 12:16:52 -0700
In-Reply-To: <20120808110414.GB16636@aftab.osrc.amd.com>
References: <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
	 <tip-332afa656e76458ee9cf0f0d123016a0658539e4@git.kernel.org>
	 <20120807153149.GI3732@erda.amd.com>
	 <20120807154134.GA7456@aftab.osrc.amd.com>
	 <1344356662.2041.48.camel@sbsiddha-desk.sc.intel.com>
	 <87pq72a951.fsf@xmission.com> <20120807205717.GC11226@aftab.osrc.amd.com>
	 <1344379147.27383.29.camel@sbsiddha-desk.sc.intel.com>
	 <20120808085837.GL3732@erda.amd.com>
	 <20120808110414.GB16636@aftab.osrc.amd.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1344453412.29170.5.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-08 at 13:04 +0200, Borislav Petkov wrote:
> On Wed, Aug 08, 2012 at 10:58:37AM +0200, Robert Richter wrote:
> > On 07.08.12 15:39:07, Suresh Siddha wrote:
> > > Boris, Robert, can you check if the below patch makes both of your
> > > systems happy again (essentially not allowing the vector to change for
> > > legacy irq's, which also allows the RTE to be set correctly in the smp
> > > case etc)? Based on your results and some more thinking, I will send a
> > > detailed patch with changelog tomorrow.
> > > 
> > >  arch/x86/kernel/apic/io_apic.c |    9 +++++++++
> > >  1 files changed, 9 insertions(+), 0 deletions(-)
> > 
> > Suresh,
> > 
> > with your patch applied the sata device works fine and the system
> > boots, no issues seen.
> 
> Ditto,
> 
> the do_IRQ issue of missing an irq handler for vector 55 is gone too on
> my box.
> 
> I'm pretty sure you can add our Tested-by:'s to the official patch.
> 

Ok. Thanks Robert, Boris.

I have appended the patch with the updated changelog. Ingo/Peter, Can
you please queue this for v3.6? I have a plan to clean this all up for
v3.7. I will work with Robert, Boris offline and post a cleaner fix for
v3.7 shortly. Thanks.
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, apic: fix broken legacy interrupts in the logical apic mode

Recent commit 332afa656e76458ee9cf0f0d123016a0658539e4 cleaned up
a workaround that updates irq_cfg domain for legacy irq's that
are handled by the IO-APIC. This was assuming that the recent
changes in assign_irq_vector() were sufficient to remove the workaround.

But this broke couple of AMD platforms. One of them seems to be
sending interrupts to the offline cpu's, resulting in spurious
"No irq handler for vector xx (irq -1)" messages when those cpu's come online.
And the other platform seems to always send the interrupt to the last logical
CPU (cpu-7). Recent changes had an unintended side effect of using only logical
cpu-0 in the IO-APIC RTE (during boot for the legacy interrupts) and this
broke the legacy interrupts not getting routed to the cpu-7 on the AMD
platform, resulting in a boot hang.

For now, reintroduce the removed workaround, (essentially not allowing the
vector to change for legacy irq's when io-apic starts to handle the irq. Which
also addressed the uninteded sife effect of just specifying cpu-0 in the
IO-APIC RTE for those irq's during boot).

Reported-and-tested-by: Robert Richter <robert.richter@amd.com>
Reported-and-tested-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a6c64aa..c265593 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1356,6 +1356,16 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 	if (!IO_APIC_IRQ(irq))
 		return;
 
+	/*
+	 * For legacy irqs, cfg->domain starts with cpu 0. Now that IO-APIC
+	 * can handle this irq and the apic driver is finialized at this point,
+	 * update the cfg->domain.
+	 */
+	if (irq < legacy_pic->nr_legacy_irqs &&
+	    cpumask_equal(cfg->domain, cpumask_of(0)))
+		apic->vector_allocation_domain(0, cfg->domain,
+					       apic->target_cpus());
+
 	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
 		return;
 


