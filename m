Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab2ALKVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 05:21:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab2ALKVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 05:21:15 -0500
Message-ID: <4F0EB40C.7060201@redhat.com>
Date: Thu, 12 Jan 2012 12:21:00 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Nadav Amit <namit@cs.technion.ac.il>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: Re: [PATCH 2/2] KVM: Fix writeback on page boundary that propagate
 changes in spite of #PF
References: <1326300811-17065-1-git-send-email-namit@cs.technion.ac.il> <1326300811-17065-2-git-send-email-namit@cs.technion.ac.il> <20120112101259.GW2167@redhat.com>
In-Reply-To: <20120112101259.GW2167@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2012 12:12 PM, Gleb Natapov wrote:
> On Wed, Jan 11, 2012 at 06:53:31PM +0200, Nadav Amit wrote:
> > Consider the case in which an instruction emulation writeback is performed on a page boundary.
> > In such case, if a #PF occurs on the second page, the write to the first page already occurred and cannot be retracted.
> > Therefore, validation of the second page access must be performed prior to writeback.
> > 
> > Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> > ---
> >  arch/x86/kvm/x86.c |   13 +++++++++++++
> >  1 files changed, 13 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 05fd3d7..7af3d67 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3626,6 +3626,8 @@ struct read_write_emulator_ops {
> >  			       int bytes, void *val);
> >  	int (*read_write_exit_mmio)(struct kvm_vcpu *vcpu, gpa_t gpa,
> >  				    void *val, int bytes);
> > +	gpa_t (*read_write_validate)(struct kvm_vcpu *vcpu, gva_t gva,
> > +				     struct x86_exception *exception);
> >  	bool write;
> >  };
> >  
> > @@ -3686,6 +3688,7 @@ static struct read_write_emulator_ops write_emultor = {
> >  	.read_write_emulate = write_emulate,
> >  	.read_write_mmio = write_mmio,
> >  	.read_write_exit_mmio = write_exit_mmio,
> > +	.read_write_validate = kvm_mmu_gva_to_gpa_write,
> >  	.write = true,
> >  };
> >  
> > @@ -3750,6 +3753,16 @@ int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
> >  		int rc, now;
> >  
> >  		now = -addr & ~PAGE_MASK;
> > +
> > +		/* First check there is no page-fault on the next page */
> > +		if (ops->read_write_validate &&
> > +			ops->read_write_validate(vcpu, addr+now, exception) ==
> > +			UNMAPPED_GVA) {
> > +			/* #PF on the first page should be reported first */
> > +			ops->read_write_validate(vcpu, addr, exception);
> > +			return X86EMUL_PROPAGATE_FAULT;
> > +		}
> > +
> This undoes optimization that vcpu_mmio_gva_to_gpa() has for handling
> mmio. 

Right.  I suggest changing I/O to have two phases: first, translate the
virtual address into an array of two physical addresses; check
exceptions and report.  Then do the actual writes.

> Furthermore for common (non faulting) case we will check page
> tables twice on each write that crosses page boundary, first time here
> and second time in emulator_read_write_onepage().

Those should be very uncommon.

-- 
error compiling committee.c: too many arguments to function

