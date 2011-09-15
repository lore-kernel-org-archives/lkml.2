Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933690Ab1IONKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:10:14 -0400
Received: from dash.upc.es ([147.83.2.50]:34586 "EHLO dash.upc.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933338Ab1IONKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 09:10:13 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Sep 2011 09:10:12 EDT
To: linux-kernel@vger.kernel.org, Adam Baker <linux@baker-net.org.uk>
Subject: [PATCH/RFC] parport_pc: remove ancient, overeager quirk that disables EPP support on many chipsets
Cc: linux-parport@lists.infradead.org, 630593@bugs.debian.org,
        Nicos Gollan <gollan@informatik.uni-kl.de>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Jonathan Nieder <jrnieder@gmail.com>
From: "Leopold Palomo-Avellaneda" <leopold.palomo@upc.edu>
Reply-To: leopold.palomo@upc.edu
Date: Thu, 15 Sep 2011 15:02:36 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_sdfcOoZueM0tUyz"
Message-Id: <201109151502.36740.leopold.palomo@upc.edu>
X-Mail-Scanned: Criba 2.0 + Clamd
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (dash.upc.es [147.83.2.50]); Thu, 15 Sep 2011 15:02:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_sdfcOoZueM0tUyz
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi again,

sorry for the noise and my mistake. The patch...

there's a bug in the parport module that have been reported (in another 
places) some time ago [1]. Also, this bug was reported at Redhat [2], but 
nobody follow the report and it was closed.

As Adam Baker said [1] :

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


Signed-off-by: Adam Baker <linux at baker-net.org.uk>
Signed-off-by: Leopold Palomo-Avellaneda <leo@alaxarxa.net>


---

--Boundary-00=_sdfcOoZueM0tUyz
Content-Type: text/x-patch;
  charset="utf-8";
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

--Boundary-00=_sdfcOoZueM0tUyz--
