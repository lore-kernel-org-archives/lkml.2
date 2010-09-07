Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab0IGPYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:24:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57767 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504Ab0IGPYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:24:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DPOMqQozsAL3L3XvxlgMXHjn8nAoCrqBgNZ6lr3xpO8Qe3tj1liLj2CD95rZlXUT7y
         aSd9UmMcquE5sn4B7iCZ9LjETpYVSkXa+bPqB68XEqR2MOvbMDNSNuR/43mzD0bMGaY8
         wf7oEes818gF9DbVkhkvuPd+0TSoLCy3mWrhE=
From: tom.leiming@gmail.com
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <me@felipebalbi.com>, Anand Gadiyar <gadiyar@ti.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [RESEND/PATCH 3/6] USB: musb-gadget: enable autoclear for OUT transfer in both DMA 0 and DMA 1
Date: Tue,  7 Sep 2010 23:23:31 +0800
Message-Id: <1283873014-32511-4-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com>
References: <1283873014-32511-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch fixes one bugs of OUT transfer in double buffer case:

	-the current code only enable autoclear for dma mode 1, and not
	for dma mode 0

Without this patch, test #5 of usbtest can't be passed if we
configure musb as g_zero and use fifo mode 3 to enable double
buffer mode.

With this patch and the following patch(fix dma length),
on my beagle B5, test#5(queued bulk out) may go beyond
18Mbyte/s(seems dma mode 0 is quicker in double buffer case)
if musb is configured as g_zero and fifo mode 3 is taken, follows
the test command:

    #./testusb -D DEV_NAME -c 1024 -t 5 -s 32768 -g 8   [1]

Also I have tested this patch can't make g_ether broken.

[1],source of testusb : tools/usb/testusb.c under linux kernel;

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Felipe Balbi <me@felipebalbi.com>
Cc: Anand Gadiyar <gadiyar@ti.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
---
 drivers/usb/musb/musb_gadget.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index f206c94..176e127 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -643,8 +643,8 @@ static void rxstate(struct musb *musb, struct musb_request *req)
 	 */
 
 				csr |= MUSB_RXCSR_DMAENAB;
-#ifdef USE_MODE1
 				csr |= MUSB_RXCSR_AUTOCLEAR;
+#ifdef USE_MODE1
 				/* csr |= MUSB_RXCSR_DMAMODE; */
 
 				/* this special sequence (enabling and then
-- 
1.6.2.5

