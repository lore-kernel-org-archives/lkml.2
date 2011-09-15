Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab1IOJd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 05:33:26 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:33263 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab1IOJdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 05:33:25 -0400
X-Originating-IP: 217.70.178.138
X-Originating-IP: 147.83.37.97
From: "Leopold Palomo-Avellaneda" <leo@alaxarxa.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH/RFC] parport_pc: remove ancient, overeager quirk that disables EPP support on many chipsets
Date: Thu, 15 Sep 2011 11:33:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.32-5-amd64; KDE/4.4.5; x86_64; ; )
Cc: linux-parport@lists.infradead.org, 630593@bugs.debian.org,
        Nicos Gollan <gollan@informatik.uni-kl.de>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Jonathan Nieder <jrnieder@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_eZccO6BXH/0PW0y"
Message-Id: <201109151133.19211.leo@alaxarxa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_eZccO6BXH/0PW0y
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi,

there's a bug in the parport module that have been reported (in another 
places) some time ago [1]. Also, this bug was reported at Redhat [2], but 
nobody follow the report and it was closed.

As Adam baked said [1] :

<quote>
A long time ago (~ 10 years), Intel produced a chipset that 
included broken EPP support. The Linux parport driver was written to detect 
such a chipset and disable EPP support on it. Unfortunately the test that was 
written gives false positives for many current chipsets and no-one seems to 
know exactly what the problem hardware was, let alone have a sample of it to 
see if a better test can be written. After such a long time it is probably 
appropriate to just remove the test (on average it does more harm than good) 
however you are correct in asserting the driver is unmaintained so no-one is 
bothering to fix it.
</quote>

I have applied the patch to the standard debian kernel and vanilla kernels and 
runs perfectly. The patch simply erases a check. Applied to some Dell 
hardware, now the EPP mode is detected and, after some initial tests it's 
working.

Please, apply the patch.

Best regards,

Leo

[1] http://lists.infradead.org/pipermail/linux-parport/2008-March/000628.html
[2] https://bugzilla.redhat.com/show_bug.cgi?id=284471

--Boundary-00=_eZccO6BXH/0PW0y
Content-Type: text/x-patch;
  charset="UTF-8";
  name="patch_parport_bug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="patch_parport_bug.patch"

--- linux-2.6-3.0.0/drivers/parport/parport_pc.c.orig	2011-09-13 16:29:54.333048437 +0200
+++ linux-2.6-3.0.0/drivers/parport/parport_pc.c	2011-09-13 16:30:39.933451659 +0200
@@ -2018,18 +2018,6 @@ static int parport_EPP_supported(struct
 	if (!clear_epp_timeout(pb))
 		return 0;  /* No way to clear timeout */
 
-	/* Check for Intel bug. */
-	if (priv->ecr) {
-		unsigned char i;
-		for (i = 0x00; i < 0x80; i += 0x20) {
-			ECR_WRITE(pb, i);
-			if (clear_epp_timeout(pb)) {
-				/* Phony EPP in ECP. */
-				return 0;
-			}
-		}
-	}
-
 	pb->modes |= PARPORT_MODE_EPP;
 
 	/* Set up access functions to use EPP hardware. */

--Boundary-00=_eZccO6BXH/0PW0y--
