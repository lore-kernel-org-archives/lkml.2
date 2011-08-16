Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1HPRzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:55:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45447 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab1HPRzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:55:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch 1/1] [PATCH] include storage keys in hibernation image.
Date: Tue, 16 Aug 2011 19:56:47 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Jiri Slaby <jslaby@suse.cz>
References: <20110816141441.898339466@de.ibm.com> <20110816141541.237704940@de.ibm.com>
In-Reply-To: <20110816141541.237704940@de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201108161956.47434.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 16, 2011, Martin Schwidefsky wrote:
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> For s390 there is one additional byte associated with each page,
> the storage key. This byte contains the referenced and changed
> bits and needs to be included into the hibernation image.
> If the storage keys are not restored to their previous state all
> original pages would appear to be dirty. This can cause
> inconsistencies e.g. with read-only filesystems.
> 
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: linux-pm@lists.linux-foundation.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-s390@vger.kernel.org
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

OK, I don't have any complaints.  Do you want me to take this
patch or do you want to push it through the s390 tree?

Rafael


> ---
> 
>  arch/s390/Kconfig               |    1 
>  arch/s390/kernel/suspend.c      |  118 ++++++++++++++++++++++++++++++++++++++++
>  arch/s390/kernel/swsusp_asm64.S |    3 +
>  include/linux/suspend.h         |   34 +++++++++++
>  kernel/power/Kconfig            |    3 +
>  kernel/power/snapshot.c         |   18 ++++++
>  6 files changed, 177 insertions(+)
> 
> Index: hibernate-2.6/arch/s390/Kconfig
> ===================================================================
> --- hibernate-2.6.orig/arch/s390/Kconfig	2011-08-09 17:40:09.220010373 +0200
> +++ hibernate-2.6/arch/s390/Kconfig	2011-08-16 16:06:09.845540931 +0200
> @@ -91,6 +91,7 @@
>  	select HAVE_ARCH_MUTEX_CPU_RELAX
>  	select HAVE_ARCH_JUMP_LABEL if !MARCH_G5
>  	select HAVE_RCU_TABLE_FREE if SMP
> +	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
>  	select ARCH_INLINE_SPIN_TRYLOCK
>  	select ARCH_INLINE_SPIN_TRYLOCK_BH
>  	select ARCH_INLINE_SPIN_LOCK
> Index: hibernate-2.6/arch/s390/kernel/suspend.c
> ===================================================================
> --- hibernate-2.6.orig/arch/s390/kernel/suspend.c	2009-09-24 09:06:44.000000000 +0200
> +++ hibernate-2.6/arch/s390/kernel/suspend.c	2011-08-16 16:06:09.845540931 +0200
> @@ -7,6 +7,7 @@
>   */
>  
>  #include <linux/pfn.h>
> +#include <linux/mm.h>
>  #include <asm/system.h>
>  
>  /*
> @@ -14,6 +15,123 @@
>   */
>  extern const void __nosave_begin, __nosave_end;
>  
> +/*
> + * The restore of the saved pages in an hibernation image will set
> + * the change and referenced bits in the storage key for each page.
> + * Overindication of the referenced bits after an hibernation cycle
> + * does not cause any harm but the overindication of the change bits
> + * would cause trouble.
> + * Use the ARCH_SAVE_PAGE_KEYS hooks to save the storage key of each
> + * page to the most significant byte of the associated page frame
> + * number in the hibernation image.
> + */
> +
> +/*
> + * Key storage is allocated as a linked list of pages.
> + * The size of the keys array is (PAGE_SIZE - sizeof(long))
> + */
> +struct page_key_data {
> +	struct page_key_data *next;
> +	unsigned char data[];
> +};
> +
> +#define PAGE_KEY_DATA_SIZE	(PAGE_SIZE - sizeof(struct page_key_data *))
> +
> +static struct page_key_data *page_key_data;
> +static struct page_key_data *page_key_rp, *page_key_wp;
> +static unsigned long page_key_rx, page_key_wx;
> +
> +/*
> + * For each page in the hibernation image one additional byte is
> + * stored in the most significant byte of the page frame number.
> + * On suspend no additional memory is required but on resume the
> + * keys need to be memorized until the page data has been restored.
> + * Only then can the storage keys be set to their old state.
> + */
> +unsigned long page_key_additional_pages(unsigned long pages)
> +{
> +	return DIV_ROUND_UP(pages, PAGE_KEY_DATA_SIZE);
> +}
> +
> +/*
> + * Free page_key_data list of arrays.
> + */
> +void page_key_free(void)
> +{
> +	struct page_key_data *pkd;
> +
> +	while (page_key_data) {
> +		pkd = page_key_data;
> +		page_key_data = pkd->next;
> +		free_page((unsigned long) pkd);
> +	}
> +}
> +
> +/*
> + * Allocate page_key_data list of arrays with enough room to store
> + * one byte for each page in the hibernation image.
> + */
> +int page_key_alloc(unsigned long pages)
> +{
> +	struct page_key_data *pk;
> +	unsigned long size;
> +
> +	size = DIV_ROUND_UP(pages, PAGE_KEY_DATA_SIZE);
> +	while (size--) {
> +		pk = (struct page_key_data *) get_zeroed_page(GFP_KERNEL);
> +		if (!pk) {
> +			page_key_free();
> +			return -ENOMEM;
> +		}
> +		pk->next = page_key_data;
> +		page_key_data = pk;
> +	}
> +	page_key_rp = page_key_wp = page_key_data;
> +	page_key_rx = page_key_wx = 0;
> +	return 0;
> +}
> +
> +/*
> + * Save the storage key into the upper 8 bits of the page frame number.
> + */
> +void page_key_read(unsigned long *pfn)
> +{
> +	unsigned long addr;
> +
> +	addr = (unsigned long) page_address(pfn_to_page(*pfn));
> +	*(unsigned char *) pfn = (unsigned char) page_get_storage_key(addr);
> +}
> +
> +/*
> + * Extract the storage key from the upper 8 bits of the page frame number
> + * and store it in the page_key_data list of arrays.
> + */
> +void page_key_memorize(unsigned long *pfn)
> +{
> +	page_key_wp->data[page_key_wx] = *(unsigned char *) pfn;
> +	*(unsigned char *) pfn = 0;
> +	if (++page_key_wx < PAGE_KEY_DATA_SIZE)
> +		return;
> +	page_key_wp = page_key_wp->next;
> +	page_key_wx = 0;
> +}
> +
> +/*
> + * Get the next key from the page_key_data list of arrays and set the
> + * storage key of the page referred by @address. If @address refers to
> + * a "safe" page the swsusp_arch_resume code will transfer the storage
> + * key from the buffer page to the original page.
> + */
> +void page_key_write(void *address)
> +{
> +	page_set_storage_key((unsigned long) address,
> +			     page_key_rp->data[page_key_rx], 0);
> +	if (++page_key_rx >= PAGE_KEY_DATA_SIZE)
> +		return;
> +	page_key_rp = page_key_rp->next;
> +	page_key_rx = 0;
> +}
> +
>  int pfn_is_nosave(unsigned long pfn)
>  {
>  	unsigned long nosave_begin_pfn = PFN_DOWN(__pa(&__nosave_begin));
> Index: hibernate-2.6/arch/s390/kernel/swsusp_asm64.S
> ===================================================================
> --- hibernate-2.6.orig/arch/s390/kernel/swsusp_asm64.S	2011-08-09 17:40:09.228010544 +0200
> +++ hibernate-2.6/arch/s390/kernel/swsusp_asm64.S	2011-08-16 16:06:09.845540931 +0200
> @@ -136,11 +136,14 @@
>  0:
>  	lg	%r2,8(%r1)
>  	lg	%r4,0(%r1)
> +	iske	%r0,%r4
>  	lghi	%r3,PAGE_SIZE
>  	lghi	%r5,PAGE_SIZE
>  1:
>  	mvcle	%r2,%r4,0
>  	jo	1b
> +	lg	%r2,8(%r1)
> +	sske	%r0,%r2
>  	lg	%r1,16(%r1)
>  	ltgr	%r1,%r1
>  	jnz	0b
> Index: hibernate-2.6/include/linux/suspend.h
> ===================================================================
> --- hibernate-2.6.orig/include/linux/suspend.h	2011-08-09 17:40:10.164030551 +0200
> +++ hibernate-2.6/include/linux/suspend.h	2011-08-16 16:06:09.845540931 +0200
> @@ -334,4 +334,38 @@
>  }
>  #endif
>  
> +#ifdef CONFIG_ARCH_SAVE_PAGE_KEYS
> +/*
> + * The ARCH_SAVE_PAGE_KEYS functions can be used by an architecture
> + * to save/restore additional information to/from the array of page
> + * frame numbers in the hibernation image. For s390 this is used to
> + * save and restore the storage key for each page that is included
> + * in the hibernation image.
> + */
> +unsigned long page_key_additional_pages(unsigned long pages);
> +int page_key_alloc(unsigned long pages);
> +void page_key_free(void);
> +void page_key_read(unsigned long *pfn);
> +void page_key_memorize(unsigned long *pfn);
> +void page_key_write(void *address);
> +
> +#else /* !CONFIG_ARCH_SAVE_PAGE_KEYS */
> +
> +static inline unsigned long page_key_additional_pages(unsigned long pages)
> +{
> +	return 0;
> +}
> +
> +static inline int  page_key_alloc(unsigned long pages)
> +{
> +	return 0;
> +}
> +
> +static inline void page_key_free(void) {}
> +static inline void page_key_read(unsigned long *pfn) {}
> +static inline void page_key_memorize(unsigned long *pfn) {}
> +static inline void page_key_write(void *address) {}
> +
> +#endif /* !CONFIG_ARCH_SAVE_PAGE_KEYS */
> +
>  #endif /* _LINUX_SUSPEND_H */
> Index: hibernate-2.6/kernel/power/Kconfig
> ===================================================================
> --- hibernate-2.6.orig/kernel/power/Kconfig	2011-08-09 17:40:10.192031153 +0200
> +++ hibernate-2.6/kernel/power/Kconfig	2011-08-16 16:06:09.845540931 +0200
> @@ -65,6 +65,9 @@
>  
>  	  For more information take a look at <file:Documentation/power/swsusp.txt>.
>  
> +config ARCH_SAVE_PAGE_KEYS
> +	bool
> +
>  config PM_STD_PARTITION
>  	string "Default resume partition"
>  	depends on HIBERNATION
> Index: hibernate-2.6/kernel/power/snapshot.c
> ===================================================================
> --- hibernate-2.6.orig/kernel/power/snapshot.c	2011-07-08 11:25:06.293203483 +0200
> +++ hibernate-2.6/kernel/power/snapshot.c	2011-08-16 16:06:09.845540931 +0200
> @@ -1339,6 +1339,9 @@
>  	count += highmem;
>  	count -= totalreserve_pages;
>  
> +	/* Add number of pages required for page keys (s390 only). */
> +	size += page_key_additional_pages(saveable);
> +
>  	/* Compute the maximum number of saveable pages to leave in memory. */
>  	max_size = (count - (size + PAGES_FOR_IO)) / 2
>  			- 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE);
> @@ -1662,6 +1665,8 @@
>  		buf[j] = memory_bm_next_pfn(bm);
>  		if (unlikely(buf[j] == BM_END_OF_MAP))
>  			break;
> +		/* Save page key for data page (s390 only). */
> +		page_key_read(buf + j);
>  	}
>  }
>  
> @@ -1821,6 +1826,9 @@
>  		if (unlikely(buf[j] == BM_END_OF_MAP))
>  			break;
>  
> +		/* Extract and buffer page key for data page (s390 only). */
> +		page_key_memorize(buf + j);
> +
>  		if (memory_bm_pfn_present(bm, buf[j]))
>  			memory_bm_set_bit(bm, buf[j]);
>  		else
> @@ -2223,6 +2231,11 @@
>  		if (error)
>  			return error;
>  
> +		/* Allocate buffer for page keys. */
> +		error = page_key_alloc(nr_copy_pages);
> +		if (error)
> +			return error;
> +
>  	} else if (handle->cur <= nr_meta_pages + 1) {
>  		error = unpack_orig_pfns(buffer, &copy_bm);
>  		if (error)
> @@ -2243,6 +2256,8 @@
>  		}
>  	} else {
>  		copy_last_highmem_page();
> +		/* Restore page key for data page (s390 only). */
> +		page_key_write(handle->buffer);
>  		handle->buffer = get_buffer(&orig_bm, &ca);
>  		if (IS_ERR(handle->buffer))
>  			return PTR_ERR(handle->buffer);
> @@ -2264,6 +2279,9 @@
>  void snapshot_write_finalize(struct snapshot_handle *handle)
>  {
>  	copy_last_highmem_page();
> +	/* Restore page key for data page (s390 only). */
> +	page_key_write(handle->buffer);
> +	page_key_free();
>  	/* Free only if we have loaded the image entirely */
>  	if (handle->cur > 1 && handle->cur > nr_meta_pages + nr_copy_pages) {
>  		memory_bm_free(&orig_bm, PG_UNSAFE_CLEAR);
> 
> 
> 

