Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab2IRErq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 00:47:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33124 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab2IRErp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 00:47:45 -0400
From: navin patidar <navinp@cdac.in>
To: gregkh@linuxfoundation.org, mfm@muteddisk.com
Cc: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navinp@cdac.in>
Subject: [PATCH] staging: usbip: vhci_hcd: Fixed oops during removal of vhci_hcd
Date: Tue, 18 Sep 2012 10:16:56 +0530
Message-Id: <1347943616-5955-1-git-send-email-navinp@cdac.in>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In response to "usbip detach -p [port_number]" user command,vhci_shoutdown_connection gets
executed which kills tcp_tx,tcp_rx kernel threads and then vhci_device_reset resets
all usb_device struct variables except kernel thread pointers.

so, at the time of vhci_hcd removal vhci_shoutdown_connection tries to kill kernel threads
which are already killed.

Signed-off-by: navin patidar <navinp@cdac.in>
---
 drivers/staging/usbip/vhci_hcd.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 12a9a5f..eea8298 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -859,6 +859,8 @@ static void vhci_device_reset(struct usbip_device *ud)
 		usb_put_dev(vdev->udev);
 	vdev->udev = NULL;
 
+	ud->tcp_rx = NULL;
+	ud->tcp_tx = NULL;
 	ud->tcp_socket = NULL;
 	ud->status = VDEV_ST_NULL;
 
-- 
1.7.9.5

