Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1EaAhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 20:37:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8571 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab1EaAg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 20:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=u58YdY1vyLIxGWYse2BJdWltNnaDmH2X4hdPjiWFTwIC/nwtYgTAWEX3DY4eQrjDjh
         ezylaAyB7QBTOml3nx8Q==
Date: Mon, 30 May 2011 17:36:57 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 2/14] mm: move vmtruncate_range to truncate.c
In-Reply-To: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
Message-ID: <alpine.LSU.2.00.1105301735520.5482@sister.anvils>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You would expect to find vmtruncate_range() next to vmtruncate()
in mm/truncate.c: move it there.

Signed-off-by: Hugh Dickins <hughd@google.co>
---
 mm/memory.c   |   24 ------------------------
 mm/truncate.c |   24 ++++++++++++++++++++++++
 2 files changed, 24 insertions(+), 24 deletions(-)

--- linux.orig/mm/memory.c	2011-05-30 13:56:10.416798124 -0700
+++ linux/mm/memory.c	2011-05-30 14:09:52.908876549 -0700
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
--- linux.orig/mm/truncate.c	2011-05-30 14:08:46.612547848 -0700
+++ linux/mm/truncate.c	2011-05-30 14:09:52.912876640 -0700
@@ -605,3 +605,27 @@ int vmtruncate(struct inode *inode, loff
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
