Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab1FFEX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 00:23:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:19975 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab1FFEX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 00:23:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=hsG7GuSYQ8KbteNze2V0N9UJ/NmLVz+z0XTGvy7d/VDwD24Y3z3CJPsT7PaS8XXrMK
         nONyfTweQkElEMREZPMw==
Date: Sun, 5 Jun 2011 21:23:26 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 1/14] mm: move vmtruncate_range to truncate.c
In-Reply-To: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
Message-ID: <alpine.LSU.2.00.1106052121570.17116@sister.anvils>
References: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You would expect to find vmtruncate_range() next to vmtruncate()
in mm/truncate.c: move it there.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
---
 mm/memory.c   |   24 ------------------------
 mm/truncate.c |   24 ++++++++++++++++++++++++
 2 files changed, 24 insertions(+), 24 deletions(-)

--- linux.orig/mm/memory.c	2011-05-29 18:42:37.441882660 -0700
+++ linux/mm/memory.c	2011-06-05 14:26:36.383176813 -0700
@@ -2796,30 +2796,6 @@ void unmap_mapping_range(struct address_
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
-int vmtruncate_range(struct inode *inode, loff_t offset, loff_t end)
-{
-	struct address_space *mapping = inode->i_mapping;
-
-	/*
-	 * If the underlying filesystem is not going to provide
-	 * a way to truncate a range of blocks (punch a hole) -
-	 * we should return failure right now.
-	 */
-	if (!inode->i_op->truncate_range)
-		return -ENOSYS;
-
-	mutex_lock(&inode->i_mutex);
-	down_write(&inode->i_alloc_sem);
-	unmap_mapping_range(mapping, offset, (end - offset), 1);
-	truncate_inode_pages_range(mapping, offset, end);
-	unmap_mapping_range(mapping, offset, (end - offset), 1);
-	inode->i_op->truncate_range(inode, offset, end);
-	up_write(&inode->i_alloc_sem);
-	mutex_unlock(&inode->i_mutex);
-
-	return 0;
-}
-
 /*
  * We enter with non-exclusive mmap_sem (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
--- linux.orig/mm/truncate.c	2011-05-29 18:42:37.477882839 -0700
+++ linux/mm/truncate.c	2011-06-05 17:16:33.369740944 -0700
@@ -603,3 +603,27 @@ int vmtruncate(struct inode *inode, loff
 	return 0;
 }
 EXPORT_SYMBOL(vmtruncate);
+
+int vmtruncate_range(struct inode *inode, loff_t offset, loff_t end)
+{
+	struct address_space *mapping = inode->i_mapping;
+
+	/*
+	 * If the underlying filesystem is not going to provide
+	 * a way to truncate a range of blocks (punch a hole) -
+	 * we should return failure right now.
+	 */
+	if (!inode->i_op->truncate_range)
+		return -ENOSYS;
+
+	mutex_lock(&inode->i_mutex);
+	down_write(&inode->i_alloc_sem);
+	unmap_mapping_range(mapping, offset, (end - offset), 1);
+	truncate_inode_pages_range(mapping, offset, end);
+	unmap_mapping_range(mapping, offset, (end - offset), 1);
+	inode->i_op->truncate_range(inode, offset, end);
+	up_write(&inode->i_alloc_sem);
+	mutex_unlock(&inode->i_mutex);
+
+	return 0;
+}
