Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab1FPHPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:15:14 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57598 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757053Ab1FPHLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:22 -0400
X-Sasl-enc: 4dZNo/LzwXJaKWVpTAV3mFX/VWZYtYfhkF57s5dMSNYf 1308208280
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:10 2011
Message-Id: <20110616002910.769414206@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:29:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Libor Pechacek <lpechacek@suse.cz>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [69/85] USB: core: Tolerate protocol stall during hub and port
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------
 status read

From: Libor Pechacek <lpechacek@suse.cz>

commit 3824c1ddaf744be44b170a335332b9d6afe79254 upstream.

Protocol stall should not be fatal while reading port or hub status as it is
transient state.  Currently hub EP0 STALL during port status read results in
failed device enumeration.  This has been observed with ST-Ericsson (formerly
Philips) USB 2.0 Hub (04cc:1521) after connecting keyboard.

Signed-off-by: Libor Pechacek <lpechacek@suse.cz>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hub.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
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


