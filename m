Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab2CUKd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 06:33:58 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55616 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904Ab2CUKd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:33:56 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Date: Wed, 21 Mar 2012 11:33:58 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 2/3] i2c-s3c2410: Rework device type handling
In-reply-to: <20120319195540.GH12384@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: ben-linux@fluff.org, thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        w.sang@pengutronix.de
Message-id: <4F69AE96.6060901@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1331657679-31302-1-git-send-email-k.lewandowsk@samsung.com>
 <1331657679-31302-3-git-send-email-k.lewandowsk@samsung.com>
 <20120314172915.GB13393@sirena.org.uk> <4F61BEC8.4030008@samsung.com>
 <20120315125630.GK3138@opensource.wolfsonmicro.com>
 <4F621EC9.6020106@samsung.com>
 <20120319195540.GH12384@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.03.2012 20:55, Mark Brown wrote:

> On Thu, Mar 15, 2012 at 05:54:33PM +0100, Karol Lewandowski wrote:
> 
>> If you consider code to be inherently less readable because of this
>> approach I'll rework it.  If it's not a such big deal for you I would
>> prefer to keep it as is.
> 
> The thing that was causing me to think the code was funny was mainly the
> fact that we're now combining both quirk based selection and chip type
> based selection into the same bitmask.  If the chip types were quirks
> it'd probably not have looked odd, and that might just be a case of
> renaming them - I can't remember what they do.


What do you think about following changes, then?

diff --git a/drivers/i2c/busses/i2c-s3c2410.c
b/drivers/i2c/busses/i2c-s3c2410.c
index fa5f8c4..18c9760 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -48,12 +48,9 @@
 static const struct of_device_id s3c24xx_i2c_match[];
 #endif

-/* reserve lower 8 bits for device type, use remaining space for hw
quirks */
-#define TYPE_BITS		0x000000ff
-#define TYPE_S3C2410		0x00000001
-#define TYPE_S3C2440		0x00000002
-#define FLAG_HDMIPHY		0x00000100
-#define FLAG_NO_GPIO		0x00000200
+#define QUIRK_S3C2440		(1 << 0)
+#define QUIRK_HDMIPHY		(1 << 1)
+#define QUIRK_NO_GPIO		(1 << 2)

 /* i2c controller state */
 enum s3c24xx_i2c_state {
@@ -67,7 +64,7 @@ enum s3c24xx_i2c_state {
 struct s3c24xx_i2c {
 	spinlock_t		lock;
 	wait_queue_head_t	wait;
-	unsigned int            type;
+	unsigned int            quirks;
 	unsigned int		suspended:1;

 	struct i2c_msg		*msg;
@@ -94,22 +91,12 @@ struct s3c24xx_i2c {
 #endif
 };

-/* s3c24xx_i2c_is_type()
- *
- * return true if this controller is of specified type
-*/
-
-static inline int s3c24xx_i2c_is_type(struct s3c24xx_i2c *i2c, unsigned
int type)
-{
-	return (i2c->type & TYPE_BITS) == type;
-}
-
-/* s3c24xx_get_device_type
+/* s3c24xx_get_device_quirks
  *
  * Get controller type either from device tree or platform device variant.
 */

-static inline unsigned int s3c24xx_get_device_type(struct
platform_device *pdev)
+static inline unsigned int s3c24xx_get_device_quirks(struct
platform_device *pdev)
 {
 #ifdef CONFIG_OF
         if (pdev->dev.of_node) {
@@ -487,7 +474,7 @@ static int s3c24xx_i2c_set_master(struct s3c24xx_i2c
*i2c)
 	 * the hangup is expected to happen, so waiting 400 ms
 	 * causes only unnecessary system hangup
 	 */
-	if (i2c->type & FLAG_HDMIPHY)
+	if (i2c->quirks & QUIRK_HDMIPHY)
 		timeout = 10;

 	while (timeout-- > 0) {
@@ -500,7 +487,7 @@ static int s3c24xx_i2c_set_master(struct s3c24xx_i2c
*i2c)
 	}

 	/* hang-up of bus dedicated for HDMIPHY occurred, resetting */
-	if (i2c->type & FLAG_HDMIPHY) {
+	if (i2c->quirks & QUIRK_HDMIPHY) {
 		writel(0, i2c->regs + S3C2410_IICCON);
 		writel(0, i2c->regs + S3C2410_IICSTAT);
 		writel(0, i2c->regs + S3C2410_IICDS);
@@ -704,7 +691,7 @@ static int s3c24xx_i2c_clockrate(struct s3c24xx_i2c
*i2c, unsigned int *got)

 	writel(iiccon, i2c->regs + S3C2410_IICCON);

-	if (s3c24xx_i2c_is_type(i2c, TYPE_S3C2440)) {
+	if (i2c->quirks & QUIRK_S3C2440) {
 		unsigned long sda_delay;

 		if (pdata->sda_delay) {
@@ -789,7 +776,7 @@ static int s3c24xx_i2c_parse_dt_gpio(struct
s3c24xx_i2c *i2c)
 {
 	int idx, gpio, ret;

-	if (i2c->type & FLAG_NO_GPIO)
+	if (i2c->quirks & QUIRK_NO_GPIO)
 		return 0;

 	for (idx = 0; idx < 2; idx++) {
@@ -817,7 +804,7 @@ static void s3c24xx_i2c_dt_gpio_free(struct
s3c24xx_i2c *i2c)
 {
 	unsigned int idx;

-	if (i2c->type & FLAG_NO_GPIO)
+	if (i2c->quirks & QUIRK_NO_GPIO)
 		return;

 	for (idx = 0; idx < 2; idx++)
@@ -898,10 +885,10 @@ s3c24xx_i2c_parse_dt(struct device_node *np,
struct s3c24xx_i2c *i2c)
 	pdata->bus_num = -1; /* i2c bus number is dynamically assigned */

 	if (of_get_property(np, "samsung,i2c-quirk-hdmiphy", NULL))
-		i2c->type |= FLAG_HDMIPHY;
+		i2c->quirks |= QUIRK_HDMIPHY;

 	if (of_get_property(np, "samsung,i2c-no-gpio", NULL))
-		i2c->type |= FLAG_NO_GPIO;
+		i2c->quirks |= QUIRK_NO_GPIO;

 	of_property_read_u32(np, "samsung,i2c-sda-delay", &pdata->sda_delay);
 	of_property_read_u32(np, "samsung,i2c-slave-addr", &pdata->slave_addr);
@@ -948,7 +935,7 @@ static int s3c24xx_i2c_probe(struct platform_device
*pdev)
 		goto err_noclk;
 	}

-	i2c->type = s3c24xx_get_device_type(pdev);
+	i2c->quirks = s3c24xx_get_device_quirks(pdev);
 	if (pdata)
 		memcpy(i2c->pdata, pdata, sizeof(*pdata));
 	else
@@ -1156,21 +1143,21 @@ static const struct dev_pm_ops
s3c24xx_i2c_dev_pm_ops = {
 static struct platform_device_id s3c24xx_driver_ids[] = {
 	{
 		.name		= "s3c2410-i2c",
-		.driver_data	= TYPE_S3C2410,
+		.driver_data	= 0,
 	}, {
 		.name		= "s3c2440-i2c",
-		.driver_data	= TYPE_S3C2440,
+		.driver_data	= QUIRK_S3C2440,
 	}, {
 		.name		= "s3c2440-hdmiphy-i2c",
-		.driver_data	= TYPE_S3C2440 | FLAG_HDMIPHY | FLAG_NO_GPIO,
+		.driver_data	= QUIRK_S3C2440 | QUIRK_HDMIPHY | QUIRK_NO_GPIO,
 	}, { },
 };
 MODULE_DEVICE_TABLE(platform, s3c24xx_driver_ids);

 #ifdef CONFIG_OF
 static const struct of_device_id s3c24xx_i2c_match[] = {
-	{ .compatible = "samsung,s3c2410-i2c", .data = (void *)TYPE_S3C2410 },
-	{ .compatible = "samsung,s3c2440-i2c", .data = (void *)TYPE_S3C2440 },
+	{ .compatible = "samsung,s3c2410-i2c", .data = (void *)0 },
+	{ .compatible = "samsung,s3c2440-i2c", .data = (void *)QUIRK_S3C2440 },
 	{},
 };
 MODULE_DEVICE_TABLE(of, s3c24xx_i2c_match);


Regards,
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
