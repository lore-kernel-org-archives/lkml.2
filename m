Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab0IYUjc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 16:39:32 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:36382 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754442Ab0IYUja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 16:39:30 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: jgarzik@pobox.com
Subject: [PATCH] de2104x: fix TP link detection
Date: Sat, 25 Sep 2010 22:39:17 +0200
User-Agent: KMail/1.9.10
Cc: netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009252239.21376.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compex FreedomLine 32 PnP-PCI2 cards have only TP and BNC connectors but the
SROM contains AUI port too. When TP loses link, the driver switches to
non-existing AUI port (which reports that carrier is always present).

Connecting TP back generates LinkPass interrupt but de_media_interrupt() is
broken - it only updates the link state of currently connected media, ignoring
the fact that LinkPass and LinkFail bits of MacStatus register belong to the
TP port only (the chip documentation says that).

This patch changes de_media_interrupt() to switch media to TP when link goes
up (and media type is not locked) and also to update the link state only when
the TP port is used.

Also the NonselPortActive (and also SelPortActive) bits of SIAStatus register
need to be cleared (by writing 1) after reading or they're useless.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.36-rc3-/drivers/net/tulip/de2104x.c	2010-09-25 21:19:53.000000000 +0200
+++ linux-2.6.36-rc3/drivers/net/tulip/de2104x.c	2010-09-25 21:22:11.000000000 +0200
@@ -243,6 +243,7 @@ enum {
 	NWayState		= (1 << 14) | (1 << 13) | (1 << 12),
 	NWayRestart		= (1 << 12),
 	NonselPortActive	= (1 << 9),
+	SelPortActive		= (1 << 8),
 	LinkFailStatus		= (1 << 2),
 	NetCxnErr		= (1 << 1),
 };
@@ -1066,6 +1067,9 @@ static void de21041_media_timer (unsigne
 	unsigned int carrier;
 	unsigned long flags;
 
+	/* clear port active bits */
+	dw32(SIAStatus, NonselPortActive | SelPortActive);
+
 	carrier = (status & NetCxnErr) ? 0 : 1;
 
 	if (carrier) {
@@ -1160,14 +1164,29 @@ no_link_yet:
 static void de_media_interrupt (struct de_private *de, u32 status)
 {
 	if (status & LinkPass) {
+		/* Ignore if current media is AUI or BNC and we can't use TP */
+		if ((de->media_type == DE_MEDIA_AUI ||
+		     de->media_type == DE_MEDIA_BNC) &&
+		    (de->media_lock ||
+		     !de_ok_to_advertise(de, DE_MEDIA_TP_AUTO)))
+			return;
+		/* If current media is not TP, change it to TP */
+		if ((de->media_type == DE_MEDIA_AUI ||
+		     de->media_type == DE_MEDIA_BNC)) {
+			de->media_type = DE_MEDIA_TP_AUTO;
+			de_stop_rxtx(de);
+			de_set_media(de);
+			de_start_rxtx(de);
+		}
 		de_link_up(de);
 		mod_timer(&de->media_timer, jiffies + DE_TIMER_LINK);
 		return;
 	}
 
 	BUG_ON(!(status & LinkFail));
-
-	if (netif_carrier_ok(de->dev)) {
+	/* Mark the link as down only if current media is TP */
+	if (netif_carrier_ok(de->dev) && de->media_type != DE_MEDIA_AUI &&
+	    de->media_type != DE_MEDIA_BNC) {
 		de_link_down(de);
 		mod_timer(&de->media_timer, jiffies + DE_TIMER_NO_LINK);
 	}


-- 
Ondrej Zary
