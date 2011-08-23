Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab1HWMjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 08:39:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656Ab1HWMix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 08:38:53 -0400
Date: Tue, 23 Aug 2011 09:38:18 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/11] KVM: MMU: improve write flooding detected
Message-ID: <20110823123818.GB4261@amt.cnet>
References: <4E4A10E8.5090705@cn.fujitsu.com>
 <4E4A1257.5080204@cn.fujitsu.com>
 <20110823080024.GA2297@amt.cnet>
 <4E53872B.3070407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E53872B.3070407@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 06:55:39PM +0800, Xiao Guangrong wrote:
> Hi Marcelo,
> 
> On 08/23/2011 04:00 PM, Marcelo Tosatti wrote:
> > On Tue, Aug 16, 2011 at 02:46:47PM +0800, Xiao Guangrong wrote:
> >> Detecting write-flooding does not work well, when we handle page written, if
> >> the last speculative spte is not accessed, we treat the page is
> >> write-flooding, however, we can speculative spte on many path, such as pte
> >> prefetch, page synced, that means the last speculative spte may be not point
> >> to the written page and the written page can be accessed via other sptes, so
> >> depends on the Accessed bit of the last speculative spte is not enough
> > 
> > Yes, a stale last_speculative_spte is possible, but is this fact a
> > noticeable problem in practice?
> > 
> > Was this detected by code inspection?
> > 
> 
> I detected this because: i noticed some shadow page is zapped by
> write-flooding but it is accessed soon, it causes the shadow page zapped
> and alloced again and again(very frequently).
> 
> Another reason is that: in current code, write-flooding is little complex
> and it stuffs code in many places, actually, write-flooding is only needed for
> shadow page/nested guest, so i want to simplify it and wrap its code up.
> 
> >> -	}
> >> +	if (spte && !(*spte & shadow_accessed_mask))
> >> +		sp->write_flooding_count++;
> >> +	else
> >> +		sp->write_flooding_count = 0;
> > 
> > This relies on the sptes being created by speculative means
> > or by pressure on the host clearing the accessed bit for the
> > shadow page to be zapped. 
> > 
> > There is no guarantee that either of these is true for a given
> > spte.
> > 
> > And if the sptes do not have accessed bit set, any nonconsecutive 3 pte
> > updates will zap the page.
> > 
> 
> Please note we clear 'sp->write_flooding_count' when it is accessed from
> shadow page cache (in kvm_mmu_get_page), it means if any spte of sp generates
> #PF, the fooding count can be reset.

OK.

> And, i think there are not problems since: if the spte without accssed bit is
> written frequently, it means the guest page table is accessed infrequently or
> during the writing, the guest page table is not accessed, in this time, zapping
> this shadow page is not bad.

Think of the following scenario:

1) page fault, spte with accessed bit is created from gpte at gfnA+indexA.
2) write to gfnA+indexA, spte has accessed bit set, write_flooding_count
is not increased.
3) repeat

So you cannot rely on the accessed bit being cleared to zap the shadow
page, because it might not be cleared in certain scenarios.

> Comparing the old way, the advantage of it is good for zapping upper shadow page,
> for example, in the old way:
> if a gfn is used as PDE for a task, later, the gfn is freed and used as PTE for
> the new task, so we have two shadow pages in the host, one sp1.level = 2 and the
> other sp2.level = 1. So, when we detect write-flooding, the vcpu->last_pte_updated
> always point to sp2.pte. As sp2 is used for the new task, we always detected both
> shadow pages are bing used, but actually, sp1 is not used by guest anymore.

Makes sense.

> > Back to the first question, what is the motivation for this heuristic
> > change? Do you have any numbers?
> > 
> 
> Yes, i have done the quick test:
> 
> before this patch:
> 2m56.561
> 2m50.651
> 2m51.220
> 2m52.199
> 2m48.066
> 
> After this patch:
> 2m51.194
> 2m55.980
> 2m50.755
> 2m47.396
> 2m46.807
> 
> It shows the new way is little better than the old way.

What test is this?
