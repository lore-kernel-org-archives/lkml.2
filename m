Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094Ab2C2LLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 07:11:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab2C2LLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 07:11:16 -0400
Message-ID: <4F744350.1060007@redhat.com>
Date: Thu, 29 Mar 2012 13:11:12 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 02/13] KVM: MMU: abstract spte write-protect
References: <4F742951.7080003@linux.vnet.ibm.com> <4F742999.9080001@linux.vnet.ibm.com>
In-Reply-To: <4F742999.9080001@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 11:21 AM, Xiao Guangrong wrote:
> Introduce a common function to abstract spte write-protect to cleanup the
> code
>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |   57 ++++++++++++++++++++++++++++++---------------------
>  1 files changed, 33 insertions(+), 24 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index c759e4f..ad40647 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1015,27 +1015,43 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
>  		rmap_remove(kvm, sptep);
>  }
>
> +/* Return true if the spte is dropped. */
> +static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
> +			       int *flush)

bool *flush

> +{
> +	u64 spte = *sptep;
> +
> +	if (!is_writable_pte(spte))
> +		return false;
> +
> +	*flush |= true;
> +
> +	if (large) {
> +		pgprintk("rmap_write_protect(large): spte %p %llx\n",
> +			 spte, *spte);
> +		BUG_ON(!is_large_pte(spte));
> +
> +		drop_spte(kvm, sptep);
> +		--kvm->stat.lpages;
> +		return true;
> +	}

As I mentioned before, write-protecting a large spte is a good idea,
since it moves some work from protect-time to fault-time, so it reduces
jitter.  This removes the need for the return value.

It may also be a good idea to populate the lower level instead of
dropping the spte.

All outside this patch set of course.  I'd add those ideas to the wiki
but it won't let me edit at the moment.

> +
> +	rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
> +	spte = spte & ~PT_WRITABLE_MASK;
> +	mmu_spte_update(sptep, spte);
> +
> +	return false;
> +}
> +
>


-- 
error compiling committee.c: too many arguments to function

