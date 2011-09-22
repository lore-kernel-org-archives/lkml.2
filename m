Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab1IVTro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 15:47:44 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:52139 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab1IVTrn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 15:47:43 -0400
Date: Thu, 22 Sep 2011 21:47:38 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        =?ISO-8859-15?Q?Ingo_J=FCrgensmann?= <ij@2011.bluespice.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] zorro: Defer device_register() until all devices have been
 identified
Message-ID: <alpine.DEB.2.00.1109222140510.8856@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the Amiga Zorro II address space is limited to 8.5 MiB and Zorro devices
can contain only one BAR, several Amiga Zorro II expansion boards (mainly
graphics cards) contain multiple Zorro devices: a small one for the control
registers and one (or more) for the graphics memory.

The conversion of cirrusfb to the new driver framework introduced a
regression: the driver contains a zorro_driver for the first Zorro device,
and uses the (old) zorro_find_device() call to find the second Zorro
device.
However, as the Zorro core calls device_register() as soon as a Zorro
device is identified, it may not have identified the second Zorro device
belonging to the same physical Zorro expansion card. Hence cirrusfb could
no longer find the second part of the Picasso II graphics card, causing a
NULL pointer dereference.

Defer the registration of Zorro devices with the driver framework until
all Zorro devices have been identified to fix this.

Note that the alternative solution (modifying cirrusfb to register a
zorro_driver for all Zorro devices belonging to a graphics card, instead
of only for the first one, and adding a synchronization mechanism to defer
initialization until all have been found), is not an option, as on some
cards one device may be optional (e.g. the second bank of 2 MiB of
graphics memory on the Picasso IV in Zorro II mode).

Reported-by: Ingo Jürgensmann <ij@2011.bluespice.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@kernel.org
---
    Hi Linus,

Since kernel.org is still down and I have only one remaining patch for 3.1,
I'm sending it by email.

Please apply. Thanks a lot!

Authorization code F68KAMYRULEZ.

 drivers/zorro/zorro.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/zorro/zorro.c b/drivers/zorro/zorro.c
index e0c2807..181fa81 100644
--- a/drivers/zorro/zorro.c
+++ b/drivers/zorro/zorro.c
@@ -148,10 +148,10 @@ static int __init amiga_zorro_probe(struct platform_device *pdev)
 	}
 	platform_set_drvdata(pdev, bus);
 
-	/* Register all devices */
 	pr_info("Zorro: Probing AutoConfig expansion devices: %u device%s\n",
 		 zorro_num_autocon, zorro_num_autocon == 1 ? "" : "s");
 
+	/* First identify all devices ... */
 	for (i = 0; i < zorro_num_autocon; i++) {
 		z = &zorro_autocon[i];
 		z->id = (z->rom.er_Manufacturer<<16) | (z->rom.er_Product<<8);
@@ -172,6 +172,11 @@ static int __init amiga_zorro_probe(struct platform_device *pdev)
 		dev_set_name(&z->dev, "%02x", i);
 		z->dev.parent = &bus->dev;
 		z->dev.bus = &zorro_bus_type;
+	}
+
+	/* ... then register them */
+	for (i = 0; i < zorro_num_autocon; i++) {
+		z = &zorro_autocon[i];
 		error = device_register(&z->dev);
 		if (error) {
 			dev_err(&bus->dev, "Error registering device %s\n",
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
