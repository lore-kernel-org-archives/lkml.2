Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab1HYNrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 09:47:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab1HYNrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 09:47:35 -0400
Date: Thu, 25 Aug 2011 10:47:12 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/11] KVM: MMU: improve write flooding detected
Message-ID: <20110825134712.GB4384@amt.cnet>
References: <4E4A10E8.5090705@cn.fujitsu.com>
 <4E4A1257.5080204@cn.fujitsu.com>
 <20110823080024.GA2297@amt.cnet>
 <4E53872B.3070407@cn.fujitsu.com>
 <20110823123818.GB4261@amt.cnet>
 <4E53D620.9030304@cn.fujitsu.com>
 <20110823190939.GA10220@amt.cnet>
 <4E560062.40805@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E560062.40805@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 03:57:22PM +0800, Xiao Guangrong wrote:
> On 08/24/2011 03:09 AM, Marcelo Tosatti wrote:
> > On Wed, Aug 24, 2011 at 12:32:32AM +0800, Xiao Guangrong wrote:
> >> On 08/23/2011 08:38 PM, Marcelo Tosatti wrote:
> >>
> >>>> And, i think there are not problems since: if the spte without accssed bit is
> >>>> written frequently, it means the guest page table is accessed infrequently or
> >>>> during the writing, the guest page table is not accessed, in this time, zapping
> >>>> this shadow page is not bad.
> >>>
> >>> Think of the following scenario:
> >>>
> >>> 1) page fault, spte with accessed bit is created from gpte at gfnA+indexA.
> >>> 2) write to gfnA+indexA, spte has accessed bit set, write_flooding_count
> >>> is not increased.
> >>> 3) repeat
> >>>
> >>
> >> I think the result is just we hoped, we do not want to zap the shadow page
> >> because the spte is currently used by the guest, it also will be used in the
> >> next repetition. So do not increase 'write_flooding_count' is a good choice.
> > 
> > Its not used. Step 2) is write to write protected shadow page at
> > gfnA.
> > 
> >> Let's consider what will happen if we increase 'write_flooding_count':
> >> 1: after three repetitions, zap the shadow page
> >> 2: in step 1, we will alloc a new shadow page for gpte at gfnA+indexA
> >> 3: in step 2, the flooding count is creased, so after 3 repetitions, the
> >>    shadow page can be zapped again, repeat 1 to 3.
> > 
> > The shadow page will not be zapped because the spte created from
> > gfnA+indexA has the accessed bit set:
> > 
> >        if (spte && !(*spte & shadow_accessed_mask))
> >                sp->write_flooding_count++;
> >        else
> >                sp->write_flooding_count = 0;
> > 
> 
> Marcelo, i am still confused with your example, in step 3), what is repeated?
> it repeats step 2) or it repeats step 1) and 2)?
> 
> Only step 2) is repeated i guess, right? if it is yes, it works well:
> when the guest writes gpte, the spte of corresponding shadow page is zapped
> (level > 1) or it is speculatively fetched(level == 1), the accessed bit is
> cleared in both case.

Right.

> the later write can detect that the accessed bit is not set, and write_flooding_count
> is increased. finally, the shadow page is zapped, the gpte is written directly.
> 
> >> The result is the shadow page for gfnA is alloced and zapped again and again,
> >> yes?
> > 
> > The point is you cannot rely on the accessed bit of sptes that have been
> > instantiated with the accessed bit set to decide whether or not to zap.
> > Because the accessed bit will only be cleared on host memory pressure.
> > 
> 
> But the accessed bit is also cleared after spte is written.

Right. But only one of the 512 sptes. Worst case, a shadow that has 1
spte with accessed bit at every 3 spte entries would not be zapped for a
linear write of the entire guest pagetable. The current heuristic does 
not suffer from this issue.

I guess it is OK to be more trigger happy with zapping by ignoring
the accessed bit, clearing the flood counter on page fault.

