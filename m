Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab1FVGjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 02:39:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33267 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab1FVGjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 02:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=YojR4irpd+WwvAOoDxIrtrDOdXmcJiY6XYC7TNOz2eA77bPPK3YhaYkOZUORlx6fJF
         KpEaGG8WA9KIKto/k9R//0k86mQgezxeqB/FKw+rnMJRNKBcnK94mtUrf8cmm4sSZGUS
         wRuynmLIWz9nRgQBO62BPqvLJWiLYi3r0NrGc=
From: Nai Xia <nai.xia@gmail.com>
Reply-To: nai.xia@gmail.com
To: Izik Eidus <izik.eidus@ravellosystems.com>
Subject: Re: [PATCH] mmu_notifier, kvm: Introduce dirty bit tracking in spte and mmu notifier to help KSM dirty bit tracking
Date: Wed, 22 Jun 2011 14:38:55 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.39; KDE/4.5.5; i686; ; )
Cc: Chris Wright <chrisw@sous-sol.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        "linux-mm" <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, mtosatti@redhat.com
References: <201106212055.25400.nai.xia@gmail.com> <20110622002123.GP25383@sequoia.sous-sol.org> <4E018897.7040707@ravellosystems.com>
In-Reply-To: <4E018897.7040707@ravellosystems.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106221438.55516.nai.xia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 June 2011 14:15:51 Izik Eidus wrote:
> On 6/22/2011 3:21 AM, Chris Wright wrote:
> > * Nai Xia (nai.xia@gmail.com) wrote:
> >> Introduced kvm_mmu_notifier_test_and_clear_dirty(), kvm_mmu_notifier_dirty_update()
> >> and their mmu_notifier interfaces to support KSM dirty bit tracking, which brings
> >> significant performance gain in volatile pages scanning in KSM.
> >> Currently, kvm_mmu_notifier_dirty_update() returns 0 if and only if intel EPT is
> >> enabled to indicate that the dirty bits of underlying sptes are not updated by
> >> hardware.
> > Did you test with each of EPT, NPT and shadow?
> >
> >> Signed-off-by: Nai Xia<nai.xia@gmail.com>
> >> Acked-by: Izik Eidus<izik.eidus@ravellosystems.com>
> >> ---
> >>   arch/x86/include/asm/kvm_host.h |    1 +
> >>   arch/x86/kvm/mmu.c              |   36 +++++++++++++++++++++++++++++
> >>   arch/x86/kvm/mmu.h              |    3 +-
> >>   arch/x86/kvm/vmx.c              |    1 +
> >>   include/linux/kvm_host.h        |    2 +-
> >>   include/linux/mmu_notifier.h    |   48 +++++++++++++++++++++++++++++++++++++++
> >>   mm/mmu_notifier.c               |   33 ++++++++++++++++++++++++++
> >>   virt/kvm/kvm_main.c             |   27 ++++++++++++++++++++++
> >>   8 files changed, 149 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >> index d2ac8e2..f0d7aa0 100644
> >> --- a/arch/x86/include/asm/kvm_host.h
> >> +++ b/arch/x86/include/asm/kvm_host.h
> >> @@ -848,6 +848,7 @@ extern bool kvm_rebooting;
> >>   int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
> >>   int kvm_age_hva(struct kvm *kvm, unsigned long hva);
> >>   int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
> >> +int kvm_test_and_clear_dirty_hva(struct kvm *kvm, unsigned long hva);
> >>   void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
> >>   int cpuid_maxphyaddr(struct kvm_vcpu *vcpu);
> >>   int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
> >> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >> index aee3862..a5a0c51 100644
> >> --- a/arch/x86/kvm/mmu.c
> >> +++ b/arch/x86/kvm/mmu.c
> >> @@ -979,6 +979,37 @@ out:
> >>   	return young;
> >>   }
> >>
> >> +/*
> >> + * Caller is supposed to SetPageDirty(), it's not done inside this.
> >> + */
> >> +static
> >> +int kvm_test_and_clear_dirty_rmapp(struct kvm *kvm, unsigned long *rmapp,
> >> +				   unsigned long data)
> >> +{
> >> +	u64 *spte;
> >> +	int dirty = 0;
> >> +
> >> +	if (!shadow_dirty_mask) {
> >> +		WARN(1, "KVM: do NOT try to test dirty bit in EPT\n");
> >> +		goto out;
> >> +	}
> > This should never fire with the dirty_update() notifier test, right?
> > And that means that this whole optimization is for the shadow mmu case,
> > arguably the legacy case.
> >
> 
> Hi Chris,
> AMD npt does track the dirty bit in the nested page tables,
> so the shadow_dirty_mask should not be 0 in that case...
> 
Hi Izik, 
I think he meant that if the caller is doing right && (!shadow_dirty_mask), 
the kvm_test_and_clear_dirty_rmapp() will never be called at all. So 
this test inside kvm_test_and_clear_dirty_rmapp() is useless...as I said
I added this test in any case of this interface abused by others, just like
a softer BUG_ON() --- dirty bit is not that critical to bump into BUG().



