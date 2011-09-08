Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab1IHODm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:03:42 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:40770
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933071Ab1IHODT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:03:19 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 20/25] Staging: hv: mousevsc: Get rid of the usage of the ext field in struct hv_device
Date: Thu,  8 Sep 2011 07:24:31 -0700
Message-Id: <1315491876-9554-20-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315491876-9554-1-git-send-email-kys@microsoft.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the usage of the ext field in struct hv_device for the mouse driver.
We do this by using the newly introduced functions to set and and get driver
specific data.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index d60f287..c6c4024 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -196,7 +196,7 @@ static struct mousevsc_dev *alloc_input_device(struct hv_device *device)
 	atomic_cmpxchg(&input_dev->ref_count, 0, 2);
 
 	input_dev->device = device;
-	device->ext = input_dev;
+	hv_set_drvdata(device, input_dev);
 
 	return input_dev;
 }
@@ -214,7 +214,7 @@ static struct mousevsc_dev *get_input_device(struct hv_device *device)
 {
 	struct mousevsc_dev *input_dev;
 
-	input_dev = (struct mousevsc_dev *)device->ext;
+	input_dev = (struct mousevsc_dev *)hv_get_drvdata(device);
 
 /*
  *	FIXME
@@ -240,7 +240,7 @@ static struct mousevsc_dev *must_get_input_device(struct hv_device *device)
 {
 	struct mousevsc_dev *input_dev;
 
-	input_dev = (struct mousevsc_dev *)device->ext;
+	input_dev = (struct mousevsc_dev *)hv_get_drvdata(device);
 
 	if (input_dev && atomic_read(&input_dev->ref_count))
 		atomic_inc(&input_dev->ref_count);
@@ -254,7 +254,7 @@ static void put_input_device(struct hv_device *device)
 {
 	struct mousevsc_dev *input_dev;
 
-	input_dev = (struct mousevsc_dev *)device->ext;
+	input_dev = (struct mousevsc_dev *)hv_get_drvdata(device);
 
 	atomic_dec(&input_dev->ref_count);
 }
@@ -266,7 +266,7 @@ static struct mousevsc_dev *release_input_device(struct hv_device *device)
 {
 	struct mousevsc_dev *input_dev;
 
-	input_dev = (struct mousevsc_dev *)device->ext;
+	input_dev = (struct mousevsc_dev *)hv_get_drvdata(device);
 
 	/* Busy wait until the ref drop to 2, then set it to 1  */
 	while (atomic_cmpxchg(&input_dev->ref_count, 2, 1) != 2)
@@ -282,13 +282,13 @@ static struct mousevsc_dev *final_release_input_device(struct hv_device *device)
 {
 	struct mousevsc_dev *input_dev;
 
-	input_dev = (struct mousevsc_dev *)device->ext;
+	input_dev = (struct mousevsc_dev *)hv_get_drvdata(device);
 
 	/* Busy wait until the ref drop to 1, then set it to 0  */
 	while (atomic_cmpxchg(&input_dev->ref_count, 1, 0) != 1)
 		udelay(100);
 
-	device->ext = NULL;
+	hv_set_drvdata(device, NULL);
 	return input_dev;
 }
 
@@ -790,7 +790,7 @@ static int mousevsc_on_device_remove(struct hv_device *device)
 	int ret = 0;
 
 	pr_info("disabling input device (%p)...",
-		    device->ext);
+		    hv_get_drvdata(device));
 
 	input_dev = release_input_device(device);
 
@@ -808,7 +808,7 @@ static int mousevsc_on_device_remove(struct hv_device *device)
 		udelay(100);
 	}
 
-	pr_info("removing input device (%p)...", device->ext);
+	pr_info("removing input device (%p)...", hv_get_drvdata(device));
 
 	input_dev = final_release_input_device(device);
 
-- 
1.7.4.1

