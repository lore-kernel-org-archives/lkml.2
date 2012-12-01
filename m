Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2LAO3v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:29:51 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:48765
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab2LAO2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:28:40 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 11/28] Drivers: hv: Change the signature for hv_signal_event()
Date: Sat,  1 Dec 2012 06:46:42 -0800
Message-Id: <1354373219-31374-11-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for implementing a per-connection signaling framework,
change the signature of the function hv_signal_event(). The current
code uses a global handle for signaling the host.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/connection.c   |    2 +-
 drivers/hv/hv.c           |    7 +++----
 drivers/hv/hyperv_vmbus.h |    2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 70ea5d1..3f8ce7b 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -402,5 +402,5 @@ int vmbus_set_event(u32 child_relid)
 		(unsigned long *)vmbus_connection.send_int_page +
 		(child_relid >> 5));
 
-	return hv_signal_event();
+	return hv_signal_event(hv_context.signal_event_param);
 }
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 3648f8f..dd0af89 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -273,13 +273,12 @@ int hv_post_message(union hv_connection_id connection_id,
  *
  * This involves a hypercall.
  */
-u16 hv_signal_event(void)
+u16 hv_signal_event(void *con_id)
 {
 	u16 status;
 
-	status = do_hypercall(HVCALL_SIGNAL_EVENT,
-			       hv_context.signal_event_param,
-			       NULL) & 0xFFFF;
+	status = (do_hypercall(HVCALL_SIGNAL_EVENT, con_id, NULL) & 0xFFFF);
+
 	return status;
 }
 
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index ac1e419..61d2c4f 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -538,7 +538,7 @@ extern int hv_post_message(union hv_connection_id connection_id,
 			 enum hv_message_type message_type,
 			 void *payload, size_t payload_size);
 
-extern u16 hv_signal_event(void);
+extern u16 hv_signal_event(void *con_id);
 
 extern void hv_synic_init(void *irqarg);
 
-- 
1.7.4.1

