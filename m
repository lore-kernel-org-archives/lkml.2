Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104Ab2EPSIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:08:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab2EPSIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:08:35 -0400
Date: Wed, 16 May 2012 20:48:19 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, x86@kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 3/5] kvm: host side for eoi optimization
Message-ID: <20120516174819.GG28798@redhat.com>
References: <42ba7beaa25855997e02fea91a11c9224c51720e.1337168687.git.mst@redhat.com>
 <20120516154940.GA20549@amt.cnet>
 <20120516162247.GA10676@redhat.com>
 <20120516163205.GB28798@redhat.com>
 <20120516165048.GA10769@redhat.com>
 <20120516170427.GA22784@amt.cnet>
 <20120516172155.GE28798@redhat.com>
 <20120516172345.GA23032@amt.cnet>
 <20120516173423.GF28798@redhat.com>
 <20120516174022.GA23332@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516174022.GA23332@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 02:40:22PM -0300, Marcelo Tosatti wrote:
> On Wed, May 16, 2012 at 08:34:23PM +0300, Gleb Natapov wrote:
> > On Wed, May 16, 2012 at 02:23:45PM -0300, Marcelo Tosatti wrote:
> > > On Wed, May 16, 2012 at 08:21:55PM +0300, Gleb Natapov wrote:
> > > > On Wed, May 16, 2012 at 02:04:27PM -0300, Marcelo Tosatti wrote:
> > > > > On Wed, May 16, 2012 at 07:50:48PM +0300, Michael S. Tsirkin wrote:
> > > > > > On Wed, May 16, 2012 at 07:32:06PM +0300, Gleb Natapov wrote:
> > > > > > > On Wed, May 16, 2012 at 07:22:47PM +0300, Michael S. Tsirkin wrote:
> > > > > > > > On Wed, May 16, 2012 at 12:49:40PM -0300, Marcelo Tosatti wrote:
> > > > > > > > > > @@ -1245,9 +1306,20 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
> > > > > > > > > >  	int vector = kvm_apic_has_interrupt(vcpu);
> > > > > > > > > >  	struct kvm_lapic *apic = vcpu->arch.apic;
> > > > > > > > > >  
> > > > > > > > > > -	if (vector == -1)
> > > > > > > > > > +	/* Detect interrupt nesting and disable EOI optimization */
> > > > > > > > > > +	if (pv_eoi_enabled(vcpu) && vector == -2)
> > > > > > > > > > +		pv_eoi_clr_pending(vcpu);
> > > > > > > > > > +
> > > > > > > > > > +	if (vector < 0)
> > > > > > > > > 
> > > > > > > > > With interrupt window exiting, the guest will exit:
> > > > > > > > > 
> > > > > > > > > - as soon as it sets RFLAGS.IF=1 and there is any 
> > > > > > > > > interrupt pending in IRR.
> > > > > > > > > - any new interrupt is set in IRR will kick vcpu
> > > > > > > > > out of guest mode and recalculate interrupt-window-exiting.
> > > > > > > > > 
> > > > > > > > > Doesnt this make this bit unnecessary ?
> > > > > > > > 
> > > > > > > > Looks like we could cut it out.  But I'm not sure how architectural it is
> > > > > > > > that we exit on interrupt window.
> > > > > > > We request exit on interrupt window only if there is pending irq that
> > > > > > > can be delivered on a guest entry.
> > > > > > 
> > > > > > Aha. If so what Marcelo proposed won't work I think: if we inject A then B
> > > > > > which is lower priority, we need an exit on EOI, we can't inject
> > > > > > immediately.
> > > > > 
> > > > > Please describe the scenario clearly, i can't see the problem.
> > > > 
> > > > During vcpu entry there are two IRRs set 100 and 200. 200 is injected,
> > > > but irq window is not requested because 100 can't be injected, During
> > > > EOI exit 100 is injected.
> > > 
> > > interrupt window exiting is always requested if IRR is pending. Except 
> > > if NMI window is requested (which has higher priority).
> > > 
> > This is where we enable irq window. We do it only if there is interrupt
> > pending:
> >                 if (kvm_cpu_has_interrupt(vcpu) || req_int_win)
> >                         kvm_x86_ops->enable_irq_window(vcpu);
> > 
> > kvm_cpu_has_interrupt() checks apic by calling kvm_apic_has_interrupt() 
> > 
> > 
> > kvm_apic_has_interrupt():
> >         apic_update_ppr(apic);
> >         highest_irr = apic_find_highest_irr(apic);
> >         if ((highest_irr == -1) ||
> >             ((highest_irr & 0xF0) <= apic_get_reg(apic, APIC_PROCPRI)))
> >                 return -1;
> > And above checks IRR priority, so we can have IRR set and do not enable
> > irq window exit.
> 
> Right, but then you cannot inject interrupt anyway so EOI is not
> necessary. Instead TPR-below-threshold trap is set which handles
> that case. No?
> 
No. EOI clears ISR -> PROCPRI is recalculated -> pending interrupt is
injected.

--
			Gleb.
