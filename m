Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab2INNXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:23:18 -0400
Received: from mailsender.cdac.in ([196.1.113.117]:42723 "EHLO
	mailsender.cdac.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab2INNXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:23:15 -0400
From: navin patidar <navinp@cdac.in>
To: gregkh@linuxfoundation.org, mfm@muteddisk.com
Cc: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navinp@cdac.in>
Subject: [PATCH] staging: usbip: stub_dev: Fixed oops during removal of usbip_host
Date: Fri, 14 Sep 2012 18:51:33 +0530
Message-Id: <1347628893-8223-1-git-send-email-navinp@cdac.in>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
X-CDAC-PUNE-MailScanner-ID: q8EDNApn008366
X-CDAC-PUNE-MailScanner: Found to be clean, Found to be clean
X-CDAC-PUNE-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=1.352, required 6, autolearn=disabled, BAYES_00 -1.90,
	FSL_HELO_NON_FQDN_1 0.00, HELO_NO_DOMAIN 0.00, RDNS_NONE 0.79,
	TO_NO_BRKTS_DIRECT 2.46), not spam, SpamAssassin (cached,
	score=0.541, required 6, autolearn=disabled, BAYES_00 -3.50,
	HELO_LOCALHOST 3.94, RDNS_NONE 0.10)
X-CDAC-PUNE-MailScanner-SpamScore: 1
X-CDAC-PUNE-MailScanner-Information: Please contact npsfhelp@cdac.in/mailadmin@cdac.in for more information
X-MailScanner-ID: q8EDNAnZ001666
X-CDAC-PUNE-MailScanner-From: navinp@cdac.in
X-CDAC-MailScanner-Spam-Status: No
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


-------------------------------------------------------------------------------------------------------------------------------

This e-mail is for the sole use of the intended recipient(s) and may
contain confidential and privileged information. If you are not the
intended recipient, please contact the sender by reply e-mail and destroy
all copies and the original message. Any unauthorized review, use,
disclosure, dissemination, forwarding, printing or copying of this email
is strictly prohibited and appropriate legal action will be taken.
-------------------------------------------------------------------------------------------------------------------------------

