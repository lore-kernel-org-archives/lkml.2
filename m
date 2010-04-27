Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab0D0QZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 12:25:33 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:45527 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752939Ab0D0QZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 12:25:32 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-pm@lists.linux-foundation.org
Subject: [PATCH v2] [RFC] ehci: Disable wake on overcurrent (WKOC_E) and disconnect (WKDISC_E)
Date: Tue, 27 Apr 2010 18:25:20 +0200
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201004271523.48647.linux@rainbow-software.org> <201004271622.55904.linux@rainbow-software.org>
In-Reply-To: <201004271622.55904.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004271825.21771.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch was not enough as it worked only when there were no USB
devices connected. With a bus-powered device connected, power loss causes
disconnect which wakes up the machine immediately again.

Does anyone know why is this enabled by default? No other USB host driver
(except oxu210hp-hcd which is based on EHCI) does that. This also means that
suspended laptop wakes up when disconnecting a mouse? I don't have any to test
right now. Wakeup on USB connect makes a bit more sense but I'd say that it's
still not a good idea to enable it by default.

If we don't need that, perhaps the following patch should be applied.


Disable wake on overcurrent and disconnect in EHCI.
This fixes immediate resume from standby on boards where port power is lost
in standby which triggers overcurrent detection and disconnect if a
bus-powered device is connected. At least Asus P4P800 boards are affected when
any of the USBPWxx (e.g. USBPW12) jumpers is set to 5V.
Tested on Asus P4P800-VM.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-source-2.6.33-orig/drivers/usb/host/ehci-hub.c	2010-02-24 19:52:17.000000000 +0100
+++ linux-source-2.6.33/drivers/usb/host/ehci-hub.c	2010-04-27 18:17:36.000000000 +0200
@@ -173,21 +173,16 @@ static int ehci_bus_suspend (struct usb_
 		}
 
 		/* enable remote wakeup on all ports */
+		t2 &= ~PORT_WAKE_BITS;
 		if (hcd->self.root_hub->do_remote_wakeup) {
 			/* only enable appropriate wake bits, otherwise the
 			 * hardware can not go phy low power mode. If a race
 			 * condition happens here(connection change during bits
 			 * set), the port change detection will finally fix it.
 			 */
-			if (t1 & PORT_CONNECT) {
-				t2 |= PORT_WKOC_E | PORT_WKDISC_E;
-				t2 &= ~PORT_WKCONN_E;
-			} else {
-				t2 |= PORT_WKOC_E | PORT_WKCONN_E;
-				t2 &= ~PORT_WKDISC_E;
-			}
-		} else
-			t2 &= ~PORT_WAKE_BITS;
+			if (!(t1 & PORT_CONNECT))
+				t2 |= PORT_WKCONN_E;
+		}
 
 		if (t1 != t2) {
 			ehci_vdbg (ehci, "port %d, %08x -> %08x\n",


-- 
Ondrej Zary
