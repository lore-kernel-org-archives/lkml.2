Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918Ab2D0Rjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:39:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40196 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab2D0Rjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:39:39 -0400
Date: Fri, 27 Apr 2012 10:39:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: ShuoX Liu <shuox.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2] percpu, x86: don't use PMD_SIZE as embedded atom_size
 on 32bit
Message-ID: <20120427173935.GE26595@google.com>
References: <4F97BA98.6010001@intel.com>
 <20120425222429.GE8989@google.com>
 <1335405672.14538.135.camel@ymzhang.sh.intel.com>
 <20120426224946.GG27486@google.com>
 <1335488964.14538.159.camel@ymzhang.sh.intel.com>
 <1335516994.14538.160.camel@ymzhang.sh.intel.com>
 <20120427165356.GA26595@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427165356.GA26595@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the embed percpu first chunk allocator, x86 uses either PAGE_SIZE
or PMD_SIZE for atom_size.  PMD_SIZE is used when CPU supports PSE so
that percpu areas are aligned to PMD mappings and possibly allow using
PMD mappings in vmalloc areas in the future.  Using larger atom_size
doesn't waste actual memory; however, it does require larger vmalloc
space allocation later on for !first chunks.

With reasonably sized vmalloc area, PMD_SIZE shouldn't be a problem
but x86_32 at this point is anything but reasonable in terms of
address space and using larger atom_size reportedly leads to frequent
percpu allocation failures on certain setups.

As there is no reason to not use PMD_SIZE on x86_64 as vmalloc space
is aplenty and most x86_64 configurations support PSE, fix the issue
by always using PMD_SIZE on x86_64 and PAGE_SIZE on x86_32.

v2: drop cpu_has_pse test and make x86_64 always use PMD_SIZE and
    x86_32 PAGE_SIZE as suggested by hpa.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Yanmin Zhang <yanmin.zhang@intel.com>
Reported-by: ShuoX Liu <shuox.liu@intel.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <4F97BA98.6010001@intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/setup_percpu.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 71f4727..5a98aa2 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -185,10 +185,22 @@ void __init setup_per_cpu_areas(void)
 #endif
 	rc = -EINVAL;
 	if (pcpu_chosen_fc != PCPU_FC_PAGE) {
-		const size_t atom_size = cpu_has_pse ? PMD_SIZE : PAGE_SIZE;
 		const size_t dyn_size = PERCPU_MODULE_RESERVE +
 			PERCPU_DYNAMIC_RESERVE - PERCPU_FIRST_CHUNK_RESERVE;
+		size_t atom_size;
 
+		/*
+		 * On 64bit, use PMD_SIZE for atom_size so that embedded
+		 * percpu areas are aligned to PMD.  This, in the future,
+		 * can also allow using PMD mappings in vmalloc area.  Use
+		 * PAGE_SIZE on 32bit as vmalloc space is highly contended
+		 * and large vmalloc area allocs can easily fail.
+		 */
+#ifdef CONFIG_X86_64
+		atom_size = PMD_SIZE;
+#else
+		atom_size = PAGE_SIZE;
+#endif
 		rc = pcpu_embed_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
 					    dyn_size, atom_size,
 					    pcpu_cpu_distance,
