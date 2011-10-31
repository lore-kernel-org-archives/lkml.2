Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab1JaQRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 12:17:21 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:33607 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920Ab1JaQRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 12:17:19 -0400
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: [PATCH] fadvise: only initiate writeback for specified range with FADV_DONTNEED
Date: Mon, 31 Oct 2011 11:16:59 -0500
Message-Id: <1320077819-1494-1-git-send-email-sbohrer@rgmadvisors.com>
X-Mailer: git-send-email 1.7.6
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

