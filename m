Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab0FPIsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:48:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab0FPIsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:48:36 -0400
Message-ID: <4C188FC0.3050306@redhat.com>
Date: Wed, 16 Jun 2010 11:48:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC][PATCH 4/9] create aggregate kvm_total_used_mmu_pages value
References: <20100615135518.BC244431@kernel.beaverton.ibm.com> <20100615135523.25D24A73@kernel.beaverton.ibm.com>
In-Reply-To: <20100615135523.25D24A73@kernel.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 04:55 PM, Dave Hansen wrote:
> Note: this is the real meat of the patch set.  It can be applied up
> to this point, and everything will probably be improved, at least
> a bit.
>
> Of slab shrinkers, the VM code says:
>
>   * Note that 'shrink' will be passed nr_to_scan == 0 when the VM is
>   * querying the cache size, so a fastpath for that case is appropriate.
>
> and it *means* it.  Look at how it calls the shrinkers:
>
> 	nr_before = (*shrinker->shrink)(0, gfp_mask);
> 	shrink_ret = (*shrinker->shrink)(this_scan, gfp_mask);
>
> So, if you do anything stupid in your shrinker, the VM will doubly
> punish you.
>    

Ouch.

> The mmu_shrink() function takes the global kvm_lock, then acquires
> every VM's kvm->mmu_lock in sequence.  If we have 100 VMs, then
> we're going to take 101 locks.  We do it twice, so each call takes
> 202 locks.  If we're under memory pressure, we can have each cpu
> trying to do this.  It can get really hairy, and we've seen lock
> spinning in mmu_shrink() be the dominant entry in profiles.
>
> This is guaranteed to optimize at least half of those lock
> aquisitions away.  It removes the need to take any of the locks
> when simply trying to count objects.
>
>
> Signed-off-by: Dave Hansen<dave@linux.vnet.ibm.com>
> ---
>
>   linux-2.6.git-dave/arch/x86/kvm/mmu.c |   33 +++++++++++++++++++++++----------
>   1 file changed, 23 insertions(+), 10 deletions(-)
>
> diff -puN arch/x86/kvm/mmu.c~make_global_used_value arch/x86/kvm/mmu.c
> --- linux-2.6.git/arch/x86/kvm/mmu.c~make_global_used_value	2010-06-09 15:14:30.000000000 -0700
> +++ linux-2.6.git-dave/arch/x86/kvm/mmu.c	2010-06-09 15:14:30.000000000 -0700
> @@ -891,6 +891,19 @@ static int is_empty_shadow_page(u64 *spt
>   }
>   #endif
>
> +/*
> + * This value is the sum of all of the kvm instances's
> + * kvm->arch.n_used_mmu_pages values.  We need a global,
> + * aggregate version in order to make the slab shrinker
> + * faster
> + */
> +static unsigned int kvm_total_used_mmu_pages;
>    

The variable needs to be at the top of the file.

> +static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
> +{
> +	kvm->arch.n_used_mmu_pages += nr;
> +	kvm_total_used_mmu_pages += nr;
>    

Needs an atomic operation, since there's no global lock here.  To avoid 
bouncing this cacheline around, make the variable percpu and make 
readers take a sum across all cpus.  Side benefit is that you no longer 
need an atomic but a local_t, which is considerably cheaper.

> +}
> +
>    


-- 
error compiling committee.c: too many arguments to function

