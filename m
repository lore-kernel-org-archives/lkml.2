Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab1FOHgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 03:36:52 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:56092 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab1FOHgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 03:36:49 -0400
Date: Wed, 15 Jun 2011 09:36:29 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Jiri Slaby <jslaby@suse.cz>, Len Brown <lenb@kernel.org>
Subject: Re: [patch 1/1] [PATCH] include storage keys in hibernation image.
Message-ID: <20110615093629.07f01779@mschwide>
In-Reply-To: <201106142250.15041.rjw@sisk.pl>
References: <20110608074523.211912903@de.ibm.com>
	<201106121441.35059.rjw@sisk.pl>
	<20110614105001.2f991377@mschwide>
	<201106142250.15041.rjw@sisk.pl>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jun 2011 22:50:14 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday, June 14, 2011, Martin Schwidefsky wrote:
> > Hi Rafael,
> 
> > On Sun, 12 Jun 2011 14:41:34 +0200
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > > diff -urpN linux-2.6/kernel/power/snapshot.c linux-2.6-patched/kernel/power/snapshot.c
> > > > --- linux-2.6/kernel/power/snapshot.c	2011-06-06 11:14:39.000000000 +0200
> > > > +++ linux-2.6-patched/kernel/power/snapshot.c	2011-06-06 11:14:43.000000000 +0200
> > > > @@ -1022,6 +1022,137 @@ static inline void copy_data_page(unsign
> > > >  }
> > > >  #endif /* CONFIG_HIGHMEM */
> > > >  
> > > > +#ifdef CONFIG_S390
> > > > +/*
> > > > + * For s390 there is one additional byte associated with each page,
> > > > + * the storage key. The key consists of the access-control bits
> > > > + * (alias the key), the fetch-protection bit, the referenced bit
> > > > + * and the change bit (alias dirty bit). Linux uses only the
> > > > + * referenced bit and the change bit for pages in the page cache.
> > > > + * Any modification of a page will set the change bit, any access
> > > > + * sets the referenced bit. Overindication of the referenced bits
> > > > + * after a hibernation cycle does not cause any harm but the
> > > > + * overindication of the change bits would cause trouble.
> > > > + * Therefore it is necessary to include the storage keys in the
> > > > + * hibernation image. The storage keys are saved to the most
> > > > + * significant byte of each page frame number in the list of pfns
> > > > + * in the hibernation image.
> > > > + */
> > > 
> > > Let me say that is not exactly straightforward. :-)
> > > 
> > > One thing I don't really understand is where those storage keys are normally
> > > stored so that they aren't present in the image without this additional
> > > mechanism.  Could you explain that a bit more, please?
> > 
> > The storage keys are outside of the directly addressable memory, the only
> > way to get to them is with special instructions:
> > iske - insert storage key extended, ivsk - insert virtual storage key,
> > sske - set storage key extended, and rrbe - reset reference bit extended.
> > The storage key of a page has 7 bits, 4 bit for access-control, the
> > fetch-protection-bit, the reference-bit and the change-bit. In Linux only
> > the reference and change bits are used.
> 
> OK, so it looks like we would only need to store 2 bits per page in additional
> allocations.

For now we'd only need two bits, but with KVM guests we will have to store the
complete storage key. The guest OS could make use of all the bits in the storage
key, the KVM host needs to preserve them.

> > These bits are per physical page, one of the major differences of the s390
> > machines compared to other architectures. We had a number of interesting
> > problems because of pte dirty & referenced vs page dirty & referenced.
> > For e.g. x86 a page is implicitly clean if it has no mapper. On s390 is
> > depends on the contents of the storage key. Which is why SetPageUptodate
> > clears the storage key.
> > 
> > In regard to hibernation the important aspect is that each and every write
> > to a page sets the dirty bit even if it is done by I/O. The restore of the
> > hibernation image therefore makes all pages dirty. To get the correct
> > original combination of page content and storage key content the storage
> > key needs to be set after the last access to the page content.
> 
> What, in your opinion, is the right time for restoring the original storage
> keys after the image has been loaded?  It seems that should happen after
> passing control to the hibernated kernel.

Anytime after the final write of the page content completed and before the
hibernated kernel gets control (or shortly after in the resume code of the
restored kernel).

> > > > +
> > > > +/*
> > > > + * Key storage is allocated as a linked list of pages.
> > > > + * The size of the keys array is (PAGE_SIZE - sizeof(long))
> > > > + */
> > > > +struct page_key_data {
> > > > +	struct page_key_data *next;
> > > > +	unsigned char data[];
> > > > +};
> > > 
> > > This seems to be similar to the data structure for the saving of ACPI NVS
> > > memory, so perhaps it's possible to combine the two.
> > 
> > Almost the same, I thought about ways to merge them. I dropped the idea in
> > order to keep the patch as small as possible.
> 
> I think, however, that we really should try to merge them.  The only
> difference seems to be how the additionally allocated pages will be populated
> and what's going to happen to their contents during restore.
> 
> ACPI will simply copy the NVS memory to those pages, while S390 will save
> the relevant storage key bits in there.

One complication to keep in mind is that we need to know which storage key
goes to which page frame. We need something like the orig_bm/copy_bm or
we'd have to store the pfn with the key. Simply storing the key for every
page will make the array unnecessarily big.

> > > > +#define PAGE_KEY_DATA_SIZE	(PAGE_SIZE - sizeof(struct page_key_data *))
> > > > +
> > > > +static struct page_key_data *page_key_data;
> > > > +static struct page_key_data *page_key_rp, *page_key_wp;
> > > > +static unsigned long page_key_rx, page_key_wx;
> > > > +
> > > > +/*
> > > > + * For each page in the hibernation image one additional byte is
> > > > + * stored in the most significant byte of the page frame number.
> > > 
> > > I'm not sure it's really worth the complication.  If you simply store those
> > > keys in separete pages, you'd need one additional page per PAGE_SIZE
> > > page frames, so given PAGE_SIZE = 4096 that's one page per 16 MB of memory,
> > > which is not a whole lot (64 extra pages per GB if I'm not mistaken).
> > > 
> > > It seems that doing it will simplify things quite a git.
> > 
> > One of the versions of the patch actually did that and it turned out to
> > be much larger then the proposed solution. That older version had another
> > step in snapshot_read_next / snapshot_write_next to copy the storage keys
> > to pages allocated for that purpose. I had some trouble with the way how
> > the code deals with the orig_bm and the copy_bm though. Not trivial code..
> 
> Well, I'm sure we can handle that. :-)
> 
> I thought of the following approach:
> 
> * Allocate memory for saving the relevant bits of the storage keys before
>   the memory preallocation kicks in.
> 
> * Save the storage key bits to that memory before creating the image (be
>   careful about the storage keys of the pages they are being stored into).
> 
> * After getting control from the boot kernel, restore the storage key bits
>   saved before creating the image.
> 
> * Free additional memory used for storing them.
> 
> This way we wouldn't have to worry about any interactions with
> snapshot_read_next / snapshot_write_next etc.

Well before the preallocation kicked in we don't know which are the relevant
storage keys. The only other option would be to store all of them which I
consider to be a inferior solution. 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

