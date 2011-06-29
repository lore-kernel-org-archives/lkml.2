Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab1F2OaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:30:16 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:48328
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755883Ab1F2OWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:22:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 16/40] Staging: hv: netvsc: Introduce state to manage the lifecycle of net device
Date: Wed, 29 Jun 2011 07:39:13 -0700
Message-Id: <1309358377-8537-16-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for cleaning up reference counts, introduce state to manage
the lifecycle of net device.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hyperv_net.h |    1 +
 drivers/staging/hv/netvsc.c     |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/hyperv_net.h b/drivers/staging/hv/hyperv_net.h
index b5bee9e..c6836be 100644
--- a/drivers/staging/hv/hyperv_net.h
+++ b/drivers/staging/hv/hyperv_net.h
@@ -371,6 +371,7 @@ struct netvsc_device {
 
 	atomic_t refcnt;
 	atomic_t num_outstanding_sends;
+	bool destroy;
 	bool drain_notify;
 	wait_queue_head_t waiting_to_drain;
 	/*
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 56749ca..f03018c 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -43,6 +43,7 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 	/* Set to 2 to allow both inbound and outbound traffic */
 	atomic_set(&net_device->refcnt, 2);
 	net_device->drain_notify = false;
+	net_device->destroy = false;
 	init_waitqueue_head(&net_device->waiting_to_drain);
 
 	net_device->dev = device;
@@ -409,6 +410,7 @@ int netvsc_device_remove(struct hv_device *device)
 		netdev_err(ndev, "No net device present!!\n");
 		return -ENODEV;
 	}
+	net_device->destroy = true;
 
 	/* Wait for all send completions */
 	while (atomic_read(&net_device->num_outstanding_sends)) {
-- 
1.7.4.1

