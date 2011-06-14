Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab1FNIu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 04:50:28 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:42408 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab1FNIu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 04:50:26 -0400
Date: Tue, 14 Jun 2011 10:50:01 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Jiri Slaby <jslaby@suse.cz>, Len Brown <lenb@kernel.org>
Subject: Re: [patch 1/1] [PATCH] include storage keys in hibernation image.
Message-ID: <20110614105001.2f991377@mschwide>
In-Reply-To: <201106121441.35059.rjw@sisk.pl>
References: <20110608074523.211912903@de.ibm.com>
	<20110608074648.287491002@de.ibm.com>
	<201106121441.35059.rjw@sisk.pl>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

first of all: thanks for the review.

On Sun, 12 Jun 2011 14:41:34 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > diff -urpN linux-2.6/arch/s390/kernel/swsusp_asm64.S linux-2.6-patched/arch/s390/kernel/swsusp_asm64.S
> > --- linux-2.6/arch/s390/kernel/swsusp_asm64.S	2011-05-19 06:06:34.000000000 +0200
> > +++ linux-2.6-patched/arch/s390/kernel/swsusp_asm64.S	2011-06-06 11:14:43.000000000 +0200
> > @@ -138,11 +138,14 @@ swsusp_arch_resume:
> >  0:
> >  	lg	%r2,8(%r1)
> >  	lg	%r4,0(%r1)
> > +	iske	%r0,%r4
> >  	lghi	%r3,PAGE_SIZE
> >  	lghi	%r5,PAGE_SIZE
> >  1:
> >  	mvcle	%r2,%r4,0
> >  	jo	1b
> > +	lg	%r2,8(%r1)
> > +	sske	%r0,%r2
> >  	lg	%r1,16(%r1)
> >  	ltgr	%r1,%r1
> >  	jnz	0b
> 
> I cannot comment on the assembly.

The swsusp_arch_resume code copies the safe pages to their final target
page. Writing to a page sets the dirty bit in the storage key. Which
means that the storage key needs to be restored >after< the copy has
been done. To avoid having to deal with additional pages where the
storage key are kept while the copy is still pending I simply set the
storage key of the safe page and transfer it from the safe page to the
final target page after the copy has been done. That is what the iske
and the sske instruction are doing.
 
> > diff -urpN linux-2.6/kernel/power/snapshot.c linux-2.6-patched/kernel/power/snapshot.c
> > --- linux-2.6/kernel/power/snapshot.c	2011-06-06 11:14:39.000000000 +0200
> > +++ linux-2.6-patched/kernel/power/snapshot.c	2011-06-06 11:14:43.000000000 +0200
> > @@ -1022,6 +1022,137 @@ static inline void copy_data_page(unsign
> >  }
> >  #endif /* CONFIG_HIGHMEM */
> >  
> > +#ifdef CONFIG_S390
> > +/*
> > + * For s390 there is one additional byte associated with each page,
> > + * the storage key. The key consists of the access-control bits
> > + * (alias the key), the fetch-protection bit, the referenced bit
> > + * and the change bit (alias dirty bit). Linux uses only the
> > + * referenced bit and the change bit for pages in the page cache.
> > + * Any modification of a page will set the change bit, any access
> > + * sets the referenced bit. Overindication of the referenced bits
> > + * after a hibernation cycle does not cause any harm but the
> > + * overindication of the change bits would cause trouble.
> > + * Therefore it is necessary to include the storage keys in the
> > + * hibernation image. The storage keys are saved to the most
> > + * significant byte of each page frame number in the list of pfns
> > + * in the hibernation image.
> > + */
> 
> Let me say that is not exactly straightforward. :-)
> 
> One thing I don't really understand is where those storage keys are normally
> stored so that they aren't present in the image without this additional
> mechanism.  Could you explain that a bit more, please?

The storage keys are outside of the directly addressable memory, the only
way to get to them is with special instructions:
iske - insert storage key extended, ivsk - insert virtual storage key,
sske - set storage key extended, and rrbe - reset reference bit extended.
The storage key of a page has 7 bits, 4 bit for access-control, the
fetch-protection-bit, the reference-bit and the change-bit. In Linux only
the reference and change bits are used.

These bits are per physical page, one of the major differences of the s390
machines compared to other architectures. We had a number of interesting
problems because of pte dirty & referenced vs page dirty & referenced.
For e.g. x86 a page is implicitly clean if it has no mapper. On s390 is
depends on the contents of the storage key. Which is why SetPageUptodate
clears the storage key.

In regard to hibernation the important aspect is that each and every write
to a page sets the dirty bit even if it is done by I/O. The restore of the
hibernation image therefore makes all pages dirty. To get the correct
original combination of page content and storage key content the storage
key needs to be set after the last access to the page content.

> > +
> > +/*
> > + * Key storage is allocated as a linked list of pages.
> > + * The size of the keys array is (PAGE_SIZE - sizeof(long))
> > + */
> > +struct page_key_data {
> > +	struct page_key_data *next;
> > +	unsigned char data[];
> > +};
> 
> This seems to be similar to the data structure for the saving of ACPI NVS
> memory, so perhaps it's possible to combine the two.

Almost the same, I thought about ways to merge them. I dropped the idea in
order to keep the patch as small as possible.

> > +#define PAGE_KEY_DATA_SIZE	(PAGE_SIZE - sizeof(struct page_key_data *))
> > +
> > +static struct page_key_data *page_key_data;
> > +static struct page_key_data *page_key_rp, *page_key_wp;
> > +static unsigned long page_key_rx, page_key_wx;
> > +
> > +/*
> > + * For each page in the hibernation image one additional byte is
> > + * stored in the most significant byte of the page frame number.
> 
> I'm not sure it's really worth the complication.  If you simply store those
> keys in separete pages, you'd need one additional page per PAGE_SIZE
> page frames, so given PAGE_SIZE = 4096 that's one page per 16 MB of memory,
> which is not a whole lot (64 extra pages per GB if I'm not mistaken).
> 
> It seems that doing it will simplify things quite a git.

One of the versions of the patch actually did that and it turned out to
be much larger then the proposed solution. That older version had another
step in snapshot_read_next / snapshot_write_next to copy the storage keys
to pages allocated for that purpose. I had some trouble with the way how
the code deals with the orig_bm and the copy_bm though. Not trivial code..

In the end I decided to use some of the unused 12 bits in the pfn list
entries, it avoids any structural changes to the snapshot code and it
resulted in the smallest patch (at least so far). One thing that seemed
important to me was to make the patch obviously correct for the other
architectures, for !s390 the new functions are nops and there is no
structural change.

> Apart from this, I'm not sure that kernel/power/snapshot.c is the right
> place for all this S390-specific code.  I'd rather see it in arch/s390.

The alternative would be to move the s390 specific page_key_xxx functions
to some architecture file. The hooks in snapshot.c would have to stay
though. Unfortunately they are in odd places and you can only understand
them in the context of the s390 storage keys.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

