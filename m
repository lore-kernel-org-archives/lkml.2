Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab1H0SrC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:47:02 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:40506
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750974Ab1H0SrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:47:00 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 16/46] Staging: hv: netvsc: Get rid of release_inbound_net_device() by inlining the code
Date: Sat, 27 Aug 2011 11:31:15 -0700
Message-Id: <1314469905-7058-16-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of release_inbound_net_device() by inlining the code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/netvsc.c |   24 ++----------------------
 1 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index e46161d..388f083 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -88,23 +88,6 @@ static void put_net_device(struct hv_device *device)
 	atomic_dec(&net_device->refcnt);
 }
 
-static struct netvsc_device *release_inbound_net_device(
-		struct hv_device *device)
-{
-	struct netvsc_device *net_device;
-
-	net_device = device->ext;
-	if (net_device == NULL)
-		return NULL;
-
-	/* Busy wait until the ref drop to 1, then set it to 0 */
-	while (atomic_cmpxchg(&net_device->refcnt, 1, 0) != 1)
-		udelay(100);
-
-	device->ext = NULL;
-	return net_device;
-}
-
 static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 {
 	struct nvsp_message *revoke_packet;
@@ -400,9 +383,8 @@ int netvsc_device_remove(struct hv_device *device)
 
 	netvsc_disconnect_vsp(net_device);
 
-	/* Stop inbound traffic ie receives and sends completions */
-	net_device = release_inbound_net_device(device);
-
+	atomic_dec(&net_device->refcnt);
+	device->ext = NULL;
 	/*
 	 * Wait until the ref cnt falls to 0.
 	 * We have already stopped any new references
@@ -967,8 +949,6 @@ cleanup:
 			kfree(packet);
 		}
 
-		release_inbound_net_device(device);
-
 		kfree(net_device);
 	}
 
-- 
1.7.4.1

