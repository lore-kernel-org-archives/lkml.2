Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358Ab2INKOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 06:14:09 -0400
Received: from mailsender.cdac.in ([196.1.113.117]:57025 "EHLO
	mailsender.cdac.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758704Ab2INKOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 06:14:05 -0400
X-Greylist: delayed 1224 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Sep 2012 06:14:04 EDT
From: navin patidar <navinp@cdac.in>
To: gregkh@linuxfoundation.org, mfm@muteddisk.com
Cc: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navinp@cdac.in>
Subject: [PATCH] staging: usbip: vhci_hcd: Fixed oops during removal of vhci_hcd
Date: Fri, 14 Sep 2012 15:21:37 +0530
Message-Id: <1347616297-3339-1-git-send-email-navinp@cdac.in>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
X-CDAC-PUNE-MailScanner-ID: q8E9rNqW005870
X-CDAC-PUNE-MailScanner: Found to be clean, Found to be clean
X-CDAC-PUNE-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=1.352, required 6, autolearn=disabled, BAYES_00 -1.90,
	FSL_HELO_NON_FQDN_1 0.00, HELO_NO_DOMAIN 0.00, RDNS_NONE 0.79,
	TO_NO_BRKTS_DIRECT 2.46), not spam, SpamAssassin (cached,
	score=3.856, required 6, autolearn=disabled, BAYES_40 -0.18,
	HELO_LOCALHOST 3.94, RDNS_NONE 0.10)
X-CDAC-PUNE-MailScanner-SpamScore: 1, 3
X-CDAC-PUNE-MailScanner-Information: Please contact npsfhelp@cdac.in/mailadmin@cdac.in for more information
X-MailScanner-ID: q8E9rNIJ020090
X-CDAC-PUNE-MailScanner-From: navinp@cdac.in
X-CDAC-MailScanner-Spam-Status: No
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
 drivers/staging/usbip/vhci_hcd.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 6076f42..b1f427c 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -858,6 +858,9 @@ static void vhci_device_reset(struct usbip_device *ud)
 	if (vdev->udev)
 		usb_put_dev(vdev->udev);
 	vdev->udev = NULL;
+	/* Reset kernel thread pointers */
+	ud->tcp_rx = NULL;
+	ud->tcp_tx = NULL;
 
 	ud->tcp_socket = NULL;
 	ud->status = VDEV_ST_NULL;
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

