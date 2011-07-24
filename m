Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab1GXK1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 06:27:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34366 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab1GXK1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 06:27:40 -0400
Date: Sun, 24 Jul 2011 12:27:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Hans Rosenfeld <hans.rosenfeld@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Mike Travis <travis@sgi.com>
Subject: Re: [patch 3/3] x86: cache_info: Kill the atomic allocation in
 amd_init_l3_cache()
Message-ID: <20110724102734.GA17099@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
	Hans Rosenfeld <hans.rosenfeld@amd.com>,
	Borislav Petkov <borislav.petkov@amd.com>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Mike Travis <travis@sgi.com>
References: <20110723212603.517924252@linutronix.de>
 <20110723212626.688229918@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110723212626.688229918@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 09:46:09AM -0000, Thomas Gleixner wrote:
> It's not a good reason to allocate memory in the smp function call
> just because someone thought it's the most conveniant place.
> 
> The AMD L3 data is coupled to the northbridge info by a pointer to the
> corresponding north bridge data. So allocating it with the northbridge
> data and referencing the northbridge in the cache_info code instead
> uses less memory and gets rid of that atomic allocation hack in the
> smp function call.

Nice, much better.

See for a minor nitpick below.

> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/include/asm/amd_nb.h         |    6 ++
>  arch/x86/kernel/cpu/intel_cacheinfo.c |   74 +++++++++++-----------------------
>  2 files changed, 32 insertions(+), 48 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/amd_nb.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/amd_nb.h
> +++ linux-2.6/arch/x86/include/asm/amd_nb.h
> @@ -19,9 +19,15 @@ extern int amd_numa_init(void);
>  extern int amd_get_subcaches(int);
>  extern int amd_set_subcaches(int, int);
>  
> +struct amd_l3_cache {
> +	unsigned indices;
> +	u8	 subcaches[4];
> +};
> +
>  struct amd_northbridge {
>  	struct pci_dev *misc;
>  	struct pci_dev *link;
> +	struct amd_l3_cache l3_cache;
>  };
>  
>  struct amd_northbridge_info {
> Index: linux-2.6/arch/x86/kernel/cpu/intel_cacheinfo.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
> +++ linux-2.6/arch/x86/kernel/cpu/intel_cacheinfo.c
> @@ -151,18 +151,12 @@ union _cpuid4_leaf_ecx {
>  	u32 full;
>  };
>  
> -struct amd_l3_cache {
> -	struct	 amd_northbridge *nb;
> -	unsigned indices;
> -	u8	 subcaches[4];
> -};
> -
>  struct _cpuid4_info_regs {
>  	union _cpuid4_leaf_eax eax;
>  	union _cpuid4_leaf_ebx ebx;
>  	union _cpuid4_leaf_ecx ecx;
>  	unsigned long size;
> -	struct amd_l3_cache *l3;
> +	struct amd_northbridge *nb;
>  };
>  
>  struct _cpuid4_info {
> @@ -309,12 +303,13 @@ struct _cache_attr {
>  /*
>   * L3 cache descriptors
>   */
> -static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
> +static void __cpuinit amd_calc_l3_indices(struct amd_northbridge *nb)
>  {
> +	struct amd_l3_cache *l3 = &nb->l3_cache;
>  	unsigned int sc0, sc1, sc2, sc3;
>  	u32 val = 0;
>  
> -	pci_read_config_dword(l3->nb->misc, 0x1C4, &val);
> +	pci_read_config_dword(nb->misc, 0x1C4, &val);
>  
>  	/* calculate subcache sizes */
>  	l3->subcaches[0] = sc0 = !(val & BIT(0));
> @@ -328,33 +323,16 @@ static void __cpuinit amd_calc_l3_indice
>  static void __cpuinit amd_init_l3_cache(struct _cpuid4_info_regs *this_leaf,
>  					int index)
>  {
> -	static struct amd_l3_cache *__cpuinitdata l3_caches;
>  	int node;
>  
>  	/* only for L3, and not in virtualized environments */
> -	if (index < 3 || amd_nb_num() == 0)
> +	if (index < 3)
>  		return;

AFAICT, we still need the "amd_nb_num() == 0" check for xen because it
doesn't export NB PCI devices to the guest, see f2b20e41...

>  
> -	/*
> -	 * Strictly speaking, the amount in @size below is leaked since it is
> -	 * never freed but this is done only on shutdown so it doesn't matter.
> -	 */
> -	if (!l3_caches) {
> -		int size = amd_nb_num() * sizeof(struct amd_l3_cache);
> -
> -		l3_caches = kzalloc(size, GFP_ATOMIC);
> -		if (!l3_caches)
> -			return;
> -	}
> -
>  	node = amd_get_nb_id(smp_processor_id());
> -
> -	if (!l3_caches[node].nb) {
> -		l3_caches[node].nb = node_to_amd_nb(node);
> -		amd_calc_l3_indices(&l3_caches[node]);
> -	}
> -
> -	this_leaf->l3 = &l3_caches[node];
> +	this_leaf->nb = node_to_amd_nb(node);

although, on a second thought, node_to_amd_nb(node) should return NULL
since the AMD NB caching code shouldnt've enumerated any NB devices and

> +	if (this_leaf->nb && !this_leaf->nb->l3_cache.indices)
> +		amd_calc_l3_indices(this_leaf->nb);

this check should fail. Hm.

Let me test the patchset on Monday to verify there are no other subtle
interactions I haven't thought of right now.

Thanks.

-- 
Regards/Gruss,
    Boris.
