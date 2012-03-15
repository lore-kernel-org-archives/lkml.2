Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161116Ab2COQ6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:58:11 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:35860 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161055Ab2COQ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:58:04 -0400
Date: Thu, 15 Mar 2012 12:54:00 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Akshay Karle <akshay.a.karle@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        kvm@vger.kernel.org, ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Subject: Re: [RFC 1/2] kvm: host-side changes for tmem on KVM
Message-ID: <20120315165400.GL30250@phenom.dumpdata.com>
References: <1331225648.2585.27.camel@aks>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331225648.2585.27.camel@aks>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F621F9A.0113,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 10:24:08PM +0530, Akshay Karle wrote:
> From: Akshay Karle <akshay.a.karle@gmail.com>
> Subject: [RFC 1/2] kvm: host-side changes for tmem on KVM
> 
> Working at host:
> Once the guest exits to the kvm host, the host determines that the guest exited
> to perform some tmem operation(done at kvm_emulate_hypercall)and then
> we use zcache to implement this required operations(performed by kvm_pv_tmem_op).

Do you need any modifications to the Kconfig file to reflect the KVM dependency?

> 
> ---
> Diffstat for host patch:
>  arch/x86/include/asm/kvm_host.h      |    1 
>  arch/x86/kvm/x86.c                   |    4 +
>  drivers/staging/zcache/zcache-main.c |   98 ++++++++++++++++++++++++++++++++---
>  3 files changed, 95 insertions(+), 8 deletions(-)
> 
> diff -Napur vanilla/linux-3.1.5/arch/x86/include/asm/kvm_host.h linux-3.1.5//arch/x86/include/asm/kvm_host.h
> --- vanilla/linux-3.1.5/arch/x86/include/asm/kvm_host.h	2011-12-09 22:27:05.000000000 +0530
> +++ linux-3.1.5//arch/x86/include/asm/kvm_host.h	2012-03-05 14:09:41.648006153 +0530
> @@ -668,6 +668,7 @@ int emulator_write_phys(struct kvm_vcpu
>  			  const void *val, int bytes);
>  int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
>  		  gpa_t addr, unsigned long *ret);
> +int kvm_pv_tmem_op(struct kvm_vcpu *vcpu, gpa_t addr, unsigned long *ret);
>  u8 kvm_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn);
>  
>  extern bool tdp_enabled;
> diff -Napur vanilla/linux-3.1.5/arch/x86/kvm/x86.c linux-3.1.5//arch/x86/kvm/x86.c
> --- vanilla/linux-3.1.5/arch/x86/kvm/x86.c	2011-12-09 22:27:05.000000000 +0530
> +++ linux-3.1.5//arch/x86/kvm/x86.c	2012-03-05 14:09:41.652006083 +0530
> @@ -5267,6 +5267,10 @@ int kvm_emulate_hypercall(struct kvm_vcp
>  	case KVM_HC_MMU_OP:
>  		r = kvm_pv_mmu_op(vcpu, a0, hc_gpa(vcpu, a1, a2), &ret);
>  		break;
> +	case KVM_HC_TMEM:
> +		r = kvm_pv_tmem_op(vcpu, a0, &ret);
> +		ret = ret - 1000;

That is rather odd. Why the subtraction of 1000?

> +		break;
>  	default:
>  		ret = -KVM_ENOSYS;
>  		break;
> diff -Napur vanilla/linux-3.1.5/drivers/staging/zcache/zcache-main.c linux-3.1.5//drivers/staging/zcache/zcache-main.c
> --- vanilla/linux-3.1.5/drivers/staging/zcache/zcache-main.c	2011-12-09 22:27:05.000000000 +0530
> +++ linux-3.1.5//drivers/staging/zcache/zcache-main.c	2012-03-05 14:10:31.264006031 +0530
> @@ -30,6 +30,7 @@
>  #include <linux/atomic.h>
>  #include <linux/math64.h>
>  #include "tmem.h"
> +#include "kvm-tmem.h"
>  
>  #include "../zram/xvmalloc.h" /* if built in drivers/staging */
>  
> @@ -669,7 +670,6 @@ static struct zv_hdr *zv_create(struct x
>  	int chunks = (alloc_size + (CHUNK_SIZE - 1)) >> CHUNK_SHIFT;
>  	int ret;
>  
> -	BUG_ON(!irqs_disabled());

Can you explain why?

>  	BUG_ON(chunks >= NCHUNKS);
>  	ret = xv_malloc(xvpool, alloc_size,
>  			&page, &offset, ZCACHE_GFP_MASK);
> @@ -1313,7 +1313,6 @@ static int zcache_compress(struct page *
>  	unsigned char *wmem = __get_cpu_var(zcache_workmem);
>  	char *from_va;
>  
> -	BUG_ON(!irqs_disabled());
>  	if (unlikely(dmem == NULL || wmem == NULL))
>  		goto out;  /* no buffer, so can't compress */
>  	from_va = kmap_atomic(from, KM_USER0);
> @@ -1533,7 +1532,6 @@ static int zcache_put_page(int cli_id, i
>  	struct tmem_pool *pool;
>  	int ret = -1;
>  
> -	BUG_ON(!irqs_disabled());
>  	pool = zcache_get_pool_by_id(cli_id, pool_id);
>  	if (unlikely(pool == NULL))
>  		goto out;
> @@ -1898,6 +1896,67 @@ struct frontswap_ops zcache_frontswap_re
>  #endif
>  
>  /*
> + * tmem op to support tmem in kvm guests
> + */
> +
> +int kvm_pv_tmem_op(struct kvm_vcpu *vcpu, gpa_t addr, unsigned long *ret)
> +{
> +	struct tmem_ops op;
> +	struct tmem_oid oid;
> +	uint64_t pfn;
> +	struct page *page;
> +	int r;
> +
> +	r = kvm_read_guest(vcpu->kvm, addr, &op, sizeof(op));
> +	if (r < 0)
> +		return r;
> +
> +	switch (op.cmd) {
> +	case TMEM_NEW_POOL:
> +		*ret = zcache_new_pool(op.u.new.cli_id, op.u.new.flags);
> +		break;
> +	case TMEM_DESTROY_POOL:
> +		*ret = zcache_destroy_pool(op.u.gen.cli_id, op.pool_id);
> +		break;
> +	case TMEM_NEW_PAGE:
> +		break;
> +	case TMEM_PUT_PAGE:
> +		pfn = gfn_to_pfn(vcpu->kvm, op.u.gen.pfn);
> +		page = pfn_to_page(pfn);
> +		oid.oid[0] = op.u.gen.oid[0];
> +		oid.oid[1] = op.u.gen.oid[1];
> +		oid.oid[2] = op.u.gen.oid[2];
> +		VM_BUG_ON(!PageLocked(page));
> +		*ret = zcache_put_page(op.u.gen.cli_id, op.pool_id,
> +				&oid, op.u.gen.index, page);
> +		break;
> +	case TMEM_GET_PAGE:
> +		pfn = gfn_to_pfn(vcpu->kvm, op.u.gen.pfn);
> +		page = pfn_to_page(pfn);
> +		oid.oid[0] = op.u.gen.oid[0];
> +		oid.oid[1] = op.u.gen.oid[1];
> +		oid.oid[2] = op.u.gen.oid[2];
> +		*ret = zcache_get_page(TMEM_CLI, op.pool_id,
> +				&oid, op.u.gen.index, page);
> +		break;
> +	case TMEM_FLUSH_PAGE:
> +		oid.oid[0] = op.u.gen.oid[0];
> +		oid.oid[1] = op.u.gen.oid[1];
> +		oid.oid[2] = op.u.gen.oid[2];
> +		*ret = zcache_flush_page(op.u.gen.cli_id, op.pool_id,
> +				&oid, op.u.gen.index);
> +		break;
> +	case TMEM_FLUSH_OBJECT:
> +		oid.oid[0] = op.u.gen.oid[0];
> +		oid.oid[1] = op.u.gen.oid[1];
> +		oid.oid[2] = op.u.gen.oid[2];
> +		*ret = zcache_flush_object(op.u.gen.cli_id, op.pool_id, &oid);
> +		break;
> +	}
> +	return 0;
> +}
> +
> +/*
>   * zcache initialization
>   * NOTE FOR NOW zcache MUST BE PROVIDED AS A KERNEL BOOT PARAMETER OR
>   * NOTHING HAPPENS!
> @@ -1934,10 +1993,19 @@ static int __init no_frontswap(char *s)
>  
>  __setup("nofrontswap", no_frontswap);
>  
> +static int kvm_tmem_enabled = 0;

No need to declare it zero. Don't we want to have it running by default?
So the function below would be 'disable_kvm' instead of enabling it?

> +
> +static int __init enable_kvm_tmem(char *s)
> +{
> +	kvm_tmem_enabled = 1;
> +	return 1;
> +}
> +
> +__setup("kvmtmem", enable_kvm_tmem);
> +
>  static int __init zcache_init(void)
>  {
>  	int ret = 0;
> -
>  #ifdef CONFIG_SYSFS
>  	ret = sysfs_create_group(mm_kobj, &zcache_attr_group);
>  	if (ret) {
> @@ -1946,7 +2014,7 @@ static int __init zcache_init(void)
>  	}
>  #endif /* CONFIG_SYSFS */
>  #if defined(CONFIG_CLEANCACHE) || defined(CONFIG_FRONTSWAP)
> -	if (zcache_enabled) {
> +	if (zcache_enabled || kvm_tmem_enabled) {
>  		unsigned int cpu;
>  
>  		tmem_register_hostops(&zcache_hostops);
> @@ -1966,11 +2034,25 @@ static int __init zcache_init(void)
>  				sizeof(struct tmem_objnode), 0, 0, NULL);
>  	zcache_obj_cache = kmem_cache_create("zcache_obj",
>  				sizeof(struct tmem_obj), 0, 0, NULL);
> -	ret = zcache_new_client(LOCAL_CLIENT);
> -	if (ret) {
> -		pr_err("zcache: can't create client\n");
> +	if(kvm_tmem_enabled) {

Space..
> +		ret = zcache_new_client(TMEM_CLI);
> +		if(ret) {
> +			pr_err("zcache: can't create client\n");
> +			goto out;
> +		}
> +		zbud_init();
> +		register_shrinker(&zcache_shrinker);
> +		pr_info("zcache: transcendent memory enabled using kernel "
> +			"for kvm guests\n");
>  		goto out;
>  	}
> +	else {
> +		ret = zcache_new_client(LOCAL_CLIENT);
> +		if (ret) {
> +			pr_err("zcache: can't create client\n");
> +			goto out;
> +		}
> +	}
>  #endif
>  #ifdef CONFIG_CLEANCACHE
>  	if (zcache_enabled && use_cleancache) {
> 
