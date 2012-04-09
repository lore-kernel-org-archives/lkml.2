Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2DIM2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 08:28:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab2DIM2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 08:28:52 -0400
Message-ID: <4F82D5FF.20202@redhat.com>
Date: Mon, 09 Apr 2012 15:28:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 09/13] KVM: MMU: get expected spte out of mmu-lock
References: <4F742951.7080003@linux.vnet.ibm.com> <4F742A97.6030308@linux.vnet.ibm.com> <4F7879E6.8020103@redhat.com> <4F7DE39D.3040207@gmail.com>
In-Reply-To: <4F7DE39D.3040207@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2012 09:25 PM, Xiao Guangrong wrote:
> On 04/01/2012 11:53 PM, Avi Kivity wrote:
>
> > On 03/29/2012 11:25 AM, Xiao Guangrong wrote:
> >> It depends on PTE_LIST_WRITE_PROTECT bit in rmap which let us quickly know
> >> whether the page is writable out of mmu-lock
> >>
> >> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> >> ---
> >>  arch/x86/kvm/mmu.c         |   17 +++++++++++++----
> >>  arch/x86/kvm/paging_tmpl.h |    2 +-
> >>  2 files changed, 14 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >> index 3887a07..c029185 100644
> >> --- a/arch/x86/kvm/mmu.c
> >> +++ b/arch/x86/kvm/mmu.c
> >> @@ -1148,6 +1148,12 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
> >>
> >>  	*rmapp |= PTE_LIST_WRITE_PROTECT;
> >>
> >> +	/*
> >> +	 * Setting PTE_LIST_WRITE_PROTECT bit before doing page
> >> +	 * write-protect.
> >> +	 */
> >> +	smp_mb();
> >> +
> > 
> > wmb only needed.
> > 
>
>
> We should ensure setting this bit before reading spte, it cooperates with
> fast page fault path to avoid this case:
>
> On fast page fault path:                    On rmap_write_protect path:
>                                             read spte: old_spte = *spte
>                                        (reading spte is reordered to the front of
>                                         setting PTE_LIST_WRITE_PROTECT bit)
> set spte.identification
>    smp_mb
> if (!rmap.PTE_LIST_WRITE_PROTECT)
>                                             set rmap.PTE_LIST_WRITE_PROTECT
>     cmpxchg(sptep, spte, spte | WRITABLE)
>                                             see old_spte.identification is not set,
>                                             so it does not write-protect this page
>                                                   OOPS!!!

Ah, so it's protecting two paths at the same time: rmap.write_protect ->
fast page fault, and lock(sptep) -> write protect.

The whole thing needs to be documented very carefully in locking.txt,
otherwise mmu.c will be write-protected to everyone except you.

> > Would it be better to store this bit in all the sptes instead?  We're
> > touching them in any case.  More work to clear them, but
> > un-write-protecting a page is beneficial anyway as it can save a fault.
> > 
>
> There are two reasons:
> - if we set this bit in rmap, we can do the quickly check to see the page is
>   writble before doing shadow page walking.
>
> - since a full barrier is needed, we should use smp_mb for every spte like this:
>
>   while ((spte = rmap_next(rmapp, spte))) {
> 	read spte
>         smp_mb
>         write-protect spte
>   }
>
>   smp_mb is called in the loop, i think it is not good, yes?

Yes, agree.

> If you just want to save the fault, we can let all spte to be writeable in
> mmu_need_write_protect, but we should cache gpte access bits into spte firstly.
> It should be another patchset i think. :)

Yes.

-- 
error compiling committee.c: too many arguments to function

