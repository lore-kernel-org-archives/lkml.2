Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032893Ab2I1Ubc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:31:32 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36926 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965071Ab2I1UbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:31:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Yinghai Lu <yinghai@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 184/218] mm: sparse: fix usemap allocation above node descriptor section
Date: Fri, 28 Sep 2012 13:16:41 -0700
Message-Id: <20120928201522.617288689@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 99ab7b19440a72ebdf225f99b20f8ef40decee86 upstream.

After commit f5bf18fa22f8 ("bootmem/sparsemem: remove limit constraint
in alloc_bootmem_section"), usemap allocations may easily be placed
outside the optimal section that holds the node descriptor, even if
there is space available in that section.  This results in unnecessary
hotplug dependencies that need to have the node unplugged before the
section holding the usemap.

The reason is that the bootmem allocator doesn't guarantee a linear
search starting from the passed allocation goal but may start out at a
much higher address absent an upper limit.

Fix this by trying the allocation with the limit at the section end,
then retry without if that fails.  This keeps the fix from f5bf18fa22f8
of not panicking if the allocation does not fit in the section, but
still makes sure to try to stay within the section at first.

[rewritten massively by Johannes to apply to 3.4]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

---
 mm/bootmem.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -766,13 +766,17 @@ void * __init alloc_bootmem_section(unsi
 				    unsigned long section_nr)
 {
 	bootmem_data_t *bdata;
-	unsigned long pfn, goal;
+	unsigned long pfn, goal, limit;
 
 	pfn = section_nr_to_pfn(section_nr);
 	goal = pfn << PAGE_SHIFT;
+	limit = section_nr_to_pfn(section_nr + 1) << PAGE_SHIFT;
 	bdata = &bootmem_node_data[early_pfn_to_nid(pfn)];
 
-	return alloc_bootmem_core(bdata, size, SMP_CACHE_BYTES, goal, 0);
+	if (goal + size > limit)
+		limit = 0;
+
+	return alloc_bootmem_core(bdata, size, SMP_CACHE_BYTES, goal, limit);
 }
 #endif
 


