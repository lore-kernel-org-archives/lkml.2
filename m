Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0KHRBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 12:01:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab0KHRBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 12:01:42 -0500
Date: Mon, 8 Nov 2010 19:01:36 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: MMU: don not retry #PF for nonpaging guest
Message-ID: <20101108170136.GB705@redhat.com>
References: <4CD28B5F.1040205@cn.fujitsu.com>
 <4CD28BCA.1060907@cn.fujitsu.com>
 <20101104103548.GE6018@redhat.com>
 <4CD39886.4050909@cn.fujitsu.com>
 <20101105074533.GC14910@redhat.com>
 <4CD3BA50.1000002@cn.fujitsu.com>
 <20101105103124.GD14910@redhat.com>
 <4CD75D0B.1000305@cn.fujitsu.com>
 <20101108135219.GA9036@redhat.com>
 <AANLkTim6M11nu2hD=T+F=xGfePyUEo+WO+UDtYDVL+xm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim6M11nu2hD=T+F=xGfePyUEo+WO+UDtYDVL+xm@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 12:58:24AM +0800, Xiao Guangrong wrote:
> I mean the second case, the problem is in "d:", now, A-apf is on
> L0->L1 mapping, and A-apf.gva is nested fault address(L2's physics
> address in L0->L2 mapping), you use this address to retry #pf in
> L0->L1 mapping? it is just waste.
> 
No A-apf.gva should contain L1 physical address.

> On 11/8/10, Gleb Natapov <gleb@redhat.com> wrote:
> > On Mon, Nov 08, 2010 at 10:14:35AM +0800, Xiao Guangrong wrote:
> >> On 11/05/2010 06:31 PM, Gleb Natapov wrote:
> >> > On Fri, Nov 05, 2010 at 04:03:28PM +0800, Xiao Guangrong wrote:
> >> >> On 11/05/2010 03:45 PM, Gleb Natapov wrote:
> >> >>
> >> >>>>
> >> >>>> It looks like something broken: apfs can generated in L2 guest
> >> >>>> (nested ntp guest)
> >> >>>> and be retried in L1 guest.
> >> >>>>
> >> >>> Why is this a problem? apf will be generate on direct map even when L2
> >> >>> guest is running so it should be OK to prefault it into direct map on
> >> >>> completion.
> >> >>>
> >> >>
> >> >> The nested_cr3 is different between L2 and L1, fix L2's page fault in
> >> >> L1's page table
> >> >> is useless.
> >> > But we are fixing L0 page faults in L0 page table. We do not start apf
> >> > because of L1 faulted in its page table.
> >> >
> >>
> >> Hi Gleb,
> >>
> >> For example, NPT Guest L1 runs on Host, and Nested NPT Guest L2 runs on
> >> Guest L1.
> >> Now, Guest L2 is running, has below sequences:
> >>
> >> a: NPF/PF occurs in L2 Guest, and generates a apf(named A-apf), then
> >>    L2 Guest is blocked
> >>
> > What do you mean by that? Do you mean L2 exits to L1 with NPF because
> > L1 swapped out L2 page? In this case apf will be generated and handled
> > by L1 just like in L0->L1 non-nested case. Or do you mean L2 exits to L0
> > with NPF because L0 swapped out L1 page? Lets assume you mean second
> > case since it is interesting one.
> >
> >> b: a external event wakes up L2 Guest, and let it run again.
> >>
> >> c: L2 Guest VMEXIT to L1 Guest because L2 Guest's action is intercepted by
> >> Guest L1
> >>
> >> d: When cpu enter L1 Guest, A-apf is completed, then it will retry A-apf
> >> in
> >>    L1 Guest's mmu context, and this 'retry' is useless.
> > Since A-apf was on L0->L1 mapping it is OK to prefault it into direct
> > map. Wen L2 will run again and try to access this page it fill fault
> > again since the page is not pre-faulted into nntp shadow page. This time
> > L0 will find page in memory and will create shadow mapping for it
> > without apf.
> >
> >>
> >> Could you please point it out for me if i missed something. :-)
> >>
> >
> > --
> > 			Gleb.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> -- 
> Sent from my mobile device

--
			Gleb.
