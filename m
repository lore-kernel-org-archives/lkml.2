Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab1H0SL7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:11:59 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54795
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751484Ab1H0SLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:11 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 06/46] Staging: hv: storvsc: Introduce state to manage the lifecycle of stor device
Date: Sat, 27 Aug 2011 11:31:05 -0700
Message-Id: <1314469905-7058-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce state to manage the lifecycle of stor device. This would be the
basis for managing the references on the stor object.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hyperv_storage.h |    2 +-
 drivers/staging/hv/storvsc.c        |    8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

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
index 48bd8da..0f8c609 100644
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
@@ -399,9 +399,15 @@ int storvsc_dev_add(struct hv_device *device,
 int storvsc_dev_remove(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
+	unsigned long flags;
+
 
 	stor_device = release_stor_device(device);
 
+	spin_lock_irqsave(&device->channel->inbound_lock, flags);
+	stor_device->destroy = true;
+	spin_unlock_irqrestore(&device->channel->inbound_lock, flags);
+
 	/*
 	 * At this point, all outbound traffic should be disable. We
 	 * only allow inbound traffic (responses) to proceed so that
-- 
1.7.4.1

