Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030254Ab2I1TB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:01:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030226Ab2I1TBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:01:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Klaus Falkner <klaus.falkner@solectrix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 161/262] USB: ohci-at91: fix PIO handling in relation with number of ports
Date: Fri, 28 Sep 2012 11:51:30 -0700
Message-Id: <20120928183016.976186282@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 6fffb77c8393151b0cf8cef1b9c2ba90587dd2e8 upstream.

If the number of ports present on the SoC/board is not the maximum
and that the platform data is not filled with all data, there is
an easy way to mess the PIO setup for this interface.
This quick fix addresses mis-configuration in USB host platform data
that is common in at91 boards since commit 0ee6d1e (USB: ohci-at91:
change maximum number of ports) that did not modified the associatd
board files.

Reported-by: Klaus Falkner <klaus.falkner@solectrix.de>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ohci-at91.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -570,6 +570,16 @@ static int __devinit ohci_hcd_at91_drv_p
 
 	if (pdata) {
 		at91_for_each_port(i) {
+			/*
+			 * do not configure PIO if not in relation with
+			 * real USB port on board
+			 */
+			if (i >= pdata->ports) {
+				pdata->vbus_pin[i] = -EINVAL;
+				pdata->overcurrent_pin[i] = -EINVAL;
+				break;
+			}
+
 			if (!gpio_is_valid(pdata->vbus_pin[i]))
 				continue;
 			gpio = pdata->vbus_pin[i];


