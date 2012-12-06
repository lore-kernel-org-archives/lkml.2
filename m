Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab2LFWUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 17:20:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab2LFWUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 17:20:40 -0500
Subject: [PATCH 00/10] kvm: memory slot cleanups, fix, and increase
To: mtosatti@redhat.com, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Thu, 06 Dec 2012 15:20:06 -0700
Message-ID: <20121206214722.24968.6043.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series does away with any kind of complicated resizing of the
slot array and simply does a one time increase.  I do compact struct
kvm_memory_slot a bit to take better advantage of the space we are
using.  This reduces each slot from 64 bytes (x86_64) to 56 bytes.
By enforcing the API around valid operations for an unused slot and
fields that can be modified runtime, I found and was able to fix a
bug in iommu mapping for slots.  The renames enabled me to find the
previously posted bug fix for catching slot overlaps.

As mentioned in the series, the primary motivation for increasing
memory slots is assigned devices.  With this, I've been able to
assign 30 devices to a single VM and could have gone further, but
ran out of SRIOV VFs.  Typical devices use anywhere from 2-4 slots
and max out at 8 slots.  125 user slots (3 private slots) allows
us to support between 28 and 56 typical devices per VM.

Tested on x86_64, compiled on ia64, powerpc, and s390.

Thanks,
Alex

---

Alex Williamson (10):
      kvm: Restrict non-existing slot state transitions
      kvm: Check userspace_addr when modifying a memory slot
      kvm: Fix iommu map/unmap to handle memory slot moves
      kvm: Minor memory slot optimization
      kvm: Rename KVM_MEMORY_SLOTS -> KVM_USER_MEM_SLOTS
      kvm: Make KVM_PRIVATE_MEM_SLOTS optional
      kvm: struct kvm_memory_slot.user_alloc -> bool
      kvm: struct kvm_memory_slot.flags -> u32
      kvm: struct kvm_memory_slot.id -> short
      kvm: Increase user memory slots on x86 to 125


 arch/ia64/include/asm/kvm_host.h    |    4 --
 arch/ia64/kvm/kvm-ia64.c            |    8 ++--
 arch/powerpc/include/asm/kvm_host.h |    6 +--
 arch/powerpc/kvm/book3s_hv.c        |    2 -
 arch/powerpc/kvm/powerpc.c          |    4 +-
 arch/s390/include/asm/kvm_host.h    |    4 --
 arch/s390/kvm/kvm-s390.c            |    4 +-
 arch/x86/include/asm/kvm_host.h     |    8 ++--
 arch/x86/include/asm/vmx.h          |    6 +--
 arch/x86/kvm/vmx.c                  |    6 +--
 arch/x86/kvm/x86.c                  |   10 ++---
 include/linux/kvm_host.h            |   24 +++++++-----
 virt/kvm/kvm_main.c                 |   72 +++++++++++++++++++++++------------
 13 files changed, 90 insertions(+), 68 deletions(-)
