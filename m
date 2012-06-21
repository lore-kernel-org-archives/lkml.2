Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497Ab2FUVkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:40:12 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:48812
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760446Ab2FUVkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:40:08 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 03/13] Drivers: hv: kvp: Support the new IP injection messages
Date: Thu, 21 Jun 2012 14:31:35 -0700
Message-Id: <1340314305-27126-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1340314305-27126-1-git-send-email-kys@microsoft.com>
References: <1340314200-27078-1-git-send-email-kys@microsoft.com>
 <1340314305-27126-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement support for the new IP injection messages in the driver code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv_kvp.c |   70 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 63 insertions(+), 7 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index 6e6f0c2..4fd0932 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -51,7 +51,7 @@ static struct {
 static void kvp_send_key(struct work_struct *dummy);
 
 
-static void kvp_respond_to_host(char *key, char *value, int error);
+static void kvp_respond_to_host(struct hv_kvp_msg *msg, int error);
 static void kvp_work_func(struct work_struct *dummy);
 static void kvp_register(void);
 
@@ -96,7 +96,7 @@ kvp_work_func(struct work_struct *dummy)
 	 * If the timer fires, the user-mode component has not responded;
 	 * process the pending transaction.
 	 */
-	kvp_respond_to_host("Unknown key", "Guest timed out", HV_E_FAIL);
+	kvp_respond_to_host(NULL, HV_E_FAIL);
 }
 
 /*
@@ -107,7 +107,6 @@ static void
 kvp_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 {
 	struct hv_kvp_msg *message;
-	struct hv_kvp_msg_enumerate *data;
 	int	error;
 
 	message = (struct hv_kvp_msg *)msg->data;
@@ -126,13 +125,59 @@ kvp_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 	 * the user level daemon to transmit errors.
 	 */
 	error = *((int *)(&message->kvp_hdr.operation));
-	data = &message->body.kvp_enum_data;
 	/*
 	 * Complete the transaction by forwarding the key value
 	 * to the host. But first, cancel the timeout.
 	 */
 	if (cancel_delayed_work_sync(&kvp_work))
-		kvp_respond_to_host(data->data.key, data->data.value, error);
+		kvp_respond_to_host(message, error);
+}
+
+static void process_ipinfo(struct hv_kvp_msg *in_msg,
+		struct hv_kvp_msg *out_msg, int op)
+{
+	switch (op) {
+	case KVP_OP_SET_IP_INFO:
+		/*
+		 * Transform all parameters into utf8 encoding.
+		 */
+		utf16s_to_utf8s((wchar_t *)in_msg->body.kvp_ip_val.ip_addr,
+				MAX_IP_ADDR_SIZE,
+				UTF16_LITTLE_ENDIAN,
+				(__u8 *)out_msg->body.kvp_ip_val.ip_addr,
+				MAX_IP_ADDR_SIZE);
+
+		utf16s_to_utf8s((wchar_t *)in_msg->body.kvp_ip_val.sub_net,
+				MAX_IP_ADDR_SIZE,
+				UTF16_LITTLE_ENDIAN,
+				(__u8 *)out_msg->body.kvp_ip_val.sub_net,
+				MAX_IP_ADDR_SIZE);
+
+		utf16s_to_utf8s((wchar_t *)in_msg->body.kvp_ip_val.gate_way,
+				MAX_GATEWAY_SIZE,
+				UTF16_LITTLE_ENDIAN,
+				(__u8 *)out_msg->body.kvp_ip_val.gate_way,
+				MAX_GATEWAY_SIZE);
+
+		utf16s_to_utf8s((wchar_t *)in_msg->body.kvp_ip_val.dns_addr,
+				MAX_IP_ADDR_SIZE,
+				UTF16_LITTLE_ENDIAN,
+				(__u8 *)out_msg->body.kvp_ip_val.dns_addr,
+				MAX_IP_ADDR_SIZE);
+
+		out_msg->body.kvp_ip_val.dhcp_enabled =
+		in_msg->body.kvp_ip_val.dhcp_enabled;
+
+	default:
+		utf16s_to_utf8s((wchar_t *)in_msg->body.kvp_ip_val.adapter_id,
+				MAX_ADAPTER_ID_SIZE,
+				UTF16_LITTLE_ENDIAN,
+				(__u8 *)out_msg->body.kvp_ip_val.adapter_id,
+				MAX_ADAPTER_ID_SIZE);
+
+		out_msg->body.kvp_ip_val.addr_family =
+		in_msg->body.kvp_ip_val.addr_family;
+	}
 }
 
 static void
@@ -170,6 +215,12 @@ kvp_send_key(struct work_struct *dummy)
 	 */
 
 	switch (message->kvp_hdr.operation) {
+	case KVP_OP_SET_IP_INFO:
+		process_ipinfo(in_msg, message, KVP_OP_SET_IP_INFO);
+		break;
+	case KVP_OP_GET_IP_INFO:
+		process_ipinfo(in_msg, message, KVP_OP_GET_IP_INFO);
+		break;
 	case KVP_OP_SET:
 		switch (in_msg->body.kvp_set.data.value_type) {
 		case REG_SZ:
@@ -246,11 +297,12 @@ kvp_send_key(struct work_struct *dummy)
  */
 
 static void
-kvp_respond_to_host(char *key, char *value, int error)
+kvp_respond_to_host(struct hv_kvp_msg *msg_to_host, int error)
 {
 	struct hv_kvp_msg  *kvp_msg;
 	struct hv_kvp_exchg_msg_value  *kvp_data;
 	char	*key_name;
+	char	*value;
 	struct icmsg_hdr *icmsghdrp;
 	int	keylen = 0;
 	int	valuelen = 0;
@@ -309,6 +361,9 @@ kvp_respond_to_host(char *key, char *value, int error)
 			sizeof(struct icmsg_hdr)];
 
 	switch (kvp_transaction.kvp_msg->kvp_hdr.operation) {
+	case KVP_OP_GET_IP_INFO:
+		process_ipinfo(msg_to_host, kvp_msg, KVP_OP_SET_IP_INFO);
+		goto response_done;
 	case KVP_OP_GET:
 		kvp_data = &kvp_msg->body.kvp_get.data;
 		goto copy_value;
@@ -322,7 +377,7 @@ kvp_respond_to_host(char *key, char *value, int error)
 	}
 
 	kvp_data = &kvp_msg->body.kvp_enum_data.data;
-	key_name = key;
+	key_name = msg_to_host->body.kvp_enum_data.data.key;
 
 	/*
 	 * The windows host expects the key/value pair to be encoded
@@ -336,6 +391,7 @@ kvp_respond_to_host(char *key, char *value, int error)
 	kvp_data->key_size = 2*(keylen + 1); /* utf16 encoding */
 
 copy_value:
+	value = msg_to_host->body.kvp_enum_data.data.value;
 	valuelen = utf8s_to_utf16s(value, strlen(value), UTF16_HOST_ENDIAN,
 				(wchar_t *) kvp_data->value,
 				(HV_KVP_EXCHANGE_MAX_VALUE_SIZE / 2) - 2);
-- 
1.7.4.1

