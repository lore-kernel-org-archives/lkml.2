Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab0IGPYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:24:35 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61953 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432Ab0IGPY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:24:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=yHHvY6TbuwDsSxu7jYG4HbyOnb2Z/IjEEfkJKcPd7mx1HFrC8X0a3E+ndEYKCMIRUg
         /08JqTYie1xt6QsGG3s23QVDCaM3G6FAy1ZcLxtSjVXgvQ3lRxYY2dqA34z4DA7TI6NX
         +Rg6vk0SmR1R8mO+drmnVMdC3cAe5MnkVOves=
From: tom.leiming@gmail.com
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <me@felipebalbi.com>, Anand Gadiyar <gadiyar@ti.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [RESEND/PATCH 2/6] USB: musb-gadget: fix bulk IN infinite hangs in double buffer case
Date: Tue,  7 Sep 2010 23:23:30 +0800
Message-Id: <1283873014-32511-3-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com>
References: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch fixes one infinite hang of bulk IN transfer in double buffer
case, the hang can be observed easily by test #6 of usbtest if musb is
configured as g_zero and fifo mode 3 is taken to enable double fifo.

In fact, the patch only removes the check for non-empty fifo before
loading data from new request into fifo since the check is not correct:

	-in double buffer case, fifo may accommodate more than one packet,
	even though it has contained one packet already and is non-empty

	-since last DMA is completed before calling musb_g_tx, it is sure
	that fifo may accommodate at least one packet

Without applying the patch, new requst enqueued from .complte may not
have a chance to be loaded into fifo, then will never be completed and
cause infinite hangs.

With the patch, on my beagle B5, test#6(queued bulk in) can be passed and
test result may go beyond 33Mbyte/s if musb is configured as g_zero and
fifo mode 3 is taken, follows the test command:

	#testusb -D DEV_NAME -c 1024 -t 6 -s 32768 -g 8   [1]

[1],
    -source of testusb : tools/usb/testusb.c under linux kernel;

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Acked-by:   Anand Gadiyar <gadiyar@ti.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Felipe Balbi <me@felipebalbi.com>
Cc: Anand Gadiyar <gadiyar@ti.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
---
 drivers/usb/musb/musb_gadget.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index de0ca90..f206c94 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -504,18 +504,6 @@ void musb_g_tx(struct musb *musb, u8 epnum)
 			/* ... or if not, then complete it. */
 			musb_g_giveback(musb_ep, request, 0);
 
-			/*
-			 * Kickstart next transfer if appropriate;
-			 * the packet that just completed might not
-			 * be transmitted for hours or days.
-			 * REVISIT for double buffering...
-			 * FIXME revisit for stalls too...
-			 */
-			musb_ep_select(mbase, epnum);
-			csr = musb_readw(epio, MUSB_TXCSR);
-			if (csr & MUSB_TXCSR_FIFONOTEMPTY)
-				return;
-
 			request = musb_ep->desc ? next_request(musb_ep) : NULL;
 			if (!request) {
 				DBG(4, "%s idle now\n",
-- 
1.6.2.5

