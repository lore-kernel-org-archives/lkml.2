Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab2EUIbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:31:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576Ab2EUIbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:31:41 -0400
Message-ID: <4FB9FD68.7000908@redhat.com>
Date: Mon, 21 May 2012 11:31:36 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Hao, Xudong" <xudong.hao@intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Xudong Hao <xudong.hao@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Subject: Re: [PATCH 4/4] Enabling Access bit when doing memory swapping
References: <20120516011230.GE14256@hp-xd.sh.intel.com> <20120518022241.GA14096@amt.cnet> <403610A45A2B5242BD291EDAE8B37D300FDC6BEE@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <403610A45A2B5242BD291EDAE8B37D300FDC6BEE@SHSMSX102.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 06:22 AM, Hao, Xudong wrote:
> > -----Original Message-----
> > From: Marcelo Tosatti [mailto:mtosatti@redhat.com]
> > Sent: Friday, May 18, 2012 10:23 AM
> > To: Xudong Hao
> > Cc: avi@redhat.com; kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > Shan, Haitao; Zhang, Xiantao; Hao, Xudong
> > Subject: Re: [PATCH 4/4] Enabling Access bit when doing memory swapping
> > 
> > On Wed, May 16, 2012 at 09:12:30AM +0800, Xudong Hao wrote:
> > > Enabling Access bit when doing memory swapping.
> > >
> > > Signed-off-by: Haitao Shan <haitao.shan@intel.com>
> > > Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> > > ---
> > >  arch/x86/kvm/mmu.c |   13 +++++++------
> > >  arch/x86/kvm/vmx.c |    6 ++++--
> > >  2 files changed, 11 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > > index ff053ca..5f55f98 100644
> > > --- a/arch/x86/kvm/mmu.c
> > > +++ b/arch/x86/kvm/mmu.c
> > > @@ -1166,7 +1166,8 @@ static int kvm_age_rmapp(struct kvm *kvm,
> > unsigned long *rmapp,
> > >     int young = 0;
> > >
> > >     /*
> > > -    * Emulate the accessed bit for EPT, by checking if this page has
> > > +    * In case of absence of EPT Access and Dirty Bits supports,
> > > +    * emulate the accessed bit for EPT, by checking if this page has
> > >      * an EPT mapping, and clearing it if it does. On the next access,
> > >      * a new EPT mapping will be established.
> > >      * This has some overhead, but not as much as the cost of swapping
> > > @@ -1179,11 +1180,11 @@ static int kvm_age_rmapp(struct kvm *kvm,
> > unsigned long *rmapp,
> > >     while (spte) {
> > >         int _young;
> > >         u64 _spte = *spte;
> > > -       BUG_ON(!(_spte & PT_PRESENT_MASK));
> > > -       _young = _spte & PT_ACCESSED_MASK;
> > > +       BUG_ON(!is_shadow_present_pte(_spte));
> > > +       _young = _spte & shadow_accessed_mask;
> > >         if (_young) {
> > >             young = 1;
> > > -           clear_bit(PT_ACCESSED_SHIFT, (unsigned long *)spte);
> > > +           *spte &= ~shadow_accessed_mask;
> > >         }
> > 
> > Now a dirty bit can be lost. Is there a reason to remove the clear_bit?
>
> The clear_bit() is called in shadown and EPT A/D mode, because PT_ACCESSED_SHIFT does not make sense for EPT A/D bit, so use the code shadow_accessed_mask to mask the bit for both of them.

That doesn't answer the question.  An atomic operation is now non-atomic.

You can calculate shadow_accessed_bit and keep on using clear_bit(), or
switch to cmpxchg64(), but don't just drop the dirty bit here.

-- 
error compiling committee.c: too many arguments to function

