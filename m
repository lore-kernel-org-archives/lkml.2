Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab2GNUVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 16:21:17 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:41488
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751747Ab2GNUTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 16:19:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 04/15] Drivers: hv: kvp: Support the new IP injection messages
Date: Sat, 14 Jul 2012 13:34:09 -0700
Message-Id: <1342298060-12662-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1342298060-12662-1-git-send-email-kys@microsoft.com>
References: <1342297930-12607-1-git-send-email-kys@microsoft.com>
 <1342298060-12662-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement support for the new IP injection messages in the driver code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv_kvp.c |  141 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 133 insertions(+), 8 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index 6e6f0c2..15c641c 100644
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
@@ -126,13 +125,119 @@ kvp_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
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
+static int process_ob_ipinfo(void *in_msg, void *out_msg, int op)
+{
+	struct hv_kvp_msg *in = in_msg;
+	struct hv_kvp_ip_msg *out = out_msg;
+	int len;
+
+	switch (op) {
+	case KVP_OP_GET_IP_INFO:
+		/*
+		 * Transform all parameters into utf16 encoding.
+		 */
+		len = utf8s_to_utf16s((char *)in->body.kvp_ip_val.ip_addr,
+				strlen((char *)in->body.kvp_ip_val.ip_addr),
+				UTF16_HOST_ENDIAN,
+				(wchar_t *)out->kvp_ip_val.ip_addr,
+				MAX_IP_ADDR_SIZE);
+		if (len < 0)
+			return len;
+
+		len = utf8s_to_utf16s((char *)in->body.kvp_ip_val.sub_net,
+				strlen((char *)in->body.kvp_ip_val.sub_net),
+				UTF16_HOST_ENDIAN,
+				(wchar_t *)out->kvp_ip_val.sub_net,
+				MAX_IP_ADDR_SIZE);
+		if (len < 0)
+			return len;
+
+		len = utf8s_to_utf16s((char *)in->body.kvp_ip_val.gate_way,
+				strlen((char *)in->body.kvp_ip_val.gate_way),
+				UTF16_HOST_ENDIAN,
+				(wchar_t *)out->kvp_ip_val.gate_way,
+				MAX_GATEWAY_SIZE);
+		if (len < 0)
+			return len;
+
+		len = utf8s_to_utf16s((char *)in->body.kvp_ip_val.dns_addr,
+				strlen((char *)in->body.kvp_ip_val.dns_addr),
+				UTF16_HOST_ENDIAN,
+				(wchar_t *)out->kvp_ip_val.dns_addr,
+				MAX_IP_ADDR_SIZE);
+		if (len < 0)
+			return len;
+
+		len = utf8s_to_utf16s((char *)in->body.kvp_ip_val.adapter_id,
+				strlen((char *)in->body.kvp_ip_val.adapter_id),
+				UTF16_HOST_ENDIAN,
+				(wchar_t *)out->kvp_ip_val.adapter_id,
+				MAX_IP_ADDR_SIZE);
+		if (len < 0)
+			return len;
+
+		out->kvp_ip_val.dhcp_enabled =
+			in->body.kvp_ip_val.dhcp_enabled;
+	}
+
+	return 0;
+}
+
+static void process_ib_ipinfo(void *in_msg, void *out_msg, int op)
+{
+	struct hv_kvp_ip_msg *in = in_msg;
+	struct hv_kvp_msg *out = out_msg;
+
+	switch (op) {
+	case KVP_OP_SET_IP_INFO:
+		/*
+		 * Transform all parameters into utf8 encoding.
+		 */
+		utf16s_to_utf8s((wchar_t *)in->kvp_ip_val.ip_addr,
+				MAX_IP_ADDR_SIZE,
+				UTF16_LITTLE_ENDIAN,
+				(__u8 *)out->body.kvp_ip_val.ip_addr,
+				MAX_IP_ADDR_SIZE);
+
+		utf16s_to_utf8s((wchar_t *)in->kvp_ip_val.sub_net,
+				MAX_IP_ADDR_SIZE,
+				UTF16_LITTLE_ENDIAN,
+				(__u8 *)out->body.kvp_ip_val.sub_net,
+				MAX_IP_ADDR_SIZE);
+
+		utf16s_to_utf8s((wchar_t *)in->kvp_ip_val.gate_way,
+				MAX_GATEWAY_SIZE,
+				UTF16_LITTLE_ENDIAN,
+				(__u8 *)out->body.kvp_ip_val.gate_way,
+				MAX_GATEWAY_SIZE);
+
+		utf16s_to_utf8s((wchar_t *)in->kvp_ip_val.dns_addr,
+				MAX_IP_ADDR_SIZE,
+				UTF16_LITTLE_ENDIAN,
+				(__u8 *)out->body.kvp_ip_val.dns_addr,
+				MAX_IP_ADDR_SIZE);
+
+		out->body.kvp_ip_val.dhcp_enabled =
+			in->kvp_ip_val.dhcp_enabled;
+
+	default:
+		utf16s_to_utf8s((wchar_t *)in->kvp_ip_val.adapter_id,
+				MAX_ADAPTER_ID_SIZE,
+				UTF16_LITTLE_ENDIAN,
+				(__u8 *)out->body.kvp_ip_val.adapter_id,
+				MAX_ADAPTER_ID_SIZE);
+
+		out->body.kvp_ip_val.addr_family =
+		in->kvp_ip_val.addr_family;
+	}
 }
 
 static void
@@ -170,6 +275,12 @@ kvp_send_key(struct work_struct *dummy)
 	 */
 
 	switch (message->kvp_hdr.operation) {
+	case KVP_OP_SET_IP_INFO:
+		process_ib_ipinfo(in_msg, message, KVP_OP_SET_IP_INFO);
+		break;
+	case KVP_OP_GET_IP_INFO:
+		process_ib_ipinfo(in_msg, message, KVP_OP_GET_IP_INFO);
+		break;
 	case KVP_OP_SET:
 		switch (in_msg->body.kvp_set.data.value_type) {
 		case REG_SZ:
@@ -246,17 +357,19 @@ kvp_send_key(struct work_struct *dummy)
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
 	u32	buf_len;
 	struct vmbus_channel *channel;
 	u64	req_id;
+	int ret;
 
 	/*
 	 * If a transaction is not active; log and return.
@@ -309,6 +422,16 @@ kvp_respond_to_host(char *key, char *value, int error)
 			sizeof(struct icmsg_hdr)];
 
 	switch (kvp_transaction.kvp_msg->kvp_hdr.operation) {
+	case KVP_OP_GET_IP_INFO:
+		ret = process_ob_ipinfo(msg_to_host,
+				 (struct hv_kvp_ip_msg *)kvp_msg,
+				 KVP_OP_GET_IP_INFO);
+		if (ret < 0)
+			icmsghdrp->status = HV_E_FAIL;
+
+		goto response_done;
+	case KVP_OP_SET_IP_INFO:
+		goto response_done;
 	case KVP_OP_GET:
 		kvp_data = &kvp_msg->body.kvp_get.data;
 		goto copy_value;
@@ -322,7 +445,7 @@ kvp_respond_to_host(char *key, char *value, int error)
 	}
 
 	kvp_data = &kvp_msg->body.kvp_enum_data.data;
-	key_name = key;
+	key_name = msg_to_host->body.kvp_enum_data.data.key;
 
 	/*
 	 * The windows host expects the key/value pair to be encoded
@@ -336,6 +459,7 @@ kvp_respond_to_host(char *key, char *value, int error)
 	kvp_data->key_size = 2*(keylen + 1); /* utf16 encoding */
 
 copy_value:
+	value = msg_to_host->body.kvp_enum_data.data.value;
 	valuelen = utf8s_to_utf16s(value, strlen(value), UTF16_HOST_ENDIAN,
 				(wchar_t *) kvp_data->value,
 				(HV_KVP_EXCHANGE_MAX_VALUE_SIZE / 2) - 2);
@@ -388,7 +512,8 @@ void hv_kvp_onchannelcallback(void *context)
 		return;
 	}
 
-	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE, &recvlen, &requestid);
+	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE * 2, &recvlen,
+			 &requestid);
 
 	if (recvlen > 0) {
 		icmsghdrp = (struct icmsg_hdr *)&recv_buffer[
-- 
1.7.4.1

