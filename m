Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab2DEX7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 19:59:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:59222 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab2DEX7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 19:59:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="85890044"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Pallipadi Venkatesh <venki@google.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: [v3 VM_PAT PATCH 0/3] x86 VM_PAT series
Date: Thu,  5 Apr 2012 17:01:32 -0700
Message-Id: <1333670495-7016-1-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <4F7D8860.3040008@openvz.org>
References: <4F7D8860.3040008@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-05 at 15:56 +0400, Konstantin Khlebnikov wrote:
> With this patches I see new ranges in /sys/kernel/debug/x86/pat_memtype_list
> This is 4k single-page vma mappged by X11. kernel fills them via vm_insert_pfn().
> Is this ok?

This is expected and I saw these new entries too (but not as many as you saw), as the
patch is tracking single page vma's coming from vm_insert_pfn() interface too.

Thinking a bit more about this in the context of your numbers, those new entries that
are getting tracked are not adding any new value. As the driver has already reserved the
whole aperture with write-combining attribute, tracking these single page vma's doesn't
help anymore.

> Maybe we shouldn't use PAT for small VMA?

For vm_insert_pfn(), expectation is that we just look up the memory attribute.
And for remap_pfn_range(), if the whole VMA is remapped, we reserve the new
attribute for the specified pfn-range, as typically drivers
call remap_pfn_range() for the whole VMA (can be a single page) with the desired
attribute (with out the prior reservation of the memory attribute for the pfn range).
So exposing two different API's for this behavior is probably the better way
to address this in a clean way. Revised patches follows.

Konstantin Khlebnikov (1):
  mm, x86, PAT: rework linear pfn-mmap tracking

Suresh Siddha (2):
  x86, pat: remove the dependency on 'vm_pgoff' in track/untrack pfn
    vma routines
  x86, pat: separate the pfn attribute tracking for remap_pfn_range and
    vm_insert_pfn

 arch/x86/mm/pat.c             |   80 ++++++++++++++++++++++++++++------------
 include/asm-generic/pgtable.h |   57 +++++++++++++++++------------
 include/linux/mm.h            |   15 +-------
 mm/huge_memory.c              |    7 ++--
 mm/memory.c                   |   23 +++++-------
 5 files changed, 104 insertions(+), 78 deletions(-)

-- 
1.7.6.5
