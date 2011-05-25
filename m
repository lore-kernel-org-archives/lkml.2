Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1EYKt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 06:49:56 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:39569 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1EYKtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 06:49:55 -0400
Date: Wed, 25 May 2011 12:49:52 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 6/6] slab: only define SLAB_CACHE_DMA for CONFIG_ZONE_DMA
Message-ID: <20110525104952.GD2498@osiris.boeblingen.de.ibm.com>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1105241653180.29780@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105241653180.29780@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 04:53:57PM -0700, David Rientjes wrote:
> Only define SLAB_CACHE_DMA support if CONFIG_ZONE_DMA is enabled.  This
> catches build errors when used on an invalid configuration.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  include/linux/slab.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -20,7 +20,9 @@
>  #define SLAB_RED_ZONE		0x00000400UL	/* DEBUG: Red zone objs in a cache */
>  #define SLAB_POISON		0x00000800UL	/* DEBUG: Poison objects */
>  #define SLAB_HWCACHE_ALIGN	0x00002000UL	/* Align objs on cache lines */
> -#define SLAB_CACHE_DMA		0x00004000UL	/* Use GFP_DMA memory */
> +#ifdef CONFIG_ZONE_DMA
> +# define SLAB_CACHE_DMA		0x00004000UL	/* Use GFP_DMA memory */
> +#endif
>  #define SLAB_STORE_USER		0x00010000UL	/* DEBUG: Store the last owner for bug hunting */
>  #define SLAB_PANIC		0x00040000UL	/* Panic if kmem_cache_create() fails */
>  /*

Ok, now I see what you want. But please let's don't add an
#ifdef CONFIG_ZONE_DMA
to the dasd driver. Instead just re-add ZONE_DMA to 31-bit s390. Everything
would be in ZONE_DMA again and ZONE_NORMAL would be empty. Doesn't matter
if we have an additional zone, since 31-bit support isn't important anymore.

So I could add the following patch to the s390 tree, if wanted:

---
 arch/s390/Kconfig   |    2 +-
 arch/s390/mm/init.c |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -2,7 +2,7 @@ config MMU
 	def_bool y
 
 config ZONE_DMA
-	def_bool y if 64BIT
+	def_bool y
 
 config LOCKDEP_SUPPORT
 	def_bool y
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -119,9 +119,7 @@ void __init paging_init(void)
 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-#ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA] = PFN_DOWN(MAX_DMA_ADDRESS);
-#endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 	free_area_init_nodes(max_zone_pfns);
 	fault_init();
