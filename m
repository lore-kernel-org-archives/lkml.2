Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab2L0MLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 07:11:54 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:26493 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752663Ab2L0MLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 07:11:17 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH 2/6] of: Return -ENXIO from of_parse_phandle_with_args for too large index and return errors from of_gpio_named_count
Date: Thu, 27 Dec 2012 13:10:43 +0100
Message-Id: <1356610247-11491-3-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1356610247-11491-1-git-send-email-andreas@gaisler.com>
References: <1356610247-11491-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets of_gpio_named_count return an errno on errors by being able to
distinguish between reaching the end of the phandle list and getting some other
error from of_parse_phandle_with_args.

Return error from of_spi_register_master when there is an "cs-gpios" list for
which gp_gpio_named_count fails.

Adjust drivers/hwmon/gpio-fan.c to cope with error return.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---

Uses -ENXIO modelled after uses such as in platform_get_irq, but maybe some
other errno than ENXIO is more appropriate for this case.

 drivers/gpio/gpiolib-of.c |    8 +++++---
 drivers/hwmon/gpio-fan.c  |    2 +-
 drivers/of/base.c         |    5 ++++-
 drivers/spi/spi.c         |   11 +++++++----
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index d542a14..28f24a6 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -107,11 +107,10 @@ EXPORT_SYMBOL(of_get_named_gpio_flags);
  */
 unsigned int of_gpio_named_count(struct device_node *np, const char* propname)
 {
+	int ret;
 	unsigned int cnt = 0;
 
 	do {
-		int ret;
-
 		ret = of_parse_phandle_with_args(np, propname, "#gpio-cells",
 						 cnt, NULL);
 		/* A hole in the gpios = <> counts anyway. */
@@ -119,7 +118,10 @@ unsigned int of_gpio_named_count(struct device_node *np, const char* propname)
 			break;
 	} while (++cnt);
 
-	return cnt;
+	if (ret == -ENXIO)
+		return cnt;
+	else
+		return ret;
 }
 EXPORT_SYMBOL(of_gpio_named_count);
 
diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index 4e04c12..9ccd92f 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -477,7 +477,7 @@ static int gpio_fan_get_of_pdata(struct device *dev,
 	pdata->speed = speed;
 
 	/* Alarm GPIO if one exists */
-	if (of_gpio_named_count(node, "alarm-gpios")) {
+	if (of_gpio_named_count(node, "alarm-gpios") > 0) {
 		struct gpio_fan_alarm *alarm;
 		int val;
 		enum of_gpio_flags flags;
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 986afd7..1f16629 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1110,7 +1110,10 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
 	/* Loop exited without finding a valid entry; return an error */
 	if (node)
 		of_node_put(node);
-	return -EINVAL;
+	if (list == list_end)
+		return -ENXIO; /* Index beyond end of list */
+	else
+		return -EINVAL;
 }
 EXPORT_SYMBOL(of_parse_phandle_with_args);
 
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 19ee901..9c2acf1 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1059,7 +1059,7 @@ EXPORT_SYMBOL_GPL(spi_alloc_master);
 #ifdef CONFIG_OF
 static int of_spi_register_master(struct spi_master *master)
 {
-	u16 nb;
+	int nb;
 	int i, *cs;
 	struct device_node *np = master->dev.of_node;
 
@@ -1067,10 +1067,13 @@ static int of_spi_register_master(struct spi_master *master)
 		return 0;
 
 	nb = of_gpio_named_count(np, "cs-gpios");
-	master->num_chipselect = max(nb, master->num_chipselect);
-
-	if (nb < 1)
+	if (nb == 0 || nb == -ENOENT) /* No error if cs-gpios does not exist */
 		return 0;
+	else if (nb < 0)
+		return nb;
+
+	if (nb > master->num_chipselect)
+		master->num_chipselect = (u16)nb;
 
 	cs = devm_kzalloc(&master->dev,
 			  sizeof(int) * master->num_chipselect,
-- 
1.7.0.4

