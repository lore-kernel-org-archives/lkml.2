Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab2LDPbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 10:31:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab2LDPbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 10:31:03 -0500
Date: Tue, 4 Dec 2012 17:30:43 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] kvm: Growable memory slot array
Message-ID: <20121204153043.GA14176@redhat.com>
References: <20121203231912.3661.57179.stgit@bling.home>
 <20121204114803.GH19514@redhat.com>
 <1354634515.1809.406.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354634515.1809.406.camel@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 08:21:55AM -0700, Alex Williamson wrote:
> On Tue, 2012-12-04 at 13:48 +0200, Gleb Natapov wrote:
> > On Mon, Dec 03, 2012 at 04:39:05PM -0700, Alex Williamson wrote:
> > > Memory slots are currently a fixed resource with a relatively small
> > > limit.  When using PCI device assignment in a qemu guest it's fairly
> > > easy to exhaust the number of available slots.  I posted patches
> > > exploring growing the number of memory slots a while ago, but it was
> > > prior to caching memory slot array misses and thefore had potentially
> > > poor performance.  Now that we do that, Avi seemed receptive to
> > > increasing the memory slot array to arbitrary lengths.  I think we
> > > still don't want to impose unnecessary kernel memory consumptions on
> > > guests not making use of this, so I present again a growable memory
> > > slot array.
> > > 
> > > A couple notes/questions; in the previous version we had a
> > > kvm_arch_flush_shadow() call when we increased the number of slots.
> > > I'm not sure if this is still necessary.  I had also made the x86
> > > specific slot_bitmap dynamically grow as well and switch between a
> > > direct bitmap and indirect pointer to a bitmap.  That may have
> > > contributed to needing the flush.  I haven't done that yet here
> > > because it seems like an unnecessary complication if we have a max
> > > on the order of 512 or 1024 entries.  A bit per slot isn't a lot of
> > > overhead.  If we want to go more, maybe we should make it switch.
> > > That leads to the final question, we need an upper bound since this
> > > does allow consumption of extra kernel memory, what should it be?  A
> > This is the most important question :) If we want to have 1000s of
> > them or 100 is enough?
> 
> We can certainly hit respectable numbers of assigned devices in the
> hundreds.  Worst case is 8 slots per assigned device, typical case is 4
> or less.  So 512 slots would more or less guarantee 64 devices (we do
> need some slots for actual memory), and more typically allow at least
> 128 devices.  Philosophically, supporting a full PCI bus, 256 functions,
> 2048 slots, is an attractive target, but it's probably no practical.
> 
> I think on x86 a slot is 72 bytes w/ alignment padding, so a maximum of
> 36k @512 slots.
> 
> >  Also what about changing kvm_memslots->memslots[]
> > array to be "struct kvm_memory_slot *memslots[KVM_MEM_SLOTS_NUM]"? It
> > will save us good amount of memory for unused slots.
> 
> I'm not following where that results in memory savings.  Can you
> clarify.  Thanks,
> 
We will waste sizeof(void*) for each unused slot instead of
sizeof(struct kvm_memory_slot).

--
			Gleb.
