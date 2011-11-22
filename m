Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959Ab1KVXBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 18:01:48 -0500
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:52756 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802Ab1KVXBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 18:01:47 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: [PATCH resend] fadvise: only initiate writeback for specified range with FADV_DONTNEED
Date: Tue, 22 Nov 2011 17:01:17 -0600
Message-Id: <1322002877-5464-1-git-send-email-sbohrer@rgmadvisors.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <20111101150555.GC19965@redhat.com>
References: <20111101150555.GC19965@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously POSIX_FADV_DONTNEED would start writeback for the entire file
when the bdi was not write congested.  This negatively impacts
performance if the file contians dirty pages outside of the requested
range.  This change uses __filemap_fdatawrite_range() to only initiate
writeback for the requested range.

Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
---

Andrew is this something you could apply?

 mm/fadvise.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/fadvise.c b/mm/fadvise.c
index 8d723c9..469491e 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -117,7 +117,8 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
 		break;
 	case POSIX_FADV_DONTNEED:
 		if (!bdi_write_congested(mapping->backing_dev_info))
-			filemap_flush(mapping);
+			__filemap_fdatawrite_range(mapping, offset, endbyte,
+						   WB_SYNC_NONE);
 
 		/* First and last FULL page! */
 		start_index = (offset+(PAGE_CACHE_SIZE-1)) >> PAGE_CACHE_SHIFT;
-- 
1.7.6



---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

