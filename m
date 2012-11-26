Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab2KZRnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:43:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47776 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933417Ab2KZRKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:10:09 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefano Babic <sbabic@denx.de>, Felipe Balbi <balbi@ti.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 164/270] usb: musb: am35xx: drop spurious unplugging a device
Date: Mon, 26 Nov 2012 14:57:34 -0200
Message-Id: <1353949160-26803-165-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/musb/am35x.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/musb/am35x.c b/drivers/usb/musb/am35x.c
index 9f3eda9..340cff9 100644
--- a/drivers/usb/musb/am35x.c
+++ b/drivers/usb/musb/am35x.c
@@ -311,6 +311,12 @@ static irqreturn_t am35x_musb_interrupt(int irq, void *hci)
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
 
-- 
1.7.9.5

