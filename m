Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1HYQhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:37:10 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42813
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753523Ab1HYQ25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:57 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 35/59] Staging: hv: vmbus: Retry vmbus_post_msg() before giving up
Date: Thu, 25 Aug 2011 09:49:01 -0700
Message-Id: <1314290965-2698-35-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function hv_post_msg() can fail because of transient resource
conditions. It may be useful to retry the operation.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 arch/x86/include/asm/hyperv.h   |    1 +
 drivers/staging/hv/connection.c |   18 +++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/hyperv.h b/arch/x86/include/asm/hyperv.h
index 5df477a..b80420b 100644
--- a/arch/x86/include/asm/hyperv.h
+++ b/arch/x86/include/asm/hyperv.h
@@ -189,5 +189,6 @@
 #define HV_STATUS_INVALID_HYPERCALL_CODE	2
 #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
 #define HV_STATUS_INVALID_ALIGNMENT		4
+#define HV_STATUS_INSUFFICIENT_BUFFERS		19
 
 #endif
diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index 0e7efce..a88ad70 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
+#include <linux/delay.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
@@ -268,10 +269,25 @@ void vmbus_on_event(unsigned long data)
 int vmbus_post_msg(void *buffer, size_t buflen)
 {
 	union hv_connection_id conn_id;
+	int ret = 0;
+	int retries = 0;
 
 	conn_id.asu32 = 0;
 	conn_id.u.id = VMBUS_MESSAGE_CONNECTION_ID;
-	return hv_post_message(conn_id, 1, buffer, buflen);
+
+	/*
+	 * hv_post_message() can have transient failures because of
+	 * insufficient resources. Retry the operation a couple of
+	 * times before giving up.
+	 */
+	while (retries < 3) {
+		ret =  hv_post_message(conn_id, 1, buffer, buflen);
+		if (ret != HV_STATUS_INSUFFICIENT_BUFFERS)
+			return ret;
+		retries++;
+		msleep(100);
+	}
+	return ret;
 }
 
 /*
-- 
1.7.4.1

