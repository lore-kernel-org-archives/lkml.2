Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab2KZRdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:33:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47985 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933782Ab2KZRMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:12:34 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 203/270] staging: comedi: amplc_pc236: fix invalid register access during detach
Date: Mon, 26 Nov 2012 14:58:13 -0200
Message-Id: <1353949160-26803-204-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: devpriv is a macro on 3.5, just check dev->iobase ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/comedi/drivers/amplc_pc236.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 57ba322..1fe5ac9 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -479,7 +479,7 @@ static int pc236_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void pc236_detach(struct comedi_device *dev)
 {
-	if (devpriv)
+	if (dev->iobase)
 		pc236_intr_disable(dev);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-- 
1.7.9.5

