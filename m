Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab2L0Grf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 01:47:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab2L0Grc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 01:47:32 -0500
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH 1/2] vhost_net: correct error hanlding in vhost_net_set_backend()
Date: Thu, 27 Dec 2012 14:39:19 +0800
Message-Id: <1356590360-32770-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the leaking of oldubufs and fd refcnt when fail to initialized used ring.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index ebd08b2..629d6b5 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -834,8 +834,10 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 		vhost_net_enable_vq(n, vq);
 
 		r = vhost_init_used(vq);
-		if (r)
-			goto err_vq;
+		if (r) {
+			sock = NULL;
+			goto err_used;
+		}
 
 		n->tx_packets = 0;
 		n->tx_zcopy_err = 0;
@@ -859,8 +861,14 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	mutex_unlock(&n->dev.mutex);
 	return 0;
 
+err_used:
+	if (oldubufs)
+		vhost_ubuf_put_and_wait(oldubufs);
+	if (oldsock)
+		fput(oldsock->file);
 err_ubufs:
-	fput(sock->file);
+	if (sock)
+		fput(sock->file);
 err_vq:
 	mutex_unlock(&vq->mutex);
 err:
-- 
1.7.1

