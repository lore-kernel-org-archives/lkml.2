Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab2AWXw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:52:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853Ab2AWXve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:51:34 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:30 2012
Message-Id: <20120123234030.351967279@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:40:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: [87/90] mm: fix NULL ptr dereference in __count_immobile_pages
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Hocko <mhocko@suse.cz>

commit 687875fb7de4a95223af20ee024282fa9099f860 upstream.

Fix the following NULL ptr dereference caused by

  cat /sys/devices/system/memory/memory0/removable

Pid: 13979, comm: sed Not tainted 3.0.13-0.5-default #1 IBM BladeCenter LS21 -[7971PAM]-/Server Blade
RIP: __count_immobile_pages+0x4/0x100
Process sed (pid: 13979, threadinfo ffff880221c36000, task ffff88022e788480)
Call Trace:
  is_pageblock_removable_nolock+0x34/0x40
  is_mem_section_removable+0x74/0xf0
  show_mem_removable+0x41/0x70
  sysfs_read_file+0xfe/0x1c0
  vfs_read+0xc7/0x130
  sys_read+0x53/0xa0
  system_call_fastpath+0x16/0x1b

We are crashing because we are trying to dereference NULL zone which
came from pfn=0 (struct page ffffea0000000000). According to the boot
log this page is marked reserved:
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)

and early_node_map confirms that:
early_node_map[3] active PFN ranges
    1: 0x00000010 -> 0x0000009c
    1: 0x00000100 -> 0x000bffa3
    1: 0x00100000 -> 0x00240000

The problem is that memory_present works in PAGE_SECTION_MASK aligned
blocks so the reserved range sneaks into the the section as well.  This
also means that free_area_init_node will not take care of those reserved
pages and they stay uninitialized.

When we try to read the removable status we walk through all available
sections and hope that the zone is valid for all pages in the section.
But this is not true in this case as the zone and nid are not initialized.

We have only one node in this particular case and it is marked as node=1
(rather than 0) and that made the problem visible because page_to_nid will
return 0 and there are no zones on the node.

Let's check that the zone is valid and that the given pfn falls into its
boundaries and mark the section not removable.  This might cause some
false positives, probably, but we do not have any sane way to find out
whether the page is reserved by the platform or it is just not used for
whatever other reasons.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page_alloc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5565,6 +5565,17 @@ __count_immobile_pages(struct zone *zone
 bool is_pageblock_removable_nolock(struct page *page)
 {
 	struct zone *zone = page_zone(page);
+	unsigned long pfn = page_to_pfn(page);
+
+	/*
+	 * We have to be careful here because we are iterating over memory
+	 * sections which are not zone aware so we might end up outside of
+	 * the zone but still within the section.
+	 */
+	if (!zone || zone->zone_start_pfn > pfn ||
+			zone->zone_start_pfn + zone->spanned_pages <= pfn)
+		return false;
+
 	return __count_immobile_pages(zone, page, 0);
 }
 


