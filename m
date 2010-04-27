Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab0D0OXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 10:23:16 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:44938 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753289Ab0D0OXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 10:23:06 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-pm@lists.linux-foundation.org
Subject: [PATCH] ehci: Disable wake on overcurrent (WKOC_E)
Date: Tue, 27 Apr 2010 16:22:53 +0200
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201004271523.48647.linux@rainbow-software.org>
In-Reply-To: <201004271523.48647.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004271622.55904.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable wake on overcurrent in EHCI.
This fixes immediate resume from standby on boards where port power is lost
in standby which triggers overcurrent detection. At least Asus P4P800 boards
are affected when any of the USBPWxx (e.g. USBPW12) jumpers is set to 5V.
Tested on Asus P4P800-VM.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-source-2.6.33-orig/drivers/usb/host/ehci-hub.c	2010-02-24 19:52:17.000000000 +0100
+++ linux-source-2.6.33/drivers/usb/host/ehci-hub.c	2010-04-27 16:04:37.000000000 +0200
@@ -180,10 +180,10 @@ static int ehci_bus_suspend (struct usb_
 			 * set), the port change detection will finally fix it.
 			 */
 			if (t1 & PORT_CONNECT) {
-				t2 |= PORT_WKOC_E | PORT_WKDISC_E;
+				t2 |= PORT_WKDISC_E;
 				t2 &= ~PORT_WKCONN_E;
 			} else {
-				t2 |= PORT_WKOC_E | PORT_WKCONN_E;
+				t2 |= PORT_WKCONN_E;
 				t2 &= ~PORT_WKDISC_E;
 			}
 		} else
@@ -912,7 +912,7 @@ static int ehci_hub_control (
 			 * mode if we have hostpc feature
 			 */
 			temp &= ~PORT_WKCONN_E;
-			temp |= PORT_WKDISC_E | PORT_WKOC_E;
+			temp |= PORT_WKDISC_E;
 			ehci_writel(ehci, temp | PORT_SUSPEND, status_reg);
 			if (hostpc_reg) {
 				spin_unlock_irqrestore(&ehci->lock, flags);


-- 
Ondrej Zary
