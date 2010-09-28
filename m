Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab0I1RLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:11:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757276Ab0I1RLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:11:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: vgoyal@redhat.com
Subject: [PATCH 2/4] blkio: deletion of a cgroup was causes oops
Date: Tue, 28 Sep 2010 13:10:57 -0400
Message-Id: <1285693859-13591-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1285693859-13591-1-git-send-email-vgoyal@redhat.com>
References: <1285693859-13591-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Now a cgroup list of blkg elements can contain blkg from multiple policies.
  Before sending an unlink event, make sure blkg belongs to they policy. If
  policy does not own the blkg, do not send update for this blkg.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 1916bc0..357f472 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1411,13 +1411,14 @@ static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 		/*
 		 * This blkio_group is being unlinked as associated cgroup is
 		 * going away. Let all the IO controlling policies know about
-		 * this event. Currently this is static call to one io
-		 * controlling policy. Once we have more policies in place, we
-		 * need some dynamic registration of callback function.
+		 * this event.
 		 */
 		spin_lock(&blkio_list_lock);
-		list_for_each_entry(blkiop, &blkio_list, list)
+		list_for_each_entry(blkiop, &blkio_list, list) {
+			if (blkiop->plid != blkg->plid)
+				continue;
 			blkiop->ops.blkio_unlink_group_fn(key, blkg);
+		}
 		spin_unlock(&blkio_list_lock);
 	} while (1);
 
-- 
1.7.2.3

