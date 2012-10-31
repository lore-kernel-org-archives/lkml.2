Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934626Ab2JaK4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:56:14 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51607 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab2JaK4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:56:12 -0400
From: Xiaotian Feng <xtfeng@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>,
        Rupesh Gujare <rgujare@ozmodevices.com>,
        Chris Kelly <ckelly@ozmodevices.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH] staging: ozwpan: use tasklet_kill in device remove/release process
Date: Wed, 31 Oct 2012 18:56:48 +0800
Message-Id: <1351681008-27356-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some driver uses tasklet_disable in device remove/release process,
tasklet_disable will inc tasklet->count and return. If the tasklet
is not handled yet under some softirq pressure, the tasklet will be
placed on the tasklet_vec, never have a chance to be excuted. This might
lead to a heavy loaded ksoftirqd, wakeup with pending_softirq, but
tasklet is disabled. tasklet_kill should be used in this case.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Rupesh Gujare <rgujare@ozmodevices.com>
Cc: Chris Kelly <ckelly@ozmodevices.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/ozwpan/ozhcd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 2e087ac..33c0009 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -2304,8 +2304,8 @@ error:
  */
 void oz_hcd_term(void)
 {
-	tasklet_disable(&g_urb_process_tasklet);
-	tasklet_disable(&g_urb_cancel_tasklet);
+	tasklet_kill(&g_urb_process_tasklet);
+	tasklet_kill(&g_urb_cancel_tasklet);
 	platform_device_unregister(g_plat_dev);
 	platform_driver_unregister(&g_oz_plat_drv);
 	oz_trace("Pending urbs:%d\n", atomic_read(&g_pending_urbs));
-- 
1.7.9.5

