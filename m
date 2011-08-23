Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab1HWTKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:10:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab1HWTKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:10:06 -0400
Date: Tue, 23 Aug 2011 16:09:39 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/11] KVM: MMU: improve write flooding detected
Message-ID: <20110823190939.GA10220@amt.cnet>
References: <4E4A10E8.5090705@cn.fujitsu.com>
 <4E4A1257.5080204@cn.fujitsu.com>
 <20110823080024.GA2297@amt.cnet>
 <4E53872B.3070407@cn.fujitsu.com>
 <20110823123818.GB4261@amt.cnet>
 <4E53D620.9030304@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E53D620.9030304@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 12:32:32AM +0800, Xiao Guangrong wrote:
> On 08/23/2011 08:38 PM, Marcelo Tosatti wrote:
> 
> >> And, i think there are not problems since: if the spte without accssed bit is
> >> written frequently, it means the guest page table is accessed infrequently or
> >> during the writing, the guest page table is not accessed, in this time, zapping
> >> this shadow page is not bad.
> > 
> > Think of the following scenario:
> > 
> > 1) page fault, spte with accessed bit is created from gpte at gfnA+indexA.
> > 2) write to gfnA+indexA, spte has accessed bit set, write_flooding_count
> > is not increased.
> > 3) repeat
> > 
> 
> I think the result is just we hoped, we do not want to zap the shadow page
> because the spte is currently used by the guest, it also will be used in the
> next repetition. So do not increase 'write_flooding_count' is a good choice.

Its not used. Step 2) is write to write protected shadow page at
gfnA.

> Let's consider what will happen if we increase 'write_flooding_count':
> 1: after three repetitions, zap the shadow page
> 2: in step 1, we will alloc a new shadow page for gpte at gfnA+indexA
> 3: in step 2, the flooding count is creased, so after 3 repetitions, the
>    shadow page can be zapped again, repeat 1 to 3.

The shadow page will not be zapped because the spte created from
gfnA+indexA has the accessed bit set:

       if (spte && !(*spte & shadow_accessed_mask))
               sp->write_flooding_count++;
       else
               sp->write_flooding_count = 0;

> The result is the shadow page for gfnA is alloced and zapped again and again,
> yes?

The point is you cannot rely on the accessed bit of sptes that have been
instantiated with the accessed bit set to decide whether or not to zap.
Because the accessed bit will only be cleared on host memory pressure.

> > So you cannot rely on the accessed bit being cleared to zap the shadow
> > page, because it might not be cleared in certain scenarios.
> > 
> >> Comparing the old way, the advantage of it is good for zapping upper shadow page,
> >> for example, in the old way:
> >> if a gfn is used as PDE for a task, later, the gfn is freed and used as PTE for
> >> the new task, so we have two shadow pages in the host, one sp1.level = 2 and the
> >> other sp2.level = 1. So, when we detect write-flooding, the vcpu->last_pte_updated
> >> always point to sp2.pte. As sp2 is used for the new task, we always detected both
> >> shadow pages are bing used, but actually, sp1 is not used by guest anymore.
> > 
> > Makes sense.
> > 
> >>> Back to the first question, what is the motivation for this heuristic
> >>> change? Do you have any numbers?
> >>>
> >>
> >> Yes, i have done the quick test:
> >>
> >> before this patch:
> >> 2m56.561
> >> 2m50.651
> >> 2m51.220
> >> 2m52.199
> >> 2m48.066
> >>
> >> After this patch:
> >> 2m51.194
> >> 2m55.980
> >> 2m50.755
> >> 2m47.396
> >> 2m46.807
> >>
> >> It shows the new way is little better than the old way.
> > 
> > What test is this?
> > 
> 
> Sorry, i forgot to mention it, the test case is kerbench. :-)
>  
