Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2JZAY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:24:58 -0400
Received: from mail.kernel.org ([198.145.19.201]:53544 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab2JZAHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stefano Babic <sbabic@denx.de>, Felipe Balbi <balbi@ti.com>,
        Dmitry Lifshitz <lifshitz@compulab.co.il>,
        Igor Grinberg <grinberg@compulab.co.il>
Subject: [ 25/85] usb: musb: am35xx: drop spurious unplugging a device
Date: Thu, 25 Oct 2012 17:05:43 -0700
Message-Id: <20121026000033.639329600@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Babic <sbabic@denx.de>

commit 6ff1f3d3bd7c69c62ca5773b1b684bce42eff06a upstream.

On AM3517, tx and rx interrupt are detected together with
the disconnect event. This generates a kernel panic in musb_interrupt,
because rx / tx are handled after disconnect.
This issue was seen on a Technexion's TAM3517 SOM. Unplugging a device,
tx / rx interrupts together with disconnect are detected. This brings
to kernel panic like this:

[   68.526153] Unable to handle kernel NULL pointer dereference at virtual address 00000011
[   68.534698] pgd = c0004000
[   68.537536] [00000011] *pgd=00000000
[   68.541351] Internal error: Oops: 17 [#1] ARM
[   68.545928] Modules linked in:
[   68.549163] CPU: 0    Not tainted  (3.6.0-rc5-00020-g9e05905 #178)
[   68.555694] PC is at rxstate+0x8/0xdc
[   68.559539] LR is at musb_interrupt+0x98/0x858
[   68.564239] pc : [<c035cd88>]    lr : [<c035af1c>]    psr: 40000193
[   68.564239] sp : ce83fb40  ip : d0906410  fp : 00000000
[   68.576293] r10: 00000000  r9 : cf3b0e40  r8 : 00000002
[   68.581817] r7 : 00000019  r6 : 00000001  r5 : 00000001  r4 : 000000d4
[   68.588684] r3 : 00000000  r2 : 00000000  r1 : ffffffcc  r0 : cf23c108
[   68.595550] Flags: nZcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment ke

Note: this behavior is not seen with a USB hub, while it is
easy to reproduce connecting a USB-pen directly to the USB-A of
the board.

Drop tx / rx interrupts if disconnect is detected.

Signed-off-by: Stefano Babic <sbabic@denx.de>
CC: Felipe Balbi <balbi@ti.com>
Tested-by: Dmitry Lifshitz <lifshitz@compulab.co.il>
Tested-by: Igor Grinberg <grinberg@compulab.co.il>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/am35x.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/musb/am35x.c
+++ b/drivers/usb/musb/am35x.c
@@ -312,6 +312,12 @@ static irqreturn_t am35x_musb_interrupt(
 		ret = IRQ_HANDLED;
 	}
 
+	/* Drop spurious RX and TX if device is disconnected */
+	if (musb->int_usb & MUSB_INTR_DISCONNECT) {
+		musb->int_tx = 0;
+		musb->int_rx = 0;
+	}
+
 	if (musb->int_tx || musb->int_rx || musb->int_usb)
 		ret |= musb_interrupt(musb);
 


