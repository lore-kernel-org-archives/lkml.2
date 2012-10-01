Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab2JAXPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:15:08 -0400
Received: from 1wt.eu ([62.212.114.60]:35493 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933077Ab2JAXCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:05 -0400
Message-Id: <20121001225202.394490409@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:50 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 113/180] wanmain: comparing array with NULL
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

[ Upstream commit 8b72ff6484fe303e01498b58621810a114f3cf09 ]

gcc really should warn about these !

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/wanrouter/wanmain.c |   51 +++++++++++++++++++++-------------------------
 1 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/net/wanrouter/wanmain.c b/net/wanrouter/wanmain.c
index 258daa8..0d8380a 100644
--- a/net/wanrouter/wanmain.c
+++ b/net/wanrouter/wanmain.c
@@ -603,36 +603,31 @@ static int wanrouter_device_new_if(struct wan_device *wandev,
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
-- 
1.7.2.1.45.g54fbc



