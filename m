Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946221Ab2ERXC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:02:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53524 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946199Ab2ERXCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:02:51 -0400
Message-Id: <20120518211559.805734534@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
        Yanmin Zhang <yanmin.zhang@intel.com>, ShuoX Liu <shuox.liu@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 04/54] percpu, x86: dont use PMD_SIZE as embedded atom_size on 32bit
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit d5e28005a1d2e67833852f4c9ea8ec206ea3ff85 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/setup_percpu.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

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


