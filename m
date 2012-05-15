Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965750Ab2EOCSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:49394 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964916Ab2EOCQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:48 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 059/179] USB: core: Tolerate protocol stall during hub and port status read
Date: Mon, 14 May 2012 22:12:35 -0400
Message-ID: <1337048075-6132-60-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Libor Pechacek <lpechacek@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3824c1ddaf744be44b170a335332b9d6afe79254 upstream.

Protocol stall should not be fatal while reading port or hub status as it is
transient state.  Currently hub EP0 STALL during port status read results in
failed device enumeration.  This has been observed with ST-Ericsson (formerly
Philips) USB 2.0 Hub (04cc:1521) after connecting keyboard.

Signed-off-by: Libor Pechacek <lpechacek@suse.cz>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/core/hub.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index e5363de..642fc7e 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -327,7 +327,8 @@ static int get_hub_status(struct usb_device *hdev,
 {
 	int i, status = -ETIMEDOUT;
 
-	for (i = 0; i < USB_STS_RETRIES && status == -ETIMEDOUT; i++) {
+	for (i = 0; i < USB_STS_RETRIES &&
+			(status == -ETIMEDOUT || status == -EPIPE); i++) {
 		status = usb_control_msg(hdev, usb_rcvctrlpipe(hdev, 0),
 			USB_REQ_GET_STATUS, USB_DIR_IN | USB_RT_HUB, 0, 0,
 			data, sizeof(*data), USB_STS_TIMEOUT);
@@ -343,7 +344,8 @@ static int get_port_status(struct usb_device *hdev, int port1,
 {
 	int i, status = -ETIMEDOUT;
 
-	for (i = 0; i < USB_STS_RETRIES && status == -ETIMEDOUT; i++) {
+	for (i = 0; i < USB_STS_RETRIES &&
+			(status == -ETIMEDOUT || status == -EPIPE); i++) {
 		status = usb_control_msg(hdev, usb_rcvctrlpipe(hdev, 0),
 			USB_REQ_GET_STATUS, USB_DIR_IN | USB_RT_PORT, 0, port1,
 			data, sizeof(*data), USB_STS_TIMEOUT);
-- 
1.7.9.6

