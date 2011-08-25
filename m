Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab1HYQfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:35:46 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42819
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753525Ab1HYQ25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:57 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 36/59] Staging: hv: storvsc: Cleanup error handling in storvsc_dev_add()
Date: Thu, 25 Aug 2011 09:49:02 -0700
Message-Id: <1314290965-2698-36-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard Linux error values and cleanup error handling. I would like
to acknowledge Andre Bartke (andre.bartke@gmail.com) for highlighting this
problem.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 3029786..915aeee 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -392,10 +392,8 @@ int storvsc_dev_add(struct hv_device *device,
 
 	device_info = (struct storvsc_device_info *)additional_info;
 	stor_device = alloc_stor_device(device);
-	if (!stor_device) {
-		ret = -1;
-		goto cleanup;
-	}
+	if (!stor_device)
+		return -ENOMEM;
 
 	/* Save the channel properties to our storvsc channel */
 
@@ -409,11 +407,13 @@ int storvsc_dev_add(struct hv_device *device,
 	stor_device->port_number = device_info->port_number;
 	/* Send it back up */
 	ret = storvsc_connect_to_vsp(device, device_info->ring_buffer_size);
-
+	if (ret) {
+		free_stor_device(stor_device);
+		return ret;
+	}
 	device_info->path_id = stor_device->path_id;
 	device_info->target_id = stor_device->target_id;
 
-cleanup:
 	return ret;
 }
 
-- 
1.7.4.1

