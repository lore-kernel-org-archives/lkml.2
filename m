Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab0FCX4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 19:56:17 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:38671 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756149Ab0FCX4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 19:56:07 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [PATCH 3/6] writeback: Add tracing to write_cache_pages
Date: Fri,  4 Jun 2010 09:55:25 +1000
Message-Id: <1275609328-12514-4-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275609328-12514-1-git-send-email-david@fromorbit.com>
References: <1275609328-12514-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a trace event to the ->writepage loop in write_cache_pages to give
visibility into how the ->writepage call is changing variables within the
writeback control structure. Of most interest is how wbc->nr_to_write changes
from call to call, especially with filesystems that write multiple pages
in ->writepage.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/trace/events/writeback.h |    1 +
 mm/page-writeback.c              |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 72c1a12..5dda40e 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -244,6 +244,7 @@ DEFINE_WBC_EVENT(wbc_writeback_wait);
 DEFINE_WBC_EVENT(wbc_balance_dirty_start);
 DEFINE_WBC_EVENT(wbc_balance_dirty_written);
 DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
+DEFINE_WBC_EVENT(wbc_writepage);
 
 #endif /* _TRACE_WRITEBACK_H */
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 68eb727..caaf954 100644
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

