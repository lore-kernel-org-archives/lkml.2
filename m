Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab0EFTEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 15:04:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab0EFTEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 15:04:39 -0400
Date: Thu, 6 May 2010 16:04:02 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm mmu: reduce 50% memory usage
Message-ID: <20100506190402.GA3432@amt.cnet>
References: <4BD8228D.7090708@cn.fujitsu.com>
 <20100429180955.GA17909@amt.cnet>
 <4BD9D35C.5090403@redhat.com>
 <20100430154427.GA32340@amt.cnet>
 <4BE269D4.9090108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE269D4.9090108@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 03:03:48PM +0800, Lai Jiangshan wrote:
> Marcelo Tosatti wrote:
> > On Thu, Apr 29, 2010 at 09:43:40PM +0300, Avi Kivity wrote:
> >> On 04/29/2010 09:09 PM, Marcelo Tosatti wrote:
> >>> You missed quadrant on 4mb large page emulation with shadow (see updated
> >>> patch below).
> >> Good catch.
> >>
> >>> Also for some reason i can't understand the assumption
> >>> does not hold for large sptes with TDP, so reverted for now.
> >> It's unrelated to TDP, same issue with shadow.  I think the
> >> calculation is correct.  For example the 4th spte for a level=2 page
> >> will yield gfn=4*512.
> > 
> > Under testing i see sp at level 2, with sp->gfn == 4096, mmu_set_spte
> > setting index 8 to gfn 4096 (whereas kvm_mmu_page_get_gfn returns 4096 +
> > 8*512).
> > 
> > Lai, can you please take a look at it? You should see the
> > kvm_mmu_page_set_gfn BUG_ON by using -mem-path on hugetlbfs.
> > 
> 
> Could you tell me how you test it? It will be better if I follow
> your test steps.

mount -t hugetlbfs none /mnt/
echo xyz > /proc/sys/vm/nr_hugepages
qemu-kvm parameters -mem-path /mnt/

> I also hit the kvm_mmu_page_set_gfn BUG_ON, It is because
> FNAME(fetch)() set sp->gfn wrong. The patch:
> [PATCH] kvm: calculate correct gfn for small host pages which emulates large guest pages
> fix it.
> 
> I can not hit kvm_mmu_page_set_gfn BUG_ON after this patch also
> applied.
> 
> So could you tell me your test steps:
> The host: ept/npt enabled? 64bit? testing codes in host?

Intel EPT enabled.

> The guest: OS? PAE? 32bit? 64bit? testing codes in guest?

FC12 guest.

