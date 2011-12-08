Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab1LHG5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 01:57:22 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58009 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab1LHG5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 01:57:20 -0500
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] vmalloc: purge_fragmented_blocks: Acquire spinlock before reading vmap_block
Date: Thu,  8 Dec 2011 12:32:12 +0530
Message-Id: <1323327732-30817-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purge_fragmented_blocks will loop over all vmap_blocks in the
vmap_block_queue to create the purge list.
Currently, the code in the loop does not acquire the &vb->lock before
reading the vb->free and vb->dirty.

Due to this, there might be a possibility of vb->free and vb->dirty being
changed in parallel which could lead to the current vmap_block not being
selected for purging.

Changing the code to acquire this spinlock before the check for vb->free
and vb->dirty.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 mm/vmalloc.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 3231bf3..2228971 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -855,11 +855,14 @@ static void purge_fragmented_blocks(int cpu)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(vb, &vbq->free, free_list) {
+		spin_lock(&vb->lock);
 
-		if (!(vb->free + vb->dirty == VMAP_BBMAP_BITS && vb->dirty != VMAP_BBMAP_BITS))
+		if (!(vb->free + vb->dirty == VMAP_BBMAP_BITS &&
+			  vb->dirty != VMAP_BBMAP_BITS)) {
+			spin_unlock(&vb->lock);
 			continue;
+		}
 
-		spin_lock(&vb->lock);
 		if (vb->free + vb->dirty == VMAP_BBMAP_BITS && vb->dirty != VMAP_BBMAP_BITS) {
 			vb->free = 0; /* prevent further allocs after releasing lock */
 			vb->dirty = VMAP_BBMAP_BITS; /* prevent purging it again */
-- 
1.7.6

