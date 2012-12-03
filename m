Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab2LCXjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 18:39:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab2LCXjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 18:39:07 -0500
Subject: [RFC PATCH 0/6] kvm: Growable memory slot array
To: mtosatti@redhat.com, kvm@vger.kernel.org, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 03 Dec 2012 16:39:05 -0700
Message-ID: <20121203231912.3661.57179.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory slots are currently a fixed resource with a relatively small
limit.  When using PCI device assignment in a qemu guest it's fairly
easy to exhaust the number of available slots.  I posted patches
exploring growing the number of memory slots a while ago, but it was
prior to caching memory slot array misses and thefore had potentially
poor performance.  Now that we do that, Avi seemed receptive to
increasing the memory slot array to arbitrary lengths.  I think we
still don't want to impose unnecessary kernel memory consumptions on
guests not making use of this, so I present again a growable memory
slot array.

A couple notes/questions; in the previous version we had a
kvm_arch_flush_shadow() call when we increased the number of slots.
I'm not sure if this is still necessary.  I had also made the x86
specific slot_bitmap dynamically grow as well and switch between a
direct bitmap and indirect pointer to a bitmap.  That may have
contributed to needing the flush.  I haven't done that yet here
because it seems like an unnecessary complication if we have a max
on the order of 512 or 1024 entries.  A bit per slot isn't a lot of
overhead.  If we want to go more, maybe we should make it switch.
That leads to the final question, we need an upper bound since this
does allow consumption of extra kernel memory, what should it be?  A
PCI bus filled with assigned devices can theorically use up to 2048
slots (32 devices * 8 functions * (6 BARs + ROM + possibly split
MSI-X BAR)).  For this RFC, I don't change the max, just make it
grow up to 32 user slots.  Untested on anything but x86 so far.
Thanks,

Alex
---

Alex Williamson (6):
      kvm: Rename KVM_MEMORY_SLOTS -> KVM_USER_MEM_SLOTS
      kvm: Make KVM_PRIVATE_MEM_SLOTS optional
      kvm: Merge id_to_index into memslots
      kvm: Move private memory slots to start of memslots array
      kvm: Re-introduce memslots->nmemslots
      kvm: Allow memory slots to grow


 arch/ia64/include/asm/kvm_host.h    |    4 --
 arch/ia64/kvm/kvm-ia64.c            |    6 +--
 arch/powerpc/include/asm/kvm_host.h |    6 +--
 arch/powerpc/kvm/book3s_hv.c        |    4 +-
 arch/s390/include/asm/kvm_host.h    |    4 --
 arch/x86/include/asm/kvm_host.h     |    8 ++-
 arch/x86/include/asm/vmx.h          |    6 +--
 arch/x86/kvm/vmx.c                  |    3 +
 arch/x86/kvm/x86.c                  |   10 +++-
 include/linux/kvm_host.h            |   20 +++++---
 virt/kvm/kvm_main.c                 |   83 ++++++++++++++++++++++++-----------
 11 files changed, 93 insertions(+), 61 deletions(-)
