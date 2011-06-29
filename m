Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab1F2Oar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:30:47 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:51106
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755793Ab1F2OWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:22:53 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 06/40] Staging: hv: vmbus: Introduce a lock to protect the ext field in hv_device
Date: Wed, 29 Jun 2011 07:39:03 -0700
Message-Id: <1309358377-8537-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current mechanism for handling references in broken. 
Introduce a lock to protect the ext field in hv_device.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hyperv.h    |    3 +++
 drivers/staging/hv/vmbus_drv.c |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/hyperv.h b/drivers/staging/hv/hyperv.h
index 370b096..ff3c69d 100644
--- a/drivers/staging/hv/hyperv.h
+++ b/drivers/staging/hv/hyperv.h
@@ -830,6 +830,9 @@ struct hv_device {
 
 	struct vmbus_channel *channel;
 
+	/* This lock protects the device extension field */
+	spinlock_t ext_lock;
+
 	/* Device extension; */
 	void *ext;
 };
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 2e6bfc1..903362e 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -557,6 +557,7 @@ struct hv_device *vmbus_child_device_create(struct hv_guid *type,
 		return NULL;
 	}
 
+	spin_lock_init(&child_device_obj->ext_lock);
 	child_device_obj->channel = channel;
 	/*
 	 * Get the human readable device type name and stash it away.
-- 
1.7.4.1

