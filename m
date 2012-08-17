Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030720Ab2HQDg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:36:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46723 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030609Ab2HQD0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:26:52 -0400
Message-Id: <20120817030244.873921360@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:02:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 07/37] wanmain: comparing array with NULL
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

[ Upstream commit 8b72ff6484fe303e01498b58621810a114f3cf09 ]

gcc really should warn about these !

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wanrouter/wanmain.c | 51 ++++++++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 28 deletions(-)

diff --git a/net/wanrouter/wanmain.c b/net/wanrouter/wanmain.c
index 788a12c..2ab7850 100644
--- a/net/wanrouter/wanmain.c
+++ b/net/wanrouter/wanmain.c
@@ -602,36 +602,31 @@ static int wanrouter_device_new_if(struct wan_device *wandev,
 		 * successfully, add it to the interface list.
 		 */
 
-		if (dev->name == NULL) {
-			err = -EINVAL;
-		} else {
+#ifdef WANDEBUG
+		printk(KERN_INFO "%s: registering interface %s...\n",
+		       wanrouter_modname, dev->name);
+#endif
 
-			#ifdef WANDEBUG
-			printk(KERN_INFO "%s: registering interface %s...\n",
-				wanrouter_modname, dev->name);
-			#endif
-
-			err = register_netdev(dev);
-			if (!err) {
-				struct net_device *slave = NULL;
-				unsigned long smp_flags=0;
-
-				lock_adapter_irq(&wandev->lock, &smp_flags);
-
-				if (wandev->dev == NULL) {
-					wandev->dev = dev;
-				} else {
-					for (slave=wandev->dev;
-					     DEV_TO_SLAVE(slave);
-					     slave = DEV_TO_SLAVE(slave))
-						DEV_TO_SLAVE(slave) = dev;
-				}
-				++wandev->ndev;
-
-				unlock_adapter_irq(&wandev->lock, &smp_flags);
-				err = 0;	/* done !!! */
-				goto out;
+		err = register_netdev(dev);
+		if (!err) {
+			struct net_device *slave = NULL;
+			unsigned long smp_flags=0;
+
+			lock_adapter_irq(&wandev->lock, &smp_flags);
+
+			if (wandev->dev == NULL) {
+				wandev->dev = dev;
+			} else {
+				for (slave=wandev->dev;
+				     DEV_TO_SLAVE(slave);
+				     slave = DEV_TO_SLAVE(slave))
+					DEV_TO_SLAVE(slave) = dev;
 			}
+			++wandev->ndev;
+
+			unlock_adapter_irq(&wandev->lock, &smp_flags);
+			err = 0;	/* done !!! */
+			goto out;
 		}
 		if (wandev->del_if)
 			wandev->del_if(wandev, dev);


