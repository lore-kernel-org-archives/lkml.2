Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032395Ab2I1UZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:25:59 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61998 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031750Ab2I1UZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:25:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Xishi Qiu <qiuxishi@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        Mel Gorman <mgorman@suse.de>, "Luck, Tony" <tony.luck@intel.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 082/218] memory hotplug: fix section info double registration bug
Date: Fri, 28 Sep 2012 13:14:59 -0700
Message-Id: <20120928201510.966871186@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: qiuxishi <qiuxishi@gmail.com>

commit f14851af0ebb32745c6c5a2e400aa0549f9d20df upstream.

There may be a bug when registering section info.  For example, on my
Itanium platform, the pfn range of node0 includes the other nodes, so
other nodes' section info will be double registered, and memmap's page
count will equal to 3.

  node0: start_pfn=0x100,    spanned_pfn=0x20fb00, present_pfn=0x7f8a3, => 0x000100-0x20fc00
  node1: start_pfn=0x80000,  spanned_pfn=0x80000,  present_pfn=0x80000, => 0x080000-0x100000
  node2: start_pfn=0x100000, spanned_pfn=0x80000,  present_pfn=0x80000, => 0x100000-0x180000
  node3: start_pfn=0x180000, spanned_pfn=0x80000,  present_pfn=0x80000, => 0x180000-0x200000

  free_all_bootmem_node()
	register_page_bootmem_info_node()
		register_page_bootmem_info_section()

When hot remove memory, we can't free the memmap's page because
page_count() is 2 after put_page_bootmem().

  sparse_remove_one_section()
	free_section_usemap()
		free_map_bootmem()
			put_page_bootmem()

[akpm@linux-foundation.org: add code comment]
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory_hotplug.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -127,9 +127,6 @@ static void register_page_bootmem_info_s
 	struct mem_section *ms;
 	struct page *page, *memmap;
 
-	if (!pfn_valid(start_pfn))
-		return;
-
 	section_nr = pfn_to_section_nr(start_pfn);
 	ms = __nr_to_section(section_nr);
 
@@ -188,9 +185,16 @@ void register_page_bootmem_info_node(str
 	end_pfn = pfn + pgdat->node_spanned_pages;
 
 	/* register_section info */
-	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION)
-		register_page_bootmem_info_section(pfn);
-
+	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+		/*
+		 * Some platforms can assign the same pfn to multiple nodes - on
+		 * node0 as well as nodeN.  To avoid registering a pfn against
+		 * multiple nodes we check that this pfn does not already
+		 * reside in some other node.
+		 */
+		if (pfn_valid(pfn) && (pfn_to_nid(pfn) == node))
+			register_page_bootmem_info_section(pfn);
+	}
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 


