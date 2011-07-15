Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab1GORis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:38:48 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37357
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754201Ab1GORaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:08 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 090/117] Staging: hv: netvsc: Introduce state to manage the lifecycle of net device
Date: Fri, 15 Jul 2011 10:47:18 -0700
Message-Id: <1310752065-27895-90-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce state to manage the lifecycle of net device.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hyperv_net.h |    1 +
 drivers/staging/hv/netvsc.c     |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/hyperv_net.h b/drivers/staging/hv/hyperv_net.h
index 5782fea..0b347c1 100644
--- a/drivers/staging/hv/hyperv_net.h
+++ b/drivers/staging/hv/hyperv_net.h
@@ -371,6 +371,7 @@ struct netvsc_device {
 
 	atomic_t refcnt;
 	atomic_t num_outstanding_sends;
+	bool destroy;
 	/*
 	 * List of free preallocated hv_netvsc_packet to represent receive
 	 * packet
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 7722102..67cf7fb 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -43,6 +43,7 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 	/* Set to 2 to allow both inbound and outbound traffic */
 	atomic_set(&net_device->refcnt, 2);
 
+	net_device->destroy = false;
 	net_device->dev = device;
 	device->ext = net_device;
 
@@ -404,6 +405,8 @@ int netvsc_device_remove(struct hv_device *device)
 		return -ENODEV;
 	}
 
+	net_device->destroy = true;
+
 	/* Wait for all send completions */
 	while (atomic_read(&net_device->num_outstanding_sends)) {
 		dev_err(&device->device,
-- 
1.7.4.1

