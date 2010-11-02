Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0KBA0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 20:26:01 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42980 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab0KBAZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 20:25:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=hhurDuoVnjjXbUTovRm3cmbP1YgAFjDcTmkJ9uho8x3YRKGfZ09vFJEbMb4LlrWnmm
         BcO6kP7sUK8XDYXrFq9jspO5wlvZ21T8iNWQjEkhgPwadngHFKBrH4YEwjkRA6eJrZRr
         afdHF4IoN829yTt5fCicfgFAsdrlq+p+pGwHg=
MIME-Version: 1.0
Date: Tue, 2 Nov 2010 00:25:58 +0000
Message-ID: <AANLkTimf_mVrRPEcj8qBbYw1iYHfWdeKUNS3Kk-dfhTT@mail.gmail.com>
Subject: [2.6.37-rc1, patch] gianfar: fix sleep in atomic...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Francois Romieu <romieu@fr.zoreil.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since device_set_wakeup_enable now sleeps, it should not be called
from a critical section. Since wol_en is not updated elsewhere, we can
omit the locking entirely.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/drivers/net/gianfar_ethtool.c b/drivers/net/gianfar_ethtool.c
index 5c566eb..e641d7c 100644
--- a/drivers/net/gianfar_ethtool.c
+++ b/drivers/net/gianfar_ethtool.c
@@ -635,10 +635,8 @@ static int gfar_set_wol(struct net_device *dev,
struct ethtool_wolinfo *wol)
 	if (wol->wolopts & ~WAKE_MAGIC)
 		return -EINVAL;

-	spin_lock_irqsave(&priv->bflock, flags);
 	priv->wol_en = wol->wolopts & WAKE_MAGIC ? 1 : 0;
 	device_set_wakeup_enable(&dev->dev, priv->wol_en);
-	spin_unlock_irqrestore(&priv->bflock, flags);

 	return 0;
 }
-- 
Daniel J Blueman
