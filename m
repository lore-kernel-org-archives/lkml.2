Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab0KAVfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:35:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62056 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab0KAVfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:35:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=FJ9LETgHzMR7c9+j58osyVr9T8Qx7fX10S4+0RN0wlF47wOA+y08Kg+yhJQQKnmYDM
         aTsleL6Tv7XgnIc58+VnCnkQgrY6CBVrkU7gkCROwnZpHALZuUG/otGBgW9ryUEttSor
         jeHvhLyyRIVWZcSZfr14zheJirnCGLEDO97N8=
MIME-Version: 1.0
Date: Mon, 1 Nov 2010 21:35:49 +0000
Message-ID: <AANLkTimZvwdY8Q+=iGMC2MhPt_Vow38a0SE9g4ij-cRe@mail.gmail.com>
Subject: [2.6.37-rc1, patch] r8169: fix sleeping while holding spinlock...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent changes to the r8169 driver cause it to call
device_set_wakeup_enable under spinlock, which may sleep.

Locking isn't necessary around the call to device_set_wakeup_enable,
so drop the spinlock before calling it, to address this.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index d88ce9f..894e7c7 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -846,10 +846,10 @@ static int rtl8169_set_wol(struct net_device
*dev, struct ethtool_wolinfo *wol)
 	else
 		tp->features &= ~RTL_FEATURE_WOL;
 	__rtl8169_set_wol(tp, wol->wolopts);
-	device_set_wakeup_enable(&tp->pci_dev->dev, wol->wolopts);
-
 	spin_unlock_irq(&tp->lock);

+	device_set_wakeup_enable(&tp->pci_dev->dev, wol->wolopts);
+
 	return 0;
 }

-- 
Daniel J Blueman
