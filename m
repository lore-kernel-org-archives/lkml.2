Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab0FUPC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:02:57 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:48103 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab0FUPCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:02:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Lothar Wassmann <LW@KARO-electronics.de>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>, Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] USB: isp1362-hcd, fix double lock
Date: Mon, 21 Jun 2010 17:02:51 +0200
Message-Id: <1277132571-14320-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that isp1362_sw_reset tries to take a isp1362_hcd->lock,
but it is already held in isp1362_hc_stop. Avoid that by introducing
__isp1362_sw_reset which doesn't take the lock and call it from
isp1362_hc_stop. isp1362_sw_reset is then as simple as lock --
__isp1362_sw_reset -- unlock.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Lothar Wassmann <LW@KARO-electronics.de>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/host/isp1362-hcd.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index 20a0dfe..0587ad4 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -2224,12 +2224,9 @@ static void remove_debug_file(struct isp1362_hcd *isp1362_hcd)
 
 /*-------------------------------------------------------------------------*/
 
-static void isp1362_sw_reset(struct isp1362_hcd *isp1362_hcd)
+static void __isp1362_sw_reset(struct isp1362_hcd *isp1362_hcd)
 {
 	int tmp = 20;
-	unsigned long flags;
-
-	spin_lock_irqsave(&isp1362_hcd->lock, flags);
 
 	isp1362_write_reg16(isp1362_hcd, HCSWRES, HCSWRES_MAGIC);
 	isp1362_write_reg32(isp1362_hcd, HCCMDSTAT, OHCI_HCR);
@@ -2240,6 +2237,14 @@ static void isp1362_sw_reset(struct isp1362_hcd *isp1362_hcd)
 	}
 	if (!tmp)
 		pr_err("Software reset timeout\n");
+}
+
+static void isp1362_sw_reset(struct isp1362_hcd *isp1362_hcd)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&isp1362_hcd->lock, flags);
+	__isp1362_sw_reset(isp1362_hcd);
 	spin_unlock_irqrestore(&isp1362_hcd->lock, flags);
 }
 
@@ -2418,7 +2423,7 @@ static void isp1362_hc_stop(struct usb_hcd *hcd)
 	if (isp1362_hcd->board && isp1362_hcd->board->reset)
 		isp1362_hcd->board->reset(hcd->self.controller, 1);
 	else
-		isp1362_sw_reset(isp1362_hcd);
+		__isp1362_sw_reset(isp1362_hcd);
 
 	if (isp1362_hcd->board && isp1362_hcd->board->clock)
 		isp1362_hcd->board->clock(hcd->self.controller, 0);
-- 
1.7.1


