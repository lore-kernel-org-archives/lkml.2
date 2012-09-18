Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab2IREBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 00:01:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58224 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2IREBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 00:01:03 -0400
From: navin patidar <navinp@cdac.in>
To: gregkh@linuxfoundation.org, mfm@muteddisk.com
Cc: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navinp@cdac.in>
Subject: [PATCH] staging: usbip: stub_dev: Fixed oops during removal of usbip_host
Date: Tue, 18 Sep 2012 09:30:06 +0530
Message-Id: <1347940806-4653-1-git-send-email-navinp@cdac.in>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stub_device_reset should set kernel thread pointers to NULL.
so that at the time of usbip_host removal stub_shoutdown_connection
doesn't try to kill kernel threads which are already killed.

Signed-off-by: navin patidar <navinp@cdac.in>
---
 drivers/staging/usbip/stub_dev.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index 92ced35..447a98c 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -198,10 +198,8 @@ static void stub_shutdown_connection(struct usbip_device *ud)
 	 * tcp_socket is freed after threads are killed so that usbip_xmit does
 	 * not touch NULL socket.
 	 */
-	if (ud->tcp_socket) {
+	if (ud->tcp_socket)
 		sock_release(ud->tcp_socket);
-		ud->tcp_socket = NULL;
-	}
 
 	/* 3. free used data */
 	stub_device_cleanup_urbs(sdev);
@@ -233,6 +231,9 @@ static void stub_device_reset(struct usbip_device *ud)
 
 	dev_dbg(&udev->dev, "device reset");
 
+	ud->tcp_socket = NULL;
+	ud->tcp_rx = NULL;
+	ud->tcp_tx = NULL;
 	ret = usb_lock_device_for_reset(udev, sdev->interface);
 	if (ret < 0) {
 		dev_err(&udev->dev, "lock for reset\n");
-- 
1.7.9.5

