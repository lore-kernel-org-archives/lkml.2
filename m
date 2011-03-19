Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab1CSPjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 11:39:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54587 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab1CSPjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 11:39:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=M6MHRNCG6qiQoRAIwQghcJyGM18Bi4nVd8u9EGkuZx2UddXsP2N/GNYiCT4ICTfT7A
         FZ9PXKJWnM2pOqlNkcd2wj/wWuseaBAxSokS1R5f64bg/WcnEaV5V9M/MfYJgd/Q7m5H
         LOhRkXf6IFiSVMxR9fF1PCiUqKoCtgPSErLaM=
Subject: [PATCH] r8169: fix a bug in rtl8169_init_phy()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Anca Emanuel <anca.emanuel@gmail.com>, piotr@hosowicz.com,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Francois Romieu <romieu@fr.zoreil.com>,
        David Miller <davem@davemloft.net>
In-Reply-To: <1300548821.2831.28.camel@edumazet-laptop>
References: <4D84A46B.1000407@example.com>
	 <AANLkTimFGeHYEOxx=h883rRJL463g1CBUDS0wGM-52Nj@mail.gmail.com>
	 <1300547930.2831.27.camel@edumazet-laptop>
	 <201103191631.07952.oliver@neukum.org>
	 <1300548821.2831.28.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Mar 2011 16:39:11 +0100
Message-ID: <1300549151.2831.32.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 19 mars 2011 à 16:33 +0100, Eric Dumazet a écrit :
> Le samedi 19 mars 2011 à 16:31 +0100, Oliver Neukum a écrit :
> > Am Samstag, 19. März 2011, 16:18:50 schrieb Eric Dumazet:
> > 
> > > Problem comes from commit 54405cde762408b00a445466a40da4f7f33a8479
> > > (r8169: support control of advertising.)
> > > 
> > > Reverting it brings back NIC for me
> > 
> > Odd. It worked for me. Are you testing on a gigabit switch? Could you send
> > me dmesg? Does it work if you use ethtool to advertise a lower speed?
> > 
> > 	Regards
> > 		Oliver
> 
> I found the bug, I am sending a patch in two minutes.
> 

Here it is

[PATCH] r8169: fix a bug in rtl8169_init_phy()

commit 54405cde7624 (r8169: support control of advertising.)
introduced a bug in rtl8169_init_phy()

Reported-by: Piotr Hosowicz <piotr@hosowicz.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: Francois Romieu <romieu@fr.zoreil.com>
---
 drivers/net/r8169.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 5e40351..493b0de 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2685,9 +2685,9 @@ static void rtl8169_init_phy(struct net_device *dev, struct rtl8169_private *tp)
 	rtl8169_set_speed(dev, AUTONEG_ENABLE, SPEED_1000, DUPLEX_FULL,
 		ADVERTISED_10baseT_Half | ADVERTISED_10baseT_Full |
 		ADVERTISED_100baseT_Half | ADVERTISED_100baseT_Full |
-		tp->mii.supports_gmii ?
+		(tp->mii.supports_gmii ?
 			ADVERTISED_1000baseT_Half |
-			ADVERTISED_1000baseT_Full : 0);
+			ADVERTISED_1000baseT_Full : 0));
 
 	if (RTL_R8(PHYstatus) & TBI_Enable)
 		netif_info(tp, link, dev, "TBI auto-negotiating\n");


