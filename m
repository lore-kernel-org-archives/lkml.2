Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab1FNUtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 16:49:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56374 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab1FNUtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 16:49:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch 1/1] [PATCH] include storage keys in hibernation image.
Date: Tue, 14 Jun 2011 22:50:14 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Jiri Slaby <jslaby@suse.cz>, Len Brown <lenb@kernel.org>
References: <20110608074523.211912903@de.ibm.com> <201106121441.35059.rjw@sisk.pl> <20110614105001.2f991377@mschwide>
In-Reply-To: <20110614105001.2f991377@mschwide>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106142250.15041.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 14, 2011, Martin Schwidefsky wrote:
> Hi Rafael,

Hi,

> first of all: thanks for the review.
> 
> On Sun, 12 Jun 2011 14:41:34 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > > diff -urpN linux-2.6/arch/s390/kernel/swsusp_asm64.S linux-2.6-patched/arch/s390/kernel/swsusp_asm64.S
> > > --- linux-2.6/arch/s390/kernel/swsusp_asm64.S	2011-05-19 06:06:34.000000000 +0200
> > > +++ linux-2.6-patched/arch/s390/kernel/swsusp_asm64.S	2011-06-06 11:14:43.000000000 +0200
> > > @@ -138,11 +138,14 @@ swsusp_arch_resume:
> > >  0:
> > >  	lg	%r2,8(%r1)
> > >  	lg	%r4,0(%r1)
> > > +	iske	%r0,%r4
> > >  	lghi	%r3,PAGE_SIZE
> > >  	lghi	%r5,PAGE_SIZE
> > >  1:
> > >  	mvcle	%r2,%r4,0
> > >  	jo	1b
> > > +	lg	%r2,8(%r1)
> > > +	sske	%r0,%r2
> > >  	lg	%r1,16(%r1)
> > >  	ltgr	%r1,%r1
> > >  	jnz	0b
> > 
> > I cannot comment on the assembly.
> 
> The swsusp_arch_resume code copies the safe pages to their final target
> page. Writing to a page sets the dirty bit in the storage key. Which
> means that the storage key needs to be restored >after< the copy has
> been done. To avoid having to deal with additional pages where the
> storage key are kept while the copy is still pending I simply set the
> storage key of the safe page and transfer it from the safe page to the
> final target page after the copy has been done. That is what the iske
> and the sske instruction are doing.

I see.

> > > diff -urpN linux-2.6/kernel/power/snapshot.c linux-2.6-patched/kernel/power/snapshot.c
> > > --- linux-2.6/kernel/power/snapshot.c	2011-06-06 11:14:39.000000000 +0200
> > > +++ linux-2.6-patched/kernel/power/snapshot.c	2011-06-06 11:14:43.000000000 +0200
> > > @@ -1022,6 +1022,137 @@ static inline void copy_data_page(unsign
> > >  }
> > >  #endif /* CONFIG_HIGHMEM */
> > >  
> > > +#ifdef CONFIG_S390
> > > +/*
> > > + * For s390 there is one additional byte associated with each page,
> > > + * the storage key. The key consists of the access-control bits
> > > + * (alias the key), the fetch-protection bit, the referenced bit
> > > + * and the change bit (alias dirty bit). Linux uses only the
> > > + * referenced bit and the change bit for pages in the page cache.
> > > + * Any modification of a page will set the change bit, any access
> > > + * sets the referenced bit. Overindication of the referenced bits
> > > + * after a hibernation cycle does not cause any harm but the
> > > + * overindication of the change bits would cause trouble.
> > > + * Therefore it is necessary to include the storage keys in the
> > > + * hibernation image. The storage keys are saved to the most
> > > + * significant byte of each page frame number in the list of pfns
> > > + * in the hibernation image.
> > > + */
> > 
> > Let me say that is not exactly straightforward. :-)
> > 
> > One thing I don't really understand is where those storage keys are normally
> > stored so that they aren't present in the image without this additional
> > mechanism.  Could you explain that a bit more, please?
> 
> The storage keys are outside of the directly addressable memory, the only
> way to get to them is with special instructions:
> iske - insert storage key extended, ivsk - insert virtual storage key,
> sske - set storage key extended, and rrbe - reset reference bit extended.
> The storage key of a page has 7 bits, 4 bit for access-control, the
> fetch-protection-bit, the reference-bit and the change-bit. In Linux only
> the reference and change bits are used.

OK, so it looks like we would only need to store 2 bits per page in additional
allocations.

> These bits are per physical page, one of the major differences of the s390
> machines compared to other architectures. We had a number of interesting
> problems because of pte dirty & referenced vs page dirty & referenced.
> For e.g. x86 a page is implicitly clean if it has no mapper. On s390 is
> depends on the contents of the storage key. Which is why SetPageUptodate
> clears the storage key.
> 
> In regard to hibernation the important aspect is that each and every write
> to a page sets the dirty bit even if it is done by I/O. The restore of the
> hibernation image therefore makes all pages dirty. To get the correct
> original combination of page content and storage key content the storage
> key needs to be set after the last access to the page content.

What, in your opinion, is the right time for restoring the original storage
keys after the image has been loaded?  It seems that should happen after
passing control to the hibernated kernel.

> > > +
> > > +/*
> > > + * Key storage is allocated as a linked list of pages.
> > > + * The size of the keys array is (PAGE_SIZE - sizeof(long))
> > > + */
> > > +struct page_key_data {
> > > +	struct page_key_data *next;
> > > +	unsigned char data[];
> > > +};
> > 
> > This seems to be similar to the data structure for the saving of ACPI NVS
> > memory, so perhaps it's possible to combine the two.
> 
> Almost the same, I thought about ways to merge them. I dropped the idea in
> order to keep the patch as small as possible.

I think, however, that we really should try to merge them.  The only
difference seems to be how the additionally allocated pages will be populated
and what's going to happen to their contents during restore.

ACPI will simply copy the NVS memory to those pages, while S390 will save
the relevant storage key bits in there.

> > > +#define PAGE_KEY_DATA_SIZE	(PAGE_SIZE - sizeof(struct page_key_data *))
> > > +
> > > +static struct page_key_data *page_key_data;
> > > +static struct page_key_data *page_key_rp, *page_key_wp;
> > > +static unsigned long page_key_rx, page_key_wx;
> > > +
> > > +/*
> > > + * For each page in the hibernation image one additional byte is
> > > + * stored in the most significant byte of the page frame number.
> > 
> > I'm not sure it's really worth the complication.  If you simply store those
> > keys in separete pages, you'd need one additional page per PAGE_SIZE
> > page frames, so given PAGE_SIZE = 4096 that's one page per 16 MB of memory,
> > which is not a whole lot (64 extra pages per GB if I'm not mistaken).
> > 
> > It seems that doing it will simplify things quite a git.
> 
> One of the versions of the patch actually did that and it turned out to
> be much larger then the proposed solution. That older version had another
> step in snapshot_read_next / snapshot_write_next to copy the storage keys
> to pages allocated for that purpose. I had some trouble with the way how
> the code deals with the orig_bm and the copy_bm though. Not trivial code..

Well, I'm sure we can handle that. :-)

I thought of the following approach:

* Allocate memory for saving the relevant bits of the storage keys before
  the memory preallocation kicks in.

* Save the storage key bits to that memory before creating the image (be
  careful about the storage keys of the pages they are being stored into).

* After getting control from the boot kernel, restore the storage key bits
  saved before creating the image.

* Free additional memory used for storing them.

This way we wouldn't have to worry about any interactions with
snapshot_read_next / snapshot_write_next etc.

Thanks,
Rafael
