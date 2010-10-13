Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab0JMKMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 06:12:53 -0400
Received: from mail.haemail.nl ([95.142.102.149]:46276 "EHLO vm2-12.ams.int"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751780Ab0JMKMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 06:12:52 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Oct 2010 06:12:51 EDT
Date: Wed, 13 Oct 2010 10:06:00 +0000 (UTC)
From: Jurgen Braam <j.braam@homeautomationeurope.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>, e9hack <e9hack@googlemail.com>,
        Johan Hovold <jhovold@gmail.com>
Message-ID: <13257307.1383581286964359341.JavaMail.PC-43$@PC-43>
In-Reply-To: <18494093.1383561286964261272.JavaMail.PC-43$@PC-43>
Subject: [PATCH][RFC] USB: EHCI: add missing
 {endpoint_reset,clear_tt_buffer_complete} operations
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.201.252.82]
X-Mailer: Zimbra 6.0.3_GA_1915.UBUNTU8_64 (Yahoo! Zimbra Desktop/1.0.3_1691_Windows)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jurgen Braam <j.braam@homeautomationeurope.com>

The ehci-{atmel,mxc,w90x900,xilinx-of} HCD drivers did not yet have the
endpoint_reset and clear_tt_buffer_complete operations set in their struct
hc_driver. This is a follow up on commit
b18ffd49e86102a9ed0a1cc83fdafe3891e844e5 ("USB: EHCI: update toggle state
for linked QHs") and 914b701280a76f96890ad63eb0fa99bf204b961c ("USB: EHCI:
use the new clear_tt_buffer interface").

When usb-serial's generic_cleanup(), or any XXX_close() function for that
matter, terminates all read/write URBs with usb_kill_urb() then the queues
to their respective endpoints generally stop. Sometimes the Transaction
Translator buffers may be left in an indeterminate state and need to be
cleaned up with clear_tt_buffer(). After this clear_tt_buffer_complete() is
called if it is defined in the hc_driver struct. In this process the
endpoint_reset() is needed to ensure the URB queues are restarted.

Signed-off-by: Jurgen Braam <j.braam@homeautomationeurope.com>
---

The reason I stumbled onto this was that I have been on a bug-tracking
mission for the past 40 hours. I was hunting for the reason why some
usb-serial-based convertors like ftdi_sio stopped working after a close()
and subsequent open(). The observed effect is that after working perfectly
the first time, the second time reads from the device no longer seem to
work. The ehci-mxc driver for the iMX27 platform is one of the HCDs that do
not yet set these operations.

I'm not familiar with or able to test the other ehci-hcd drivers
(atmel,w90x900,xilinx-of) so maybe these need some testing. Could this
maybe also be relevant for other *-hcd drivers? This patch applies to
2.6.36-rc7, please comment.

For the record: I found the other HCDs with missing operations with:
 git grep -i -n --color -E "\.(clear_tt_buffer_complete|urb_enqueue|endpoint_)" drivers/usb/host/ehci*
Maybe we could do something like usb-serial.c's #define
set_to_generic_if_null() to prevent future omissions?

My search lead me past the following, I list them here for future reverse
googleability:
- http://www.spinics.net/lists/linux-usb/msg34099.html "Problem with FTDI_SIO version 1.5.0. and 1.6.0"
- http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg32747.html "Endpoint queues and URB unlinking"
- http://kerneltrap.org/mailarchive/linux-usb/2010/8/24/6264209 "ftdi_sioserial adapter data toggle problem."
- http://lkml.org/lkml/2009/9/12/70 "Trouble with USB serial driver(ftdi_sio.c) on 2.6.31"
- http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-09/msg01780.html "[patch 58/71] USB: fix the clear_tt_buffer interface"
- http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg27905.html "[PATCH] - ftdi_sio.c, usb-serial.c usb_kill_urb()"
- copy browser tab url, paste in this list, close tab, rinse, repeat. ;)

kind regards,
Jurgen

---
 drivers/usb/host/ehci-atmel.c     |    3 +++
 drivers/usb/host/ehci-mxc.c       |    3 +++
 drivers/usb/host/ehci-w90x900.c   |    3 +++
 drivers/usb/host/ehci-xilinx-of.c |    1 +
 4 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
index 51bd0ed..39f09e6 100644
--- a/drivers/usb/host/ehci-atmel.c
+++ b/drivers/usb/host/ehci-atmel.c
@@ -99,6 +99,7 @@ static const struct hc_driver ehci_atmel_hc_driver = {
 	.urb_enqueue		= ehci_urb_enqueue,
 	.urb_dequeue		= ehci_urb_dequeue,
 	.endpoint_disable	= ehci_endpoint_disable,
+	.endpoint_reset		= ehci_endpoint_reset,
 
 	/* scheduling support */
 	.get_frame_number	= ehci_get_frame,
@@ -110,6 +111,8 @@ static const struct hc_driver ehci_atmel_hc_driver = {
 	.bus_resume		= ehci_bus_resume,
 	.relinquish_port	= ehci_relinquish_port,
 	.port_handed_over	= ehci_port_handed_over,
+
+	.clear_tt_buffer_complete = ehci_clear_tt_buffer_complete,
 };
 
 static int __init ehci_atmel_drv_probe(struct platform_device *pdev)
diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
index a8ad8ac..14537f6 100644
--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -95,6 +95,7 @@ static const struct hc_driver ehci_mxc_hc_driver = {
 	.urb_enqueue = ehci_urb_enqueue,
 	.urb_dequeue = ehci_urb_dequeue,
 	.endpoint_disable = ehci_endpoint_disable,
+	.endpoint_reset = ehci_endpoint_reset,
 
 	/*
 	 * scheduling support
@@ -110,6 +111,8 @@ static const struct hc_driver ehci_mxc_hc_driver = {
 	.bus_resume = ehci_bus_resume,
 	.relinquish_port = ehci_relinquish_port,
 	.port_handed_over = ehci_port_handed_over,
+
+	.clear_tt_buffer_complete = ehci_clear_tt_buffer_complete,
 };
 
 static int ehci_mxc_drv_probe(struct platform_device *pdev)
diff --git a/drivers/usb/host/ehci-w90x900.c b/drivers/usb/host/ehci-w90x900.c
index cfa21ea..6bc3580 100644
--- a/drivers/usb/host/ehci-w90x900.c
+++ b/drivers/usb/host/ehci-w90x900.c
@@ -130,6 +130,7 @@ static const struct hc_driver ehci_w90x900_hc_driver = {
 	.urb_enqueue = ehci_urb_enqueue,
 	.urb_dequeue = ehci_urb_dequeue,
 	.endpoint_disable = ehci_endpoint_disable,
+	.endpoint_reset = ehci_endpoint_reset,
 
 	/*
 	 * scheduling support
@@ -147,6 +148,8 @@ static const struct hc_driver ehci_w90x900_hc_driver = {
 #endif
 	.relinquish_port	= ehci_relinquish_port,
 	.port_handed_over	= ehci_port_handed_over,
+
+	.clear_tt_buffer_complete = ehci_clear_tt_buffer_complete,
 };
 
 static int __devinit ehci_w90x900_probe(struct platform_device *pdev)
diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
index 6c8076a..e8f4f36 100644
--- a/drivers/usb/host/ehci-xilinx-of.c
+++ b/drivers/usb/host/ehci-xilinx-of.c
@@ -117,6 +117,7 @@ static const struct hc_driver ehci_xilinx_of_hc_driver = {
 	.urb_enqueue		= ehci_urb_enqueue,
 	.urb_dequeue		= ehci_urb_dequeue,
 	.endpoint_disable	= ehci_endpoint_disable,
+	.endpoint_reset		= ehci_endpoint_reset,
 
 	/*
 	 * scheduling support
-- 
1.5.6.5
