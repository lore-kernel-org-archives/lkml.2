Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab2BMKmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 05:42:55 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33009 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2BMKmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 05:42:54 -0500
Message-ID: <4F38E8E1.3070004@mvista.com>
Date: Mon, 13 Feb 2012 14:41:37 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        microblaze-uclinux@itee.uq.edu.au, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-ia64@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@linux-mips.org,
        discuss@x86-64.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Jonathan Corbet <corbet@lwn.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: Re: [PATCH 03/14 v2] MIPS: adapt for dma_map_ops changes
References: <1324643253-3024-4-git-send-email-m.szyprowski@samsung.com> <1329129329-25205-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1329129329-25205-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 13-02-2012 14:35, Marek Szyprowski wrote:

> From: Andrzej Pietrasiewicz<andrzej.p@samsung.com>

> Adapt core MIPS architecture code for dma_map_ops changes: replace
> alloc/free_coherent with generic alloc/free methods.

> Signed-off-by: Andrzej Pietrasiewicz<andrzej.p@samsung.com>
> [added missing changes to arch/mips/cavium-octeon/dma-octeon.c]
> Signed-off-by: Marek Szyprowski<m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
[...]

> diff --git a/arch/mips/include/asm/dma-mapping.h b/arch/mips/include/asm/dma-mapping.h
> index 7aa37dd..cbd41f5 100644
> --- a/arch/mips/include/asm/dma-mapping.h
> +++ b/arch/mips/include/asm/dma-mapping.h
> @@ -57,25 +57,31 @@ dma_set_mask(struct device *dev, u64 mask)
>   extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
>   	       enum dma_data_direction direction);
>
> -static inline void *dma_alloc_coherent(struct device *dev, size_t size,
> -				       dma_addr_t *dma_handle, gfp_t gfp)
> +#define dma_alloc_coherent(d,s,h,f)	dma_alloc_attrs(d,s,h,f,NULL)
> +
> +static inline void *dma_alloc_attrs(struct device *dev, size_t size,
> +				    dma_addr_t *dma_handle, gfp_t gfp,
> +				    struct dma_attrs *attrs)
>   {
>   	void *ret;
>   	struct dma_map_ops *ops = get_dma_ops(dev);
>
> -	ret = ops->alloc_coherent(dev, size, dma_handle, gfp);
> +	ret = ops->alloc(dev, size, dma_handle, gfp, NULL);

    Not 'attrs' instead of NULL?

>
>   	debug_dma_alloc_coherent(dev, size, *dma_handle, ret);
>
>   	return ret;
>   }
>
> -static inline void dma_free_coherent(struct device *dev, size_t size,
> -				     void *vaddr, dma_addr_t dma_handle)
> +#define dma_free_coherent(d,s,c,h) dma_free_attrs(d,s,c,h,NULL)
> +
> +static inline void dma_free_attrs(struct device *dev, size_t size,
> +				  void *vaddr, dma_addr_t dma_handle,
> +				  struct dma_attrs *attrs)
>   {
>   	struct dma_map_ops *ops = get_dma_ops(dev);
>
> -	ops->free_coherent(dev, size, vaddr, dma_handle);
> +	ops->free(dev, size, vaddr, dma_handle, NULL);

    Same here...

WBR, Sergei
