Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946234Ab2I1V3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:29:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47839 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032681Ab2I1U2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:28:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Klaus Falkner <klaus.falkner@solectrix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 129/218] USB: ohci-at91: fix PIO handling in relation with number of ports
Date: Fri, 28 Sep 2012 13:15:46 -0700
Message-Id: <20120928201516.280263091@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -569,6 +569,16 @@ static int __devinit ohci_hcd_at91_drv_p
 
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


