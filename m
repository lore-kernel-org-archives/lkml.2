Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1BVSyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:54:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab1BVSyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:54:54 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [RFC PATCH 0/3] Weight-balanced binary tree + KVM growable memory
	slots using wbtree
To: avi@redhat.com
Cc: alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, mtosatti@redhat.com, xiaoguangrong@cn.fujitsu.com
Date: Tue, 22 Feb 2011 11:54:49 -0700
Message-ID: <20110222183822.22026.62832.stgit@s20.home>
In-Reply-To: <1298386481.5764.60.camel@x201>
References: <1298386481.5764.60.camel@x201>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series introduces a new weight-balanced binary tree (wbtree) for
general use.  It's largely leveraged from the rbtree, copying it's
rotate functions, while introducing different rebalance and erase
functions.  This tree is particularly useful for managing memory
ranges, where it's desirable to have the most likely targets (the
largest ranges) at the top of each subtree.

Patches 2 & 3 go on to convert the KVM memory slots to a growable
array and make use of wbtree for efficient managment.  Trying to
exercise the worst case for this data structure, I ran netperf
TCP_RR on an emulated rtl8139 NIC connected directly to the host
via a tap.  Both qemu-kvm and the netserver on the host were
pinned to optimal CPUs with taskset.  This series resulted in
a 3% improvement for this test.

Note that part of why this series is RFC is that the print_tree
function in the last patch is debug code that generates output
for dot.  You can copy the output to a file and run:

  dot -Tpdf foo.dot > foo.pdf

to generate a nice diagram of the tree currently in use.  I'll
follow-up with a few examples.  Thanks,

Alex

---

Alex Williamson (3):
      kvm: Use weight-balanced tree for memory slot management
      kvm: Allow memory slot array to grow on demand
      Weight-balanced tree


 arch/ia64/include/asm/kvm_host.h    |    4 -
 arch/ia64/kvm/kvm-ia64.c            |    2 
 arch/powerpc/include/asm/kvm_host.h |    3 
 arch/s390/include/asm/kvm_host.h    |    3 
 arch/x86/include/asm/kvm_host.h     |    5 -
 arch/x86/include/asm/vmx.h          |    6 -
 arch/x86/kvm/mmu.c                  |   32 ++++-
 arch/x86/kvm/x86.c                  |    6 -
 include/linux/kvm_host.h            |   25 ++++
 include/linux/wbtree.h              |   55 +++++++++
 lib/Makefile                        |    3 
 lib/wbtree.c                        |  170 ++++++++++++++++++++++++++
 virt/kvm/kvm_main.c                 |  226 +++++++++++++++++++++++++++--------
 13 files changed, 464 insertions(+), 76 deletions(-)
 create mode 100644 include/linux/wbtree.h
 create mode 100644 lib/wbtree.c
