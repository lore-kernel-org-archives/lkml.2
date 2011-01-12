Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab1ALNWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 08:22:15 -0500
Received: from mail.nusquama.org ([85.131.211.20]:53064 "EHLO
	mail.nusquama.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756294Ab1ALNVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 08:21:51 -0500
From: Max Vozeler <max@vozeler.com>
To: gregkh@suse.de
Cc: hirofuchi@users.sourceforge.net, rpjday@crashcourse.ca,
        bgmerrell@novell.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, mwehby@luxotticaRetail.com,
        marco@optikam.com, Max Vozeler <max@vozeler.com>
Subject: [PATCH 6/7] staging: usbip: vhci: handle EAGAIN from SO_RCVTIMEO
Date: Wed, 12 Jan 2011 15:02:04 +0200
Message-Id: <1294837325-26187-7-git-send-email-max@vozeler.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1294837325-26187-1-git-send-email-max@vozeler.com>
References: <1294837325-26187-1-git-send-email-max@vozeler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is a receive timeout without any active
requests, we can tell the connection was idle and
ignore the timeout.

If there are active requests for which we expect
to receive a reply we close the connection.

This makes it possible to set an upper bound on
the time a usbip device may be unresponsive.

This is a workaround for the lack of heart-beat
messages in the USBIP protocol.

Extending the protocol would break compatibility
with all previous stub versions, so this seems like
the lesser evil.

Signed-off-by: Max Vozeler <max@vozeler.com>
Tested-by: Mark Wehby <MWehby@luxotticaRetail.com>
---
 drivers/staging/usbip/vhci_rx.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/usbip/vhci_rx.c b/drivers/staging/usbip/vhci_rx.c
index ac15cea..bf69914 100644
--- a/drivers/staging/usbip/vhci_rx.c
+++ b/drivers/staging/usbip/vhci_rx.c
@@ -193,6 +193,19 @@ static void vhci_recv_ret_unlink(struct vhci_device *vdev,
 	return;
 }
 
+static int vhci_priv_tx_empty(struct vhci_device *vdev)
+{
+	int empty = 0;
+
+	spin_lock(&vdev->priv_lock);
+
+	empty = list_empty(&vdev->priv_rx);
+
+	spin_unlock(&vdev->priv_lock);
+
+	return empty;
+}
+
 /* recv a pdu */
 static void vhci_rx_pdu(struct usbip_device *ud)
 {
@@ -210,8 +223,14 @@ static void vhci_rx_pdu(struct usbip_device *ud)
 	if (ret < 0) {
 		if (ret == -ECONNRESET)
 			usbip_uinfo("connection reset by peer\n");
-		else if (ret != -ERESTARTSYS)
+		else if (ret == -EAGAIN) {
+			/* ignore if connection was idle */
+			if (vhci_priv_tx_empty(vdev))
+				return;
+			usbip_uinfo("connection timed out with pending urbs\n");
+		} else if (ret != -ERESTARTSYS)
 			usbip_uinfo("xmit failed %d\n", ret);
+
 		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
 		return;
 	}
-- 
1.7.2.3

