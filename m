Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab0FHAjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:39:17 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:38723 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752077Ab0FHAjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:39:13 -0400
From: Dave Chinner <david@fromorbit.com>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [PATCH 6/6] writeback: limit write_cache_pages integrity scanning to current EOF
Date: Tue,  8 Jun 2010 10:38:07 +1000
Message-Id: <1275957487-23633-7-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275957487-23633-1-git-send-email-david@fromorbit.com>
References: <1275957487-23633-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

sync can currently take a really long time if a concurrent writer is
extending a file. The problem is that the dirty pages on the address
space grow in the same direction as write_cache_pages scans, so if
the writer keeps ahead of writeback, the writeback will not
terminate until the writer stops adding dirty pages.

For a data integrity sync, we only need to write the pages dirty at
the time we start the writeback, so we can stop scanning once we get
to the page that was at the end of the file at the time the scan
started.

This will prevent operations like copying a large file preventing
sync from completing as it will not write back pages that were
dirtied after the sync was started. This does not impact the
existing integrity guarantees, as any dirty page (old or new)
within the EOF range at the start of the scan will still be
captured.

This patch will not prevent sync from blocking on large writes into
holes. That requires more complex intervention while this patch only
addresses the common append-case of this sync holdoff.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mm/page-writeback.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0acadee..1a361f0 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -855,7 +855,22 @@ int write_cache_pages(struct address_space *mapping,
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
 		cycled = 1; /* ignore range_cyclic tests */
+
+		/*
+		 * If this is a data integrity sync, cap the writeback to the
+		 * current end of file. Any extension to the file that occurs
+		 * after this is a new write and we don't need to write those
+		 * pages out to fulfil our data integrity requirements. If we
+		 * try to write them out, we can get stuck in this scan until
+		 * the concurrent writer stops adding dirty pages and extending
+		 * EOF.
+		 */
+		if (wbc->sync_mode == WB_SYNC_ALL &&
+		    wbc->range_end == LLONG_MAX) {
+			end = i_size_read(mapping->host) >> PAGE_CACHE_SHIFT;
+		}
 	}
+
 retry:
 	done_index = index;
 	while (!done && (index <= end)) {
-- 
1.7.1

