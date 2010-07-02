Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476Ab0GBRXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 13:23:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759379Ab0GBRWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 13:22:36 -0400
Date: Fri, 2 Jul 2010 13:54:32 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 4/6] KVM: MMU: prefetch ptes when intercepted guest #PF
Message-ID: <20100702165432.GB25969@amt.cnet>
References: <4C2C9DC0.8050607@cn.fujitsu.com>
 <4C2C9E45.1040304@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2C9E45.1040304@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 09:55:17PM +0800, Xiao Guangrong wrote:
> Support prefetch ptes when intercept guest #PF, avoid to #PF by later
> access
> 
> If we meet any failure in the prefetch path, we will exit it and
> not try other ptes to avoid become heavy path
> 
> Note: this speculative will mark page become dirty but it not really
> accessed, the same issue is in other speculative paths like invlpg,
> pte write, fortunately, it just affect host memory management. After
> Avi's patchset named "[PATCH v2 1/4] KVM: MMU: Introduce drop_spte()"
> merged, we will easily fix it. Will do it in the future.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c         |   79 ++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/paging_tmpl.h |   76 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 155 insertions(+), 0 deletions(-)
> 

> +	if (pte_prefetch_topup_memory_cache(vcpu))
> +		return;
> +
> +	for (j = 0; i < max; i++, j++) {
> +		pt_element_t gpte;
> +		unsigned pte_access;
> +		u64 *spte = sp->spt + i;
> +		gfn_t gfn;
> +		pfn_t pfn;
> +
> +		if (spte == sptep)
> +			continue;
> +
> +		if (*spte != shadow_trap_nonpresent_pte)
> +			continue;
> +
> +		gpte = gptep[j];
> +
> +		if (is_rsvd_bits_set(vcpu, gpte, PT_PAGE_TABLE_LEVEL))
> +			break;

BTW, doesnt sync_page also lack reserved bit checking? (unrelated to
this patch).

