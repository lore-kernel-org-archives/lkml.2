Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab2DLFhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 01:37:46 -0400
Received: from ozlabs.org ([203.10.76.45]:41083 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756539Ab2DLFgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 01:36:48 -0400
From: David Gibson <david@gibson.dropbear.id.au>
To: rusty@rustcorp.com.au, mst@redhat.com
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, qemu-devel@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 2/3] virtio_balloon: Fix endian bug
Date: Thu, 12 Apr 2012 15:36:34 +1000
Message-Id: <1334208995-29985-3-git-send-email-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334208995-29985-1-git-send-email-david@gibson.dropbear.id.au>
References: <1334208995-29985-1-git-send-email-david@gibson.dropbear.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although virtio config space fields are usually in guest-native endian,
the spec for the virtio balloon device explicitly states that both fields
in its config space are little-endian.

However, the current virtio_balloon driver does not have a suitable endian
swap for the 'num_pages' field, although it does have one for the 'actual'
field.  This patch corrects the bug, adding sparse annotation while we're
at it.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 drivers/virtio/virtio_balloon.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 6c07793..553cc1f 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -238,11 +238,14 @@ static void virtballoon_changed(struct virtio_device *vdev)
 
 static inline s64 towards_target(struct virtio_balloon *vb)
 {
-	u32 v;
+	__le32 v;
+	s64 target;
+
 	vb->vdev->config->get(vb->vdev,
 			      offsetof(struct virtio_balloon_config, num_pages),
 			      &v, sizeof(v));
-	return (s64)v - vb->num_pages;
+	target = le32_to_cpu(v);
+	return target - vb->num_pages;
 }
 
 static void update_balloon_size(struct virtio_balloon *vb)
-- 
1.7.9.5

