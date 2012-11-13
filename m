Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab2KMGsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 01:48:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:28309 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab2KMGsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 01:48:39 -0500
X-AuditID: cbfee61b-b7f616d00000319b-54-50a1ed463f65
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2] mm: cma: WARN if freed memory is still in use
Date: Tue, 13 Nov 2012 07:47:51 +0100
Message-id: <1352789271-18461-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <xa1t8va6zsad.fsf@mina86.com>
References: <xa1t8va6zsad.fsf@mina86.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJMWRmVeSWpSXmKPExsVy+t9jQV23twsDDC7NlrC4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZzz4vZClYxl6x+tpt5gbGX6xdjBwcEgImEncbmLsYOYFMMYkL
	99azgdhCAtMZJXY91ehi5AKyVzBJ7NrzmRUkwSZgKNH1tgusSEQgTOJP4zZWkCJmkKKLd/eB
	FQkLOErMO/qaCcRmEVCVeH11JyOIzSvgIfH58Fk2iMUKEnMm2YCEOQW0JO5MesIOsVhTYnHH
	ZbYJjLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgT7+5n0DsZVDRaHGAU4GJV4eBUt
	FwYIsSaWFVfmHmKU4GBWEuE1rwcK8aYkVlalFuXHF5XmpBYfYpTmYFES5232SAkQEkhPLEnN
	Tk0tSC2CyTJxcEo1MEof5bEv8BRb/dv28Db3eQbHdrE8XKzLzdLuXvAw+gS/smHJjJZyfUv5
	Fa6L/ty+tLTF5QznlCDLquYv8h2Xbzae/Kj2UkjojZ5d+ONNN9K07ZSXR+9cuUzxZEjVpmXb
	ecV3Pau4srVG1USwToo/IPyyaF7cyb5iq7lZFxNarUPtWf893H+ZSYmlOCPRUIu5qDgRABbO
	GsLzAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory returned to free_contig_range() must have no other references. Let
kernel to complain loudly if page reference count is not equal to 1.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Michal Nazarewicz <mina86@mina86.com>
---
 mm/page_alloc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 022e4ed..290c2eb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5888,8 +5888,13 @@ done:
 
 void free_contig_range(unsigned long pfn, unsigned nr_pages)
 {
-	for (; nr_pages--; ++pfn)
-		__free_page(pfn_to_page(pfn));
+	struct page *page = pfn_to_page(pfn);
+	int count = 0;
+	for (; nr_pages--; page++) {
+		count += page_count(page) != 1;
+		__free_page(page);
+	}
+	WARN(count != 0, "%d pages are still in use!\n", count);
 }
 #endif
 
-- 
1.7.9.5

