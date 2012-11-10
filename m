Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab2KJN7v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 08:59:51 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:47743 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2KJN7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 08:59:45 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Yinghai Lu <yinghai@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>
Subject: [RFC PATCH 6/6] VFIO: use ACCESS_ONCE() to guard access to dev->driver
Date: Sat, 10 Nov 2012 21:57:19 +0800
Message-Id: <1352555839-18961-6-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352555839-18961-1-git-send-email-jiang.liu@huawei.com>
References: <1352555839-18961-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Jiang Liu <jiang.liu@huawei.com>

Comments from dev_driver_string(),
/* dev->driver can change to NULL underneath us because of unbinding,
 * so be careful about accessing it.
 */

So use ACCESS_ONCE() to guard access to dev->driver field.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/vfio/vfio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 18714b9..f158e42 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -520,8 +520,9 @@ static bool vfio_whitelisted_driver(struct device_driver *drv)
 static int vfio_dev_viable(struct device *dev, void *data)
 {
 	struct vfio_device_driver *driver;
+	struct device_driver *drv = ACCESS_ONCE(dev->driver);
 
-	if (!dev->driver || vfio_whitelisted_driver(dev->driver))
+	if (!drv || vfio_whitelisted_driver(drv))
 		return 0;
 
 	mutex_lock(&vfio.device_drivers_lock);
-- 
1.7.9.5

