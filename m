Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab1ABHYl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:24:41 -0500
Received: from mail.windriver.com ([147.11.1.11]:36487 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab1ABHYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:38 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 177/260] V4L/DVB: cx231xx: Avoid an OOPS when card is unknown (card=0)
Date: Sun,  2 Jan 2011 02:17:53 -0500
Message-Id: <1293952756-15010-178-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:24.0604 (UTC) FILETIME=[F132E7C0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/media/video/cx231xx/cx231xx-cards.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index 6bdc0ef..f78c07c 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -226,14 +226,16 @@ void cx231xx_pre_card_setup(struct cx231xx *dev)
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
-- 
1.7.3.3

