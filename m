Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab1G0WCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:02:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:35829 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549Ab1G0Vss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30900703"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: lpechacek@suse.cz, stern@rowland.harvard.edu, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [49/99] USB: core: Tolerate protocol stall during hub and port
Message-Id: <20110727214848.33DC22403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Libor Pechacek <lpechacek@suse.cz>

commit 3824c1ddaf744be44b170a335332b9d6afe79254 upstream.

Protocol stall should not be fatal while reading port or hub status as it is
transient state.  Currently hub EP0 STALL during port status read results in
failed device enumeration.  This has been observed with ST-Ericsson (formerly
Philips) USB 2.0 Hub (04cc:1521) after connecting keyboard.

Signed-off-by: Libor Pechacek <lpechacek@suse.cz>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/core/hub.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/usb/core/hub.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/core/hub.c
+++ linux-2.6.35.y/drivers/usb/core/hub.c
@@ -327,7 +327,8 @@ static int get_hub_status(struct usb_dev
 {
 	int i, status = -ETIMEDOUT;
 
-	for (i = 0; i < USB_STS_RETRIES && status == -ETIMEDOUT; i++) {
+	for (i = 0; i < USB_STS_RETRIES &&
+			(status == -ETIMEDOUT || status == -EPIPE); i++) {
 		status = usb_control_msg(hdev, usb_rcvctrlpipe(hdev, 0),
 			USB_REQ_GET_STATUS, USB_DIR_IN | USB_RT_HUB, 0, 0,
 			data, sizeof(*data), USB_STS_TIMEOUT);
@@ -343,7 +344,8 @@ static int get_port_status(struct usb_de
 {
 	int i, status = -ETIMEDOUT;
 
-	for (i = 0; i < USB_STS_RETRIES && status == -ETIMEDOUT; i++) {
+	for (i = 0; i < USB_STS_RETRIES &&
+			(status == -ETIMEDOUT || status == -EPIPE); i++) {
 		status = usb_control_msg(hdev, usb_rcvctrlpipe(hdev, 0),
 			USB_REQ_GET_STATUS, USB_DIR_IN | USB_RT_PORT, 0, port1,
 			data, sizeof(*data), USB_STS_TIMEOUT);
