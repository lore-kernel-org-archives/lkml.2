Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab2FNBGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 21:06:51 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:50165 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab2FNBGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 21:06:50 -0400
Date: Thu, 14 Jun 2012 10:13:28 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 5/9] KVM: MMU: introduce SPTE_MMU_WRITEABLE bit
Message-Id: <20120614101328.c23ab94b.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120613213905.GD19290@amt.cnet>
References: <4FC470C7.5040700@linux.vnet.ibm.com>
	<4FC4716A.8030304@linux.vnet.ibm.com>
	<20120613213905.GD19290@amt.cnet>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012 18:39:05 -0300
Marcelo Tosatti <mtosatti@redhat.com> wrote:

> >  /* Return true if the spte is dropped. */
> > -static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush)
> > +static bool
> > +spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
> >  {
> >  	u64 spte = *sptep;
> > 
> > -	if (!is_writable_pte(spte))
> > +	if (!is_writable_pte(spte) &&
> > +	      !(pt_protect && spte_can_be_writable(spte)))
> >  		return false;
> > 
> >  	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
> > 
> > -	*flush |= true;
> >  	if (is_large_pte(spte)) {
> >  		WARN_ON(page_header(__pa(sptep))->role.level ==
> >  		       PT_PAGE_TABLE_LEVEL);
> > +
> > +		*flush |= true;
> >  		drop_spte(kvm, sptep);
> >  		--kvm->stat.lpages;
> >  		return true;
> >  	}
> > 
> > +	if (pt_protect)
> > +		spte &= ~SPTE_MMU_WRITEABLE;
> >  	spte = spte & ~PT_WRITABLE_MASK;
> > -	mmu_spte_update(sptep, spte);
> > +
> > +	*flush = mmu_spte_update(sptep, spte);
> 
> This clears previous flush value when looping over multiple sptes in 
> a single rmapp.
> 

I'm sorry but I have to say that this function is hard to understand.

/* Return true if the spte is dropped. */
static bool
spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)

Even with the comment above, can we guess what this function will do
for us without reading the body?

My feeling is that separate roles have been put into this one without
explaining each parameter.

I think there are two solutions:
	1. separate this into a few functions
	2. explain each parameter/role properly in the comment

Gaining a bit of lines by putting many things into one function will
not help us IMO.

Thanks,
	Takuya
