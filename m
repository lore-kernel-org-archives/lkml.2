Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab1G1WTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:19:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60375 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab1G1WTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:19:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch 1/1] [PATCH] include storage keys in hibernation image.
Date: Fri, 29 Jul 2011 00:01:14 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Jiri Slaby <jslaby@suse.cz>
References: <20110608074523.211912903@de.ibm.com> <20110608074648.287491002@de.ibm.com>
In-Reply-To: <20110608074648.287491002@de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201107290001.14465.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for the extreme delay.

On Wednesday, June 08, 2011, Martin Schwidefsky wrote:
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
> ---
> 
>  arch/s390/kernel/swsusp_asm64.S |    3 
>  kernel/power/snapshot.c         |  148 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 151 insertions(+)
> 
> diff -urpN linux-2.6/arch/s390/kernel/swsusp_asm64.S linux-2.6-patched/arch/s390/kernel/swsusp_asm64.S
> --- linux-2.6/arch/s390/kernel/swsusp_asm64.S	2011-05-19 06:06:34.000000000 +0200
> +++ linux-2.6-patched/arch/s390/kernel/swsusp_asm64.S	2011-06-06 11:14:43.000000000 +0200
> @@ -138,11 +138,14 @@ swsusp_arch_resume:
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
> diff -urpN linux-2.6/kernel/power/snapshot.c linux-2.6-patched/kernel/power/snapshot.c
> --- linux-2.6/kernel/power/snapshot.c	2011-06-06 11:14:39.000000000 +0200
> +++ linux-2.6-patched/kernel/power/snapshot.c	2011-06-06 11:14:43.000000000 +0200
> @@ -1022,6 +1022,137 @@ static inline void copy_data_page(unsign
>  }
>  #endif /* CONFIG_HIGHMEM */
>  
> +#ifdef CONFIG_S390
> +/*
> + * For s390 there is one additional byte associated with each page,
> + * the storage key. The key consists of the access-control bits
> + * (alias the key), the fetch-protection bit, the referenced bit
> + * and the change bit (alias dirty bit). Linux uses only the
> + * referenced bit and the change bit for pages in the page cache.
> + * Any modification of a page will set the change bit, any access
> + * sets the referenced bit. Overindication of the referenced bits
> + * after a hibernation cycle does not cause any harm but the
> + * overindication of the change bits would cause trouble.
> + * Therefore it is necessary to include the storage keys in the
> + * hibernation image. The storage keys are saved to the most
> + * significant byte of each page frame number in the list of pfns
> + * in the hibernation image.
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
> +static inline unsigned long page_key_additional_pages(unsigned long pages)
> +{
> +	return DIV_ROUND_UP(pages, PAGE_KEY_DATA_SIZE);
> +}
> +
> +/*
> + * Free page_key_data list of arrays.
> + */
> +static void page_key_free(void)
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
> +static int page_key_alloc(unsigned long pages)
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
> +static inline void page_key_read(unsigned long *pfn)
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
> +static inline void page_key_memorize(unsigned long *pfn)
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
> +static void page_key_write(void *address)
> +{
> +	page_set_storage_key((unsigned long) address,
> +			     page_key_rp->data[page_key_rx], 0);
> +	if (++page_key_rx >= PAGE_KEY_DATA_SIZE)
> +		return;
> +	page_key_rp = page_key_rp->next;
> +	page_key_rx = 0;
> +}
> +#else
> +static unsigned long page_key_additional_pages(unsigned long pages) { return 0; }
> +static inline int  page_key_alloc(unsigned long pages) { return 0; }
> +static inline void page_key_free(void) { }
> +static inline void page_key_read(unsigned long *pfn) { }
> +static inline void page_key_memorize(unsigned long *pfn) { }
> +static inline void page_key_write(void *address) { }
> +#endif

Having reconsidered things I think the code under the #ifdef above
should really go to arch/s390.

Now, for the purpose of exporting the headers I'd introduce
CONFIG_ARCH_SAVE_PAGE_KEYS and make S390 do

select ARCH_SAVE_PAGE_KEYS if HIBERNATION

and I'd put a #ifdef depending on that into include/linux/suspend.h.

Apart from this, I have only one complaint, which is that the kerneldoc
comments should follow the standard (the other comments in snapshot.c don't,
but that's a matter for a separate patch).

Thanks,
Rafael
