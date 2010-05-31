Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0EaQir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 12:38:47 -0400
Received: from smtp.nokia.com ([192.100.105.134]:44885 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab0EaQiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 12:38:46 -0400
Date: Mon, 31 May 2010 19:41:21 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: "Doyu Hiroshi (Nokia-D/Helsinki)" <hiroshi.doyu@nokia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "catalin.marinas@arm.com" <catalin.marinas@arm.com>
Subject: Re: [PATCH 1/2] kmemleak: Fix some false positives with special
	scan
Message-ID: <20100531164121.GV17639@pcarmody-desktop>
References: <1273821401-26578-1-git-send-email-Hiroshi.DOYU@nokia.com> <1273821401-26578-2-git-send-email-Hiroshi.DOYU@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273821401-26578-2-git-send-email-Hiroshi.DOYU@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 31 May 2010 16:38:34.0716 (UTC) FILETIME=[B658A1C0:01CB00DF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One small comment below.

On 14/05/10 09:16 +0200, Doyu Hiroshi (Nokia-D/Helsinki) wrote:
> From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
> 
> There is the false positive that the pointer is calculated by other
> methods than the usual container_of macro. "kmemleak_ignore" can cover
> a false positive, but it would loose the advantage of kmemleak. This
> patch allows kmemleak to work with such false positives by introducing
> a new special memory block with a calculation formula. The client
> module can register the area with a function, which kmemleak scan and
> calculate the pointer with the function.
> 
> The typical use case could be the IOMMU first level pagetable which
> stores the pointer to the second level of page table with
> modification, for example, a physical address with attribution bits.
> 
> Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
> ---
>  include/linux/kmemleak.h |    4 ++
>  mm/kmemleak.c            |   83 ++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 84 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/kmemleak.h b/include/linux/kmemleak.h
> index 99d9a67..10be9ef 100644
> --- a/include/linux/kmemleak.h
> +++ b/include/linux/kmemleak.h
> @@ -35,6 +35,10 @@ extern void kmemleak_ignore(const void *ptr) __ref;
>  extern void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp) __ref;
>  extern void kmemleak_no_scan(const void *ptr) __ref;
>  
> +extern int kmemleak_special_scan(const void *ptr, size_t size,
> +				 unsigned long (*fn)(unsigned long)) __ref;
> +extern void kmemleak_no_special(const void *ptr) __ref;
> +
>  static inline void kmemleak_alloc_recursive(const void *ptr, size_t size,
>  					    int min_count, unsigned long flags,
>  					    gfp_t gfp)
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 2c0d032..5166987 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -249,6 +249,67 @@ static struct early_log
>  	early_log[CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE] __initdata;
>  static int crt_early_log __initdata;
>  
> +/* scan area which requires special conversion */
> +struct special_block {
> +	void *start;
> +	void *end;
> +	unsigned long (*fn)(unsigned long);
> +};
> +#define SPECIAL_MAX 5
> +static struct special_block special_block[SPECIAL_MAX];
> +static DEFINE_SPINLOCK(special_block_lock);
> +
> +int kmemleak_special_scan(const void *ptr, size_t size,
> +			  unsigned long (*fn)(unsigned long))
> +{
> +	struct special_block *p;
> +	int i, err = 0;
> +
> +	if (!ptr || (size == 0) || !fn)
> +		return -EINVAL;
> +
> +	spin_lock(&special_block_lock);
> +
> +	p = special_block;
> +	for (i = 0; i < SPECIAL_MAX; i++, p++) {
> +		if (!p->start)
> +			break;
> +	}
> +
> +	if (i == SPECIAL_MAX) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +	p->start = (void *)ptr;
> +	p->end = (void *)ptr + size;
> +	p->fn = fn;
> +out:
> +	spin_unlock(&special_block_lock);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(kmemleak_special_scan);
> +
> +void kmemleak_no_special(const void *ptr)
> +{
> +	int i;
> +
> +	spin_lock(&special_block_lock);
> +
> +	for (i = 0; i < SPECIAL_MAX; i++) {
> +		struct special_block *p;
> +
> +		p = &special_block[i];
> +		if (p->start == ptr) {
> +			memset(p, 0, sizeof(*p));
> +			break;
> +		}
> +	}
> +
> +	spin_unlock(&special_block_lock);
> +}
> +EXPORT_SYMBOL_GPL(kmemleak_no_special);
> +
>  static void kmemleak_disable(void);
>  
>  /*
> @@ -983,8 +1044,9 @@ static int scan_should_stop(void)
>   * Scan a memory block (exclusive range) for valid pointers and add those
>   * found to the gray list.
>   */
> -static void scan_block(void *_start, void *_end,
> -		       struct kmemleak_object *scanned, int allow_resched)
> +static void __scan_block(void *_start, void *_end,
> +			 struct kmemleak_object *scanned, int allow_resched,
> +			 unsigned long (*fn)(unsigned long))
>  {
>  	unsigned long *ptr;
>  	unsigned long *start = PTR_ALIGN(_start, BYTES_PER_POINTER);
> @@ -1005,7 +1067,7 @@ static void scan_block(void *_start, void *_end,
>  						  BYTES_PER_POINTER))
>  			continue;
>  
> -		pointer = *ptr;
> +		pointer = fn ? fn(*ptr) : *ptr;

Tests on the real-world scenario where this special scan became
desirable indicate that the following micro-optimisation is useful,
as much of the scanning is over zero-initialised blocks:

-		pointer = *ptr;
+		pointer = (fn && *ptr) ? fn(*ptr) : *ptr;

But that's itsy-bitsy.

As this patchset is already making itself useful, I'd like to add my 
support for it:

Acked-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

Cheers,
Phil
