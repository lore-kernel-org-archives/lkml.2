Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584Ab2EJRes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:34:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52779 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760486Ab2EJReh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:34:37 -0400
Message-Id: <20120510173135.019336986@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 24/52] net: In unregister_netdevice_notifier unregister the netdevices.
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 7d3d43dab4e978d8d9ad1acf8af15c9b1c4b0f0f ]

We already synthesize events in register_netdevice_notifier and synthesizing
events in unregister_netdevice_notifier allows to us remove the need for
special case cleanup code.

This change should be safe as it adds no new cases for existing callers
of unregiser_netdevice_notifier to handle.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1412,14 +1412,34 @@ EXPORT_SYMBOL(register_netdevice_notifie
  *	register_netdevice_notifier(). The notifier is unlinked into the
  *	kernel structures and may then be reused. A negative errno code
  *	is returned on a failure.
+ *
+ * 	After unregistering unregister and down device events are synthesized
+ *	for all devices on the device list to the removed notifier to remove
+ *	the need for special case cleanup code.
  */
 
 int unregister_netdevice_notifier(struct notifier_block *nb)
 {
+	struct net_device *dev;
+	struct net *net;
 	int err;
 
 	rtnl_lock();
 	err = raw_notifier_chain_unregister(&netdev_chain, nb);
+	if (err)
+		goto unlock;
+
+	for_each_net(net) {
+		for_each_netdev(net, dev) {
+			if (dev->flags & IFF_UP) {
+				nb->notifier_call(nb, NETDEV_GOING_DOWN, dev);
+				nb->notifier_call(nb, NETDEV_DOWN, dev);
+			}
+			nb->notifier_call(nb, NETDEV_UNREGISTER, dev);
+			nb->notifier_call(nb, NETDEV_UNREGISTER_BATCH, dev);
+		}
+	}
+unlock:
 	rtnl_unlock();
 	return err;
 }


