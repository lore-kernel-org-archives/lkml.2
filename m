Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab2DPGRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 02:17:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab2DPGRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 02:17:08 -0400
Subject: [PATCH 5/6] vhost_net: fix use after free of vq->ubufs
To: netdev@vger.kernel.org, xma@us.ibm.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, mst@redhat.com
From: Jason Wang <jasowang@redhat.com>
Cc: ebiederm@xmission.com
Date: Mon, 16 Apr 2012 14:08:25 +0800
Message-ID: <20120416060825.14140.32069.stgit@intel-e5620-16-2.englab.nay.redhat.com>
In-Reply-To: <20120416060749.14140.19433.stgit@intel-e5620-16-2.englab.nay.redhat.com>
References: <20120416060749.14140.19433.stgit@intel-e5620-16-2.englab.nay.redhat.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When zerocopy socket is used, ubufs pointer were used in handle_tx()
without any validation. This would cause NULL pointer deference after
it has been freed in vhost_net_set_backend(). Fix this by check the
pointer before using it.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index f0da2c3..29abd65 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -163,10 +163,15 @@ static void handle_tx(struct vhost_net *net)
 	mutex_lock(&vq->mutex);
 	vhost_disable_notify(&net->dev, vq);
 
+	zcopy = vhost_sock_zcopy(sock);
+	if (zcopy && !vq->ubufs) {
+		mutex_unlock(&vq->mutex);
+		return;
+	}
+
 	if (wmem < sock->sk->sk_sndbuf / 2)
 		tx_poll_stop(net);
 	hdr_size = vq->vhost_hlen;
-	zcopy = vhost_sock_zcopy(sock);
 
 	for (;;) {
 		/* Release DMAs done buffers first */

