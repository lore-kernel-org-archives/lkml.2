Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab1CMVXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 17:23:08 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21094 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab1CMVXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 17:23:07 -0400
Date: Sun, 13 Mar 2011 22:22:45 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH] SPI: Fix a mem leak in dw_spi_setup()
Message-ID: <alpine.LNX.2.00.1103132216530.29706@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/spi/dw_spi.c:dw_spi_setup() we may dynamically allocate memory 
for 'chip' with 'kmalloc'. If we then later leave the function early due 
to '!spi->max_speed_hz' we fail to release this memory again - causing a 
leak when the 'chip' variable goes out of scope.
As far as I can see, the cleanest fix for this is to simply move the test 
for '!spi->max_speed_hz' to the top of the function before we even do the 
dynamic allocation. This way we avoid the issue of having to remember to 
free the memory again and we also avoid a lot of assignments that are 
completely pointless in the failure case.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 dw_spi.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

 compile tested only.

diff --git a/drivers/spi/dw_spi.c b/drivers/spi/dw_spi.c
index 22af77f..6cd678c 100644
--- a/drivers/spi/dw_spi.c
+++ b/drivers/spi/dw_spi.c
@@ -702,6 +702,11 @@ static int dw_spi_setup(struct spi_device *spi)
 	if (spi->bits_per_word != 8 && spi->bits_per_word != 16)
 		return -EINVAL;
 
+	if (!spi->max_speed_hz) {
+		dev_err(&spi->dev, "No max speed HZ parameter\n");
+		return -EINVAL;
+	}
+
 	/* Only alloc on first setup */
 	chip = spi_get_ctldata(spi);
 	if (!chip) {
@@ -746,13 +751,7 @@ static int dw_spi_setup(struct spi_device *spi)
 		return -EINVAL;
 	}
 	chip->bits_per_word = spi->bits_per_word;
-
-	if (!spi->max_speed_hz) {
-		dev_err(&spi->dev, "No max speed HZ parameter\n");
-		return -EINVAL;
-	}
 	chip->speed_hz = spi->max_speed_hz;
-
 	chip->tmode = 0; /* Tx & Rx */
 	/* Default SPI mode is SCPOL = 0, SCPH = 0 */
 	chip->cr0 = (chip->bits_per_word - 1)


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

