Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab2ENUgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:36:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754Ab2ENUgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:36:15 -0400
Date: Mon, 14 May 2012 13:36:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Optimize bitmap_weight
Message-Id: <20120514133613.ebccc529.akpm@linux-foundation.org>
In-Reply-To: <CAC5umyjP9DLVJXvpVEwOOS6EK47zT+zYabyTCDLFSmNis5E8QA@mail.gmail.com>
References: <1336745414-5530-1-git-send-email-akinobu.mita@gmail.com>
	<20120511154836.aff26ad3.akpm@linux-foundation.org>
	<CAC5umyjP9DLVJXvpVEwOOS6EK47zT+zYabyTCDLFSmNis5E8QA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012 06:50:15 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> 2012/5/12 Andrew Morton <akpm@linux-foundation.org>:
> > On Fri, 11 May 2012 23:10:14 +0900
> > Akinobu Mita <akinobu.mita@gmail.com> wrote:
> >
> >> The current implementation of bitmap_weight simply evaluates the
> >> population count for each long word of the array, and adds.
> >>
> >> The subsection "Counting 1-bits in an Array" in the revisions of
> >> the book 'Hacker's Delight' explains more superior methods than
> >> the naive method.
> >>
> >> http://www.hackersdelight.org/revisions.pdf
> >> http://www.hackersdelight.org/HDcode/newCode/pop_arrayHS.c.txt
> >>
> >> My benchmark results on Intel Core i3 CPU with 32-bit kernel
> >> showed 50% faster for 8192 bits bitmap.  However, it is not faster
> >> for small bitmap (< BITS_PER_LONG * 8) than the naive method.
> >> So if the bitmap size is known to be small at compile time,
> >> use the naive method.
> >>
> >> ...
> >>
> >>  extern void bitmap_clear(unsigned long *map, int start, int nr);
> >> @@ -277,7 +278,9 @@ static inline int bitmap_weight(const unsigned long *src, int nbits)
> >>  {
> >>       if (small_const_nbits(nbits))
> >>               return hweight_long(*src & BITMAP_LAST_WORD_MASK(nbits));
> >
> > Why do we require a constant_p `nbits' for this case?

^^ this?

> >> -     return  bitmap_weight(src, nbits);
> >> +     else if ( builtin_constant_p(nbits) && (nbits) < BITS_PER_LONG * 8)
> >> +             return  bitmap_weight(src, nbits);
> >> +     return  bitmap_weight_fast(src, nbits);
> >>  }
> >
> > BITS_PER_LONG*8 sounds like a large bitmap: 256 or 512 entries.  Will
> > the kernel call  bitmap_weight_fast() sufficiently often to make this
> > extra code worth merging?
> >
> 
> I roughly checked the call sites of bitmap_weight() and picked up some
> outstanding usages below.
> 
> Some filesystems (udf, omfs, ntfs, and hpfs) use bitmap_weight() to
> the block size bytes region in statfs() path.
> 
> num_online_cpus() and the variants are bitmap_weight() to the NR_CPUS
> bitmap and num_online_nodes() and the variants are to the MAX_NUMNODES
> bitmap.  So these bitmaps could be large on extremely large system.
> 
> bm_count_bits() in drivers/block/drbd/drbd_bitmap.c computes the
> population count for multiple pages.  But it is currently open-coded
> loops with hweight_long() which can be converted to bitmap_weight().
> 
> I consider introducing bitmap_weight_large() which is specialized for
> the large bitmap instead of optimizing bitmap_weight() and replace the
> call sites like above.

I don't see much advantage to that - it would be better if
bitmap_weight() Just Works.
