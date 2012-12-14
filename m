Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab2LNHsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 02:48:51 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40193 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2LNHsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 02:48:50 -0500
Message-ID: <1355471324.11297.3.camel@phoenix>
Subject: [PATCH 2/6] iio: dac: ad5380: Don't set error code to st->vref
From: Axel Lin <axel.lin@ingics.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 14 Dec 2012 15:48:44 +0800
In-Reply-To: <1355471245.11297.1.camel@phoenix>
References: <1355471245.11297.1.camel@phoenix>
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
 drivers/iio/dac/ad5380.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad5380.c b/drivers/iio/dac/ad5380.c
index 14991ac..4aca189 100644
--- a/drivers/iio/dac/ad5380.c
+++ b/drivers/iio/dac/ad5380.c
@@ -406,7 +406,11 @@ static int __devinit ad5380_probe(struct device *dev, struct regmap *regmap,
 			goto error_free_reg;
 		}
 
-		st->vref = regulator_get_voltage(st->vref_reg);
+		ret = regulator_get_voltage(st->vref_reg);
+		if (ret < 0)
+			goto error_disable_reg;
+
+		st->vref = ret;
 	} else {
 		st->vref = st->chip_info->int_vref;
 		ctrl |= AD5380_CTRL_INT_VREF_EN;
-- 
1.7.9.5



