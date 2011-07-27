Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab1G0UTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:19:53 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:53630 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754731Ab1G0UTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:19:41 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: hostap_cs: add ID for LG cards
Date: Wed, 27 Jul 2011 22:19:15 +0200
User-Agent: KMail/1.9.10
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <201107262314.03422.linux@rainbow-software.org> <4E2F379D.9080108@gnu.org>
In-Reply-To: <4E2F379D.9080108@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107272219.23501.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 July 2011 23:54:37 Pavel Roskin wrote:
> On 07/26/2011 05:14 PM, Ondrej Zary wrote:
> > Add IDs for LG PCMCIA cards.
> > This allows LG LW1100P PCI card (with integrated CardBus bridge) to work
> > (tested with rev 3.0) and probably also LW1100N (PCMCIA).
> >
> > Signed-off-by: Ondrej Zary<linux@rainbow-software.org>
> 
> Acked-by: Pavel Roskin <proski@gnu.org>
> 
> I googled for the card name and found indications that the card uses 
> Intersil firmware and thus supportable by Hostap.
> 
> The problem was reported in year 2003, first in June:
> http://osdir.com/ml/linux.drivers.hostap/2003-06/msg00159.html
> 
> And then in November:
> http://osdir.com/ml/linux.linux-wlan.user/2003-11/msg00039.html

I have the card since 2003 and I was using it back then with HostAP
(in managed mode - after much pain with linux-wlan-ng, I was surprised how
well HostAP worked). I even flashed the card's firmware using hostap tools
multiple times (currently v1.8.4).
But I don't remember if I had to add card's device ID to the driver...probably
because PCMCIA configuration was totally different back then.

> It's quite disappointing that we are fixing this more than 8 years after 
> the first report, when the cards in question have become rare and 
> obsolete.  But it's still better than nothing.
> 
> > --- linux-2.6.39-rc2-orig/drivers/net/wireless/hostap/hostap_cs.c	2011-04-06 03:30:43.000000000 +0200
> > +++ linux-2.6.39-rc2/drivers/net/wireless/hostap/hostap_cs.c	2011-07-26 22:17:03.000000000 +0200
> > @@ -648,6 +648,8 @@ static struct pcmcia_device_id hostap_cs
> >   					 0x74c5e40d),
> >   	PCMCIA_DEVICE_MANF_CARD_PROD_ID1(0x0156, 0x0002, "Intersil",
> >   					 0x4b801a17),
> > +	PCMCIA_DEVICE_MANF_CARD_PROD_ID1(0x0156, 0x0002, "LG",
> > +					 0xb474d43a),
> 
> What is the "pccardctl ident" output on your card?
> 
> I think we may want to introduce PCMCIA_DEVICE_MANF_CARD_PROD_ID3 and match
> 
> PCMCIA_DEVICE_MANF_CARD_PROD_ID3(0x0156, 0x0002, "Version 1.02", xxx)
> 
> Maybe some other card would be supported too?  I doubt there are any 
> Agere or Symbol cards with "Version 1.02" in the third text ID.

Yes, that looks good, it would match my card too:
  product info: "LG", "11Mbps Wireless LAN PCI Card", "Version 01.02", ""
  manfid: 0x0156, 0x0002
  function: 6 (network)


---------------------------

Add generic "Version 01.02" match (used by many different cards) to hostap_cs.

This allows LG LW1100P PCI card (with integrated CardBus bridge) to work
(tested with rev 3.0) and probably also LW1100N (PCMCIA).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.39-rc2-orig/include/pcmcia/device_id.h	2011-04-06 03:30:43.000000000 +0200
+++ linux-2.6.39-rc2/include/pcmcia/device_id.h	2011-07-27 21:43:54.000000000 +0200
@@ -95,6 +95,14 @@
 	.prod_id = { (v1), NULL, NULL, NULL }, \
 	.prod_id_hash = { (vh1), 0, 0, 0 }, }
 
+#define PCMCIA_DEVICE_MANF_CARD_PROD_ID3(manf, card, v3, vh3) { \
+	.match_flags = PCMCIA_DEV_ID_MATCH_MANF_ID| \
+			PCMCIA_DEV_ID_MATCH_CARD_ID| \
+			PCMCIA_DEV_ID_MATCH_PROD_ID3, \
+	.manf_id = (manf), \
+	.card_id = (card), \
+	.prod_id = { NULL, NULL, (v3), NULL }, \
+	.prod_id_hash = { 0, 0, (vh3), 0 }, }
 
 /* multi-function devices */
 
--- linux-2.6.39-rc2-orig/drivers/net/wireless/hostap/hostap_cs.c	2011-04-06 03:30:43.000000000 +0200
+++ linux-2.6.39-rc2/drivers/net/wireless/hostap/hostap_cs.c	2011-07-27 21:12:19.000000000 +0200
@@ -648,6 +648,8 @@ static struct pcmcia_device_id hostap_cs
 					 0x74c5e40d),
 	PCMCIA_DEVICE_MANF_CARD_PROD_ID1(0x0156, 0x0002, "Intersil",
 					 0x4b801a17),
+	PCMCIA_DEVICE_MANF_CARD_PROD_ID3(0x0156, 0x0002, "Version 01.02",
+					 0x4b74baa0),
 	PCMCIA_MFC_DEVICE_PROD_ID12(0, "SanDisk", "ConnectPlus",
 				    0x7a954bd9, 0x74be00c6),
 	PCMCIA_DEVICE_PROD_ID123(


-- 
Ondrej Zary
