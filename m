Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab1ACNwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:52:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58971 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab1ACNut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=cqoTGsFMiFOXrSsK0A3XaUlyaRoHeyoHDgot1tzN6aqrHiL5bPxqXcy1mIWmK/V85A
         jCo1tZky+Yj78MMuj/8IwpWQOfzO6HTsVXQy97OerygZcgOcZoMGaCzsCG+p56b6Qm6H
         +GIyWeh142GmlhWix/3lj4+5S4yLlqPIt8r+c=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Alex Elder <aelder@sgi.com>,
        xfs-masters@oss.sgi.com, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 28/32] xfs: convert to alloc_workqueue()
Date: Mon,  3 Jan 2011 14:49:51 +0100
Message-Id: <1294062595-30097-29-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert from create[_singlethread]_workqueue() to alloc_workqueue().

* xfsdatad_workqueue and xfsconvertd_workqueue are identity converted.
  Using higher concurrency limit might be useful but given the
  complexity of workqueue usage in xfs, proceeding cautiously seems
  better.

* xfs_mru_reap_wq is converted to non-ordered workqueue with max
  concurrency of 1 as the work items don't require any specific
  ordering and already have proper synchronization.  It seems it was
  singlethreaded to save worker threads, which is no longer a concern.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alex Elder <aelder@sgi.com>
Cc: xfs-masters@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 fs/xfs/linux-2.6/xfs_buf.c |    5 +++--
 fs/xfs/xfs_mru_cache.c     |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 4c5deb6..d6da590 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1944,11 +1944,12 @@ xfs_buf_init(void)
 	if (!xfslogd_workqueue)
 		goto out_free_buf_zone;
 
-	xfsdatad_workqueue = create_workqueue("xfsdatad");
+	xfsdatad_workqueue = alloc_workqueue("xfsdatad", WQ_MEM_RECLAIM, 1);
 	if (!xfsdatad_workqueue)
 		goto out_destroy_xfslogd_workqueue;
 
-	xfsconvertd_workqueue = create_workqueue("xfsconvertd");
+	xfsconvertd_workqueue = alloc_workqueue("xfsconvertd",
+						WQ_MEM_RECLAIM, 1);
 	if (!xfsconvertd_workqueue)
 		goto out_destroy_xfsdatad_workqueue;
 
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index 45ce15d..2acdc77 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -309,7 +309,7 @@ xfs_mru_cache_init(void)
 	if (!xfs_mru_elem_zone)
 		goto out;
 
-	xfs_mru_reap_wq = create_singlethread_workqueue("xfs_mru_cache");
+	xfs_mru_reap_wq = alloc_workqueue("xfs_mru_cache", WQ_MEM_RECLAIM, 1);
 	if (!xfs_mru_reap_wq)
 		goto out_destroy_mru_elem_zone;
 
-- 
1.7.1

