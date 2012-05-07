Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab2EGD3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 23:29:08 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:48951 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab2EGD3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 23:29:07 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: peterz@infradead.org, mingo@elte.hu, jeremy@goop.org, mtosatti@redhat.com,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        avi@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v1 3/5] KVM: Add paravirt kvm_flush_tlb_others
In-Reply-To: <20120504114449.GB25659@linux.vnet.ibm.com>
References: <20120427161727.27082.43096.stgit@abhimanyu> <20120427162401.27082.59387.stgit@abhimanyu> <20120504114449.GB25659@linux.vnet.ibm.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Mon, 07 May 2012 08:40:10 +0530
Message-ID: <87d36gbsa5.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12050617-3568-0000-0000-000001AA4E6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2012 17:14:49 +0530, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> * Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com> [2012-04-27 21:54:37]:
> 
> > @@ -1549,6 +1549,11 @@ static void kvm_set_vcpu_state(struct kvm_vcpu *vcpu)
> >  		return;
> > 
> >  	vs->state = 1;
> > +	if (vs->flush_on_enter) {
> > +		kvm_mmu_flush_tlb(vcpu);
> > +		vs->flush_on_enter = 0;
> > +	}
> > +
> >  	kvm_write_guest_cached(vcpu->kvm, ghc, vs, 2*sizeof(__u32));
> 
> Reading flush_on_enter before writing ->state (=1) is racy afaics (and
> may cause vcpu to miss a TLB flush request).
> 
Yes I see this with sysbench, here is what I have now, currently I have
tested it with sysbench(50 runs). Will fold this in my v2.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 60546e9..b2ee9fd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1548,9 +1548,20 @@ static void kvm_set_vcpu_state(struct kvm_vcpu *vcpu)
        if (!(vcpu->arch.v_state.msr_val & KVM_MSR_ENABLED))
                return;
 
+       /* 
+        * Let the guest know that we are online, make sure we do not
+        * overwrite flush_on_enter, just write the vs->state.
+        */
        vs->state = 1;
-       kvm_write_guest_cached(vcpu->kvm, ghc, vs, 2*sizeof(__u32));
+       kvm_write_guest_cached(vcpu->kvm, ghc, vs, 1*sizeof(__u32));
        smp_wmb();
+       /* 
+        * Guest might have seen us offline and would have set
+        * flush_on_enter. 
+        */
+       kvm_read_guest_cached(vcpu->kvm, ghc, vs, 2*sizeof(__u32));
+       if (vs->flush_on_enter) 
+               kvm_x86_ops->tlb_flush(vcpu);
 }
 
 static void kvm_clear_vcpu_state(struct kvm_vcpu *vcpu)


Nikunj

