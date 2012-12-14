Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab2LNHri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 02:47:38 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64623 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab2LNHrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 02:47:35 -0500
Message-ID: <1355471245.11297.1.camel@phoenix>
Subject: [PATCH 1/6] iio: adc: ad7266: Don't set error code to st->vref_uv
From: Axel Lin <axel.lin@ingics.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 14 Dec 2012 15:47:25 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator_get_voltage() may return negative error code.
Add error checking to avoid setting error code to st->vref_uv.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/iio/adc/ad7266.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7266.c b/drivers/iio/adc/ad7266.c
index a6f4fc5..e36107d 100644
--- a/drivers/iio/adc/ad7266.c
+++ b/drivers/iio/adc/ad7266.c
@@ -411,7 +411,11 @@ static int __devinit ad7266_probe(struct spi_device *spi)
 		if (ret)
 			goto error_put_reg;
 
-		st->vref_uv = regulator_get_voltage(st->reg);
+		ret = regulator_get_voltage(st->reg);
+		if (ret < 0)
+			goto error_disable_reg;
+
+		st->vref_uv = ret;
 	} else {
 		/* Use internal reference */
 		st->vref_uv = 2500000;
-- 
1.7.9.5



