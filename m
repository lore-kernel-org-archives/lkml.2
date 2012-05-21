Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab2EUDW6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 23:22:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:51469 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233Ab2EUDW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 23:22:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="145526469"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: Marcelo Tosatti <mtosatti@redhat.com>,
        Xudong Hao <xudong.hao@linux.intel.com>
CC: "avi@redhat.com" <avi@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Subject: RE: [PATCH 4/4] Enabling Access bit when doing memory swapping
Thread-Topic: [PATCH 4/4] Enabling Access bit when doing memory swapping
Thread-Index: AQHNMwB99DBQcMufFEKPOUTp11XjXpbOThaAgAVNAKA=
Date: Mon, 21 May 2012 03:22:47 +0000
Message-ID: <403610A45A2B5242BD291EDAE8B37D300FDC6BEE@SHSMSX102.ccr.corp.intel.com>
References: <20120516011230.GE14256@hp-xd.sh.intel.com>
 <20120518022241.GA14096@amt.cnet>
In-Reply-To: <20120518022241.GA14096@amt.cnet>
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
> From: Marcelo Tosatti [mailto:mtosatti@redhat.com]
> Sent: Friday, May 18, 2012 10:23 AM
> To: Xudong Hao
> Cc: avi@redhat.com; kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> Shan, Haitao; Zhang, Xiantao; Hao, Xudong
> Subject: Re: [PATCH 4/4] Enabling Access bit when doing memory swapping
> 
> On Wed, May 16, 2012 at 09:12:30AM +0800, Xudong Hao wrote:
> > Enabling Access bit when doing memory swapping.
> >
> > Signed-off-by: Haitao Shan <haitao.shan@intel.com>
> > Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> > ---
> >  arch/x86/kvm/mmu.c |   13 +++++++------
> >  arch/x86/kvm/vmx.c |    6 ++++--
> >  2 files changed, 11 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > index ff053ca..5f55f98 100644
> > --- a/arch/x86/kvm/mmu.c
> > +++ b/arch/x86/kvm/mmu.c
> > @@ -1166,7 +1166,8 @@ static int kvm_age_rmapp(struct kvm *kvm,
> unsigned long *rmapp,
> >     int young = 0;
> >
> >     /*
> > -    * Emulate the accessed bit for EPT, by checking if this page has
> > +    * In case of absence of EPT Access and Dirty Bits supports,
> > +    * emulate the accessed bit for EPT, by checking if this page has
> >      * an EPT mapping, and clearing it if it does. On the next access,
> >      * a new EPT mapping will be established.
> >      * This has some overhead, but not as much as the cost of swapping
> > @@ -1179,11 +1180,11 @@ static int kvm_age_rmapp(struct kvm *kvm,
> unsigned long *rmapp,
> >     while (spte) {
> >         int _young;
> >         u64 _spte = *spte;
> > -       BUG_ON(!(_spte & PT_PRESENT_MASK));
> > -       _young = _spte & PT_ACCESSED_MASK;
> > +       BUG_ON(!is_shadow_present_pte(_spte));
> > +       _young = _spte & shadow_accessed_mask;
> >         if (_young) {
> >             young = 1;
> > -           clear_bit(PT_ACCESSED_SHIFT, (unsigned long *)spte);
> > +           *spte &= ~shadow_accessed_mask;
> >         }
> 
> Now a dirty bit can be lost. Is there a reason to remove the clear_bit?

The clear_bit() is called in shadown and EPT A/D mode, because PT_ACCESSED_SHIFT does not make sense for EPT A/D bit, so use the code shadow_accessed_mask to mask the bit for both of them.
