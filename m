Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab2J2LEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:04:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47189 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758578Ab2J2LEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:04:48 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 2/7] staging/gdm72xx: Use netdev_ or pr_ printks in gdm_qos.c
Date: Mon, 29 Oct 2012 20:04:42 +0900
Message-Id: <1351508682-1749-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351508627-1713-1-git-send-email-yamanetoshi@gmail.com>
References: <1351508627-1713-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
- WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...

and add pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/gdm72xx/gdm_qos.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
index e26c6a8..1e63031 100644
--- a/drivers/staging/gdm72xx/gdm_qos.c
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -11,6 +11,8 @@
  * GNU General Public License for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/etherdevice.h>
 #include <asm/byteorder.h>
 
@@ -24,15 +26,6 @@
 
 #define B2H(x)		__be16_to_cpu(x)
 
-#undef dprintk
-#define dprintk(fmt, args ...) printk(KERN_DEBUG "[QoS] " fmt, ## args)
-#undef wprintk
-#define wprintk(fmt, args ...) \
-	printk(KERN_WARNING "[QoS WARNING] " fmt, ## args)
-#undef eprintk
-#define eprintk(fmt, args ...) printk(KERN_ERR "[QoS ERROR] " fmt, ## args)
-
-
 #define MAX_FREE_LIST_CNT		32
 static struct {
 	struct list_head head;
@@ -95,7 +88,7 @@ static void free_qos_entry_list(struct list_head *free_list)
 		total_free++;
 	}
 
-	dprintk("%s: total_free_cnt=%d\n", __func__, total_free);
+	pr_debug("%s: total_free_cnt=%d\n", __func__, total_free);
 }
 
 void gdm_qos_init(void *nic_ptr)
@@ -240,7 +233,9 @@ static u32 extract_qos_list(struct nic *nic, struct list_head *head)
 					qcb->csr[i].qos_buf_count++;
 
 					if (!list_empty(&qcb->qos_list[i]))
-						wprintk("QoS Index(%d) is piled!!\n", i);
+						netdev_warn(nic->netdev,
+							    "Index(%d) is piled!!\n",
+							    i);
 				}
 			}
 		}
@@ -280,7 +275,8 @@ int gdm_qos_send_hci_pkt(struct sk_buff *skb, struct net_device *dev)
 			entry = alloc_qos_entry();
 			entry->skb = skb;
 			entry->dev = dev;
-			dprintk("qcb->qos_list_cnt=%d\n", qcb->qos_list_cnt);
+			netdev_dbg(dev, "qcb->qos_list_cnt=%d\n",
+				   qcb->qos_list_cnt);
 		}
 
 		spin_lock_irqsave(&qcb->qos_lock, flags);
@@ -362,7 +358,7 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 			index = get_csr(qcb, SFID, 0);
 			if (index == -1) {
 				spin_unlock_irqrestore(&qcb->qos_lock, flags);
-				eprintk("QoS ERROR: No SF\n");
+				netdev_err(nic->netdev, "QoS ERROR: No SF\n");
 				return;
 			}
 			qcb->csr[index].qos_buf_count = buf[(i*5)+10];
@@ -383,11 +379,12 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 
 		index = get_csr(qcb, SFID, 1);
 		if (index == -1) {
-			eprintk("QoS ERROR: csr Update Error\n");
+			netdev_err(nic->netdev, "QoS ERROR: csr Update Error\n");
 			return;
 		}
 
-		dprintk("QOS_ADD SFID = 0x%x, index=%d\n", SFID, index);
+		netdev_dbg(nic->netdev, "QOS_ADD SFID = 0x%x, index=%d\n",
+			   SFID, index);
 
 		spin_lock_irqsave(&qcb->qos_lock, flags);
 		qcb->csr[index].SFID = SFID;
@@ -435,11 +432,13 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 		SFID += (buf[pos++]);
 		index = get_csr(qcb, SFID, 1);
 		if (index == -1) {
-			eprintk("QoS ERROR: Wrong index(%d)\n", index);
+			netdev_err(nic->netdev, "QoS ERROR: Wrong index(%d)\n",
+				   index);
 			return;
 		}
 
-		dprintk("QOS_CHANGE_DEL SFID = 0x%x, index=%d\n", SFID, index);
+		netdev_dbg(nic->netdev, "QOS_CHANGE_DEL SFID = 0x%x, index=%d\n",
+			   SFID, index);
 
 		INIT_LIST_HEAD(&free_list);
 
-- 
1.7.9.5

