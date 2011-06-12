Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab1FLMlI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 08:41:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49427 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227Ab1FLMlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 08:41:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch 1/1] [PATCH] include storage keys in hibernation image.
Date: Sun, 12 Jun 2011 14:41:34 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Jiri Slaby <jslaby@suse.cz>, Len Brown <lenb@kernel.org>
References: <20110608074523.211912903@de.ibm.com> <20110608074648.287491002@de.ibm.com>
In-Reply-To: <20110608074648.287491002@de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201106121441.35059.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

I cannot comment on the assembly.

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

Let me say that is not exactly straightforward. :-)

One thing I don't really understand is where those storage keys are normally
stored so that they aren't present in the image without this additional
mechanism.  Could you explain that a bit more, please?

> +
> +/*
> + * Key storage is allocated as a linked list of pages.
> + * The size of the keys array is (PAGE_SIZE - sizeof(long))
> + */
> +struct page_key_data {
> +	struct page_key_data *next;
> +	unsigned char data[];
> +};

This seems to be similar to the data structure for the saving of ACPI NVS
memory, so perhaps it's possible to combine the two.

> +#define PAGE_KEY_DATA_SIZE	(PAGE_SIZE - sizeof(struct page_key_data *))
> +
> +static struct page_key_data *page_key_data;
> +static struct page_key_data *page_key_rp, *page_key_wp;
> +static unsigned long page_key_rx, page_key_wx;
> +
> +/*
> + * For each page in the hibernation image one additional byte is
> + * stored in the most significant byte of the page frame number.

I'm not sure it's really worth the complication.  If you simply store those
keys in separete pages, you'd need one additional page per PAGE_SIZE
page frames, so given PAGE_SIZE = 4096 that's one page per 16 MB of memory,
which is not a whole lot (64 extra pages per GB if I'm not mistaken).

It seems that doing it will simplify things quite a git.

Apart from this, I'm not sure that kernel/power/snapshot.c is the right
place for all this S390-specific code.  I'd rather see it in arch/s390.

Thanks,
Rafael
