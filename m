Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab2DCAos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 20:44:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:33891 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab2DCAoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 20:44:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="148910140"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Konstantin Khlebnikov <koct9i@gmail.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Pallipadi Venkatesh <venki@google.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: [x86 PAT PATCH 0/2] x86 PAT vm_flag code refactoring
Date: Mon,  2 Apr 2012 17:46:07 -0700
Message-Id: <1333413969-30761-1-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <20120331170947.7773.46399.stgit@zurg>
References: <20120331170947.7773.46399.stgit@zurg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin,

On Sat, 2012-03-31 at 21:09 +0400, Konstantin Khlebnikov wrote:
> v2: Do not use batched pfn reserving for single-page VMA. This is not optimal
> and breaks something, because I see glitches on the screen with i915/drm driver.
> With this version glitches are gone, and I see the same regions in
> /sys/kernel/debug/x86/pat_memtype_list as before patch. So, please review this
> carefully, probably I'm wrong somewhere, or I have triggered some hidden bug.

Actually it is not a hidden bug. In the original code, we were setting
VM_PFN_AT_MMAP only for remap_pfn_range() but not for the vm_insert_pfn().
Also the value of 'vm_pgoff' depends on the driver/mmap_region() in the case of
vm_insert_pfn(). But with your proposed code, you were setting
the VM_PAT for the single-page VMA also and end-up using wrong vm_pgoff in
untrack_pfn_vma().

We can simplify the track/untrack pfn routines and can remove the
dependency on vm_pgoff completely. Am appending a patch which does this
and also modified your x86 PAT patch based on this. Can you please
check and if you are ok, merge these bits with the rest of your patches.

thanks,
suresh
---

Konstantin Khlebnikov (1):
  mm, x86, PAT: rework linear pfn-mmap tracking

Suresh Siddha (1):
  x86, pat: remove the dependency on 'vm_pgoff' in track/untrack pfn
    vma routines

 arch/x86/mm/pat.c             |   38 ++++++++++++++++++++++++--------------
 include/asm-generic/pgtable.h |    4 ++--
 include/linux/mm.h            |   15 +--------------
 mm/huge_memory.c              |    7 +++----
 mm/memory.c                   |   15 ++++++++-------
 5 files changed, 38 insertions(+), 41 deletions(-)

-- 
1.7.6.5

