Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768470Ab2KOQol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:44:41 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58818 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768408Ab2KOQoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:44:39 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Joerg Roedel <joerg.roedel@amd.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH v2 2/3] VFIO: use ACCESS_ONCE() to guard access to dev->driver
Date: Fri, 16 Nov 2012 00:43:17 +0800
Message-Id: <1352997798-18891-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352997798-18891-1-git-send-email-jiang.liu@huawei.com>
References: <1352997798-18891-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 3359ec2..0090212 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -465,8 +465,9 @@ static int vfio_dev_viable(struct device *dev, void *data)
 {
 	struct vfio_group *group = data;
 	struct vfio_device *device;
+	struct device_driver *drv = ACCESS_ONCE(dev->driver);
 
-	if (!dev->driver || vfio_whitelisted_driver(dev->driver))
+	if (!drv || vfio_whitelisted_driver(drv))
 		return 0;
 
 	device = vfio_group_get_device(group, dev);
-- 
1.7.9.5

