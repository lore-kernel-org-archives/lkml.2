Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab2EPS3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:29:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760076Ab2EPS3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:29:50 -0400
Date: Wed, 16 May 2012 21:29:49 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, x86@kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 3/5] kvm: host side for eoi optimization
Message-ID: <20120516182948.GF10769@redhat.com>
References: <cover.1337168687.git.mst@redhat.com>
 <42ba7beaa25855997e02fea91a11c9224c51720e.1337168687.git.mst@redhat.com>
 <20120516154940.GA20549@amt.cnet>
 <20120516162247.GA10676@redhat.com>
 <20120516172058.GA22861@amt.cnet>
 <20120516175856.GD10769@redhat.com>
 <20120516181500.GA23791@amt.cnet>
 <20120516182520.GH28798@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516182520.GH28798@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 09:25:20PM +0300, Gleb Natapov wrote:
> On Wed, May 16, 2012 at 03:15:00PM -0300, Marcelo Tosatti wrote:
> > On Wed, May 16, 2012 at 08:58:57PM +0300, Michael S. Tsirkin wrote:
> > > On Wed, May 16, 2012 at 02:20:58PM -0300, Marcelo Tosatti wrote:
> > > > On Wed, May 16, 2012 at 07:22:47PM +0300, Michael S. Tsirkin wrote:
> > > > > On Wed, May 16, 2012 at 12:49:40PM -0300, Marcelo Tosatti wrote:
> > > > > > > @@ -1245,9 +1306,20 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
> > > > > > >  	int vector = kvm_apic_has_interrupt(vcpu);
> > > > > > >  	struct kvm_lapic *apic = vcpu->arch.apic;
> > > > > > >  
> > > > > > > -	if (vector == -1)
> > > > > > > +	/* Detect interrupt nesting and disable EOI optimization */
> > > > > > > +	if (pv_eoi_enabled(vcpu) && vector == -2)
> > > > > > > +		pv_eoi_clr_pending(vcpu);
> > > > > > > +
> > > > > > > +	if (vector < 0)
> > > > > > 
> > > > > > With interrupt window exiting, the guest will exit:
> > > > > > 
> > > > > > - as soon as it sets RFLAGS.IF=1 and there is any 
> > > > > > interrupt pending in IRR.
> > > > > > - any new interrupt is set in IRR will kick vcpu
> > > > > > out of guest mode and recalculate interrupt-window-exiting.
> > > > > > 
> > > > > > Doesnt this make this bit unnecessary ?
> > > > > 
> > > > > Looks like we could cut it out.  But I'm not sure how architectural it is
> > > > > that we exit on interrupt window.
> > > > > I guess there are reasons to exit on interrupt window but
> > > > > isn't it better to make the feature independent of it?
> > > > 
> > > > Hum... not sure. Is it helpful for the Hyper-V interface?
> > > > 
> > > > > This almost never happens in my testing anyway, so
> > > > > however we handle it is unlikely to affect performance.
> > > > 
> > > > It decreases the amount of state that must be maintained.
> > > > 
> > > > BTW there is a bug covered by interrupt window exiting:
> > > > 
> > > > vcpu0                               host
> > > > - irr 5 set
> > > > - isr 5 set, irr 5 cleared
> > > > - eoi_skip bit not set, 
> > > > no other bit set in irr.
> > > > - enter guest
> > > > 
> > > >                                     irr 4 set
> > > >                                     kick vcpu0 out of guest mode
> > > > 
> > > > - eoi pending bit not set
> > > >   (previous interrupt injection 
> > > >    still pending)
> > > > - skip eoi
> > > > 
> > > > If it were not for interrupt window exiting, this would 
> > > > inject vector 4 on an unrelated exit who knows how long 
> > > > in the future.
> > > > 
> > > > Also note optimization depends on the fact that the host 
> > > > kicks vcpu out unconditionally (so it is dependent on 
> > > > certain kvm implementation details).
> > > > 
> > > 
> > > Look we can summarize as follows: irq windows exit is
> > > required both before and after this patch.
> > > But it does not make the check above redundant.
> > 
> > Right, it is not redundant.
> > 
> > The above is still a bug: a case where eoi pending bit is not updated
> > properly.
> When IRR is set while eoi_skip is enabled, eoi_skip should be cleared.
> Michael does your patch do that?

I think this does it:
        /* Detect interrupt nesting and disable EOI optimization */
        if (pv_eoi_enabled(vcpu) && vector == -2)
                pv_eoi_clr_pending(vcpu);

-2 is returned when irr is set.


> > 
> > How come is this compatible with hyper-v again? Enlight me.
> 
> --
> 			Gleb.
