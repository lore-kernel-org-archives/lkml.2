Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0KJCdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:33:33 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58142 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab0KJCdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:33:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=LJa/bALrLYJZ8kdcthGQH5S4bfAOiur/z5SVcN81ORCzu8D1p7RbS+B8ZpZsc/eGD0
         0d40hlsXC/iRYhywqztMEvvqFxc/+833EDDlRUR9Rgo+dzSxolBLMZ6vrkIDx1FpO9Bk
         G6lHAXTeN8G1gYnm47NNVjLTIsz0XMrVYLC7I=
Subject: [PATCH] rtc: rtc-omap - fix a memory leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: "Mark A. Greer" <mgreer@mvista.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 10 Nov 2010 10:37:20 +0800
Message-Id: <1289356640.13311.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_mem_region() will call kzalloc to allocate memory for struct resource.
release_resource() unregisters the resource but does not free the allocated
memory, thus use release_mem_region() instead to fix the memory leak.

Also add a missing iounmap() in omap_rtc_remove().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/rtc/rtc-omap.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 73377b0..e72b523 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -429,13 +429,14 @@ fail1:
 fail0:
 	iounmap(rtc_base);
 fail:
-	release_resource(mem);
+	release_mem_region(mem->start, resource_size(mem));
 	return -EIO;
 }
 
 static int __exit omap_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_device	*rtc = platform_get_drvdata(pdev);
+	struct resource		*mem = dev_get_drvdata(&rtc->dev);
 
 	device_init_wakeup(&pdev->dev, 0);
 
@@ -447,8 +448,9 @@ static int __exit omap_rtc_remove(struct platform_device *pdev)
 	if (omap_rtc_timer != omap_rtc_alarm)
 		free_irq(omap_rtc_alarm, rtc);
 
-	release_resource(dev_get_drvdata(&rtc->dev));
 	rtc_device_unregister(rtc);
+	iounmap(rtc_base);
+	release_mem_region(mem->start, resource_size(mem));
 	return 0;
 }
 
-- 
1.7.2



