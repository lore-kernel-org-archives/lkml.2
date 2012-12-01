Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab2LAOYU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:24:20 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:45206
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269Ab2LAOXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:40 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 28/28] Drivers: hv: Cleanup and consolidate reporting of build/version info
Date: Sat,  1 Dec 2012 06:46:59 -0800
Message-Id: <1354373219-31374-28-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, cleanup and consolidate reporting of host and vmbus version numbers.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/connection.c |   11 +++++++----
 drivers/hv/hv.c         |    7 -------
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 3965537..253a74b 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -120,9 +120,6 @@ static int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo,
 	if (msginfo->response.version_response.version_supported) {
 		vmbus_connection.conn_state = CONNECTED;
 	} else {
-		pr_err("Unable to connect, "
-			"Version %d not supported by Hyper-V\n",
-			version);
 		return -ECONNREFUSED;
 	}
 
@@ -208,11 +205,17 @@ int vmbus_connect(void)
 		goto cleanup;
 
 	vmbus_proto_version = version;
-	pr_info("Negotiated host information %d\n", version);
+	pr_info("Hyper-V Host Build:%d-%d.%d-%d-%d.%d; Vmbus version:%d.%d\n",
+		    host_info_eax, host_info_ebx >> 16,
+		    host_info_ebx & 0xFFFF, host_info_ecx,
+		    host_info_edx >> 24, host_info_edx & 0xFFFFFF,
+		    version >> 16, version & 0xFFFF);
+
 	kfree(msginfo);
 	return 0;
 
 cleanup:
+	pr_err("Unable to connect to host\n");
 	vmbus_connection.conn_state = DISCONNECTED;
 
 	if (vmbus_connection.work_queue)
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 0cd2da3..1c5481d 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -74,13 +74,6 @@ static int query_hypervisor_info(void)
 		edx = 0;
 		op = HVCPUID_VERSION;
 		cpuid(op, &eax, &ebx, &ecx, &edx);
-		pr_info("Hyper-V Host OS Build:%d-%d.%d-%d-%d.%d\n",
-			    eax,
-			    ebx >> 16,
-			    ebx & 0xFFFF,
-			    ecx,
-			    edx >> 24,
-			    edx & 0xFFFFFF);
 		host_info_eax = eax;
 		host_info_ebx = ebx;
 		host_info_ecx = ecx;
-- 
1.7.4.1

