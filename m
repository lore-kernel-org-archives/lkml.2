Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab0FPJYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 05:24:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab0FPJYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 05:24:05 -0400
Message-ID: <4C189830.2070300@redhat.com>
Date: Wed, 16 Jun 2010 12:24:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC][PATCH 9/9] make kvm mmu shrinker more aggressive
References: <20100615135518.BC244431@kernel.beaverton.ibm.com> <20100615135530.4565745D@kernel.beaverton.ibm.com>
In-Reply-To: <20100615135530.4565745D@kernel.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 04:55 PM, Dave Hansen wrote:
> In a previous patch, we removed the 'nr_to_scan' tracking.
> It was not being used to track the number of objects
> scanned, so we stopped using it entirely.  Here, we
> strart using it again.
>
> The theory here is simple; if we already have the refcount
> and the kvm->mmu_lock, then we should do as much work as
> possible under the lock.  The downside is that we're less
> fair about the KVM instances from which we reclaim.  Each
> call to mmu_shrink() will tend to "pick on" one instance,
> after which it gets moved to the end of the list and left
> alone for a while.
>    

That also increases the latency hit, as well as a potential fault storm, 
on that instance.  Spreading out is less efficient, but smoother.

> If mmu_shrink() has already done a significant amount of
> scanning, the use of 'nr_to_scan' inside shrink_kvm_mmu()
> will also ensure that we do not over-reclaim when we have
> already done a lot of work in this call.
>
> In the end, this patch defines a "scan" as:
> 1. An attempt to acquire a refcount on a 'struct kvm'
> 2. freeing a kvm mmu page
>
> This would probably be most ideal if we can expose some
> of the work done by kvm_mmu_remove_some_alloc_mmu_pages()
> as also counting as scanning, but I think we have churned
> enough for the moment.
>    

It usually removes one page.

> Signed-off-by: Dave Hansen<dave@linux.vnet.ibm.com>
> ---
>
>   linux-2.6.git-dave/arch/x86/kvm/mmu.c |   11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff -puN arch/x86/kvm/mmu.c~make-shrinker-more-aggressive arch/x86/kvm/mmu.c
> --- linux-2.6.git/arch/x86/kvm/mmu.c~make-shrinker-more-aggressive	2010-06-14 11:30:44.000000000 -0700
> +++ linux-2.6.git-dave/arch/x86/kvm/mmu.c	2010-06-14 11:38:04.000000000 -0700
> @@ -2935,8 +2935,10 @@ static int shrink_kvm_mmu(struct kvm *kv
>
>   	idx = srcu_read_lock(&kvm->srcu);
>   	spin_lock(&kvm->mmu_lock);
> -	if (kvm->arch.n_used_mmu_pages>  0)
> -		freed_pages = kvm_mmu_remove_some_alloc_mmu_pages(kvm);
> +	while (nr_to_scan>  0&&  kvm->arch.n_used_mmu_pages>  0) {
> +		freed_pages += kvm_mmu_remove_some_alloc_mmu_pages(kvm);
> +		nr_to_scan--;
> +	}
>    

What tree are you patching?

-- 
error compiling committee.c: too many arguments to function

