Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab1HYCF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 22:05:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab1HYCFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 22:05:25 -0400
Date: Wed, 24 Aug 2011 23:04:24 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/11] KVM: MMU: improve write flooding detected
Message-ID: <20110825020424.GA2542@amt.cnet>
References: <4E4A10E8.5090705@cn.fujitsu.com>
 <4E4A1257.5080204@cn.fujitsu.com>
 <20110823080024.GA2297@amt.cnet>
 <4E53872B.3070407@cn.fujitsu.com>
 <20110823123818.GB4261@amt.cnet>
 <4E53D620.9030304@cn.fujitsu.com>
 <20110823190939.GA10220@amt.cnet>
 <4E540AB4.6060905@cn.fujitsu.com>
 <20110824200540.GA19804@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824200540.GA19804@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 05:05:40PM -0300, Marcelo Tosatti wrote:
> On Wed, Aug 24, 2011 at 04:16:52AM +0800, Xiao Guangrong wrote:
> > On 08/24/2011 03:09 AM, Marcelo Tosatti wrote:
> > > On Wed, Aug 24, 2011 at 12:32:32AM +0800, Xiao Guangrong wrote:
> > >> On 08/23/2011 08:38 PM, Marcelo Tosatti wrote:
> > >>
> > >>>> And, i think there are not problems since: if the spte without accssed bit is
> > >>>> written frequently, it means the guest page table is accessed infrequently or
> > >>>> during the writing, the guest page table is not accessed, in this time, zapping
> > >>>> this shadow page is not bad.
> > >>>
> > >>> Think of the following scenario:
> > >>>
> > >>> 1) page fault, spte with accessed bit is created from gpte at gfnA+indexA.
> > >>> 2) write to gfnA+indexA, spte has accessed bit set, write_flooding_count
> > >>> is not increased.
> > >>> 3) repeat
> > >>>
> > >>
> > >> I think the result is just we hoped, we do not want to zap the shadow page
> > >> because the spte is currently used by the guest, it also will be used in the
> > >> next repetition. So do not increase 'write_flooding_count' is a good choice.
> > > 
> > > Its not used. Step 2) is write to write protected shadow page at
> > > gfnA.
> > > 
> > >> Let's consider what will happen if we increase 'write_flooding_count':
> > >> 1: after three repetitions, zap the shadow page
> > >> 2: in step 1, we will alloc a new shadow page for gpte at gfnA+indexA
> > >> 3: in step 2, the flooding count is creased, so after 3 repetitions, the
> > >>    shadow page can be zapped again, repeat 1 to 3.
> > > 
> > > The shadow page will not be zapped because the spte created from
> > > gfnA+indexA has the accessed bit set:
> > > 
> > >        if (spte && !(*spte & shadow_accessed_mask))
> > >                sp->write_flooding_count++;
> > >        else
> > >                sp->write_flooding_count = 0;
> > > 
> > 
> > Ah, i see, i thought it was "repeat"ed on the same spte, it was my wrong.
> > 
> > Yes, in this case, the sp is not zapped, but it is hardly to know the gfn
> > is not used as gpte just depends on writing, for example, the guest can
> > change the mapping address or the status bit, and so on...The sp can be
> > zapped if the guest write it again(on the same address), i think it is
> > acceptable, anymore, it is just the speculative way to zap the unused
> > shadow page...your opinion?
> 
> It could increase the flood count independently of the accessed bit of
> the spte being updated, zapping after 3 attempts as it is now.
> 
> But additionally reset the flood count if the gpte appears to be valid
> (points to an existant gfn if the present bit is set, or if its zeroed).

Well not zero, as thats a common pattern for non ptes.

