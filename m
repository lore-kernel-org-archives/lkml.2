Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab0KPRdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:33:25 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34846 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab0KPRdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:33:24 -0500
Date: Tue, 16 Nov 2010 18:33:40 +0100
From: Borislav Petkov <bp@amd64.org>
To: hpa@zytor.com, mingo@elte.hu
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, tglx@linuxtronix.de,
        linux-kernel@vger.kernel.org, andreas.herrmann3@amd.com
Subject: Re: [PATCH 3/3] Cleanup L3 cache index disable support
Message-ID: <20101116173340.GA9417@kryptos.osrc.amd.com>
References: <1288365272-214117-1-git-send-email-hans.rosenfeld@amd.com>
 <1288365272-214117-3-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288365272-214117-3-git-send-email-hans.rosenfeld@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.

Ingo, hpa, any progress on those? Do we need to resend them against
tip/master or do you have objections?

Thanks.

On Fri, Oct 29, 2010 at 05:14:32PM +0200, Hans Rosenfeld wrote:
> Adaptions to the changes of the AMD northbridge caching code: instead of
> a bool in each l3 struct, use a flag in amd_northbridges.flags to
> indicate L3 cache index disable support; use a pointer to the whole
> northbridge instead of the misc device in the l3 struct; simplify the
> initialisation; dynamically generate sysfs attribute array.
> 
> Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
> ---
>  arch/x86/include/asm/amd_nb.h         |    1 +
>  arch/x86/kernel/amd_nb.c              |   10 ++
>  arch/x86/kernel/cpu/intel_cacheinfo.c |  147 ++++++++++++++-------------------
>  3 files changed, 74 insertions(+), 84 deletions(-)
> 
> diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
> index 4d7ec7d..6aee50d 100644
> --- a/arch/x86/include/asm/amd_nb.h
> +++ b/arch/x86/include/asm/amd_nb.h
> @@ -25,6 +25,7 @@ struct amd_northbridge_info {
>  extern struct amd_northbridge_info amd_northbridges;
>  
>  #define AMD_NB_GART			0x1
> +#define AMD_NB_L3_INDEX_DISABLE		0x2
>  
>  #ifdef CONFIG_AMD_NB
>  
> diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
> index 63c8b4f..affacb5 100644
> --- a/arch/x86/kernel/amd_nb.c
> +++ b/arch/x86/kernel/amd_nb.c
> @@ -68,6 +68,16 @@ int amd_cache_northbridges(void)
>  	    boot_cpu_data.x86 == 0x15)
>  		amd_northbridges.flags |= AMD_NB_GART;
>  
> +	/*
> +	 * Some CPU families support L3 Cache Index Disable. There are some
> +	 * limitations because of E382 and E388 on family 0x10.
> +	 */
> +	if (boot_cpu_data.x86 == 0x10 &&
> +	    boot_cpu_data.x86_model >= 0x8 &&
> +	    (boot_cpu_data.x86_model > 0x9 ||
> +	     boot_cpu_data.x86_mask >= 0x1))
> +		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(amd_cache_northbridges);
> diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
> index 6b8ea74..9ecf81f 100644
> --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> @@ -149,8 +149,7 @@ union _cpuid4_leaf_ecx {
>  };
>  
>  struct amd_l3_cache {
> -	struct	 pci_dev *dev;
> -	bool	 can_disable;
> +	struct	 amd_northbridge *nb;
>  	unsigned indices;
>  	u8	 subcaches[4];
>  };
> @@ -311,14 +310,12 @@ struct _cache_attr {
>  /*
>   * L3 cache descriptors
>   */
> -static struct amd_l3_cache **__cpuinitdata l3_caches;
> -
>  static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
>  {
>  	unsigned int sc0, sc1, sc2, sc3;
>  	u32 val = 0;
>  
> -	pci_read_config_dword(l3->dev, 0x1C4, &val);
> +	pci_read_config_dword(l3->nb->misc, 0x1C4, &val);
>  
>  	/* calculate subcache sizes */
>  	l3->subcaches[0] = sc0 = !(val & BIT(0));
> @@ -330,47 +327,14 @@ static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
>  	l3->indices = (max(max3(sc0, sc1, sc2), sc3) << 10) - 1;
>  }
>  
> -static struct amd_l3_cache * __cpuinit amd_init_l3_cache(int node)
> -{
> -	struct amd_l3_cache *l3;
> -	struct pci_dev *dev = node_to_amd_nb(node)->misc;
> -
> -	l3 = kzalloc(sizeof(struct amd_l3_cache), GFP_ATOMIC);
> -	if (!l3) {
> -		printk(KERN_WARNING "Error allocating L3 struct\n");
> -		return NULL;
> -	}
> -
> -	l3->dev = dev;
> -
> -	amd_calc_l3_indices(l3);
> -
> -	return l3;
> -}
> -
> -static void __cpuinit amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf,
> -					   int index)
> +static void __cpuinit amd_init_l3_cache(struct _cpuid4_info_regs *this_leaf,
> +					int index)
>  {
> +	static struct amd_l3_cache *__cpuinitdata l3_caches;
>  	int node;
>  
> -	if (boot_cpu_data.x86 != 0x10)
> -		return;
> -
> -	if (index < 3)
> -		return;
> -
> -	/* see errata #382 and #388 */
> -	if (boot_cpu_data.x86_model < 0x8)
> -		return;
> -
> -	if ((boot_cpu_data.x86_model == 0x8 ||
> -	     boot_cpu_data.x86_model == 0x9)
> -		&&
> -	     boot_cpu_data.x86_mask < 0x1)
> -			return;
> -
> -	/* not in virtualized environments */
> -	if (amd_nb_num() == 0)
> +	/* only for L3, and not in virtualized environments */
> +	if (index < 3 || amd_nb_num() == 0)
>  		return;
>  
>  	/*
> @@ -378,7 +342,7 @@ static void __cpuinit amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf,
>  	 * never freed but this is done only on shutdown so it doesn't matter.
>  	 */
>  	if (!l3_caches) {
> -		int size = amd_nb_num() * sizeof(struct amd_l3_cache *);
> +		int size = amd_nb_num() * sizeof(struct amd_l3_cache);
>  
>  		l3_caches = kzalloc(size, GFP_ATOMIC);
>  		if (!l3_caches)
> @@ -387,14 +351,12 @@ static void __cpuinit amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf,
>  
>  	node = amd_get_nb_id(smp_processor_id());
>  
> -	if (!l3_caches[node]) {
> -		l3_caches[node] = amd_init_l3_cache(node);
> -		l3_caches[node]->can_disable = true;
> +	if (!l3_caches[node].nb) {
> +		l3_caches[node].nb = node_to_amd_nb(node);
> +		amd_calc_l3_indices(&l3_caches[node]);
>  	}
>  
> -	WARN_ON(!l3_caches[node]);
> -
> -	this_leaf->l3 = l3_caches[node];
> +	this_leaf->l3 = &l3_caches[node];
>  }
>  
>  /*
> @@ -408,7 +370,7 @@ int amd_get_l3_disable_slot(struct amd_l3_cache *l3, unsigned slot)
>  {
>  	unsigned int reg = 0;
>  
> -	pci_read_config_dword(l3->dev, 0x1BC + slot * 4, &reg);
> +	pci_read_config_dword(l3->nb->misc, 0x1BC + slot * 4, &reg);
>  
>  	/* check whether this slot is activated already */
>  	if (reg & (3UL << 30))
> @@ -422,7 +384,8 @@ static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
>  {
>  	int index;
>  
> -	if (!this_leaf->l3 || !this_leaf->l3->can_disable)
> +	if (!this_leaf->l3 ||
> +	    !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
>  		return -EINVAL;
>  
>  	index = amd_get_l3_disable_slot(this_leaf->l3, slot);
> @@ -457,7 +420,7 @@ static void amd_l3_disable_index(struct amd_l3_cache *l3, int cpu,
>  		if (!l3->subcaches[i])
>  			continue;
>  
> -		pci_write_config_dword(l3->dev, 0x1BC + slot * 4, reg);
> +		pci_write_config_dword(l3->nb->misc, 0x1BC + slot * 4, reg);
>  
>  		/*
>  		 * We need to WBINVD on a core on the node containing the L3
> @@ -467,7 +430,7 @@ static void amd_l3_disable_index(struct amd_l3_cache *l3, int cpu,
>  		wbinvd_on_cpu(cpu);
>  
>  		reg |= BIT(31);
> -		pci_write_config_dword(l3->dev, 0x1BC + slot * 4, reg);
> +		pci_write_config_dword(l3->nb->misc, 0x1BC + slot * 4, reg);
>  	}
>  }
>  
> @@ -524,7 +487,8 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  
> -	if (!this_leaf->l3 || !this_leaf->l3->can_disable)
> +	if (!this_leaf->l3 ||
> +	    !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
>  		return -EINVAL;
>  
>  	cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
> @@ -545,7 +509,7 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
>  #define STORE_CACHE_DISABLE(slot)					\
>  static ssize_t								\
>  store_cache_disable_##slot(struct _cpuid4_info *this_leaf,		\
> -			    const char *buf, size_t count)		\
> +			   const char *buf, size_t count)		\
>  {									\
>  	return store_cache_disable(this_leaf, buf, count, slot);	\
>  }
> @@ -558,10 +522,7 @@ static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
>  		show_cache_disable_1, store_cache_disable_1);
>  
>  #else	/* CONFIG_AMD_NB */
> -static void __cpuinit
> -amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf, int index)
> -{
> -};
> +#define amd_init_l3_cache(x, y)
>  #endif /* CONFIG_AMD_NB */
>  
>  static int
> @@ -575,7 +536,7 @@ __cpuinit cpuid4_cache_lookup_regs(int index,
>  
>  	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
>  		amd_cpuid4(index, &eax, &ebx, &ecx);
> -		amd_check_l3_disable(this_leaf, index);
> +		amd_init_l3_cache(this_leaf, index);
>  	} else {
>  		cpuid_count(4, index, &eax.full, &ebx.full, &ecx.full, &edx);
>  	}
> @@ -983,30 +944,48 @@ define_one_ro(size);
>  define_one_ro(shared_cpu_map);
>  define_one_ro(shared_cpu_list);
>  
> -#define DEFAULT_SYSFS_CACHE_ATTRS	\
> -	&type.attr,			\
> -	&level.attr,			\
> -	&coherency_line_size.attr,	\
> -	&physical_line_partition.attr,	\
> -	&ways_of_associativity.attr,	\
> -	&number_of_sets.attr,		\
> -	&size.attr,			\
> -	&shared_cpu_map.attr,		\
> -	&shared_cpu_list.attr
> -
>  static struct attribute *default_attrs[] = {
> -	DEFAULT_SYSFS_CACHE_ATTRS,
> +	&type.attr,
> +	&level.attr,
> +	&coherency_line_size.attr,
> +	&physical_line_partition.attr,
> +	&ways_of_associativity.attr,
> +	&number_of_sets.attr,
> +	&size.attr,
> +	&shared_cpu_map.attr,
> +	&shared_cpu_list.attr,
>  	NULL
>  };
>  
> -static struct attribute *default_l3_attrs[] = {
> -	DEFAULT_SYSFS_CACHE_ATTRS,
>  #ifdef CONFIG_AMD_NB
> -	&cache_disable_0.attr,
> -	&cache_disable_1.attr,
> +static struct attribute ** __cpuinit amd_l3_attrs(void)
> +{
> +	static struct attribute **attrs;
> +	int n;
> +
> +	if (attrs)
> +		return attrs;
> +
> +	n = sizeof (default_attrs) / sizeof (struct attribute *);
> +
> +	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
> +		n += 2;
> +
> +	attrs = kzalloc(n * sizeof (struct attribute *), GFP_KERNEL);
> +	if (attrs == NULL)
> +		return attrs = default_attrs;
> +
> +	for (n = 0; default_attrs[n]; n++)
> +		attrs[n] = default_attrs[n];
> +
> +	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE)) {
> +		attrs[n++] = &cache_disable_0.attr;
> +		attrs[n++] = &cache_disable_1.attr;
> +	}
> +
> +	return attrs;
> +}
>  #endif
> -	NULL
> -};
>  
>  static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
>  {
> @@ -1117,11 +1096,11 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
>  
>  		this_leaf = CPUID4_INFO_IDX(cpu, i);
>  
> -		if (this_leaf->l3 && this_leaf->l3->can_disable)
> -			ktype_cache.default_attrs = default_l3_attrs;
> -		else
> -			ktype_cache.default_attrs = default_attrs;
> -
> +		ktype_cache.default_attrs = default_attrs;
> +#ifdef CONFIG_AMD_NB
> +		if (this_leaf->l3)
> +			ktype_cache.default_attrs = amd_l3_attrs();
> +#endif
>  		retval = kobject_init_and_add(&(this_object->kobj),
>  					      &ktype_cache,
>  					      per_cpu(ici_cache_kobject, cpu),
> -- 
> 1.5.6.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
