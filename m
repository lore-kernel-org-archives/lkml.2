Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026Ab2JDVXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:23:03 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:50177 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933928Ab2JDVW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:22:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Patrick McHardy <kaber@trash.net>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 52/58] IPoIB: Fix use-after-free of multicast object
Date: Thu,  4 Oct 2012 14:19:59 -0700
Message-Id: <20121004210642.045352485@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.449598766@linuxfoundation.org>
References: <20121004210635.449598766@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   19 ++++++++++---------
 2 files changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -148,7 +148,7 @@ static int ipoib_stop(struct net_device
 
 	netif_stop_queue(dev);
 
-	ipoib_ib_dev_down(dev, 0);
+	ipoib_ib_dev_down(dev, 1);
 	ipoib_ib_dev_stop(dev, 0);
 
 	if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -190,7 +190,9 @@ static int ipoib_mcast_join_finish(struc
 
 	mcast->mcmember = *mcmember;
 
-	/* Set the cached Q_Key before we attach if it's the broadcast group */
+	/* Set the multicast MTU and cached Q_Key before we attach if it's
+	 * the broadcast group.
+	 */
 	if (!memcmp(mcast->mcmember.mgid.raw, priv->dev->broadcast + 4,
 		    sizeof (union ib_gid))) {
 		spin_lock_irq(&priv->lock);
@@ -198,10 +200,17 @@ static int ipoib_mcast_join_finish(struc
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
@@ -589,14 +598,6 @@ void ipoib_mcast_join_task(struct work_s
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


