Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2ALK2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 05:28:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab2ALK16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 05:27:58 -0500
Date: Thu, 12 Jan 2012 12:27:45 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Nadav Amit <namit@cs.technion.ac.il>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: Re: [PATCH 2/2] KVM: Fix writeback on page boundary that propagate
 changes in spite of #PF
Message-ID: <20120112102745.GX2167@redhat.com>
References: <1326300811-17065-1-git-send-email-namit@cs.technion.ac.il>
 <1326300811-17065-2-git-send-email-namit@cs.technion.ac.il>
 <20120112101259.GW2167@redhat.com>
 <4F0EB40C.7060201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0EB40C.7060201@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 12:21:00PM +0200, Avi Kivity wrote:
> On 01/12/2012 12:12 PM, Gleb Natapov wrote:
> > On Wed, Jan 11, 2012 at 06:53:31PM +0200, Nadav Amit wrote:
> > > Consider the case in which an instruction emulation writeback is performed on a page boundary.
> > > In such case, if a #PF occurs on the second page, the write to the first page already occurred and cannot be retracted.
> > > Therefore, validation of the second page access must be performed prior to writeback.
> > > 
> > > Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> > > ---
> > >  arch/x86/kvm/x86.c |   13 +++++++++++++
> > >  1 files changed, 13 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 05fd3d7..7af3d67 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -3626,6 +3626,8 @@ struct read_write_emulator_ops {
> > >  			       int bytes, void *val);
> > >  	int (*read_write_exit_mmio)(struct kvm_vcpu *vcpu, gpa_t gpa,
> > >  				    void *val, int bytes);
> > > +	gpa_t (*read_write_validate)(struct kvm_vcpu *vcpu, gva_t gva,
> > > +				     struct x86_exception *exception);
> > >  	bool write;
> > >  };
> > >  
> > > @@ -3686,6 +3688,7 @@ static struct read_write_emulator_ops write_emultor = {
> > >  	.read_write_emulate = write_emulate,
> > >  	.read_write_mmio = write_mmio,
> > >  	.read_write_exit_mmio = write_exit_mmio,
> > > +	.read_write_validate = kvm_mmu_gva_to_gpa_write,
> > >  	.write = true,
> > >  };
> > >  
> > > @@ -3750,6 +3753,16 @@ int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
> > >  		int rc, now;
> > >  
> > >  		now = -addr & ~PAGE_MASK;
> > > +
> > > +		/* First check there is no page-fault on the next page */
> > > +		if (ops->read_write_validate &&
> > > +			ops->read_write_validate(vcpu, addr+now, exception) ==
> > > +			UNMAPPED_GVA) {
> > > +			/* #PF on the first page should be reported first */
> > > +			ops->read_write_validate(vcpu, addr, exception);
> > > +			return X86EMUL_PROPAGATE_FAULT;
> > > +		}
> > > +
> > This undoes optimization that vcpu_mmio_gva_to_gpa() has for handling
> > mmio. 
> 
> Right.  I suggest changing I/O to have two phases: first, translate the
> virtual address into an array of two physical addresses; check
> exceptions and report.  Then do the actual writes.
> 
> > Furthermore for common (non faulting) case we will check page
> > tables twice on each write that crosses page boundary, first time here
> > and second time in emulator_read_write_onepage().
> 
> Those should be very uncommon.
> 
Still it is better to have all the checks in one place like you suggest
above.

--
			Gleb.
