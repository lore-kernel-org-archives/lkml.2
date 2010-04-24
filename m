Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567Ab0DXAzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 20:55:41 -0400
Received: from [217.108.136.188] ([217.108.136.188]:3236 "EHLO
	smtp.VirtualLogix.COM" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab0DXAzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 20:55:39 -0400
Date: Sat, 24 Apr 2010 02:55:24 +0200
Message-Id: <201004240055.o3O0tOCP016954@localhost.localdomain>
From: Eric Lescouet <lescouet@virtuallogix.com>
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH]: Fix deadlock in USBIP driver (staging), linux-2.6.34-rc5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resent with hopefully everything ...

When detaching a port from the client side (usbip --detach 0),
the event thread, on the server side, is going to deadlock.
The "eh" server thread is getting USBIP_EH_RESET event and calls:
  -> stub_device_reset() -> usb_reset_device()
the USB framework is then calling back _in the same "eh" thread_ :
  -> stub_disconnect() -> usbip_stop_eh() -> wait_for_completion()
the "eh" thread is being asleep forever, waiting for its own completion.
This patch checks if "eh" is the current thread, in usbip_stop_eh().

Signed-off-by: Eric Lescouet <eric@lescouet.org>
---

diff -Nur linux-2.6.34-rc5/drivers/staging/usbip/usbip_event.c linux-2.6.34-rc5.new/drivers/staging/usbip/usbip_event.c
--- linux-2.6.34-rc5/drivers/staging/usbip/usbip_event.c	2010-04-20 01:29:56.000000000 +0200
+++ linux-2.6.34-rc5.new/drivers/staging/usbip/usbip_event.c	2010-04-22 19:19:52.997889126 +0200
@@ -117,6 +117,9 @@
 {
 	struct usbip_task *eh = &ud->eh;
 
+	if (eh->thread == current)
+		return; /* do not wait for myself */
+
 	wait_for_completion(&eh->thread_done);
 	usbip_dbg_eh("usbip_eh has finished\n");
 }
