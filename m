Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760377Ab2FUVSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:18:49 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:55672
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760341Ab2FUVSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:18:48 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 02/13] Drivers: hv: kvp: Cleanup error handling in KVP
Date: Thu, 21 Jun 2012 14:31:34 -0700
Message-Id: <1340314305-27126-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1340314305-27126-1-git-send-email-kys@microsoft.com>
References: <1340314200-27078-1-git-send-email-kys@microsoft.com>
 <1340314305-27126-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation to implementing IP injection, cleanup the way we propagate
and handle errors both in the driver as well as in the user level daemon.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv_kvp.c      |   43 +++++++++++++++++++------------------
 include/linux/hyperv.h   |   17 +++++++++-----
 tools/hv/hv_kvp_daemon.c |   53 +++++++++++++++++++++++----------------------
 3 files changed, 60 insertions(+), 53 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index 0012eed..6e6f0c2 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -50,7 +50,6 @@ static struct {
 
 static void kvp_send_key(struct work_struct *dummy);
 
-#define TIMEOUT_FIRED 1
 
 static void kvp_respond_to_host(char *key, char *value, int error);
 static void kvp_work_func(struct work_struct *dummy);
@@ -97,7 +96,7 @@ kvp_work_func(struct work_struct *dummy)
 	 * If the timer fires, the user-mode component has not responded;
 	 * process the pending transaction.
 	 */
-	kvp_respond_to_host("Unknown key", "Guest timed out", TIMEOUT_FIRED);
+	kvp_respond_to_host("Unknown key", "Guest timed out", HV_E_FAIL);
 }
 
 /*
@@ -109,27 +108,31 @@ kvp_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 {
 	struct hv_kvp_msg *message;
 	struct hv_kvp_msg_enumerate *data;
+	int	error;
 
 	message = (struct hv_kvp_msg *)msg->data;
-	switch (message->kvp_hdr.operation) {
-	case KVP_OP_REGISTER:
+
+	if (message->kvp_hdr.operation == KVP_OP_REGISTER) {
 		pr_info("KVP: user-mode registering done.\n");
 		kvp_register();
 		kvp_transaction.active = false;
-		hv_kvp_onchannelcallback(kvp_transaction.kvp_context);
-		break;
-
-	default:
-		data = &message->body.kvp_enum_data;
-		/*
-		 * Complete the transaction by forwarding the key value
-		 * to the host. But first, cancel the timeout.
-		 */
-		if (cancel_delayed_work_sync(&kvp_work))
-			kvp_respond_to_host(data->data.key,
-					 data->data.value,
-					!strlen(data->data.key));
+		if (kvp_transaction.kvp_context)
+			hv_kvp_onchannelcallback(kvp_transaction.kvp_context);
+		return;
 	}
+
+	/*
+	 * We use the message header information from
+	 * the user level daemon to transmit errors.
+	 */
+	error = *((int *)(&message->kvp_hdr.operation));
+	data = &message->body.kvp_enum_data;
+	/*
+	 * Complete the transaction by forwarding the key value
+	 * to the host. But first, cancel the timeout.
+	 */
+	if (cancel_delayed_work_sync(&kvp_work))
+		kvp_respond_to_host(data->data.key, data->data.value, error);
 }
 
 static void
@@ -287,6 +290,7 @@ kvp_respond_to_host(char *key, char *value, int error)
 		 */
 		return;
 
+	icmsghdrp->status = error;
 
 	/*
 	 * If the error parameter is set, terminate the host's enumeration
@@ -294,15 +298,12 @@ kvp_respond_to_host(char *key, char *value, int error)
 	 */
 	if (error) {
 		/*
-		 * Something failed or the we have timedout;
+		 * Something failed or  we have timedout;
 		 * terminate the current  host-side iteration.
 		 */
-		icmsghdrp->status = HV_S_CONT;
 		goto response_done;
 	}
 
-	icmsghdrp->status = HV_S_OK;
-
 	kvp_msg = (struct hv_kvp_msg *)
 			&recv_buffer[sizeof(struct vmbuspipe_hdr) +
 			sizeof(struct icmsg_hdr)];
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 0497764..9d75699 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -142,6 +142,17 @@ enum hv_kvp_exchg_pool {
 	KVP_POOL_COUNT /* Number of pools, must be last. */
 };
 
+/*
+ * Some Hyper-V status codes.
+ */
+
+#define HV_S_OK				0x00000000
+#define HV_E_FAIL			0x80004005
+#define HV_S_CONT			0x80070103
+#define HV_ERROR_NOT_SUPPORTED		0x80070032
+#define HV_ERROR_MACHINE_LOCKED		0x800704F7
+#define HV_ERROR_DEVICE_NOT_CONNECTED	0x8007048F
+
 #define ADDR_FAMILY_NONE	0x00
 #define ADDR_FAMILY_IPV4	0x01
 #define ADDR_FAMILY_IPV6	0x02
@@ -1000,12 +1011,6 @@ void vmbus_driver_unregister(struct hv_driver *hv_driver);
 #define ICMSGHDRFLAG_REQUEST		2
 #define ICMSGHDRFLAG_RESPONSE		4
 
-#define HV_S_OK				0x00000000
-#define HV_E_FAIL			0x80004005
-#define HV_S_CONT			0x80070103
-#define HV_ERROR_NOT_SUPPORTED		0x80070032
-#define HV_ERROR_MACHINE_LOCKED		0x800704F7
-#define HV_ERROR_DEVICE_NOT_CONNECTED	0x8007048F
 
 /*
  * While we want to handle util services as regular devices,
diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index d9834b3..4831997 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -394,7 +394,7 @@ static int kvp_get_value(int pool, __u8 *key, int key_size, __u8 *value,
 	return 1;
 }
 
-static void kvp_pool_enumerate(int pool, int index, __u8 *key, int key_size,
+static int kvp_pool_enumerate(int pool, int index, __u8 *key, int key_size,
 				__u8 *value, int value_size)
 {
 	struct kvp_record *record;
@@ -406,16 +406,12 @@ static void kvp_pool_enumerate(int pool, int index, __u8 *key, int key_size,
 	record = kvp_file_info[pool].records;
 
 	if (index >= kvp_file_info[pool].num_records) {
-		/*
-		 * This is an invalid index; terminate enumeration;
-		 * - a NULL value will do the trick.
-		 */
-		strcpy(value, "");
-		return;
+		return 1;
 	}
 
 	memcpy(key, record[index].key, key_size);
 	memcpy(value, record[index].value, value_size);
+	return 0;
 }
 
 
@@ -646,6 +642,8 @@ int main(void)
 	char	*p;
 	char	*key_value;
 	char	*key_name;
+	int	op;
+	int	pool;
 
 	daemon(1, 0);
 	openlog("KVP", 0, LOG_USER);
@@ -721,7 +719,16 @@ int main(void)
 		incoming_cn_msg = (struct cn_msg *)NLMSG_DATA(incoming_msg);
 		hv_msg = (struct hv_kvp_msg *)incoming_cn_msg->data;
 
-		switch (hv_msg->kvp_hdr.operation) {
+		/*
+		 * We will use the KVP header information to pass back
+		 * the error from this daemon. So, first copy the state
+		 * and set the error code to success.
+		 */
+		op = hv_msg->kvp_hdr.operation;
+		pool = hv_msg->kvp_hdr.pool;
+		*((int *)(&hv_msg->kvp_hdr.operation)) = HV_S_OK;
+
+		switch (op) {
 		case KVP_OP_REGISTER:
 			/*
 			 * Driver is registering with us; stash away the version
@@ -738,20 +745,14 @@ int main(void)
 			}
 			continue;
 
-		/*
-		 * The current protocol with the kernel component uses a
-		 * NULL key name to pass an error condition.
-		 * For the SET, GET and DELETE operations,
-		 * use the existing protocol to pass back error.
-		 */
-
 		case KVP_OP_SET:
 			if (kvp_key_add_or_modify(hv_msg->kvp_hdr.pool,
 					hv_msg->body.kvp_set.data.key,
 					hv_msg->body.kvp_set.data.key_size,
 					hv_msg->body.kvp_set.data.value,
 					hv_msg->body.kvp_set.data.value_size))
-				strcpy(hv_msg->body.kvp_set.data.key, "");
+				*((int *)(&hv_msg->kvp_hdr.operation)) =
+								HV_S_CONT;
 			break;
 
 		case KVP_OP_GET:
@@ -760,14 +761,16 @@ int main(void)
 					hv_msg->body.kvp_set.data.key_size,
 					hv_msg->body.kvp_set.data.value,
 					hv_msg->body.kvp_set.data.value_size))
-				strcpy(hv_msg->body.kvp_set.data.key, "");
+				*((int *)(&hv_msg->kvp_hdr.operation)) =
+								HV_S_CONT;
 			break;
 
 		case KVP_OP_DELETE:
 			if (kvp_key_delete(hv_msg->kvp_hdr.pool,
 					hv_msg->body.kvp_delete.key,
 					hv_msg->body.kvp_delete.key_size))
-				strcpy(hv_msg->body.kvp_delete.key, "");
+				*((int *)(&hv_msg->kvp_hdr.operation)) =
+								HV_S_CONT;
 			break;
 
 		default:
@@ -782,13 +785,15 @@ int main(void)
 		 * both the key and the value; if not read from the
 		 * appropriate pool.
 		 */
-		if (hv_msg->kvp_hdr.pool != KVP_POOL_AUTO) {
-			kvp_pool_enumerate(hv_msg->kvp_hdr.pool,
+		if (pool != KVP_POOL_AUTO) {
+			if (kvp_pool_enumerate(hv_msg->kvp_hdr.pool,
 					hv_msg->body.kvp_enum_data.index,
 					hv_msg->body.kvp_enum_data.data.key,
 					HV_KVP_EXCHANGE_MAX_KEY_SIZE,
 					hv_msg->body.kvp_enum_data.data.value,
-					HV_KVP_EXCHANGE_MAX_VALUE_SIZE);
+					HV_KVP_EXCHANGE_MAX_VALUE_SIZE))
+				*((int *)(&hv_msg->kvp_hdr.operation)) =
+								HV_S_CONT;
 			goto kvp_done;
 		}
 
@@ -841,11 +846,7 @@ int main(void)
 			strcpy(key_name, "ProcessorArchitecture");
 			break;
 		default:
-			strcpy(key_value, "Unknown Key");
-			/*
-			 * We use a null key name to terminate enumeration.
-			 */
-			strcpy(key_name, "");
+			*((int *)(&hv_msg->kvp_hdr.operation)) = HV_S_CONT;
 			break;
 		}
 		/*
-- 
1.7.4.1

