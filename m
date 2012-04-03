Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab2DCNET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 09:04:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab2DCNES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 09:04:18 -0400
Message-ID: <4F7AF548.9000500@redhat.com>
Date: Tue, 03 Apr 2012 16:04:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/13] KVM: MMU: fast path of handling guest page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F742AE8.9020201@linux.vnet.ibm.com> <4F788119.6090401@redhat.com>
In-Reply-To: <4F788119.6090401@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2012 07:23 PM, Avi Kivity wrote:
> On 03/29/2012 11:27 AM, Xiao Guangrong wrote:
> > If the the present bit of page fault error code is set, it indicates
> > the shadow page is populated on all levels, it means what we do is only
> > modify the access bit which can be done out of mmu-lock
> >
> > The tricks in this patch is avoiding the race between fast page fault
> > path and write-protect path, write-protect path is a read-check-modify
> > path:
> > read spte, check W bit, then clear W bit. What we do is populating a
> > identification in spte, if write-protect meets it, it modify the spte
> > even if the spte is readonly. See the comment in the code to get more
> > information
> >
> > +
> > +static bool page_fault_can_be_fast(struct kvm_vcpu *vcpu, gfn_t gfn,
> > +				   u32 error_code)
> > +{
> > +	unsigned long *rmap;
> > +	bool write = error_code & PFERR_WRITE_MASK;
> > +
> > +	/*
> > +	 * #PF can be fast only if the shadow page table is present, that
> > +	 * means we just need change the access bits (e.g: R/W, U/S...)
> > +	 * which can be done out of mmu-lock.
> > +	 */
> > +	if (!(error_code & PFERR_PRESENT_MASK))
> > +		return false;
> > +
> > +	if (unlikely(vcpu->vcpu_id > max_vcpu_spte()))
> > +		return false;
> > +
> > +	rmap = gfn_to_rmap(vcpu->kvm, gfn, PT_PAGE_TABLE_LEVEL);
>
> What prevents sp->gfns from being freed while this is going on?  Did I
> miss the patch that makes mmu pages freed by rcu?  Also need barriers in
> kvm_mmu_get_page() to make sure sp->gfns is made visible before the page
> is hashed in.
>

Ah, it's call_rcu in kvm_mmu_commit_zap_page().

-- 
error compiling committee.c: too many arguments to function

