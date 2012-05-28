Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab2E1KVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 06:21:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:40323 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab2E1KVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 06:21:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="105009094"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: "'avi@redhat.com'" <avi@redhat.com>
CC: "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'mtosatti@redhat.com'" <mtosatti@redhat.com>,
        "'takuya.yoshikawa@gmail.com'" <takuya.yoshikawa@gmail.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>
Subject: RE: [PATCH v3 4/4] Enabling Access bit when doing memory swapping
Thread-Topic: [PATCH v3 4/4] Enabling Access bit when doing memory swapping
Thread-Index: AQHNN8m33b6njSgvbECbKWBAN0OYjpbXYMXAgAemdwA=
Date: Mon, 28 May 2012 10:21:03 +0000
Message-ID: <403610A45A2B5242BD291EDAE8B37D300FDCA338@SHSMSX102.ccr.corp.intel.com>
References: <1337656995-24964-1-git-send-email-xudong.hao@intel.com>
 <403610A45A2B5242BD291EDAE8B37D300FDC8918@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <403610A45A2B5242BD291EDAE8B37D300FDC8918@SHSMSX102.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Hao, Xudong
> Sent: Wednesday, May 23, 2012 9:31 PM
> To: avi@redhat.com
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org; mtosatti@redhat.com;
> takuya.yoshikawa@gmail.com; Zhang, Xiantao; Shan, Haitao
> Subject: RE: [PATCH v3 4/4] Enabling Access bit when doing memory swapping
> 
> Hi, Avi
> 
> Will these patches be accepted if no other comments?
> 
> Thanks,
> -Xudong
> 
> 
> > -----Original Message-----
> > From: Hao, Xudong
> > Sent: Tuesday, May 22, 2012 11:23 AM
> > To: avi@redhat.com
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> mtosatti@redhat.com;
> > takuya.yoshikawa@gmail.com; Zhang, Xiantao; Hao, Xudong; Shan, Haitao
> > Subject: [PATCH v3 4/4] Enabling Access bit when doing memory swapping
> >
> > <Re-send>
> >
> > Enabling Access bit when doing memory swapping.
> >
> > Changes from v2:
> > -Still using claer_bit() function to make sure it's atomic operation.
> >
> > Signed-off-by: Haitao Shan <haitao.shan@intel.com>
> > Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> > ---
> >  arch/x86/kvm/mmu.c |   14 ++++++++------
> >  arch/x86/kvm/vmx.c |    6 ++++--
> >  2 files changed, 12 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > index 72102e0..c2fef8e 100644
> > --- a/arch/x86/kvm/mmu.c
> > +++ b/arch/x86/kvm/mmu.c
> > @@ -1242,7 +1242,8 @@ static int kvm_age_rmapp(struct kvm *kvm,
> > unsigned long *rmapp,
> >  	int young = 0;
> >
> >  	/*
> > -	 * Emulate the accessed bit for EPT, by checking if this page has
> > +	 * In case of absence of EPT Access and Dirty Bits supports,
> > +	 * emulate the accessed bit for EPT, by checking if this page has
> >  	 * an EPT mapping, and clearing it if it does. On the next access,
> >  	 * a new EPT mapping will be established.
> >  	 * This has some overhead, but not as much as the cost of swapping
> > @@ -1253,11 +1254,12 @@ static int kvm_age_rmapp(struct kvm *kvm,
> > unsigned long *rmapp,
> >
> >  	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
> >  	     sptep = rmap_get_next(&iter)) {
> > -		BUG_ON(!(*sptep & PT_PRESENT_MASK));
> > +		BUG_ON(!is_shadow_present_pte(*sptep));
> >
> > -		if (*sptep & PT_ACCESSED_MASK) {
> > +		if (*sptep & shadow_accessed_mask) {
> >  			young = 1;
> > -			clear_bit(PT_ACCESSED_SHIFT, (unsigned long *)sptep);
> > +			clear_bit((ffs(shadow_accessed_mask) - 1),
> > +				 (unsigned long *)sptep);
> >  		}
> >  	}
> >
> > @@ -1281,9 +1283,9 @@ static int kvm_test_age_rmapp(struct kvm *kvm,
> > unsigned long *rmapp,
> >
> >  	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
> >  	     sptep = rmap_get_next(&iter)) {
> > -		BUG_ON(!(*sptep & PT_PRESENT_MASK));
> > +		BUG_ON(!is_shadow_present_pte(*sptep));
> >
> > -		if (*sptep & PT_ACCESSED_MASK) {
> > +		if (*sptep & shadow_accessed_mask) {
> >  			young = 1;
> >  			break;
> >  		}
> > diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> > index 32eb588..ea6390e 100644
> > --- a/arch/x86/kvm/vmx.c
> > +++ b/arch/x86/kvm/vmx.c
> > @@ -7275,8 +7275,10 @@ static int __init vmx_init(void)
> >  	vmx_disable_intercept_for_msr(MSR_IA32_SYSENTER_EIP, false);
> >
> >  	if (enable_ept) {
> > -		kvm_mmu_set_mask_ptes(0ull, 0ull, 0ull, 0ull,
> > -				VMX_EPT_EXECUTABLE_MASK);
> > +		kvm_mmu_set_mask_ptes(0ull,
> > +			(enable_ept_ad_bits) ? VMX_EPT_ACCESS_BIT : 0ull,
> > +			(enable_ept_ad_bits) ? VMX_EPT_DIRTY_BIT : 0ull,
> > +			0ull, VMX_EPT_EXECUTABLE_MASK);
> >  		ept_set_mmio_spte_mask();
> >  		kvm_enable_tdp();
> >  	} else
> > --
> > 1.5.6

Hi, Avi

Do you have other comments for this series of patches?
