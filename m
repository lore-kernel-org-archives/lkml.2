Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab2J2VmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:42:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:48957 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933155Ab2J2VmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:42:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 52/54] staging: comedi: amplc_pc236: fix invalid register access during detach
Date: Mon, 29 Oct 2012 14:40:53 -0700
Message-Id: <20121029213808.565404843@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/amplc_pc236.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -468,7 +468,7 @@ static int pc236_detach(struct comedi_de
 {
 	printk(KERN_DEBUG "comedi%d: %s: detach\n", dev->minor,
 	       PC236_DRIVER_NAME);
-	if (devpriv)
+	if (dev->iobase)
 		pc236_intr_disable(dev);
 
 	if (dev->irq)


