Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab0KIVzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:55:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35928 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab0KIVzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:55:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel J Blueman <daniel.blueman@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] gianfar: Do not call device_set_wakeup_enable() under a spinlock
Date: Tue, 9 Nov 2010 22:54:19 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Francois Romieu <romieu@fr.zoreil.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
References: <AANLkTimf_mVrRPEcj8qBbYw1iYHfWdeKUNS3Kk-dfhTT@mail.gmail.com> <201011090030.42693.rjw@sisk.pl>
In-Reply-To: <201011090030.42693.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011092254.19550.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 09, 2010, Rafael J. Wysocki wrote:
> On Tuesday, November 02, 2010, Daniel J Blueman wrote:
> > Since device_set_wakeup_enable now sleeps, it should not be called
> > from a critical section. Since wol_en is not updated elsewhere, we can
> > omit the locking entirely.
> > 
> > Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
> 
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

Having reconsidered that I think it may be better to do something like in the
patch below.

This is a regression fix, so please apply if there are no objections.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: gianfar: Do not call device_set_wakeup_enable() under a spinlock

The gianfar driver calls device_set_wakeup_enable() under a spinlock,
which causes a problem to happen after the recent core power
management changes, because this function can sleep now.  Fix this
by moving the device_set_wakeup_enable() call out of the
spinlock-protected area.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/net/gianfar_ethtool.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/net/gianfar_ethtool.c
===================================================================
--- linux-2.6.orig/drivers/net/gianfar_ethtool.c
+++ linux-2.6/drivers/net/gianfar_ethtool.c
@@ -635,9 +635,10 @@ static int gfar_set_wol(struct net_devic
 	if (wol->wolopts & ~WAKE_MAGIC)
 		return -EINVAL;
 
+	device_set_wakeup_enable(&dev->dev, wol->wolopts & WAKE_MAGIC);
+
 	spin_lock_irqsave(&priv->bflock, flags);
-	priv->wol_en = wol->wolopts & WAKE_MAGIC ? 1 : 0;
-	device_set_wakeup_enable(&dev->dev, priv->wol_en);
+	priv->wol_en =  !!device_may_wakeup(&dev->dev);
 	spin_unlock_irqrestore(&priv->bflock, flags);
 
 	return 0;
