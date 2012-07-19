Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab2GSHrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 03:47:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab2GSHrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 03:47:46 -0400
Date: Thu, 19 Jul 2012 10:47:44 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: fix race with level interrupts
Message-ID: <20120719074744.GO26120@redhat.com>
References: <20120718215228.GA13905@redhat.com>
 <1342650401.2229.224.camel@bling.home>
 <20120718224948.GB14101@redhat.com>
 <1342653640.2229.234.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342653640.2229.234.camel@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 05:20:40PM -0600, Alex Williamson wrote:
> On Thu, 2012-07-19 at 01:49 +0300, Michael S. Tsirkin wrote:
> > On Wed, Jul 18, 2012 at 04:26:41PM -0600, Alex Williamson wrote:
> > > On Thu, 2012-07-19 at 00:52 +0300, Michael S. Tsirkin wrote:
> > > > When more than 1 source id is in use for the same GSI, we have the
> > > > following race related to handling irq_states:
> > > > 
> > > > CPU 0 clears bit in irq_states. CPU 0 reads irq_state as 0.
> > > > CPU 1 sets bit in irq_states.  CPU 1 calls kvm_ioapic_set_irq(1). CPU 0
> > > > calls kvm_ioapic_set_irq(0).
> > > > 
> > > > Now ioapic thinks the level is 0 but irq_state is not 0.
> > > > 
> > > > Note that above is valid behaviour if CPU0 and CPU1 are using different
> > > > source ids.
> > > > 
> > > > Fix by performing all irq_states bitmap handling under pic/ioapic lock.
> > > > This also removes the need for atomics with irq_states handling.
> > > > 
> > > > Reported-by: Gleb Natapov <gleb@redhat.com>
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > ---
> > > > 
> > > > This survives stress testing for me (though I only tried virtio, not
> > > > device assignment).
> > > > Avi, Marcelo, though we have not observed this in the field,
> > > > it's a bugfix so probably 3.5 material?
> > > > I assume yes so the patch is against 3.5-rc7.
> > > > Also stable? It's a very old bug.
> > > > 
> > > > 
> > > >  arch/x86/include/asm/kvm_host.h | 15 ++++++++++++++-
> > > >  arch/x86/kvm/i8259.c            | 14 ++++++++++++--
> > > >  virt/kvm/ioapic.c               | 13 ++++++++++++-
> > > >  virt/kvm/ioapic.h               |  4 +++-
> > > >  virt/kvm/irq_comm.c             | 31 ++++---------------------------
> > > >  5 files changed, 45 insertions(+), 32 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > index db7c1f2..fe6e9f1 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -802,7 +802,20 @@ int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> > > >  void kvm_propagate_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
> > > >  bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
> > > >  
> > > > -int kvm_pic_set_irq(void *opaque, int irq, int level);
> > > > +static inline int kvm_irq_line_state(unsigned long *irq_state,
> > > > +				     int irq_source_id, int level)
> > > 
> > > This should probably be __kvm_irq_line_state given the calling
> > > restrictions.
> > 
> > It's such a trivial helper, do we need to split hairs about this?
> > 
> > Look it's not a good time for minor coding style nits.
> > 3.5 is imminent, it's about 1am here and I really don't have time to retest
> > today, so we'll release another kernel with a bug.
> > 
> > Could you focus on reviewing the functionality and correctness, and
> > leave ideas for better variable naming aside until 3.6?
> 
> Please get off your high horse, this bug has existed for a long time and
> nobody has noticed.  __ indicates locking and makes people think twice
> about arbitrarily calling it.  Correct naming prevents future bugs,
> which is something you've been riding me on in other areas...
> 
Agree, this is not a recent regression and in fact the bug cannot be
triggered without device assignment that uses level interrupt (is this
works at all?).

--
			Gleb.
