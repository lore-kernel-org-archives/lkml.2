Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab0FHAjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:39:09 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:47904 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751670Ab0FHAjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:39:04 -0400
From: Dave Chinner <david@fromorbit.com>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [PATCH 3/6] writeback: Add tracing to write_cache_pages
Date: Tue,  8 Jun 2010 10:38:04 +1000
Message-Id: <1275957487-23633-4-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275957487-23633-1-git-send-email-david@fromorbit.com>
References: <1275957487-23633-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Add a trace event to the ->writepage loop in write_cache_pages to give
visibility into how the ->writepage call is changing variables within the
writeback control structure. Of most interest is how wbc->nr_to_write changes
from call to call, especially with filesystems that write multiple pages
in ->writepage.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/trace/events/writeback.h |    1 +
 mm/page-writeback.c              |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 7867c16..6797c46 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -244,6 +244,7 @@ DEFINE_WBC_EVENT(wbc_writeback_wait);
 DEFINE_WBC_EVENT(wbc_balance_dirty_start);
 DEFINE_WBC_EVENT(wbc_balance_dirty_written);
 DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
+DEFINE_WBC_EVENT(wbc_writepage);
 
 #endif /* _TRACE_WRITEBACK_H */
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 345a730..7ac39c5 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -921,6 +921,7 @@ continue_unlock:
 			if (!clear_page_dirty_for_io(page))
 				goto continue_unlock;
 
+			trace_wbc_writepage(wbc);
 			ret = (*writepage)(page, wbc, data);
 			if (unlikely(ret)) {
 				if (ret == AOP_WRITEPAGE_ACTIVATE) {
-- 
1.7.1

