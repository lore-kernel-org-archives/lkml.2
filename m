Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab2HGXBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:01:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56573 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030847Ab2HGWlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:41:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Cox <alan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 089/109] wanmain: comparing array with NULL
Date: Tue,  7 Aug 2012 15:35:48 -0700
Message-Id: <20120807222050.902284144@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alan Cox <alan@linux.intel.com>

[ Upstream commit 8b72ff6484fe303e01498b58621810a114f3cf09 ]

gcc really should warn about these !

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wanrouter/wanmain.c |   53 +++++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 29 deletions(-)

--- a/net/wanrouter/wanmain.c
+++ b/net/wanrouter/wanmain.c
@@ -602,36 +602,31 @@ static int wanrouter_device_new_if(struc
 		 * successfully, add it to the interface list.
 		 */
 
-		if (dev->name == NULL) {
-			err = -EINVAL;
-		} else {
-
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
+#ifdef WANDEBUG
+		printk(KERN_INFO "%s: registering interface %s...\n",
+		       wanrouter_modname, dev->name);
+#endif
+
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


