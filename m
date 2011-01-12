Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab1ALNWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 08:22:19 -0500
Received: from mail.nusquama.org ([85.131.211.20]:54329 "EHLO
	mail.nusquama.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756292Ab1ALNVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 08:21:51 -0500
From: Max Vozeler <max@vozeler.com>
To: gregkh@suse.de
Cc: hirofuchi@users.sourceforge.net, rpjday@crashcourse.ca,
        bgmerrell@novell.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, mwehby@luxotticaRetail.com,
        marco@optikam.com, Max Vozeler <max@vozeler.com>
Subject: [PATCH 5/7] staging: usbip: vhci: friendly log messages for connection errors
Date: Wed, 12 Jan 2011 15:02:03 +0200
Message-Id: <1294837325-26187-6-git-send-email-max@vozeler.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1294837325-26187-1-git-send-email-max@vozeler.com>
References: <1294837325-26187-1-git-send-email-max@vozeler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also changes the event on connection close to be
VDEV_EVENT_DOWN - no functional change.

Signed-off-by: Max Vozeler <max@vozeler.com>
---
 drivers/staging/usbip/vhci_rx.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/vhci_rx.c b/drivers/staging/usbip/vhci_rx.c
index bdbedd2..ac15cea 100644
--- a/drivers/staging/usbip/vhci_rx.c
+++ b/drivers/staging/usbip/vhci_rx.c
@@ -205,11 +205,23 @@ static void vhci_rx_pdu(struct usbip_device *ud)
 
 	memset(&pdu, 0, sizeof(pdu));
 
-
 	/* 1. receive a pdu header */
 	ret = usbip_xmit(0, ud->tcp_socket, (char *) &pdu, sizeof(pdu), 0);
+	if (ret < 0) {
+		if (ret == -ECONNRESET)
+			usbip_uinfo("connection reset by peer\n");
+		else if (ret != -ERESTARTSYS)
+			usbip_uinfo("xmit failed %d\n", ret);
+		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
+		return;
+	}
+	if (ret == 0) {
+		usbip_uinfo("connection closed");
+		usbip_event_add(ud, VDEV_EVENT_DOWN);
+		return;
+	}
 	if (ret != sizeof(pdu)) {
-		usbip_uerr("receiving pdu failed! size is %d, should be %d\n",
+		usbip_uerr("received pdu size is %d, should be %d\n",
 					ret, (unsigned int)sizeof(pdu));
 		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
 		return;
-- 
1.7.2.3

