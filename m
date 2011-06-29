Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab1F2OW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:22:56 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:51083
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754902Ab1F2OWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:22:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 05/40] Staging: hv: storvsc: Introduce state to manage the lifecycle of stor device
Date: Wed, 29 Jun 2011 07:39:02 -0700
Message-Id: <1309358377-8537-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce state to manage the lifecycle of stor device. This would be the
basis for managing the references on the stor object.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hyperv_storage.h |    2 +-
 drivers/staging/hv/storvsc.c        |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/hyperv_storage.h b/drivers/staging/hv/hyperv_storage.h
index a224413..d93bf93 100644
--- a/drivers/staging/hv/hyperv_storage.h
+++ b/drivers/staging/hv/hyperv_storage.h
@@ -266,7 +266,7 @@ struct storvsc_device {
 
 	/* 0 indicates the device is being destroyed */
 	atomic_t ref_count;
-
+	bool	 destroy;
 	bool	 drain_notify;
 	atomic_t num_outstanding_req;
 
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 48bd8da..357b08a 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -43,7 +43,7 @@ static inline struct storvsc_device *alloc_stor_device(struct hv_device *device)
 	/* Set to 2 to allow both inbound and outbound traffics */
 	/* (ie get_out_stor_device() and get_in_stor_device()) to proceed. */
 	atomic_set(&stor_device->ref_count, 2);
-
+	stor_device->destroy = false;
 	init_waitqueue_head(&stor_device->waiting_to_drain);
 	stor_device->device = device;
 	device->ext = stor_device;
@@ -401,6 +401,7 @@ int storvsc_dev_remove(struct hv_device *device)
 	struct storvsc_device *stor_device;
 
 	stor_device = release_stor_device(device);
+	stor_device->destroy = true;
 
 	/*
 	 * At this point, all outbound traffic should be disable. We
-- 
1.7.4.1

