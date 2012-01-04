Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab2ADSoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:44:19 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:32737 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab2ADSoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:44:16 -0500
MIME-Version: 1.0
Message-ID: <1831a06a-ee73-4af9-8cf5-75662c3ce597@default>
Date: Wed, 4 Jan 2012 10:43:59 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Dave Hansen <dave@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>
Subject: RE: [PATCHv2] staging: zcache: crypto API support
References: <<1325629894-10967-1-git-send-email-sjenning@linux.vnet.ibm.com>>
In-Reply-To: <<1325629894-10967-1-git-send-email-sjenning@linux.vnet.ibm.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F049DF8.0018,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Sent: Tuesday, January 03, 2012 3:32 PM
> To: Greg Kroah-Hartman
> Cc: Seth Jennings; Dan Magenheimer; Nitin Gupta; Dave Hansen; devel@driverdev.osuosl.org; linux-
> kernel@vger.kernel.org; Thadeu Lima de Souza Cascardo; Brian King; Robert Jennings
> Subject: [PATCHv2] staging: zcache: crypto API support
> 
> This patch allow zcache to use the crypto API for page compression.
> It replaces the direct LZO compress/decompress calls with calls
> into the crypto compression API. The compressor to be used is
> specified in the kernel boot line with the zcache parameter like:
> zcache=lzo or zcache=deflate.  If the specified compressor can't
> be loaded, zcache uses lzo as the default compressor.
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>

> ---
>  drivers/staging/zcache/Kconfig       |    7 +-
>  drivers/staging/zcache/zcache-main.c |  150 ++++++++++++++++++++++++++++------
>  2 files changed, 126 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
> index 7fabcb2..1b7bba7 100644
> --- a/drivers/staging/zcache/Kconfig
> +++ b/drivers/staging/zcache/Kconfig
> @@ -1,13 +1,12 @@
>  config ZCACHE
>  	tristate "Dynamic compression of swap pages and clean pagecache pages"
> -	depends on CLEANCACHE || FRONTSWAP
> +	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO
>  	select XVMALLOC
> -	select LZO_COMPRESS
> -	select LZO_DECOMPRESS
> +	select CRYPTO_LZO
>  	default n
>  	help
>  	  Zcache doubles RAM efficiency while providing a significant
> -	  performance boosts on many workloads.  Zcache uses lzo1x
> +	  performance boosts on many workloads.  Zcache uses
>  	  compression and an in-kernel implementation of transcendent
>  	  memory to store clean page cache pages and swap in RAM,
>  	  providing a noticeable reduction in disk I/O.
> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> index 56c1f9c..a4384eb 100644
> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c
> @@ -6,7 +6,8 @@
>   *
>   * Zcache provides an in-kernel "host implementation" for transcendent memory
>   * and, thus indirectly, for cleancache and frontswap.  Zcache includes two
> - * page-accessible memory [1] interfaces, both utilizing lzo1x compression:
> + * page-accessible memory [1] interfaces, both utilizing the crypto compression
> + * API:
>   * 1) "compression buddies" ("zbud") is used for ephemeral pages
>   * 2) xvmalloc is used for persistent pages.
>   * Xvmalloc (based on the TLSF allocator) has very low fragmentation
> @@ -23,12 +24,13 @@
>  #include <linux/cpu.h>
>  #include <linux/highmem.h>
>  #include <linux/list.h>
> -#include <linux/lzo.h>
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include <linux/types.h>
>  #include <linux/atomic.h>
>  #include <linux/math64.h>
> +#include <linux/crypto.h>
> +#include <linux/string.h>
>  #include "tmem.h"
> 
>  #include "../zram/xvmalloc.h" /* if built in drivers/staging */
> @@ -81,6 +83,38 @@ static inline bool is_local_client(struct zcache_client *cli)
>  	return cli == &zcache_host;
>  }
> 
> +/* crypto API for zcache  */
> +#define ZCACHE_COMP_NAME_SZ CRYPTO_MAX_ALG_NAME
> +static char zcache_comp_name[ZCACHE_COMP_NAME_SZ];
> +static struct crypto_comp * __percpu *zcache_comp_pcpu_tfms;
> +
> +enum comp_op {
> +	ZCACHE_COMPOP_COMPRESS,
> +	ZCACHE_COMPOP_DECOMPRESS
> +};
> +
> +static inline int zcache_comp_op(enum comp_op op,
> +				const u8 *src, unsigned int slen,
> +				u8 *dst, unsigned int *dlen)
> +{
> +	struct crypto_comp *tfm;
> +	int ret;
> +
> +	BUG_ON(!zcache_comp_pcpu_tfms);
> +	tfm = *per_cpu_ptr(zcache_comp_pcpu_tfms, get_cpu());
> +	BUG_ON(!tfm);
> +	switch (op) {
> +	case ZCACHE_COMPOP_COMPRESS:
> +		ret = crypto_comp_compress(tfm, src, slen, dst, dlen);
> +		break;
> +	case ZCACHE_COMPOP_DECOMPRESS:
> +		ret = crypto_comp_decompress(tfm, src, slen, dst, dlen);
> +		break;
> +	}
> +	put_cpu();
> +	return ret;
> +}
> +
>  /**********
>   * Compression buddies ("zbud") provides for packing two (or, possibly
>   * in the future, more) compressed ephemeral pages into a single "raw"
> @@ -408,7 +442,7 @@ static int zbud_decompress(struct page *page, struct zbud_hdr *zh)
>  {
>  	struct zbud_page *zbpg;
>  	unsigned budnum = zbud_budnum(zh);
> -	size_t out_len = PAGE_SIZE;
> +	unsigned int out_len = PAGE_SIZE;
>  	char *to_va, *from_va;
>  	unsigned size;
>  	int ret = 0;
> @@ -425,8 +459,9 @@ static int zbud_decompress(struct page *page, struct zbud_hdr *zh)
>  	to_va = kmap_atomic(page, KM_USER0);
>  	size = zh->size;
>  	from_va = zbud_data(zh, size);
> -	ret = lzo1x_decompress_safe(from_va, size, to_va, &out_len);
> -	BUG_ON(ret != LZO_E_OK);
> +	ret = zcache_comp_op(ZCACHE_COMPOP_DECOMPRESS, from_va, size,
> +				to_va, &out_len);
> +	BUG_ON(ret);
>  	BUG_ON(out_len != PAGE_SIZE);
>  	kunmap_atomic(to_va, KM_USER0);
>  out:
> @@ -624,7 +659,7 @@ static int zbud_show_cumul_chunk_counts(char *buf)
> 
>  /**********
>   * This "zv" PAM implementation combines the TLSF-based xvMalloc
> - * with lzo1x compression to maximize the amount of data that can
> + * with the crypto compression API to maximize the amount of data that can
>   * be packed into a physical page.
>   *
>   * Zv represents a PAM page with the index and object (plus a "size" value
> @@ -711,7 +746,7 @@ static void zv_free(struct xv_pool *xvpool, struct zv_hdr *zv)
> 
>  static void zv_decompress(struct page *page, struct zv_hdr *zv)
>  {
> -	size_t clen = PAGE_SIZE;
> +	unsigned int clen = PAGE_SIZE;
>  	char *to_va;
>  	unsigned size;
>  	int ret;
> @@ -720,10 +755,10 @@ static void zv_decompress(struct page *page, struct zv_hdr *zv)
>  	size = xv_get_object_size(zv) - sizeof(*zv);
>  	BUG_ON(size == 0);
>  	to_va = kmap_atomic(page, KM_USER0);
> -	ret = lzo1x_decompress_safe((char *)zv + sizeof(*zv),
> -					size, to_va, &clen);
> +	ret = zcache_comp_op(ZCACHE_COMPOP_DECOMPRESS, (char *)zv + sizeof(*zv),
> +				size, to_va, &clen);
>  	kunmap_atomic(to_va, KM_USER0);
> -	BUG_ON(ret != LZO_E_OK);
> +	BUG_ON(ret);
>  	BUG_ON(clen != PAGE_SIZE);
>  }
> 
> @@ -1286,25 +1321,24 @@ static struct tmem_pamops zcache_pamops = {
>   * zcache compression/decompression and related per-cpu stuff
>   */
> 
> -#define LZO_WORKMEM_BYTES LZO1X_1_MEM_COMPRESS
> -#define LZO_DSTMEM_PAGE_ORDER 1
> -static DEFINE_PER_CPU(unsigned char *, zcache_workmem);
>  static DEFINE_PER_CPU(unsigned char *, zcache_dstmem);
> +#define ZCACHE_DSTMEM_ORDER 1
> 
>  static int zcache_compress(struct page *from, void **out_va, size_t *out_len)
>  {
>  	int ret = 0;
>  	unsigned char *dmem = __get_cpu_var(zcache_dstmem);
> -	unsigned char *wmem = __get_cpu_var(zcache_workmem);
>  	char *from_va;
> 
>  	BUG_ON(!irqs_disabled());
> -	if (unlikely(dmem == NULL || wmem == NULL))
> -		goto out;  /* no buffer, so can't compress */
> +	if (unlikely(dmem == NULL))
> +		goto out;  /* no buffer or no compressor so can't compress */
> +	*out_len = PAGE_SIZE << ZCACHE_DSTMEM_ORDER;
>  	from_va = kmap_atomic(from, KM_USER0);
>  	mb();
> -	ret = lzo1x_1_compress(from_va, PAGE_SIZE, dmem, out_len, wmem);
> -	BUG_ON(ret != LZO_E_OK);
> +	ret = zcache_comp_op(ZCACHE_COMPOP_COMPRESS, from_va, PAGE_SIZE, dmem,
> +				(unsigned int *)out_len);
> +	BUG_ON(ret);
>  	*out_va = dmem;
>  	kunmap_atomic(from_va, KM_USER0);
>  	ret = 1;
> @@ -1312,29 +1346,48 @@ out:
>  	return ret;
>  }
> 
> +static int zcache_comp_cpu_up(int cpu)
> +{
> +	struct crypto_comp *tfm;
> +
> +	tfm = crypto_alloc_comp(zcache_comp_name, 0, 0);
> +	if (IS_ERR(tfm))
> +		return NOTIFY_BAD;
> +	*per_cpu_ptr(zcache_comp_pcpu_tfms, cpu) = tfm;
> +	return NOTIFY_OK;
> +}
> +
> +static void zcache_comp_cpu_down(int cpu)
> +{
> +	struct crypto_comp *tfm;
> +
> +	tfm = *per_cpu_ptr(zcache_comp_pcpu_tfms, cpu);
> +	crypto_free_comp(tfm);
> +	*per_cpu_ptr(zcache_comp_pcpu_tfms, cpu) = NULL;
> +}
> 
>  static int zcache_cpu_notifier(struct notifier_block *nb,
>  				unsigned long action, void *pcpu)
>  {
> -	int cpu = (long)pcpu;
> +	int ret, cpu = (long)pcpu;
>  	struct zcache_preload *kp;
> 
>  	switch (action) {
>  	case CPU_UP_PREPARE:
> +		ret = zcache_comp_cpu_up(cpu);
> +		if (ret != NOTIFY_OK) {
> +			pr_err("zcache: can't allocate compressor transform\n");
> +			return ret;
> +		}
>  		per_cpu(zcache_dstmem, cpu) = (void *)__get_free_pages(
> -			GFP_KERNEL | __GFP_REPEAT,
> -			LZO_DSTMEM_PAGE_ORDER),
> -		per_cpu(zcache_workmem, cpu) =
> -			kzalloc(LZO1X_MEM_COMPRESS,
> -				GFP_KERNEL | __GFP_REPEAT);
> +			GFP_KERNEL | __GFP_REPEAT, ZCACHE_DSTMEM_ORDER);
>  		break;
>  	case CPU_DEAD:
>  	case CPU_UP_CANCELED:
> +		zcache_comp_cpu_down(cpu);
>  		free_pages((unsigned long)per_cpu(zcache_dstmem, cpu),
> -				LZO_DSTMEM_PAGE_ORDER);
> +			ZCACHE_DSTMEM_ORDER);
>  		per_cpu(zcache_dstmem, cpu) = NULL;
> -		kfree(per_cpu(zcache_workmem, cpu));
> -		per_cpu(zcache_workmem, cpu) = NULL;
>  		kp = &per_cpu(zcache_preloads, cpu);
>  		while (kp->nr) {
>  			kmem_cache_free(zcache_objnode_cache,
> @@ -1919,6 +1972,44 @@ static int __init no_frontswap(char *s)
> 
>  __setup("nofrontswap", no_frontswap);
> 
> +static int __init enable_zcache_compressor(char *s)
> +{
> +	strncpy(zcache_comp_name, s, ZCACHE_COMP_NAME_SZ);
> +	zcache_enabled = 1;
> +	return 1;
> +}
> +__setup("zcache=", enable_zcache_compressor);
> +
> +
> +static int zcache_comp_init(void)
> +{
> +	int ret = 0;
> +
> +	/* check crypto algorithm */
> +	if (*zcache_comp_name != '\0') {
> +		ret = crypto_has_comp(zcache_comp_name, 0, 0);
> +		if (!ret)
> +			pr_info("zcache: %s not supported\n",
> +					zcache_comp_name);
> +	}
> +	if (!ret)
> +		strcpy(zcache_comp_name, "lzo");
> +	ret = crypto_has_comp(zcache_comp_name, 0, 0);
> +	if (!ret) {
> +		ret = 1;
> +		goto out;
> +	}
> +	pr_info("zcache: using %s compressor\n", zcache_comp_name);
> +
> +	/* alloc percpu transforms */
> +	ret = 0;
> +	zcache_comp_pcpu_tfms = alloc_percpu(struct crypto_comp *);
> +	if (!zcache_comp_pcpu_tfms)
> +		ret = 1;
> +out:
> +	return ret;
> +}
> +
>  static int __init zcache_init(void)
>  {
>  	int ret = 0;
> @@ -1941,6 +2032,11 @@ static int __init zcache_init(void)
>  			pr_err("zcache: can't register cpu notifier\n");
>  			goto out;
>  		}
> +		ret = zcache_comp_init();
> +		if (ret) {
> +			pr_err("zcache: compressor initialization failed\n");
> +			goto out;
> +		}
>  		for_each_online_cpu(cpu) {
>  			void *pcpu = (void *)(long)cpu;
>  			zcache_cpu_notifier(&zcache_cpu_notifier_block,
> --
> 1.7.5.4
