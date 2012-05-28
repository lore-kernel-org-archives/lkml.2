Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab2E1OkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 10:40:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab2E1OkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 10:40:17 -0400
Message-ID: <4FC38E48.9080701@redhat.com>
Date: Mon, 28 May 2012 17:40:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: fix huge page adapted on non-PAE host
References: <4FC316E3.6080607@linux.vnet.ibm.com> <4FC35A15.6080000@redhat.com> <4FC363EE.6060204@linux.vnet.ibm.com> <4FC36E85.4010909@redhat.com> <4FC37600.1060301@linux.vnet.ibm.com> <4FC37A18.10809@redhat.com> <4FC38084.40409@linux.vnet.ibm.com> <4FC38362.6010802@redhat.com> <20120528143221.GF4016@redhat.com>
In-Reply-To: <20120528143221.GF4016@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 05:32 PM, Andrea Arcangeli wrote:
> Hi,
> 
> On Mon, May 28, 2012 at 04:53:38PM +0300, Avi Kivity wrote:
>> As far as I can tell __get_user_pages_fast() will take the reference
>> count in the page head in the first place.
> 
>     mask = KVM_PAGES_PER_HPAGE(level) - 1;
> 
> The BUG would trigger if the above KVM mask is 2M (that is the NPT/EPT
> pmd size), but the hugepage size in the host is 4M (noPAE 32bit).
> 
> The refcount is taken only in the head page for heads, and in both for
> tails.
> 
> Because we've mmu notifier, we never keep the pages mapped by sptes
> refcounted, we drop them all. So all we need to do is just to move the
> refcount on the same exact pfn that is then freed by mmu_set_spte
> (kvm_release_pfn_clean at the end).
> 
> The adjustement is not done for the refcounting, the issue here is, we
> want to adjust the "pfn" passed to mmu_set_spte, and in turn we've to
> move the refcounting too, because the kvm_release_pfn_clean will run
> on that "pfn" (not on the pfn returned by gup-fast anymore).
> 
> So it looks fine to just do get_page and the patch looks correct (not
> sure if the mmio the mmio check is needed or if we can just do
> get_page) as long as the "pfn" that is returned through &pfn parameter
> and then passssed to mmu_set_sptes is the same one were we do get_page.
> 
> The reason it was a get_page_unless_zero() is that it wanted to check
> that there was no THP split and the head page was still there. Problem
> is that with a 4M host page size and 2M NTP/EPT pmd size, we need to
> get_page a tail page half of the time, and get_page_unless_zero()
> won't be a correct refcount for tail pages, not equivalent to a full
> get_page.
> 
> Overall the most important thing is that the pfn returned is the
> correct one that matches the alignment of the NPT/EPT hugepmd size,
> the refcounting just closely follows that aligned "pfn".

Yes, I see it now.  Adjusting mask is incorrect since we won't have the
same adjustment on release.  I'll apply the patch for 3.5.

-- 
error compiling committee.c: too many arguments to function
