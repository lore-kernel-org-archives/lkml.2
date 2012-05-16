Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136Ab2EPSJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:09:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759774Ab2EPSJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:09:00 -0400
Date: Wed, 16 May 2012 14:04:27 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, x86@kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 3/5] kvm: host side for eoi optimization
Message-ID: <20120516170427.GA22784@amt.cnet>
References: <cover.1337168687.git.mst@redhat.com>
 <42ba7beaa25855997e02fea91a11c9224c51720e.1337168687.git.mst@redhat.com>
 <20120516154940.GA20549@amt.cnet>
 <20120516162247.GA10676@redhat.com>
 <20120516163205.GB28798@redhat.com>
 <20120516165048.GA10769@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516165048.GA10769@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 07:50:48PM +0300, Michael S. Tsirkin wrote:
> On Wed, May 16, 2012 at 07:32:06PM +0300, Gleb Natapov wrote:
> > On Wed, May 16, 2012 at 07:22:47PM +0300, Michael S. Tsirkin wrote:
> > > On Wed, May 16, 2012 at 12:49:40PM -0300, Marcelo Tosatti wrote:
> > > > > @@ -1245,9 +1306,20 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
> > > > >  	int vector = kvm_apic_has_interrupt(vcpu);
> > > > >  	struct kvm_lapic *apic = vcpu->arch.apic;
> > > > >  
> > > > > -	if (vector == -1)
> > > > > +	/* Detect interrupt nesting and disable EOI optimization */
> > > > > +	if (pv_eoi_enabled(vcpu) && vector == -2)
> > > > > +		pv_eoi_clr_pending(vcpu);
> > > > > +
> > > > > +	if (vector < 0)
> > > > 
> > > > With interrupt window exiting, the guest will exit:
> > > > 
> > > > - as soon as it sets RFLAGS.IF=1 and there is any 
> > > > interrupt pending in IRR.
> > > > - any new interrupt is set in IRR will kick vcpu
> > > > out of guest mode and recalculate interrupt-window-exiting.
> > > > 
> > > > Doesnt this make this bit unnecessary ?
> > > 
> > > Looks like we could cut it out.  But I'm not sure how architectural it is
> > > that we exit on interrupt window.
> > We request exit on interrupt window only if there is pending irq that
> > can be delivered on a guest entry.
> 
> Aha. If so what Marcelo proposed won't work I think: if we inject A then B
> which is lower priority, we need an exit on EOI, we can't inject
> immediately.

Please describe the scenario clearly, i can't see the problem.

