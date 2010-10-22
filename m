Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab0JVS4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:56:24 -0400
Received: from kroah.org ([198.145.64.141]:34066 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759298Ab0JVS4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:16 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:30 2010
Message-Id: <20101022185230.396292972@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [034/103] V4L/DVB: cx231xx: Avoid an OOPS when card is unknown (card=0)
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit c10469c637602c2385e2993d8c730cc44fd47d23 upstream.

As reported by: Carlos Americo Domiciano <c_domiciano@yahoo.com.br>:

[  220.033500] cx231xx v4l2 driver loaded.
[  220.033571] cx231xx #0: New device Conexant Corporation Polaris AV Capturb @ 480 Mbps (1554:5010) with 6 interfaces
[  220.033577] cx231xx #0: registering interface 0
[  220.033591] cx231xx #0: registering interface 1
[  220.033654] cx231xx #0: registering interface 6
[  220.033910] cx231xx #0: Identified as Unknown CX231xx video grabber (card=0)
[  220.033946] BUG: unable to handle kernel NULL pointer dereference at (null)
[  220.033955] IP: [<ffffffffa0d3c8bd>] cx231xx_pre_card_setup+0x5d/0xb0 [cx231xx]

Thanks-to: Carlos Americo Domiciano <c_domiciano@yahoo.com.br>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx231xx/cx231xx-cards.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -226,14 +226,16 @@ void cx231xx_pre_card_setup(struct cx231
 		     dev->board.name, dev->model);
 
 	/* set the direction for GPIO pins */
-	cx231xx_set_gpio_direction(dev, dev->board.tuner_gpio->bit, 1);
-	cx231xx_set_gpio_value(dev, dev->board.tuner_gpio->bit, 1);
-	cx231xx_set_gpio_direction(dev, dev->board.tuner_sif_gpio, 1);
+	if (dev->board.tuner_gpio) {
+		cx231xx_set_gpio_direction(dev, dev->board.tuner_gpio->bit, 1);
+		cx231xx_set_gpio_value(dev, dev->board.tuner_gpio->bit, 1);
+		cx231xx_set_gpio_direction(dev, dev->board.tuner_sif_gpio, 1);
 
-	/* request some modules if any required */
+		/* request some modules if any required */
 
-	/* reset the Tuner */
-	cx231xx_gpio_set(dev, dev->board.tuner_gpio);
+		/* reset the Tuner */
+		cx231xx_gpio_set(dev, dev->board.tuner_gpio);
+	}
 
 	/* set the mode to Analog mode initially */
 	cx231xx_set_mode(dev, CX231XX_ANALOG_MODE);


