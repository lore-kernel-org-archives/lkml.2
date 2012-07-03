Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780Ab2GCUn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 16:43:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab2GCUn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 16:43:56 -0400
Date: Tue, 3 Jul 2012 17:30:53 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: MMU: track the refcount when unmap the page
Message-ID: <20120703203053.GA13581@amt.cnet>
References: <4FF291A5.5090803@linux.vnet.ibm.com>
 <4FF291EE.7060408@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF291EE.7060408@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 02:32:14PM +0800, Xiao Guangrong wrote:
> It will trigger a WARN_ON if the page has been freed but it is still
> used in mmu, it can help us to detect mm bug early
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index cac3408..af7e076 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -527,6 +527,14 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
>  		return 0;
> 
>  	pfn = spte_to_pfn(old_spte);
> +
> +	/*
> +	 * KVM does not hold the refcount of the page used by
> +	 * kvm mmu, before reclaiming the page, we should
> +	 * unmap it from mmu first.
> +	 */
> +	WARN_ON(!page_count(pfn_to_page(pfn)));
> +

Except for mmio pfns.

Applied patch 1 and 2 to master, thanks.

