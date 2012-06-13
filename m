Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab2FMUxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 16:53:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709Ab2FMUxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 16:53:49 -0400
Date: Wed, 13 Jun 2012 17:53:36 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv6 6/8] kvm: only sync when attention bits set
Message-ID: <20120613205336.GB19290@amt.cnet>
References: <cover.1338474301.git.mst@redhat.com>
 <56ee14064ef307b7075f6977122781456cab5165.1338474301.git.mst@redhat.com>
 <20120612222748.GB1973@amt.cnet>
 <20120613081923.GA16162@redhat.com>
 <20120613083506.GA17190@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120613083506.GA17190@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 11:35:07AM +0300, Michael S. Tsirkin wrote:
> On Wed, Jun 13, 2012 at 11:19:24AM +0300, Michael S. Tsirkin wrote:
> > On Tue, Jun 12, 2012 at 07:27:48PM -0300, Marcelo Tosatti wrote:
> > > On Sun, Jun 03, 2012 at 10:28:29AM +0300, Michael S. Tsirkin wrote:
> > > > Commit eb0dc6d0368072236dcd086d7fdc17fd3c4574d4 introduced apic
> > > > attention bitmask but kvm still syncs lapic unconditionally.
> > > > As that commit suggested and in anticipation of adding more attention
> > > > bits, only sync lapic if(apic_attention).
> > > > 
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > ---
> > > >  arch/x86/kvm/x86.c |    3 ++-
> > > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index be6d549..2f70861 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -5388,7 +5388,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> > > >  	if (unlikely(vcpu->arch.tsc_always_catchup))
> > > >  		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
> > > >  
> > > > -	kvm_lapic_sync_from_vapic(vcpu);
> > > > +	if (unlikely(vcpu->arch.apic_attention))
> > > > +		kvm_lapic_sync_from_vapic(vcpu);
> > > 
> > > void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu)
> > > {
> > >         u32 data;
> > >         void *vapic;
> > > 
> > >         if (!test_bit(KVM_APIC_CHECK_VAPIC, &vcpu->arch.apic_attention))
> > >                 return;
> > > 
> > > Please use unlikely more carefully, when a gain is measureable:
> > > http://lwn.net/Articles/420019/
> > 
> > Do we have to measure every single thing?
> > Sometimes it's obvious: vapic is slow path, isn't it?
> 
> Just to clarify the question: I think it's obvious this condition is
> false more often than true. By how much, depends on the workload.
> Do you think this is enough to tag this unlikely?

Depends whether your processor supports flexpriority or not. I don't
want to argue in favour/against the particular instance

GCC docs:

"
— Built-in Function: long __builtin_expect (long exp, long c)

    You may use __builtin_expect to provide the compiler with branch
prediction information. In general, you should prefer to use actual
profile feedback for this (-fprofile-arcs), as programmers are
notoriously bad at predicting how their programs actually perform.
However, there are applications in which this data is hard to collect.
"

Lately half of branches in your patches are annotated.

