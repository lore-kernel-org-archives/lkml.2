Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1EIVth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:49:37 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47719
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755077Ab1EIVoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 116/206] Staging: hv: Use the completion abstraction in struct rndis_request
Date: Mon,  9 May 2011 14:56:38 -0700
Message-Id: <1304978288-22999-116-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the completion abstraction in struct rndis_request to synchronize.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/rndis_filter.c |   33 ++++++++++++++-------------------
 1 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index ee74cd1..2037836 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -59,8 +59,7 @@ struct rndis_device {
 
 struct rndis_request {
 	struct list_head list_ent;
-	int wait_condition;
-	wait_queue_head_t wait_event;
+	struct completion  wait_event;
 
 	/*
 	 * FIXME: We assumed a fixed size response here. If we do ever need to
@@ -125,7 +124,7 @@ static struct rndis_request *get_rndis_request(struct rndis_device *dev,
 	if (!request)
 		return NULL;
 
-	init_waitqueue_head(&request->wait_event);
+	init_completion(&request->wait_event);
 
 	rndis_msg = &request->request_msg;
 	rndis_msg->ndis_msg_type = msg_type;
@@ -305,8 +304,7 @@ static void rndis_filter_receive_response(struct rndis_device *dev,
 			}
 		}
 
-		request->wait_condition = 1;
-		wake_up(&request->wait_event);
+		complete(&request->wait_event);
 	} else {
 		dev_err(&dev->net_dev->dev->device,
 			"no rndis request found for this response "
@@ -465,6 +463,7 @@ static int rndis_filter_query_device(struct rndis_device *dev, u32 oid,
 	struct rndis_query_request *query;
 	struct rndis_query_complete *query_complete;
 	int ret = 0;
+	int t;
 
 	if (!result)
 		return -EINVAL;
@@ -484,14 +483,12 @@ static int rndis_filter_query_device(struct rndis_device *dev, u32 oid,
 	query->info_buflen = 0;
 	query->dev_vc_handle = 0;
 
-	request->wait_condition = 0;
 	ret = rndis_filter_send_request(dev, request);
 	if (ret != 0)
 		goto Cleanup;
 
-	wait_event_timeout(request->wait_event, request->wait_condition,
-				msecs_to_jiffies(1000));
-	if (request->wait_condition == 0) {
+	t = wait_for_completion_timeout(&request->wait_event, HZ);
+	if (t == 0) {
 		ret = -ETIMEDOUT;
 		goto Cleanup;
 	}
@@ -543,7 +540,7 @@ static int rndis_filter_set_packet_filter(struct rndis_device *dev,
 	struct rndis_set_request *set;
 	struct rndis_set_complete *set_complete;
 	u32 status;
-	int ret;
+	int ret, t;
 
 	request = get_rndis_request(dev, REMOTE_NDIS_SET_MSG,
 			RNDIS_MESSAGE_SIZE(struct rndis_set_request) +
@@ -562,14 +559,13 @@ static int rndis_filter_set_packet_filter(struct rndis_device *dev,
 	memcpy((void *)(unsigned long)set + sizeof(struct rndis_set_request),
 	       &new_filter, sizeof(u32));
 
-	request->wait_condition = 0;
 	ret = rndis_filter_send_request(dev, request);
 	if (ret != 0)
 		goto Cleanup;
 
-	wait_event_timeout(request->wait_event, request->wait_condition,
-		msecs_to_jiffies(2000));
-	if (request->wait_condition == 0) {
+	t = wait_for_completion_timeout(&request->wait_event, HZ);
+
+	if (t == 0) {
 		ret = -1;
 		dev_err(&dev->net_dev->dev->device,
 			"timeout before we got a set response...\n");
@@ -624,7 +620,7 @@ static int rndis_filter_init_device(struct rndis_device *dev)
 	struct rndis_initialize_request *init;
 	struct rndis_initialize_complete *init_complete;
 	u32 status;
-	int ret;
+	int ret, t;
 
 	request = get_rndis_request(dev, REMOTE_NDIS_INITIALIZE_MSG,
 			RNDIS_MESSAGE_SIZE(struct rndis_initialize_request));
@@ -642,7 +638,6 @@ static int rndis_filter_init_device(struct rndis_device *dev)
 
 	dev->state = RNDIS_DEV_INITIALIZING;
 
-	request->wait_condition = 0;
 	ret = rndis_filter_send_request(dev, request);
 	if (ret != 0) {
 		dev->state = RNDIS_DEV_UNINITIALIZED;
@@ -650,9 +645,9 @@ static int rndis_filter_init_device(struct rndis_device *dev)
 	}
 
 
-	wait_event_timeout(request->wait_event, request->wait_condition,
-		msecs_to_jiffies(1000));
-	if (request->wait_condition == 0) {
+	t = wait_for_completion_timeout(&request->wait_event, HZ);
+
+	if (t == 0) {
 		ret = -ETIMEDOUT;
 		goto Cleanup;
 	}
-- 
1.7.4.1

