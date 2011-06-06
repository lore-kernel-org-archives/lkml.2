Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab1FFEch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 00:32:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:26562 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1FFEcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 00:32:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=V8JTGhD4SlR3OP1kmm4RRvG/zUqtZGCDg63iH2DzKg6dCOSS5XRZUtKtqd65UXj07y
         1vOSvDtXOwbZodqvySXA==
Date: Sun, 5 Jun 2011 21:32:34 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 7/14] drm/i915: use shmem_truncate_range
In-Reply-To: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
Message-ID: <alpine.LSU.2.00.1106052131080.17116@sister.anvils>
References: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interface to ->truncate_range is changing very slightly:
once "tmpfs: take control of its truncate_range" has been applied,
this can be applied.  For now there is only a slight inefficiency
while this remains unapplied, but it will soon become essential
for managing shmem's use of swap.

Change i915_gem_object_truncate() to use shmem_truncate_range()
directly: which should also spare i915 later change if we switch
from inode_operations->truncate_range to file_operations->fallocate.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/i915/i915_gem.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- linux.orig/drivers/gpu/drm/i915/i915_gem.c	2011-06-05 18:37:13.589743574 -0700
+++ linux/drivers/gpu/drm/i915/i915_gem.c	2011-06-05 18:44:59.064050179 -0700
@@ -1694,13 +1694,10 @@ i915_gem_object_truncate(struct drm_i915
 	/* Our goal here is to return as much of the memory as
 	 * is possible back to the system as we are called from OOM.
 	 * To do this we must instruct the shmfs to drop all of its
-	 * backing pages, *now*. Here we mirror the actions taken
-	 * when by shmem_delete_inode() to release the backing store.
+	 * backing pages, *now*.
 	 */
 	inode = obj->base.filp->f_path.dentry->d_inode;
-	truncate_inode_pages(inode->i_mapping, 0);
-	if (inode->i_op->truncate_range)
-		inode->i_op->truncate_range(inode, 0, (loff_t)-1);
+	shmem_truncate_range(inode, 0, (loff_t)-1);
 
 	obj->madv = __I915_MADV_PURGED;
 }
