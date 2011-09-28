Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415Ab1I1Wt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:49:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54918 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933322Ab1I1WtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:49:22 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:45 2011
Message-Id: <20110928220145.489311507@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [191/244] zorro: Defer device_register() until all devices have been identified
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit a7f4d00a82feb5b311f765bf9522bc55bee0684f upstream.

As the Amiga Zorro II address space is limited to 8.5 MiB and Zorro
devices can contain only one BAR, several Amiga Zorro II expansion
boards (mainly graphics cards) contain multiple Zorro devices: a small
one for the control registers and one (or more) for the graphics memory.

The conversion of cirrusfb to the new driver framework introduced a
regression: the driver contains a zorro_driver for the first Zorro
device, and uses the (old) zorro_find_device() call to find the second
Zorro device.

However, as the Zorro core calls device_register() as soon as a Zorro
device is identified, it may not have identified the second Zorro device
belonging to the same physical Zorro expansion card.  Hence cirrusfb
could no longer find the second part of the Picasso II graphics card,
causing a NULL pointer dereference.

Defer the registration of Zorro devices with the driver framework until
all Zorro devices have been identified to fix this.

Note that the alternative solution (modifying cirrusfb to register a
zorro_driver for all Zorro devices belonging to a graphics card, instead
of only for the first one, and adding a synchronization mechanism to
defer initialization until all have been found), is not an option, as on
some cards one device may be optional (e.g.  the second bank of 2 MiB of
graphics memory on the Picasso IV in Zorro II mode).

Reported-by: Ingo Jürgensmann <ij@2011.bluespice.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/zorro/zorro.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/zorro/zorro.c
+++ b/drivers/zorro/zorro.c
@@ -148,10 +148,10 @@ static int __init amiga_zorro_probe(stru
 	}
 	platform_set_drvdata(pdev, bus);
 
-	/* Register all devices */
 	pr_info("Zorro: Probing AutoConfig expansion devices: %u device%s\n",
 		 zorro_num_autocon, zorro_num_autocon == 1 ? "" : "s");
 
+	/* First identify all devices ... */
 	for (i = 0; i < zorro_num_autocon; i++) {
 		z = &zorro_autocon[i];
 		z->id = (z->rom.er_Manufacturer<<16) | (z->rom.er_Product<<8);
@@ -172,6 +172,11 @@ static int __init amiga_zorro_probe(stru
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


