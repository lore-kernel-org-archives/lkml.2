Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468Ab2COLiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:38:17 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45242 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371Ab2COLiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:38:15 -0400
Date: Thu, 15 Mar 2012 14:37:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Philip Rakity <prakity@marvell.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, kernel-janitors@vger.kernel.org
Subject: [patch] max17042_battery: fix a couple buffer overflows
Message-ID: <20120315113732.GA364@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F61D49C.001F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a couple issues here caused by confusion between sizeof()
and ARRAY_SIZE().  "table_size" should be the number of elements, but we
should allocate it with kcalloc() so that we allocate the correct number
of bytes.

In max17042_init_model() we don't allocate enough space so we go past
the end of the array in max17042_read_model_data() and
max17042_model_data_compare().

In max17042_verify_model_lock() we allocate the right amount of space
but we call max17042_read_model_data() with the wrong number of elements
and also in the for loop we go past the end of the array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I don't have this hardware.  The original code is clearly buggy, but I
can't test that my fix is correct.  Please review carefully.

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index e36763a..f8cd48c 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -328,11 +328,10 @@ static inline int max17042_model_data_compare(struct max17042_chip *chip,
 static int max17042_init_model(struct max17042_chip *chip)
 {
 	int ret;
-	int table_size =
-		sizeof(chip->pdata->config_data->cell_char_tbl)/sizeof(u16);
+	int table_size = ARRAY_SIZE(chip->pdata->config_data->cell_char_tbl);
 	u16 *temp_data;
 
-	temp_data = kzalloc(table_size, GFP_KERNEL);
+	temp_data = kcalloc(table_size, sizeof(*temp_data), GFP_KERNEL);
 	if (!temp_data)
 		return -ENOMEM;
 
@@ -357,12 +356,11 @@ static int max17042_init_model(struct max17042_chip *chip)
 static int max17042_verify_model_lock(struct max17042_chip *chip)
 {
 	int i;
-	int table_size =
-		sizeof(chip->pdata->config_data->cell_char_tbl);
+	int table_size = ARRAY_SIZE(chip->pdata->config_data->cell_char_tbl);
 	u16 *temp_data;
 	int ret = 0;
 
-	temp_data = kzalloc(table_size, GFP_KERNEL);
+	temp_data = kcalloc(table_size, sizeof(*temp_data), GFP_KERNEL);
 	if (!temp_data)
 		return -ENOMEM;
 
