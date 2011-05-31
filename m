Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab1EaApO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 20:45:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16292 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab1EaApM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 20:45:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=tt62dwtbMQIKpNZItW5O1jQf7ns32bDgbDNRVtOXDGGwlIlXAh3ypX9Q9up02x61+k
         F5lFCg/wkiZlx1GWdrLA==
Date: Mon, 30 May 2011 17:45:10 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Chris Wilson <chris@chris-wilson.co.uk>, Keith Packard <keithp@keithp.com>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 7/14] drm/i915: adjust to new truncate_range
In-Reply-To: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
Message-ID: <alpine.LSU.2.00.1105301743500.5482@sister.anvils>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interface to ->truncate_range is changing very slightly:
once "tmpfs: take control of its truncate_range" has been applied,
this can be applied.  For now it's only a slight inefficiency while
this remains unapplied, but soon it will become essential.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/i915/i915_gem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux.orig/drivers/gpu/drm/i915/i915_gem.c	2011-05-30 14:26:13.121737248 -0700
+++ linux/drivers/gpu/drm/i915/i915_gem.c	2011-05-30 14:26:20.861775625 -0700
@@ -1693,13 +1693,13 @@ i915_gem_object_truncate(struct drm_i915
 	/* Our goal here is to return as much of the memory as
 	 * is possible back to the system as we are called from OOM.
 	 * To do this we must instruct the shmfs to drop all of its
-	 * backing pages, *now*. Here we mirror the actions taken
-	 * when by shmem_delete_inode() to release the backing store.
+	 * backing pages, *now*.
 	 */
 	inode = obj->base.filp->f_path.dentry->d_inode;
-	truncate_inode_pages(inode->i_mapping, 0);
 	if (inode->i_op->truncate_range)
 		inode->i_op->truncate_range(inode, 0, (loff_t)-1);
+	else
+		truncate_inode_pages(inode->i_mapping, 0);
 
 	obj->madv = __I915_MADV_PURGED;
 }
