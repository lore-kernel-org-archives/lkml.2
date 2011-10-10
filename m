Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab1JJCTF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 22:19:05 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:33555
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751148Ab1JJCTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 22:19:04 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/1] Staging: hv: util: Invoke cn_netlink_send() in a work context
Date: Sun,  9 Oct 2011 19:42:28 -0700
Message-Id: <1318214548-22572-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Invoke cn_netlink_send() in a work context as opposed being called
in the context of  channel callback. On entry into the channel callback
code the channel inbound spin lock is held and deferring to a work
context avoids having to invoke cn_netlink_send() while holding
the inbound lock. As part of this adjustment, also increase the
timeout value for waiting for the user level component of KVP.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_kvp.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/hv/hv_kvp.c b/drivers/staging/hv/hv_kvp.c
index 307aedc..1e9515c 100644
--- a/drivers/staging/hv/hv_kvp.c
+++ b/drivers/staging/hv/hv_kvp.c
@@ -44,11 +44,12 @@
 static struct {
 	bool active; /* transaction status - active or not */
 	int recv_len; /* number of bytes received. */
+	int index; /* current index */
 	struct vmbus_channel *recv_channel; /* chn we got the request */
 	u64 recv_req_id; /* request ID. */
 } kvp_transaction;
 
-static int kvp_send_key(int index);
+static void kvp_send_key(struct work_struct *dummy);
 
 #define TIMEOUT_FIRED 1
 
@@ -57,6 +58,7 @@ static void kvp_work_func(struct work_struct *dummy);
 static void kvp_register(void);
 
 static DECLARE_DELAYED_WORK(kvp_work, kvp_work_func);
+static DECLARE_WORK(kvp_sendkey_work, kvp_send_key);
 
 static struct cb_id kvp_id = { CN_KVP_IDX, CN_KVP_VAL };
 static const char kvp_name[] = "kvp_kernel_module";
@@ -121,10 +123,11 @@ kvp_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 	}
 }
 
-static int
-kvp_send_key(int index)
+static void
+kvp_send_key(struct work_struct *dummy)
 {
 	struct cn_msg *msg;
+	int index = kvp_transaction.index;
 
 	msg = kzalloc(sizeof(*msg) + sizeof(struct hv_kvp_msg) , GFP_ATOMIC);
 
@@ -136,9 +139,8 @@ kvp_send_key(int index)
 		msg->len = sizeof(struct hv_ku_msg);
 		cn_netlink_send(msg, 0, GFP_ATOMIC);
 		kfree(msg);
-		return 0;
 	}
-	return 1;
+	return;
 }
 
 /*
@@ -286,6 +288,7 @@ void hv_kvp_onchannelcallback(void *context)
 			kvp_transaction.recv_channel = channel;
 			kvp_transaction.recv_req_id = requestid;
 			kvp_transaction.active = true;
+			kvp_transaction.index = kvp_data->index;
 
 			/*
 			 * Get the information from the
@@ -296,8 +299,8 @@ void hv_kvp_onchannelcallback(void *context)
 			 * Set a timeout to deal with
 			 * user-mode not responding.
 			 */
-			kvp_send_key(kvp_data->index);
-			schedule_delayed_work(&kvp_work, 100);
+			schedule_work(&kvp_sendkey_work);
+			schedule_delayed_work(&kvp_work, 5*HZ);
 
 			return;
 
@@ -332,4 +335,5 @@ void hv_kvp_deinit(void)
 {
 	cn_del_callback(&kvp_id);
 	cancel_delayed_work_sync(&kvp_work);
+	cancel_work_sync(&kvp_sendkey_work);
 }
-- 
1.7.4.1

