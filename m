Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab2HVXW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:22:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61922 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab2HVXWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:22:21 -0400
Date: Wed, 22 Aug 2012 16:22:16 -0700
From: Tejun Heo <tj@kernel.org>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: use system_nrt_wq instead of custom ones
Message-ID: <20120822232216.GP19212@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NFC is using a number of custom ordered workqueues w/ WQ_MEM_RECLAIM.
WQ_MEM_RECLAIM is unnecessary unless NFC is gonna be used as transport
for storage device, and all use cases match one work item to one
ordered workqueue - IOW, there's no actual ordering going on at all
and using system_nrt_wq gives the same behavior.

There's nothing to be gained by using custom workqueues.  Use
system_nrt_wq instead and drop all the custom ones.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/net/nfc/hci.h   |    2 -
 include/net/nfc/nfc.h   |    1 
 include/net/nfc/shdlc.h |    1 
 net/nfc/core.c          |   13 +---------
 net/nfc/hci/core.c      |   42 +++++------------------------------
 net/nfc/hci/hcp.c       |    2 -
 net/nfc/hci/shdlc.c     |   27 +++++++---------------
 net/nfc/llcp/llcp.c     |   57 ++++++------------------------------------------
 net/nfc/llcp/llcp.h     |    3 --
 9 files changed, 26 insertions(+), 122 deletions(-)

diff --git a/include/net/nfc/hci.h b/include/net/nfc/hci.h
index f5169b0..6f065d5 100644
--- a/include/net/nfc/hci.h
+++ b/include/net/nfc/hci.h
@@ -74,7 +74,6 @@ struct nfc_hci_dev {
 
 	struct list_head msg_tx_queue;
 
-	struct workqueue_struct *msg_tx_wq;
 	struct work_struct msg_tx_work;
 
 	struct timer_list cmd_timer;
@@ -82,7 +81,6 @@ struct nfc_hci_dev {
 
 	struct sk_buff_head rx_hcp_frags;
 
-	struct workqueue_struct *msg_rx_wq;
 	struct work_struct msg_rx_work;
 
 	struct sk_buff_head msg_rx_queue;
diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 6431f5e..493cc0e 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -112,7 +112,6 @@ struct nfc_dev {
 	int tx_tailroom;
 
 	struct timer_list check_pres_timer;
-	struct workqueue_struct *check_pres_wq;
 	struct work_struct check_pres_work;
 
 	struct nfc_ops *ops;
diff --git a/include/net/nfc/shdlc.h b/include/net/nfc/shdlc.h
index 35e930d..3424273 100644
--- a/include/net/nfc/shdlc.h
+++ b/include/net/nfc/shdlc.h
@@ -79,7 +79,6 @@ struct nfc_shdlc {
 
 	struct sk_buff_head ack_pending_q;
 
-	struct workqueue_struct *sm_wq;
 	struct work_struct sm_work;
 
 	struct nfc_shdlc_ops *ops;
diff --git a/net/nfc/core.c b/net/nfc/core.c
index ff74979..c9eacc1 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -679,7 +679,7 @@ static void nfc_release(struct device *d)
 
 	if (dev->ops->check_presence) {
 		del_timer_sync(&dev->check_pres_timer);
-		destroy_workqueue(dev->check_pres_wq);
+		cancel_work_sync(&dev->check_pres_work);
 	}
 
 	nfc_genl_data_exit(&dev->genl_data);
@@ -715,7 +715,7 @@ static void nfc_check_pres_timeout(unsigned long data)
 {
 	struct nfc_dev *dev = (struct nfc_dev *)data;
 
-	queue_work(dev->check_pres_wq, &dev->check_pres_work);
+	queue_work(system_nrt_wq, &dev->check_pres_work);
 }
 
 struct class nfc_class = {
@@ -784,20 +784,11 @@ struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
 	dev->targets_generation = 1;
 
 	if (ops->check_presence) {
-		char name[32];
 		init_timer(&dev->check_pres_timer);
 		dev->check_pres_timer.data = (unsigned long)dev;
 		dev->check_pres_timer.function = nfc_check_pres_timeout;
 
 		INIT_WORK(&dev->check_pres_work, nfc_check_pres_work);
-		snprintf(name, sizeof(name), "nfc%d_check_pres_wq", dev->idx);
-		dev->check_pres_wq = alloc_workqueue(name, WQ_NON_REENTRANT |
-						     WQ_UNBOUND |
-						     WQ_MEM_RECLAIM, 1);
-		if (dev->check_pres_wq == NULL) {
-			kfree(dev);
-			return NULL;
-		}
 	}
 
 	return dev;
diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index 1ac7b3f..03646be 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -141,7 +141,7 @@ static void __nfc_hci_cmd_completion(struct nfc_hci_dev *hdev, int err,
 	kfree(hdev->cmd_pending_msg);
 	hdev->cmd_pending_msg = NULL;
 
-	queue_work(hdev->msg_tx_wq, &hdev->msg_tx_work);
+	queue_work(system_nrt_wq, &hdev->msg_tx_work);
 }
 
 void nfc_hci_resp_received(struct nfc_hci_dev *hdev, u8 result,
@@ -326,7 +326,7 @@ static void nfc_hci_cmd_timeout(unsigned long data)
 {
 	struct nfc_hci_dev *hdev = (struct nfc_hci_dev *)data;
 
-	queue_work(hdev->msg_tx_wq, &hdev->msg_tx_work);
+	queue_work(system_nrt_wq, &hdev->msg_tx_work);
 }
 
 static int hci_dev_connect_gates(struct nfc_hci_dev *hdev, u8 gate_count,
@@ -659,23 +659,11 @@ EXPORT_SYMBOL(nfc_hci_free_device);
 
 int nfc_hci_register_device(struct nfc_hci_dev *hdev)
 {
-	struct device *dev = &hdev->ndev->dev;
-	const char *devname = dev_name(dev);
-	char name[32];
-	int r = 0;
-
 	mutex_init(&hdev->msg_tx_mutex);
 
 	INIT_LIST_HEAD(&hdev->msg_tx_queue);
 
 	INIT_WORK(&hdev->msg_tx_work, nfc_hci_msg_tx_work);
-	snprintf(name, sizeof(name), "%s_hci_msg_tx_wq", devname);
-	hdev->msg_tx_wq = alloc_workqueue(name, WQ_NON_REENTRANT | WQ_UNBOUND |
-					  WQ_MEM_RECLAIM, 1);
-	if (hdev->msg_tx_wq == NULL) {
-		r = -ENOMEM;
-		goto exit;
-	}
 
 	init_timer(&hdev->cmd_timer);
 	hdev->cmd_timer.data = (unsigned long)hdev;
@@ -684,27 +672,10 @@ int nfc_hci_register_device(struct nfc_hci_dev *hdev)
 	skb_queue_head_init(&hdev->rx_hcp_frags);
 
 	INIT_WORK(&hdev->msg_rx_work, nfc_hci_msg_rx_work);
-	snprintf(name, sizeof(name), "%s_hci_msg_rx_wq", devname);
-	hdev->msg_rx_wq = alloc_workqueue(name, WQ_NON_REENTRANT | WQ_UNBOUND |
-					  WQ_MEM_RECLAIM, 1);
-	if (hdev->msg_rx_wq == NULL) {
-		r = -ENOMEM;
-		goto exit;
-	}
 
 	skb_queue_head_init(&hdev->msg_rx_queue);
 
-	r = nfc_register_device(hdev->ndev);
-
-exit:
-	if (r < 0) {
-		if (hdev->msg_tx_wq)
-			destroy_workqueue(hdev->msg_tx_wq);
-		if (hdev->msg_rx_wq)
-			destroy_workqueue(hdev->msg_rx_wq);
-	}
-
-	return r;
+	return nfc_register_device(hdev->ndev);
 }
 EXPORT_SYMBOL(nfc_hci_register_device);
 
@@ -725,9 +696,8 @@ void nfc_hci_unregister_device(struct nfc_hci_dev *hdev)
 
 	nfc_unregister_device(hdev->ndev);
 
-	destroy_workqueue(hdev->msg_tx_wq);
-
-	destroy_workqueue(hdev->msg_rx_wq);
+	cancel_work_sync(&hdev->msg_tx_work);
+	cancel_work_sync(&hdev->msg_rx_work);
 }
 EXPORT_SYMBOL(nfc_hci_unregister_device);
 
@@ -827,7 +797,7 @@ void nfc_hci_recv_frame(struct nfc_hci_dev *hdev, struct sk_buff *skb)
 		nfc_hci_hcp_message_rx(hdev, pipe, type, instruction, hcp_skb);
 	} else {
 		skb_queue_tail(&hdev->msg_rx_queue, hcp_skb);
-		queue_work(hdev->msg_rx_wq, &hdev->msg_rx_work);
+		queue_work(system_nrt_wq, &hdev->msg_rx_work);
 	}
 }
 EXPORT_SYMBOL(nfc_hci_recv_frame);
diff --git a/net/nfc/hci/hcp.c b/net/nfc/hci/hcp.c
index f4dad1a..2372b55 100644
--- a/net/nfc/hci/hcp.c
+++ b/net/nfc/hci/hcp.c
@@ -108,7 +108,7 @@ int nfc_hci_hcp_message_tx(struct nfc_hci_dev *hdev, u8 pipe,
 	list_add_tail(&cmd->msg_l, &hdev->msg_tx_queue);
 	mutex_unlock(&hdev->msg_tx_mutex);
 
-	queue_work(hdev->msg_tx_wq, &hdev->msg_tx_work);
+	queue_work(system_nrt_wq, &hdev->msg_tx_work);
 
 	return 0;
 
diff --git a/net/nfc/hci/shdlc.c b/net/nfc/hci/shdlc.c
index 6f840c1..39b51ea 100644
--- a/net/nfc/hci/shdlc.c
+++ b/net/nfc/hci/shdlc.c
@@ -540,7 +540,7 @@ static void nfc_shdlc_connect_timeout(unsigned long data)
 
 	pr_debug("\n");
 
-	queue_work(shdlc->sm_wq, &shdlc->sm_work);
+	queue_work(system_nrt_wq, &shdlc->sm_work);
 }
 
 static void nfc_shdlc_t1_timeout(unsigned long data)
@@ -549,7 +549,7 @@ static void nfc_shdlc_t1_timeout(unsigned long data)
 
 	pr_debug("SoftIRQ: need to send ack\n");
 
-	queue_work(shdlc->sm_wq, &shdlc->sm_work);
+	queue_work(system_nrt_wq, &shdlc->sm_work);
 }
 
 static void nfc_shdlc_t2_timeout(unsigned long data)
@@ -558,7 +558,7 @@ static void nfc_shdlc_t2_timeout(unsigned long data)
 
 	pr_debug("SoftIRQ: need to retransmit\n");
 
-	queue_work(shdlc->sm_wq, &shdlc->sm_work);
+	queue_work(system_nrt_wq, &shdlc->sm_work);
 }
 
 static void nfc_shdlc_sm_work(struct work_struct *work)
@@ -598,7 +598,7 @@ static void nfc_shdlc_sm_work(struct work_struct *work)
 	case SHDLC_NEGOCIATING:
 		if (timer_pending(&shdlc->connect_timer) == 0) {
 			shdlc->state = SHDLC_CONNECTING;
-			queue_work(shdlc->sm_wq, &shdlc->sm_work);
+			queue_work(system_nrt_wq, &shdlc->sm_work);
 		}
 
 		nfc_shdlc_handle_rcv_queue(shdlc);
@@ -662,7 +662,7 @@ static int nfc_shdlc_connect(struct nfc_shdlc *shdlc)
 
 	mutex_unlock(&shdlc->state_mutex);
 
-	queue_work(shdlc->sm_wq, &shdlc->sm_work);
+	queue_work(system_nrt_wq, &shdlc->sm_work);
 
 	wait_event(connect_wq, shdlc->connect_result != 1);
 
@@ -679,7 +679,7 @@ static void nfc_shdlc_disconnect(struct nfc_shdlc *shdlc)
 
 	mutex_unlock(&shdlc->state_mutex);
 
-	queue_work(shdlc->sm_wq, &shdlc->sm_work);
+	queue_work(system_nrt_wq, &shdlc->sm_work);
 }
 
 /*
@@ -697,7 +697,7 @@ void nfc_shdlc_recv_frame(struct nfc_shdlc *shdlc, struct sk_buff *skb)
 		skb_queue_tail(&shdlc->rcv_q, skb);
 	}
 
-	queue_work(shdlc->sm_wq, &shdlc->sm_work);
+	queue_work(system_nrt_wq, &shdlc->sm_work);
 }
 EXPORT_SYMBOL(nfc_shdlc_recv_frame);
 
@@ -754,7 +754,7 @@ static int nfc_shdlc_xmit(struct nfc_hci_dev *hdev, struct sk_buff *skb)
 
 	skb_queue_tail(&shdlc->send_q, skb);
 
-	queue_work(shdlc->sm_wq, &shdlc->sm_work);
+	queue_work(system_nrt_wq, &shdlc->sm_work);
 
 	return 0;
 }
@@ -843,7 +843,6 @@ struct nfc_shdlc *nfc_shdlc_allocate(struct nfc_shdlc_ops *ops,
 {
 	struct nfc_shdlc *shdlc;
 	int r;
-	char name[32];
 
 	if (ops->xmit == NULL)
 		return NULL;
@@ -876,11 +875,6 @@ struct nfc_shdlc *nfc_shdlc_allocate(struct nfc_shdlc_ops *ops,
 	skb_queue_head_init(&shdlc->ack_pending_q);
 
 	INIT_WORK(&shdlc->sm_work, nfc_shdlc_sm_work);
-	snprintf(name, sizeof(name), "%s_shdlc_sm_wq", devname);
-	shdlc->sm_wq = alloc_workqueue(name, WQ_NON_REENTRANT | WQ_UNBOUND |
-				       WQ_MEM_RECLAIM, 1);
-	if (shdlc->sm_wq == NULL)
-		goto err_allocwq;
 
 	shdlc->client_headroom = tx_headroom;
 	shdlc->client_tailroom = tx_tailroom;
@@ -904,9 +898,6 @@ err_regdev:
 	nfc_hci_free_device(shdlc->hdev);
 
 err_allocdev:
-	destroy_workqueue(shdlc->sm_wq);
-
-err_allocwq:
 	kfree(shdlc);
 
 	return NULL;
@@ -920,7 +911,7 @@ void nfc_shdlc_free(struct nfc_shdlc *shdlc)
 	nfc_hci_unregister_device(shdlc->hdev);
 	nfc_hci_free_device(shdlc->hdev);
 
-	destroy_workqueue(shdlc->sm_wq);
+	cancel_work_sync(&shdlc->sm_work);
 
 	skb_queue_purge(&shdlc->rcv_q);
 	skb_queue_purge(&shdlc->send_q);
diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 82f0f75..6f368412 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -114,9 +114,9 @@ static void local_release(struct kref *ref)
 	nfc_llcp_socket_release(local, false);
 	del_timer_sync(&local->link_timer);
 	skb_queue_purge(&local->tx_queue);
-	destroy_workqueue(local->tx_wq);
-	destroy_workqueue(local->rx_wq);
-	destroy_workqueue(local->timeout_wq);
+	cancel_work_sync(&local->tx_work);
+	cancel_work_sync(&local->rx_work);
+	cancel_work_sync(&local->timeout_work);
 	kfree_skb(local->rx_pending);
 	kfree(local);
 }
@@ -181,7 +181,7 @@ static void nfc_llcp_symm_timer(unsigned long data)
 
 	pr_err("SYMM timeout\n");
 
-	queue_work(local->timeout_wq, &local->timeout_work);
+	queue_work(system_nrt_wq, &local->timeout_work);
 }
 
 struct nfc_llcp_local *nfc_llcp_find_local(struct nfc_dev *dev)
@@ -1052,7 +1052,7 @@ static void nfc_llcp_rx_work(struct work_struct *work)
 
 	}
 
-	queue_work(local->tx_wq, &local->tx_work);
+	queue_work(system_nrt_wq, &local->tx_work);
 	kfree_skb(local->rx_pending);
 	local->rx_pending = NULL;
 
@@ -1071,7 +1071,7 @@ void nfc_llcp_recv(void *data, struct sk_buff *skb, int err)
 
 	local->rx_pending = skb_get(skb);
 	del_timer(&local->link_timer);
-	queue_work(local->rx_wq, &local->rx_work);
+	queue_work(system_nrt_wq, &local->rx_work);
 
 	return;
 }
@@ -1086,7 +1086,7 @@ int nfc_llcp_data_received(struct nfc_dev *dev, struct sk_buff *skb)
 
 	local->rx_pending = skb_get(skb);
 	del_timer(&local->link_timer);
-	queue_work(local->rx_wq, &local->rx_work);
+	queue_work(system_nrt_wq, &local->rx_work);
 
 	return 0;
 }
@@ -1121,7 +1121,7 @@ void nfc_llcp_mac_is_up(struct nfc_dev *dev, u32 target_idx,
 	if (rf_mode == NFC_RF_INITIATOR) {
 		pr_debug("Queueing Tx work\n");
 
-		queue_work(local->tx_wq, &local->tx_work);
+		queue_work(system_nrt_wq, &local->tx_work);
 	} else {
 		mod_timer(&local->link_timer,
 			  jiffies + msecs_to_jiffies(local->remote_lto));
@@ -1130,10 +1130,7 @@ void nfc_llcp_mac_is_up(struct nfc_dev *dev, u32 target_idx,
 
 int nfc_llcp_register_device(struct nfc_dev *ndev)
 {
-	struct device *dev = &ndev->dev;
 	struct nfc_llcp_local *local;
-	char name[32];
-	int err;
 
 	local = kzalloc(sizeof(struct nfc_llcp_local), GFP_KERNEL);
 	if (local == NULL)
@@ -1149,38 +1146,11 @@ int nfc_llcp_register_device(struct nfc_dev *ndev)
 
 	skb_queue_head_init(&local->tx_queue);
 	INIT_WORK(&local->tx_work, nfc_llcp_tx_work);
-	snprintf(name, sizeof(name), "%s_llcp_tx_wq", dev_name(dev));
-	local->tx_wq =
-		alloc_workqueue(name,
-				WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM,
-				1);
-	if (local->tx_wq == NULL) {
-		err = -ENOMEM;
-		goto err_local;
-	}
 
 	local->rx_pending = NULL;
 	INIT_WORK(&local->rx_work, nfc_llcp_rx_work);
-	snprintf(name, sizeof(name), "%s_llcp_rx_wq", dev_name(dev));
-	local->rx_wq =
-		alloc_workqueue(name,
-				WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM,
-				1);
-	if (local->rx_wq == NULL) {
-		err = -ENOMEM;
-		goto err_tx_wq;
-	}
 
 	INIT_WORK(&local->timeout_work, nfc_llcp_timeout_work);
-	snprintf(name, sizeof(name), "%s_llcp_timeout_wq", dev_name(dev));
-	local->timeout_wq =
-		alloc_workqueue(name,
-				WQ_NON_REENTRANT | WQ_UNBOUND | WQ_MEM_RECLAIM,
-				1);
-	if (local->timeout_wq == NULL) {
-		err = -ENOMEM;
-		goto err_rx_wq;
-	}
 
 	local->sockets.lock = __RW_LOCK_UNLOCKED(local->sockets.lock);
 	local->connecting_sockets.lock = __RW_LOCK_UNLOCKED(local->connecting_sockets.lock);
@@ -1193,17 +1163,6 @@ int nfc_llcp_register_device(struct nfc_dev *ndev)
 	list_add(&llcp_devices, &local->list);
 
 	return 0;
-
-err_rx_wq:
-	destroy_workqueue(local->rx_wq);
-
-err_tx_wq:
-	destroy_workqueue(local->tx_wq);
-
-err_local:
-	kfree(local);
-
-	return 0;
 }
 
 void nfc_llcp_unregister_device(struct nfc_dev *dev)
diff --git a/net/nfc/llcp/llcp.h b/net/nfc/llcp/llcp.h
index 83b8bba..af395c9 100644
--- a/net/nfc/llcp/llcp.h
+++ b/net/nfc/llcp/llcp.h
@@ -56,12 +56,9 @@ struct nfc_llcp_local {
 
 	struct timer_list link_timer;
 	struct sk_buff_head tx_queue;
-	struct workqueue_struct	*tx_wq;
 	struct work_struct	 tx_work;
-	struct workqueue_struct	*rx_wq;
 	struct work_struct	 rx_work;
 	struct sk_buff *rx_pending;
-	struct workqueue_struct	*timeout_wq;
 	struct work_struct	 timeout_work;
 
 	u32 target_idx;
