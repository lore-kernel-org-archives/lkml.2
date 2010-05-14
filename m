Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab0ENA60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:58:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:45452 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab0ENA6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:58:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,225,1272870000"; 
   d="scan'208";a="517784513"
Subject: Re: [PATCH -v2] KVM, Fix QEMU-KVM is killed by guest SRAO MCE
From: Huang Ying <ying.huang@intel.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
In-Reply-To: <20100513214307.GA25003@amt.cnet>
References: <1273646643.3564.51.camel@yhuang-dev.sh.intel.com>
	 <20100513214307.GA25003@amt.cnet>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 08:58:21 +0800
Message-ID: <1273798701.3564.112.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 05:43 +0800, Marcelo Tosatti wrote:
> On Wed, May 12, 2010 at 02:44:03PM +0800, Huang Ying wrote:
> > @@ -1975,6 +1976,27 @@ static int __direct_map(struct kvm_vcpu
> >  	return pt_write;
> >  }
> >  
> > +static void kvm_send_hwpoison_signal(struct kvm *kvm, gfn_t gfn)
> > +{
> > +	char buf[1];
> > +	void __user *hva;
> > +	int r;
> > +
> > +	/* Touch the page, so send SIGBUS */
> > +	hva = (void __user *)gfn_to_hva(kvm, gfn);
> > +	r = copy_from_user(buf, hva, 1);
> > +}
> 
> A SIGBUS signal has been raised by memory poisoning already, so i don't
> see why this is needed?
> 
> To avoid the MMIO processing in userspace before the MCE is sent to the
> guest you can just return -EAGAIN from the page fault handlers back to
> kvm_mmu_page_fault.

The SIGBUS signal is necessary here because this SIGBUS is SRAR (Action
Requirement) while the previously sent one is SRAO (Action Optional).
They have different semantics and processed differently in QEMU-KVM and
guest OS.

For example the guest Linux kernel may ignore SRAO MCE (raised by
QEMU-KVM after receiving SRAO SIGBUS), because it is optional, but for
SRAR MCE (raised by QEMU-KVM after receiving SRAR SIGBUS) the guest
Linux kernel must kill corresponding application or go panic.

> > +int is_hwpoison_address(unsigned long addr)
> > +{
> > +	pgd_t *pgdp;
> > +	pud_t *pudp;
> > +	pmd_t *pmdp;
> > +	pte_t pte, *ptep;
> > +	swp_entry_t entry;
> > +
> > +	pgdp = pgd_offset(current->mm, addr);
> > +	if (!pgd_present(*pgdp))
> > +		return 0;
> > +	pudp = pud_offset(pgdp, addr);
> > +	if (!pud_present(*pudp))
> > +		return 0;
> > +	pmdp = pmd_offset(pudp, addr);
> > +	if (!pmd_present(*pmdp))
> > +		return 0;
> 
> Need to bail out if pmd is huge.

Yes. I will change this.

Best Regards,
Huang Ying


