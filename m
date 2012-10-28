Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab2J1X33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:29:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42276 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757095Ab2J1X2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:34 -0400
Message-Id: <20121028231543.802487177@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:15:58 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 022/105] staging: comedi: amplc_pc236: fix invalid register access during detach
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit aaeb61a97b7159ebe30b18a422d04eeabfa8790b upstream.

`pc236_detach()` is called by the comedi core if it attempted to attach
a device and failed.  `pc236_detach()` calls `pc236_intr_disable()` if
the comedi device private data pointer (`devpriv`) is non-null.  This
test is insufficient as `pc236_intr_disable()` accesses hardware
registers and the attach routine may have failed before it has saved
their I/O base addresses.

Fix it by checking `dev->iobase` is non-zero before calling
`pc236_intr_disable()` as that means the I/O base addresses have been
saved and the hardware registers can be accessed.  It also implies the
comedi device private data pointer is valid, so there is no need to
check it.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
[Ian Abbott: This patch is for the stable 3.0 kernel.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/drivers/amplc_pc236.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 48246cd..b4311bf 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -470,7 +470,7 @@ static int pc236_detach(struct comedi_device *dev)
 {
 	printk(KERN_DEBUG "comedi%d: %s: detach\n", dev->minor,
 	       PC236_DRIVER_NAME);
-	if (devpriv)
+	if (dev->iobase)
 		pc236_intr_disable(dev);
 
 	if (dev->irq)


