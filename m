Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab2GRSSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 14:18:15 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:62519 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab2GRSSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 14:18:12 -0400
X-IronPort-AV: E=Sophos;i="4.77,610,1336348800"; 
   d="scan'208";a="13594766"
Date: Wed, 18 Jul 2012 19:17:11 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen/events: fix unmask_evtchn for PV on HVM
 guests
In-Reply-To: <20120716151441.GD552@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1207181851010.23783@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com> <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1206221722040.27860@kaball.uk.xensource.com> <20120709141915.GB9580@phenom.dumpdata.com>
 <alpine.DEB.2.02.1207131821250.23783@kaball.uk.xensource.com> <20120716151441.GD552@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Konrad Rzeszutek Wilk wrote:
> On Fri, Jul 13, 2012 at 06:48:35PM +0100, Stefano Stabellini wrote:
> > On Mon, 9 Jul 2012, Konrad Rzeszutek Wilk wrote:
> > > On Fri, Jun 22, 2012 at 05:26:07PM +0100, Stefano Stabellini wrote:
> > > > When unmask_evtchn is called, if we already have an event pending, we
> > > > just set evtchn_pending_sel waiting for local_irq_enable to be called.
> > > > That is because PV guests set the irq_enable pvops to
> > > 
> > > Can you point out where the PV guests do that please? Even just
> > > including a snippet of code would be nice so that somebody
> > > in the future has an idea of where it was/is.
> > 
> > Do you mean where PV guests set the irq_enable pvop?
> > 
> > That would be in xen_setup_vcpu_info_placement.
> > irq_enable is set to xen_irq_enable_direct that is implemented in
> > assembly in arch/x86/xen/xen-asm.S: it tests for XEN_vcpu_info_pending
> > and call xen_force_evtchn_callback.
> 
> Excellent. Pls include that comment in the git commit.

OK


> > > > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > > > index eae0d0b..0132505 100644
> > > > --- a/drivers/xen/events.c
> > > > +++ b/drivers/xen/events.c
> > > > @@ -372,8 +372,11 @@ static void unmask_evtchn(int port)
> > > >  
> > > >  	BUG_ON(!irqs_disabled());
> > > >  
> > > > -	/* Slow path (hypercall) if this is a non-local port. */
> > > > -	if (unlikely(cpu != cpu_from_evtchn(port))) {
> > > > +	/* Slow path (hypercall) if this is a non-local port or if this is
> > > > +	 * an hvm domain and an event is pending (hvm domains don't have
> > > > +	 * their own implementation of irq_enable). */
> > > > +	if (unlikely((cpu != cpu_from_evtchn(port)) ||
> > > > +			(xen_hvm_domain() && sync_test_bit(port, &s->evtchn_pending[0])))) {
> > > >  		struct evtchn_unmask unmask = { .port = port };
> > > 
> > > We already have two seperate acks - for when there is an GMFN APIC bitmap and
> > > when there is not. Can we also have to seperate unmask_evtchn then? And
> > > just have the HVM and ARM just do a straightforward unmaks_evtchn while
> > > the PV remains the same?
> > 
> > Do you mean HVM and ARM do a straightforward EVTCHNOP_unmask hypercall?
> 
> I was thinking of some way to lessen the impact of the 'if (..)'  statement.
> There is already a check from the cpu, and now there is a bit check
> and another check for domain. Was wondering if it would make more sense
> to abstract the code the unmask_evtchn calls, and provide two variants
> of the unmask_evtchn: a one that is mostly called on PV/PVHVM on x86 and
> then the ARM version?
> 
> Or won't that really give us any performance benefits and that
> extra check for hvm_domain and test_bit is negligible?
> 
> Perhaps a better question is - do you have further plans for this
> function? As in expanding it with more 'if' conditionals?

Nope, I certainly don't. In fact I agree with you on the fact that is
not very readable as it is.


> > In that case we would lose performances because most of the time an
> > hypercall won't be necessary.
> > If we keep the code as it is, it makes sense to have the PV and PVHVM
> > cases in the same function.
> 
> The two things that roam my mind is:
>  - performance impact
>  - code readability.
> 
> Granted this code is the slow patch so maybe the performance part is
> not an issue. But that 'sync_test_bit' isn't that an atomic locked
> call so it flushes the bus? There is a 'xen_hvm_domain()' condition
> before it so that does lessen the impact to be only done on HVM.
> 
> If we do run this under HVM, we would do:
>  1) cpu == cpu_from_evtchn, so 
>  2).sync_test_bit .. say it returns false
>  3). sync_clear_bit
>  4). sync_test_bit on the same word that 2) was done.
> 
> If this was re-organized a bit differently could we remove 2)
> out of the picture so that under HVM we just do 1) 3) and 4) ?

I see what you mean now. It might make sense.


> And for that we might have to have two implementations of unmaks_evtchn - were
> both of them might call the same underlaying functions that do the
> bit-operations, but the 'if' conditionals are differently organized.
> Or is this scenario really unlikely and I am just thinking to hard about this?

Let just say that I only managed to reproduce it with a buggy hypervisor
port to a new architecture :-)

But I don't like the idea of writing obfuscated and inefficient code, so
let me give it a second try.

---

xen/events: fix unmask_evtchn for PV on HVM guests

When unmask_evtchn is called, if we already have an event pending, we
just set evtchn_pending_sel waiting for local_irq_enable to be called.
That is because PV guests set the irq_enable pvops to
xen_irq_enable_direct in xen_setup_vcpu_info_placement:
xen_irq_enable_direct is implemented in assembly in
arch/x86/xen/xen-asm.S and call xen_force_evtchn_callback if
XEN_vcpu_info_pending is set.

However HVM guests (and ARM guests) do not change or do not have the
irq_enable pvop, so evtchn_unmask cannot work properly for them.

Considering that having the pending_irq bit set when unmask_evtchn is
called is not very common, and it is simpler to keep the
native_irq_enable implementation for HVM guests (and ARM guests), the
best thing to do is just use the EVTCHNOP_unmask hypercall (Xen
re-injects pending events in response).

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/events.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 0a8a17c..d75cc39 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -373,11 +373,22 @@ static void unmask_evtchn(int port)
 {
 	struct shared_info *s = HYPERVISOR_shared_info;
 	unsigned int cpu = get_cpu();
+	int do_hypercall = 0, evtchn_pending = 0;
 
 	BUG_ON(!irqs_disabled());
 
-	/* Slow path (hypercall) if this is a non-local port. */
-	if (unlikely(cpu != cpu_from_evtchn(port))) {
+	if (unlikely((cpu != cpu_from_evtchn(port))))
+		do_hypercall = 1;
+	else
+		evtchn_pending = sync_test_bit(port, &s->evtchn_pending[0]);
+
+	if (unlikely(evtchn_pending && xen_hvm_domain()))
+		do_hypercall = 1;
+
+	/* Slow path (hypercall) if this is a non-local port or if this is
+	 * an hvm domain and an event is pending (hvm domains don't have
+	 * their own implementation of irq_enable). */
+	if (do_hypercall) {
 		struct evtchn_unmask unmask = { .port = port };
 		(void)HYPERVISOR_event_channel_op(EVTCHNOP_unmask, &unmask);
 	} else {
@@ -390,7 +401,7 @@ static void unmask_evtchn(int port)
 		 * 'hw_resend_irq'. Just like a real IO-APIC we 'lose
 		 * the interrupt edge' if the channel is masked.
 		 */
-		if (sync_test_bit(port, &s->evtchn_pending[0]) &&
+		if (evtchn_pending &&
 		    !sync_test_and_set_bit(port / BITS_PER_LONG,
 					   &vcpu_info->evtchn_pending_sel))
 			vcpu_info->evtchn_upcall_pending = 1;
-- 
1.7.2.5

