Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab1F2OXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:23:20 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:51156
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755956Ab1F2OWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:22:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 25/40] Staging: hv: storvsc: Add state to manage the lifecycle of emulated HBA
Date: Wed, 29 Jun 2011 07:39:22 -0700
Message-Id: <1309358377-8537-25-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We setup a single emulated HBA for managing all IDE devices. To properly
deal with unloading of the driver, establish state to track who
should cleanup the emulated HBA.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hyperv_storage.h |    1 +
 drivers/staging/hv/storvsc.c        |    1 +
 drivers/staging/hv/storvsc_drv.c    |    9 ++++++++-
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/hyperv_storage.h b/drivers/staging/hv/hyperv_storage.h
index a15a53b..865ede1 100644
--- a/drivers/staging/hv/hyperv_storage.h
+++ b/drivers/staging/hv/hyperv_storage.h
@@ -281,6 +281,7 @@ struct storvsc_device {
 	int	 ref_count;
 	bool	 destroy;
 	bool	 drain_notify;
+	bool	 hba_owner;
 	atomic_t num_outstanding_req;
 
 	wait_queue_head_t waiting_to_drain;
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 4d13044..c06f750 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -42,6 +42,7 @@ static inline struct storvsc_device *alloc_stor_device(struct hv_device *device)
 
 	stor_device->ref_count = 1;
 	stor_device->destroy = false;
+	stor_device->hba_owner = false;
 	init_waitqueue_head(&stor_device->waiting_to_drain);
 	stor_device->device = device;
 	device->ext = stor_device;
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index fcc3f5d..898a311 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -349,6 +349,10 @@ static int storvsc_remove(struct hv_device *dev)
 	struct Scsi_Host *host = dev_get_drvdata(&dev->device);
 	struct hv_host_device *host_dev =
 			(struct hv_host_device *)host->hostdata;
+	struct storvsc_device *stor_dev = dev->ext;
+
+	if (!stor_dev->hba_owner)
+		return 0;
 
 	scsi_remove_host(host);
 
@@ -743,7 +747,10 @@ static int storvsc_probe(struct hv_device *device)
 		scsi_host_put(host);
 		return -ENODEV;
 	}
-
+	/*
+	 * This stor device owns the HBA; capture that state.
+	 */
+	((struct storvsc_device *)device->ext)->hba_owner = true;
 	host_dev->path = device_info.path_id;
 	host_dev->target = device_info.target_id;
 
-- 
1.7.4.1

