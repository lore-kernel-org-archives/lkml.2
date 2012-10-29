Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab2J2LFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:05:10 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51657 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758578Ab2J2LFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:05:07 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 3/7] staging/gdm72xx: Use netdev_ or pr_ printks in netlink_k.c
Date: Mon, 29 Oct 2012 20:05:02 +0900
Message-Id: <1351508702-1786-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351508627-1713-1-git-send-email-yamanetoshi@gmail.com>
References: <1351508627-1713-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

and add pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/gdm72xx/netlink_k.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/gdm72xx/netlink_k.c b/drivers/staging/gdm72xx/netlink_k.c
index 20d0aec..52c25ba 100644
--- a/drivers/staging/gdm72xx/netlink_k.c
+++ b/drivers/staging/gdm72xx/netlink_k.c
@@ -11,6 +11,8 @@
  * GNU General Public License for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/etherdevice.h>
 #include <linux/netlink.h>
@@ -54,8 +56,8 @@ static void netlink_rcv_cb(struct sk_buff *skb)
 
 		if (skb->len < nlh->nlmsg_len ||
 		nlh->nlmsg_len > ND_MAX_MSG_LEN) {
-			printk(KERN_ERR "Invalid length (%d,%d)\n", skb->len,
-				nlh->nlmsg_len);
+			netdev_err(skb->dev, "Invalid length (%d,%d)\n",
+				   skb->len, nlh->nlmsg_len);
 			return;
 		}
 
@@ -69,10 +71,11 @@ static void netlink_rcv_cb(struct sk_buff *skb)
 				rcv_cb(dev, nlh->nlmsg_type, msg, mlen);
 				dev_put(dev);
 			} else
-				printk(KERN_ERR "dev_get_by_index(%d) "
-					"is not found.\n", ifindex);
+				netdev_err(skb->dev,
+					   "dev_get_by_index(%d) is not found.\n",
+					   ifindex);
 		} else
-			printk(KERN_ERR "Unregistered Callback\n");
+			netdev_err(skb->dev, "Unregistered Callback\n");
 	}
 }
 
@@ -116,14 +119,14 @@ int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len)
 	int ret = 0;
 
 	if (group > ND_MAX_GROUP) {
-		printk(KERN_ERR "Group %d is invalied.\n", group);
-		printk(KERN_ERR "Valid group is 0 ~ %d.\n", ND_MAX_GROUP);
+		pr_err("Group %d is invalied.\n", group);
+		pr_err("Valid group is 0 ~ %d.\n", ND_MAX_GROUP);
 		return -EINVAL;
 	}
 
 	skb = alloc_skb(NLMSG_SPACE(len), GFP_ATOMIC);
 	if (!skb) {
-		printk(KERN_ERR "netlink_broadcast ret=%d\n", ret);
+		pr_err("netlink_broadcast ret=%d\n", ret);
 		return -ENOMEM;
 	}
 
@@ -144,8 +147,8 @@ int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len)
 		return len;
 	else {
 		if (ret != -ESRCH) {
-			printk(KERN_ERR "netlink_broadcast g=%d, t=%d, l=%d, r=%d\n",
-				group, type, len, ret);
+			pr_err("netlink_broadcast g=%d, t=%d, l=%d, r=%d\n",
+			       group, type, len, ret);
 		}
 		ret = 0;
 	}
-- 
1.7.9.5

