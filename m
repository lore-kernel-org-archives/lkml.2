Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1GBDIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 23:08:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62047 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1GBDIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 23:08:30 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH] virtio_balloon: Notify guest only after deflating the balloon
Date: Sat,  2 Jul 2011 06:06:56 +0300
Message-Id: <1309576016-22800-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unless the host requires that requested pages won't be used until
he us notified (VIRTIO_BALLOON_F_MUST_TELL_HOST), only notify after
deflating the balloon.

This will avoid having to take an exit before actually using the pages.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/virtio/virtio_balloon.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index e058ace..055f95d 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -148,14 +148,18 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
 		vb->num_pages--;
 	}
 
-
 	/*
-	 * Note that if
-	 * virtio_has_feature(vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST);
-	 * is true, we *have* to do it in this order
+	 * If the host doesn't require us to notify him before using
+	 * pages which belong to the balloon, update him only after
+	 * freeing those pages for guest use.
 	 */
-	tell_host(vb, vb->deflate_vq);
-	release_pages_by_pfn(vb->pfns, vb->num_pfns);
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST)) {
+		tell_host(vb, vb->deflate_vq);
+		release_pages_by_pfn(vb->pfns, vb->num_pfns);
+	} else {
+		release_pages_by_pfn(vb->pfns, vb->num_pfns);
+		tell_host(vb, vb->deflate_vq);
+	}
 }
 
 static inline void update_stat(struct virtio_balloon *vb, int idx,
-- 
1.7.6

