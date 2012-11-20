Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab2KTW2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 17:28:12 -0500
Received: from mail-wi0-f202.google.com ([209.85.212.202]:39590 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab2KTW2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 17:28:10 -0500
From: Doug Anderson <dianders@chromium.org>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Padmavathi Venna <padma.v@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] i2c: s3c2410: Get the i2c bus number from alias id
Date: Tue, 20 Nov 2012 14:27:04 -0800
Message-Id: <1353450428-2615-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1353450428-2615-1-git-send-email-dianders@chromium.org>
References: <1353450428-2615-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Padmavathi Venna <padma.v@samsung.com>

Get the i2c bus number that the device is connected to using the alias
id.  This makes debugging / grokking of kernel messages much easier.

[dianders: slight patch cleanup from Padmavathi's original.]

Signed-off-by: Padmavathi Venna <padma.v@samsung.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/i2c/busses/i2c-s3c2410.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 3e0335f..ca43590 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -899,11 +899,19 @@ static void
 s3c24xx_i2c_parse_dt(struct device_node *np, struct s3c24xx_i2c *i2c)
 {
 	struct s3c2410_platform_i2c *pdata = i2c->pdata;
+	int id;
 
 	if (!np)
 		return;
 
-	pdata->bus_num = -1; /* i2c bus number is dynamically assigned */
+	id = of_alias_get_id(np, "i2c");
+	if (id < 0) {
+		dev_warn(i2c->dev, "failed to get alias id:%d\n", id);
+		pdata->bus_num = -1;
+	} else {
+		/* i2c bus number is statically assigned from alias */
+		pdata->bus_num = id;
+	}
 	of_property_read_u32(np, "samsung,i2c-sda-delay", &pdata->sda_delay);
 	of_property_read_u32(np, "samsung,i2c-slave-addr", &pdata->slave_addr);
 	of_property_read_u32(np, "samsung,i2c-max-bus-freq",
-- 
1.7.7.3

