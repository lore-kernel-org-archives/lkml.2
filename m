Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab2LDR46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 12:56:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab2LDR4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 12:56:55 -0500
Message-ID: <1354643814.1809.469.camel@bling.home>
Subject: Re: [RFC PATCH 0/6] kvm: Growable memory slot array
From: Alex Williamson <alex.williamson@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2012 10:56:54 -0700
In-Reply-To: <20121204164243.GC14176@redhat.com>
References: <20121203231912.3661.57179.stgit@bling.home>
	 <20121204114803.GH19514@redhat.com> <1354634515.1809.406.camel@bling.home>
	 <20121204153043.GA14176@redhat.com> <1354635587.1809.422.camel@bling.home>
	 <20121204164243.GC14176@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-04 at 18:42 +0200, Gleb Natapov wrote:
> On Tue, Dec 04, 2012 at 08:39:47AM -0700, Alex Williamson wrote:
> > On Tue, 2012-12-04 at 17:30 +0200, Gleb Natapov wrote:
> > > On Tue, Dec 04, 2012 at 08:21:55AM -0700, Alex Williamson wrote:
> > > > On Tue, 2012-12-04 at 13:48 +0200, Gleb Natapov wrote:
> > > > > On Mon, Dec 03, 2012 at 04:39:05PM -0700, Alex Williamson wrote:
> > > > > > Memory slots are currently a fixed resource with a relatively small
> > > > > > limit.  When using PCI device assignment in a qemu guest it's fairly
> > > > > > easy to exhaust the number of available slots.  I posted patches
> > > > > > exploring growing the number of memory slots a while ago, but it was
> > > > > > prior to caching memory slot array misses and thefore had potentially
> > > > > > poor performance.  Now that we do that, Avi seemed receptive to
> > > > > > increasing the memory slot array to arbitrary lengths.  I think we
> > > > > > still don't want to impose unnecessary kernel memory consumptions on
> > > > > > guests not making use of this, so I present again a growable memory
> > > > > > slot array.
> > > > > > 
> > > > > > A couple notes/questions; in the previous version we had a
> > > > > > kvm_arch_flush_shadow() call when we increased the number of slots.
> > > > > > I'm not sure if this is still necessary.  I had also made the x86
> > > > > > specific slot_bitmap dynamically grow as well and switch between a
> > > > > > direct bitmap and indirect pointer to a bitmap.  That may have
> > > > > > contributed to needing the flush.  I haven't done that yet here
> > > > > > because it seems like an unnecessary complication if we have a max
> > > > > > on the order of 512 or 1024 entries.  A bit per slot isn't a lot of
> > > > > > overhead.  If we want to go more, maybe we should make it switch.
> > > > > > That leads to the final question, we need an upper bound since this
> > > > > > does allow consumption of extra kernel memory, what should it be?  A
> > > > > This is the most important question :) If we want to have 1000s of
> > > > > them or 100 is enough?
> > > > 
> > > > We can certainly hit respectable numbers of assigned devices in the
> > > > hundreds.  Worst case is 8 slots per assigned device, typical case is 4
> > > > or less.  So 512 slots would more or less guarantee 64 devices (we do
> > > > need some slots for actual memory), and more typically allow at least
> > > > 128 devices.  Philosophically, supporting a full PCI bus, 256 functions,
> > > > 2048 slots, is an attractive target, but it's probably no practical.
> > > > 
> > > > I think on x86 a slot is 72 bytes w/ alignment padding, so a maximum of
> > > > 36k @512 slots.
> > > > 
> > > > >  Also what about changing kvm_memslots->memslots[]
> > > > > array to be "struct kvm_memory_slot *memslots[KVM_MEM_SLOTS_NUM]"? It
> > > > > will save us good amount of memory for unused slots.
> > > > 
> > > > I'm not following where that results in memory savings.  Can you
> > > > clarify.  Thanks,
> > > > 
> > > We will waste sizeof(void*) for each unused slot instead of
> > > sizeof(struct kvm_memory_slot).
> > 
> > Ah, of course.  That means for 512 slots we're wasting a full page just
> > for the pointers, whereas we can fit 56 slots in the same space.  Given
> > that most users get by just fine w/ 32 slots, I don't think that's a win
> > in the typical case.  Maybe if we want to support sparse arrays, but a
> You can look at it differently :). We can increase number of slots to 288
> with the same memory footprint we have now. And 288 looks like a lot of
> slots.

I could settle for 288 slots, but...

288*8 = 2304
2304/72 = 32

So yes, we can fit the pointer array into the same size as 32 slots, but
we haven't allocated the slots themselves yet, so the footprint is not
the same.  Are you thinking we'd re-use the slots between generations
and only allocate new/changed ones?  That still comes out to more memory
per update for the typical case, but we're also adding the indirection
overhead.

> Memory is cheap and getting cheaper and complicated code stays
> complicated. Of course we should not go crazy with wisting memory, but
> not go crazy to save each byte either.

Yep, we could just bump the number of slots and ignore everything else.
512 slots would be 36k on x86.  As above, we're currently using 2.25k.
Is it worth it?  If not, at what point would it be worth it?  50k?
100k?  I think the first 3, maybe 4 patches in this series are still
worthwhile even if we decide not to do anything clever with saving
memory.

> > tree would probably be better at that point.  A drawback of the growable
> > array is that userspace can subvert any savings by using slot N-1 first,
> > but that's why we put a limit at a reasonable size.  Thanks,
> > 
> Why using slot as an index? May be changing id_to_index[] into hash
> table and use that to map from slot id to array index?

It was just to keep thing simple, but yes, we could fix it by allocating
only as necessary.  id_to_index would have more overhead, but maybe we
could restrict ourselves to a short (or byte?) for indexes to save
space.  If we assume 512 slots and use a short for id_to_index[], that's
1k overhead, but we can still allocate 17 slots in the same 2304 bytes
we have now, which likely easily covers typical usage.  I can give it a
try.  Thanks,

Alex

