Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab2LEW5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 17:57:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab2LEW5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 17:57:49 -0500
Message-ID: <1354748268.3224.57.camel@bling.home>
Subject: Re: [RFC PATCH 0/6] kvm: Growable memory slot array
From: Alex Williamson <alex.williamson@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, gleb@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 05 Dec 2012 15:57:48 -0700
In-Reply-To: <20121205213203.GE20260@amt.cnet>
References: <20121203231912.3661.57179.stgit@bling.home>
	 <20121205213203.GE20260@amt.cnet>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-05 at 19:32 -0200, Marcelo Tosatti wrote:
> On Mon, Dec 03, 2012 at 04:39:05PM -0700, Alex Williamson wrote:
> > Memory slots are currently a fixed resource with a relatively small
> > limit.  When using PCI device assignment in a qemu guest it's fairly
> > easy to exhaust the number of available slots.  I posted patches
> > exploring growing the number of memory slots a while ago, but it was
> > prior to caching memory slot array misses and thefore had potentially
> > poor performance.  Now that we do that, Avi seemed receptive to
> > increasing the memory slot array to arbitrary lengths.  I think we
> > still don't want to impose unnecessary kernel memory consumptions on
> > guests not making use of this, so I present again a growable memory
> > slot array.
> > 
> > A couple notes/questions; in the previous version we had a
> > kvm_arch_flush_shadow() call when we increased the number of slots.
> > I'm not sure if this is still necessary.  I had also made the x86
> > specific slot_bitmap dynamically grow as well and switch between a
> > direct bitmap and indirect pointer to a bitmap.  That may have
> > contributed to needing the flush.  
> 
> I don't remember. Do you recall what was the argument back then?
> (there must have been some).

I vaguely recall chatting with you on irc about it before posting, so
unfortunately there's no list discussion.  It's been almost 2 years, so
it's not surprising we've all forgotten.  Here's the original post:

http://article.gmane.org/gmane.linux.kernel/1103962

(click on the subject to get to the thread)  That version also included
an optimization to the x86-only slot_bitmap, and it's entirely possible
the flush had more to do with that than the memslots themselves.  I
think Avi kind of alludes to this in his first reply that the flushing
is more aggressive than necessary and indicates it could happen only
when crossing BITS_PER_LONG boundaries.

> > I haven't done that yet here
> > because it seems like an unnecessary complication if we have a max
> > on the order of 512 or 1024 entries.  A bit per slot isn't a lot of
> > overhead.  If we want to go more, maybe we should make it switch.
> > That leads to the final question, we need an upper bound since this
> > does allow consumption of extra kernel memory, what should it be?  A
> > PCI bus filled with assigned devices can theorically use up to 2048
> > slots (32 devices * 8 functions * (6 BARs + ROM + possibly split
> > MSI-X BAR)).  For this RFC, I don't change the max, just make it
> > grow up to 32 user slots.  Untested on anything but x86 so far.
> > Thanks,
> 
> Not sure. Some reasonable number based on current usage expectations?
> (can be increased later if necessary).

The first obvious step is to double it to 64 slots.  With typical
devices, that would give us 16+ assigned devices.  There are already
people bumping into the 8 device limit we set in RHEL, so doubling it
doesn't feel like much headroom.

If we double again to 128 slots then we can likely support 32 typical
devices.  That's a full PCI bus of single function devices.  That's
probably the first acceptable step.

It looks like each slot on x86_64 is 64bytes (somehow I was throwing
around 72bytes before, not sure where I counted wrong), so we currently
have:

32 user + 4 private slots = 36*64 = 2304
32+4 id_to_index = 36*4 = 144
32+4 entry slot_bitmap = 8
Total = 2456

At 132 (128+4), this becomes 8448 + 528 + 24 = 9000 bytes

We can actually compact struct kvm_memory_slot down to 56 bytes (flags
-> u32, user_alloc -> bool, id -> short), which also cuts id_to_index in
half, so that gives us: 7392 + 264 + 24 = 7680

(I might sacrifice a couple user slots just to make these powers of 2,
ie. 124 user + 4 private = 128, 7440 bytes)

Should we target that as a first step and ignore all this extra
complication?  Thanks,

Alex

