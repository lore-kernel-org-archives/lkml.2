Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab1CBF6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 00:58:15 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52007 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758000Ab1CBF6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 00:58:11 -0500
Date: Wed, 2 Mar 2011 16:58:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hema HK <hemahk@ti.com>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>
Subject: linux-next: manual merge of the usb tree with the omap tree
Message-Id: <20110302165809.583a12a9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
arch/arm/mach-omap2/usb-musb.c between commit
18a26892d62d2786c2b259ba4605ee10bba0ba13 ("OMAP2+: musb: hwmod adaptation
for musb registration") from the omap tree and commit
fb91cde49c327ff957c55d91805bc6abda59b311 ("usb: musb: OMAP4430: Power
down the PHY during board init") from the usb tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

Interestingly, the patch in the usb tree looks as though it would have
been broken as the "dev" variable passed to omap4430_phy_init() does not
exist in the version of that file in the usb tree.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/usb-musb.c
index a9d4d14,241fc94..0000000
--- a/arch/arm/mach-omap2/usb-musb.c
+++ b/arch/arm/mach-omap2/usb-musb.c
@@@ -132,35 -212,12 +132,39 @@@ void __init usb_musb_init(struct omap_m
  	musb_plat.mode = board_data->mode;
  	musb_plat.extvbus = board_data->extvbus;
  
 -	if (platform_device_register(&musb_device) < 0)
 -		printk(KERN_ERR "Unable to register HS-USB (MUSB) device\n");
 +	if (cpu_is_omap3517() || cpu_is_omap3505()) {
 +		oh_name = "am35x_otg_hs";
 +		name = "musb-am35x";
 +	} else {
 +		oh_name = "usb_otg_hs";
 +		name = "musb-omap2430";
 +	}
 +
 +	oh = omap_hwmod_lookup(oh_name);
 +	if (!oh) {
 +		pr_err("Could not look up %s\n", oh_name);
 +		return;
 +	}
 +
 +	od = omap_device_build(name, bus_id, oh, &musb_plat,
 +			       sizeof(musb_plat), omap_musb_latency,
 +			       ARRAY_SIZE(omap_musb_latency), false);
 +	if (IS_ERR(od)) {
 +		pr_err("Could not build omap_device for %s %s\n",
 +						name, oh_name);
 +		return;
 +	}
 +
 +	pdev = &od->pdev;
 +	dev = &pdev->dev;
 +	get_device(dev);
 +	dev->dma_mask = &musb_dmamask;
 +	dev->coherent_dma_mask = musb_dmamask;
 +	put_device(dev);
+ 
+ 	if (cpu_is_omap44xx())
+ 		omap4430_phy_init(dev);
+ 
  }
  
  #else
