Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab0GOMZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 08:25:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab0GOMZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 08:25:15 -0400
Date: Thu, 15 Jul 2010 15:19:12 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Sridhar Samudrala <samudrala@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vhost-net: avoid flush under lock
Message-ID: <20100715121912.GA7176@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We flush under vq mutex when changing backends.
This creates a deadlock as workqueue being flushed
needs this lock as well.

https://bugzilla.redhat.com/show_bug.cgi?id=612421

Drop the vq mutex before flush: we have the device mutex
which is sufficient to prevent another ioctl from touching
the vq.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 28d7786..50df58e6 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -534,11 +534,16 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	rcu_assign_pointer(vq->private_data, sock);
 	vhost_net_enable_vq(n, vq);
 done:
+	mutex_unlock(&vq->mutex);
+
 	if (oldsock) {
 		vhost_net_flush_vq(n, index);
 		fput(oldsock->file);
 	}
 
+	mutex_unlock(&n->dev.mutex);
+	return 0;
+
 err_vq:
 	mutex_unlock(&vq->mutex);
 err:
-- 
1.7.2.rc0.14.g41c1c
