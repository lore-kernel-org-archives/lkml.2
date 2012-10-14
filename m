Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab2JNPB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:01:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46465 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932122Ab2JNOnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:14 -0400
Message-Id: <20121014143545.019077438@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Patrick McHardy <kaber@trash.net>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 083/147] IPoIB: Fix use-after-free of multicast object
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick McHardy <kaber@trash.net>

commit bea1e22df494a729978e7f2c54f7bda328f74bc3 upstream.

Fix a crash in ipoib_mcast_join_task().  (with help from Or Gerlitz)

Commit c8c2afe360b7 ("IPoIB: Use rtnl lock/unlock when changing device
flags") added a call to rtnl_lock() in ipoib_mcast_join_task(), which
is run from the ipoib_workqueue, and hence the workqueue can't be
flushed from the context of ipoib_stop().

In the current code, ipoib_stop() (which doesn't flush the workqueue)
calls ipoib_mcast_dev_flush(), which goes and deletes all the
multicast entries.  This takes place without any synchronization with
a possible running instance of ipoib_mcast_join_task() for the same
ipoib device, leading to a crash due to NULL pointer dereference.

Fix this by making sure that the workqueue is flushed before
ipoib_mcast_dev_flush() is called.  To make that possible, we move the
RTNL-lock wrapped code to ipoib_mcast_join_finish().

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   19 ++++++++++---------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 1e19b5a..ea0dfc7 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -150,7 +150,7 @@ static int ipoib_stop(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
-	ipoib_ib_dev_down(dev, 0);
+	ipoib_ib_dev_down(dev, 1);
 	ipoib_ib_dev_stop(dev, 0);
 
 	if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 7536724..cecb98a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -175,7 +175,9 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 
 	mcast->mcmember = *mcmember;
 
-	/* Set the cached Q_Key before we attach if it's the broadcast group */
+	/* Set the multicast MTU and cached Q_Key before we attach if it's
+	 * the broadcast group.
+	 */
 	if (!memcmp(mcast->mcmember.mgid.raw, priv->dev->broadcast + 4,
 		    sizeof (union ib_gid))) {
 		spin_lock_irq(&priv->lock);
@@ -183,10 +185,17 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 			spin_unlock_irq(&priv->lock);
 			return -EAGAIN;
 		}
+		priv->mcast_mtu = IPOIB_UD_MTU(ib_mtu_enum_to_int(priv->broadcast->mcmember.mtu));
 		priv->qkey = be32_to_cpu(priv->broadcast->mcmember.qkey);
 		spin_unlock_irq(&priv->lock);
 		priv->tx_wr.wr.ud.remote_qkey = priv->qkey;
 		set_qkey = 1;
+
+		if (!ipoib_cm_admin_enabled(dev)) {
+			rtnl_lock();
+			dev_set_mtu(dev, min(priv->mcast_mtu, priv->admin_mtu));
+			rtnl_unlock();
+		}
 	}
 
 	if (!test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags)) {
@@ -574,14 +583,6 @@ void ipoib_mcast_join_task(struct work_struct *work)
 		return;
 	}
 
-	priv->mcast_mtu = IPOIB_UD_MTU(ib_mtu_enum_to_int(priv->broadcast->mcmember.mtu));
-
-	if (!ipoib_cm_admin_enabled(dev)) {
-		rtnl_lock();
-		dev_set_mtu(dev, min(priv->mcast_mtu, priv->admin_mtu));
-		rtnl_unlock();
-	}
-
 	ipoib_dbg_mcast(priv, "successfully joined all multicast groups\n");
 
 	clear_bit(IPOIB_MCAST_RUN, &priv->flags);


