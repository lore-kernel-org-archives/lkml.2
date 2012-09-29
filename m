Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419Ab2I2HOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 03:14:10 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26406 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab2I2HOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 03:14:07 -0400
Date: Sat, 29 Sep 2012 10:13:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anton Vorontsov <cbou@mail.ru>, anish kumar <anish198519851985@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] power: battery: pointer math issue in gab_probe()
Message-ID: <20120929071346.GE10993@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

psy->properties is an enum (32 bit type) so adding sizeof() puts us
four times further along than we intended.  It should be cast to a char
pointer before doing the math.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Casting to void * would also work on GCC, at least.

diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
index 9bdf444..776f118 100644
--- a/drivers/power/generic-adc-battery.c
+++ b/drivers/power/generic-adc-battery.c
@@ -279,7 +279,8 @@ static int __devinit gab_probe(struct platform_device *pdev)
 	}
 
 	memcpy(psy->properties, gab_props, sizeof(gab_props));
-	properties = psy->properties + sizeof(gab_props);
+	properties = (enum power_supply_property *)
+				((char *)psy->properties + sizeof(gab_props));
 
 	/*
 	 * getting channel from iio and copying the battery properties
