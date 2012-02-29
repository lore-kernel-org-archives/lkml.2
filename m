Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964820Ab2B2J0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 04:26:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756670Ab2B2JZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:25:25 -0500
Message-ID: <4F4DEEFA.6000506@redhat.com>
Date: Wed, 29 Feb 2012 11:25:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4] KVM: Switch to srcu-less get_dirty_log()
References: <20120223203300.241510a6.yoshikawa.takuya@oss.ntt.co.jp> <20120223203541.f51c11c9.yoshikawa.takuya@oss.ntt.co.jp> <4F4CBEAA.5030708@redhat.com> <20120229164934.745d08f5.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120229164934.745d08f5.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 09:49 AM, Takuya Yoshikawa wrote:
> Avi Kivity <avi@redhat.com> wrote:
>
> > > The key part of the implementation is the use of xchg() operation for
> > > clearing dirty bits atomically.  Since this allows us to update only
> > > BITS_PER_LONG pages at once, we need to iterate over the dirty bitmap
> > > until every dirty bit is cleared again for the next call.
> > 
> > What about using cmpxchg16b?  That should reduce locked ops by a factor
> > of 2 (but note it needs 16 bytes alignment).
>
> I tried cmpxchg16b first: the implementation could not be naturally
> combined with the for loop over the unsigned long array.
>
> 	Extra "if not zero", alignement check and ... it was ugly
> 	and I guessed it would be slow.
>
> Taking it into account that cmpxchg16b needs more cycles than others,
> I think this should be tried carefully with more measurement later.
>
> How about concentrating on xchg now?

Okay.  But note you don't need the alignment check; simply allocate the
array aligned, and a multiple of 16 bytes, in the first place.

>
> The implementation is simple and gives us enough improvement for now.
> At least, I want to see whether xchg-based implementation works well
> for one release.
>
> 	GET_DIRTY_LOG can be easily tuned to one particular case and
> 	it is really hard to check whether the implementation works well
> 	for every important case.  I really want feedback from users
> 	before adding non-obvious optimization.
>
> In addition, we should care about the new API.  It is not decided about
> what kind of range can be ordered.  I think restricting the range to be
> long size aligned is natural.  Do you have any plan?

Not really.  But the current changes are all internal and don't affect
the user API.

>
> > > Another point to note is that we do not use for_each_set_bit() to check
> > > which ones in each BITS_PER_LONG pages are actually dirty.  Instead we
> > > simply use __ffs() and __fls() and pass the range in between the two
> > > positions found by them to kvm_mmu_write_protect_pt_range().
> > 
> > This seems artificial.
>
> OK, then I want to pass the bits (unsingned long) as a mask.
>
> Non-NPT machines may gain some.
>
> > > Even though the passed range may include clean pages, it is much faster
> > > than repeatedly call find_next_bit() due to the locality of dirty pages.
> > 
> > Perhaps this is due to the implementation of find_next_bit()?  would
> > using bsf improve things?
>
> I need to explain what I did in the past.
>
> Before srcu-less work, I had already noticed the slowness of
> for_each_set_bit() and replaced it with simple for loop like now: the
> improvement was significant.
>
> Yes, find_next_bit() is for generic use and not at all good when there
> are many consecutive bits set: it cannot assume anything so needs to check
> a lot of cases - we have long size aligned bitmap and "bits" is already
> known to be non-zero after the first check of the for loop.
>
> Of course, doing 64 function calls alone should be avoided in our case.
> I also do not want to call kvm_mmu_* for each bit.
>
> So, above, I proposed just passing "bits" to kvm_mmu_*: we can check
> each bit i in a register before using rmap[i] if needed.
>
> __ffs is really fast compared to other APIs.

You could do something like this

    for (i = 0; i < bitmap_size_in_longs; ++i) {
        mask = bitmap[i];
        if (!mask)
               continue;
        for (j = __ffs(mask); mask; mask &= mask - 1, j = __ffs(mask))
                handle i * BITS_PER_LONG + j;
    }

This gives you the speed of __ffs() but without working on zero bits.

>
> One note is that we will lose in cases like bits = 0xffffffff..
>
> 2271171.4    12064.9       138.6      16K     -45
> 3375866.2    14743.3       103.0      32K     -55
> 4408395.6    10720.0        67.2      64K     -51
> 5915336.2    26538.1        45.1     128K     -44
> 8497356.4    16441.0        32.4     256K     -29
>
> So the last one will become worse.  For other 4 patterns I am not sure.
>
> I thought that we should tune to the last case for gaining a lot from
> the locality of WWS.  What do you think about this point?
>
> > > -	} else {
> > > -		r = -EFAULT;
> > > -		if (clear_user(log->dirty_bitmap, n))
> > > -			goto out;
> > > +		kvm_mmu_write_protect_pt_range(kvm, memslot, start, end);
> > 
> > If indeed the problem is find_next_bit(), then we could hanve
> > kvm_mmu_write_protect_slot_masked() which would just take the bitmap as
> > a parameter.  This would allow covering just this function with the
> > spinlock, not the xchg loop.
>
> We may see partial display updates if we do not hold the mmu_lock during
> xchg loop: it is possible that pages near the end of the framebuffer alone
> gets updated sometimes - I noticed this problem when I fixed the TLB flush
> issue.

I don't understand why this happens.

>
> Not a big problem but still maybe-noticeable change, so I think we should
> do it separately with some comments if needed.

Well if it's noticable on the framebuffer it's also noticable with live
migration.  We could do it later, but we need to really understand it first.

> In addition, we do not want to scan the dirty bitmap twice.  Using the
> bits value soon after it is read into a register seems to be the fastest.

Probably.

> BTW, I also want to decide the design of the new API at this chance.

Let's wait with that.  We're adding APIs too quickly.  Let's squeeze
everything we can out of the current APIs.

-- 
error compiling committee.c: too many arguments to function

