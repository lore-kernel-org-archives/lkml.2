Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1DZQAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:00:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59586 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab1DZQAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:00:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer;
        b=CPgQyWZrsspBDIJGHcLCbeR0AcshiofXfUt6tf7bOvxNHg8Th8J8XmxzybCSM0ou2E
         Kf8ve5TZTMuq1uVOVPw+k12lgTJO4OgvyINW+fVoatSAHiBKcWX6Q4Oy/V848dQVXLEn
         WMlKXZoFmsF8gMb8NbCBPQYhrabuuU3m/BH4M=
Subject: Flow-control representation in ethtool (mii.c fix?)
From: artpol <artpol84@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jgarzik@pobox.com
Content-Type: multipart/mixed; boundary="=-1IMBMr99+VQAeN3YJYHQ"
Date: Tue, 26 Apr 2011 23:00:39 +0700
Message-ID: <1303833639.1938.8.camel@artpol-thinkpad>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1IMBMr99+VQAeN3YJYHQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hello, All.

I was dealing with flow-control on my ethernet card:
eth0: RTL8168d/8111d 
# uname -r
2.6.35-28-generic-pae (Ubuntu 10.10 current kernel)

And found following problem:

~# ethtool eth0
Settings for eth0:
Supported ports: [ TP MII ]
Supported link modes:   10baseT/Half 10baseT/Full 
                        100baseT/Half 100baseT/Full 
                        1000baseT/Half 1000baseT/Full 
Supports auto-negotiation: Yes
Advertised link modes:  10baseT/Half 10baseT/Full 
                        100baseT/Half 100baseT/Full 
                        1000baseT/Half 1000baseT/Full 
Advertised pause frame use: No
...
Link partner advertised pause frame use: No

As you can see no pause frame is advertised. But mii-tool shows
different result:
~# mii-tool eth0
eth0: negotiated 100baseTx-FD flow-control, link ok

And the same shows remote embedded device whith which I work.

Inspection of kernel sources shows that GSET ethtool command leads
r8169.c to call mii_ethtool_gset(). And looking there I found that this
function simply ignore Pause-related settings. Searching kernel sources
shows that a lot of ethernet drivers use this function 
(grep -R mii_ethtool_gset drivers/net/*)

In latest kernel (2.6.38.4) I also see that this thing doesn't fixed. So
I'd like to know is there some background behind this current design or
not. If not I suggest simple patch attached to this mail. I've test it
on kernel 2.6.38.4 and it works for me:

Settings for eth0:
  Supported ports: [ TP MII ]
  Supported link modes:   10baseT/Half 10baseT/Full
                          100baseT/Half 100baseT/Full
                          1000baseT/Half 1000baseT/Full
  Supports auto-negotiation: Yes
  Advertised link modes:  10baseT/Half 10baseT/Full
                          100baseT/Half 100baseT/Full
                          1000baseT/Half 1000baseT/Full
  Advertised pause frame use: Symmetric Receive-only
  Advertised auto-negotiation: Yes
  Link partner advertised link modes:  10baseT/Half 10baseT/Full
                                       100baseT/Half 100baseT/Full
  Link partner advertised pause frame use: Symmetric
  Link partner advertised auto-negotiation: Yes
....

--
Artem Polyakov.

--=-1IMBMr99+VQAeN3YJYHQ
Content-Disposition: attachment; filename="mii_flow_control_gset.patch"
Content-Type: text/x-patch; name="mii_flow_control_gset.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff -Naur linux-2.6.38.4_old/drivers/net/mii.c linux-2.6.38.4_new/drivers/net/mii.c
--- linux-2.6.38.4_old/drivers/net/mii.c	2011-04-22 04:34:46.000000000 +0700
+++ linux-2.6.38.4_new/drivers/net/mii.c	2011-04-25 22:55:40.342981965 +0700
@@ -49,6 +49,10 @@
 		result |= ADVERTISED_100baseT_Half;
 	if (advert & ADVERTISE_100FULL)
 		result |= ADVERTISED_100baseT_Full;
+	if (advert & ADVERTISE_PAUSE_CAP)
+		result |= ADVERTISED_Pause;
+	if (advert & ADVERTISE_PAUSE_ASYM)
+		result |= ADVERTISED_Asym_Pause;
 
 	return result;
 }

--=-1IMBMr99+VQAeN3YJYHQ--

