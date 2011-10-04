Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933831Ab1JDVLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 17:11:11 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:36364
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933776Ab1JDVLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 17:11:10 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, longli@microsoft.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/1] Staging: hv: util: Fix a bug in kvp implementation
Date: Tue,  4 Oct 2011 14:00:02 -0700
Message-Id: <1317762002-4351-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The host gurantees that there can be only one kvp transaction active
against the guest. So, the transaction active state is needed only to
protect against spurious user level calls. The current code had a race
condition where the guest could prematurely return because the previous
transaction state was not cleared - this state was being cleared after
sending the response to the host and there was a window where the host
could notify the guest of a new transaction before the transaction active
state was properly set. 
Also deal with the case when the user mode component
does not respond in a timely fashion correctly.
I would like to thank Long Li <longli@microsoft.com>
for identifying the problem.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Diagnosed-by: Long Li <longli@microsoft.com>
---
 drivers/staging/hv/hv_kvp.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/hv_kvp.c b/drivers/staging/hv/hv_kvp.c
index 9aa9ede..307aedc 100644
--- a/drivers/staging/hv/hv_kvp.c
+++ b/drivers/staging/hv/hv_kvp.c
@@ -50,6 +50,8 @@ static struct {
 
 static int kvp_send_key(int index);
 
+#define TIMEOUT_FIRED 1
+
 static void kvp_respond_to_host(char *key, char *value, int error);
 static void kvp_work_func(struct work_struct *dummy);
 static void kvp_register(void);
@@ -58,7 +60,6 @@ static DECLARE_DELAYED_WORK(kvp_work, kvp_work_func);
 
 static struct cb_id kvp_id = { CN_KVP_IDX, CN_KVP_VAL };
 static const char kvp_name[] = "kvp_kernel_module";
-static int timeout_fired;
 static u8 *recv_buffer;
 /*
  * Register the kernel component with the user-level daemon.
@@ -90,8 +91,7 @@ kvp_work_func(struct work_struct *dummy)
 	 * If the timer fires, the user-mode component has not responded;
 	 * process the pending transaction.
 	 */
-	kvp_respond_to_host("Unknown key", "Guest timed out", timeout_fired);
-	timeout_fired = 1;
+	kvp_respond_to_host("Unknown key", "Guest timed out", TIMEOUT_FIRED);
 }
 
 /*
@@ -177,6 +177,8 @@ kvp_respond_to_host(char *key, char *value, int error)
 	channel = kvp_transaction.recv_channel;
 	req_id = kvp_transaction.recv_req_id;
 
+	kvp_transaction.active = false;
+
 	if (channel->onchannel_callback == NULL)
 		/*
 		 * We have raced with util driver being unloaded;
@@ -224,7 +226,6 @@ response_done:
 	vmbus_sendpacket(channel, recv_buffer, buf_len, req_id,
 				VM_PKT_DATA_INBAND, 0);
 
-	kvp_transaction.active = false;
 }
 
 /*
@@ -250,10 +251,6 @@ void hv_kvp_onchannelcallback(void *context)
 	struct icmsg_negotiate *negop = NULL;
 
 
-	if (kvp_transaction.active)
-		return;
-
-
 	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE, &recvlen, &requestid);
 
 	if (recvlen > 0) {
-- 
1.7.4.1

