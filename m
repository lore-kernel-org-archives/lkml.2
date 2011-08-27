Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab1H0SLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:11:36 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:39802
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751267Ab1H0SLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:09 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 13/46] Staging: hv: netvsc: Introduce state to manage the lifecycle of net device
Date: Sat, 27 Aug 2011 11:31:12 -0700
Message-Id: <1314469905-7058-13-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce state to manage the lifecycle of net device.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hyperv_net.h |    1 +
 drivers/staging/hv/netvsc.c     |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)

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
index 7722102..8eb4039 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -43,6 +43,7 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 	/* Set to 2 to allow both inbound and outbound traffic */
 	atomic_set(&net_device->refcnt, 2);
 
+	net_device->destroy = false;
 	net_device->dev = device;
 	device->ext = net_device;
 
@@ -396,6 +397,7 @@ int netvsc_device_remove(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
 	struct hv_netvsc_packet *netvsc_packet, *pos;
+	unsigned long flags;
 
 	/* Stop outbound traffic ie sends and receives completions */
 	net_device = release_outbound_net_device(device);
@@ -404,6 +406,10 @@ int netvsc_device_remove(struct hv_device *device)
 		return -ENODEV;
 	}
 
+	spin_lock_irqsave(&device->channel->inbound_lock, flags);
+	net_device->destroy = true;
+	spin_unlock_irqrestore(&device->channel->inbound_lock, flags);
+
 	/* Wait for all send completions */
 	while (atomic_read(&net_device->num_outstanding_sends)) {
 		dev_err(&device->device,
-- 
1.7.4.1

