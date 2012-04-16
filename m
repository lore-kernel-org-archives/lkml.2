Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2DPKCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 06:02:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab2DPKCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 06:02:07 -0400
Message-ID: <4F8BEE1B.8000704@redhat.com>
Date: Mon, 16 Apr 2012 13:02:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 10/16] KVM: MMU: fask check whether page is writable
References: <4F87FA69.5060106@linux.vnet.ibm.com> <4F87FC82.2050302@linux.vnet.ibm.com> <4F8AE64F.7080909@redhat.com> <4F8B9115.2030807@linux.vnet.ibm.com>
In-Reply-To: <4F8B9115.2030807@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 06:25 AM, Xiao Guangrong wrote:
> On 04/15/2012 11:16 PM, Avi Kivity wrote:
>
> > On 04/13/2012 01:14 PM, Xiao Guangrong wrote:
> >> Using bit 1 (PTE_LIST_WP_BIT) in rmap store the write-protect status
> >> to avoid unnecessary shadow page walking
> >>
> >> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> >> ---
> >>  arch/x86/kvm/mmu.c |   40 ++++++++++++++++++++++++++++++++++------
> >>  1 files changed, 34 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >> index 0c6e92d..8b71908 100644
> >> --- a/arch/x86/kvm/mmu.c
> >> +++ b/arch/x86/kvm/mmu.c
> >> @@ -796,7 +796,9 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
> >>  	return level - 1;
> >>  }
> >>
> >> -#define PTE_LIST_DESC		(0x1ull)
> >> +#define PTE_LIST_DESC_BIT	0
> >> +#define PTE_LIST_WP_BIT	1
> >> +#define PTE_LIST_DESC		(1 << PTE_LIST_DESC_BIT)
> >>  #define PTE_LIST_FLAG_MASK	(0x3ull)
> >>
> >>  static void
> >> @@ -1067,6 +1069,12 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
> >>  	return mmu_memory_cache_free_objects(cache);
> >>  }
> >>
> >> +static void host_page_write_protect(u64 *spte, unsigned long *rmapp)
> >> +{
> >> +	if (!(*spte & SPTE_HOST_WRITEABLE))
> >> +		__test_and_set_bit(PTE_LIST_WP_BIT, rmapp);
> >> +}
> >>
> > 
> > Why is this needed, in addition to spte.SPTE_WRITE_PROTECT?
> > 
>
>
> It is used to avoid the unnecessary overload 

It's overloading me :(

> for fast page fault if
> KSM is enabled. On the fast check path, it can see the gfn is write-protected
> by host, then the fast page fault path is not called.

The fast page fault path is supposed to be fast, so it's okay if we take
a bit of extra overhead before a COW (which is going to be slow anyway).

Let's get the simplest possible version in, and then discuss if/how we
need to optimize it further.

-- 
error compiling committee.c: too many arguments to function

