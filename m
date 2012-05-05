Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617Ab2EEDje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 23:39:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39005 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab2EEDjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 23:39:33 -0400
Date: Fri, 4 May 2012 20:38:09 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] max17042_battery: add suspend/resume hooks
Message-ID: <20120505033809.GA3285@lizard>
References: <1332795220-8343-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1332795220-8343-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 02:23:40AM +0530, Ramakrishna Pallala wrote:
> This patch adds suspend/resume methods to the driver.
> 
> In suspend method irq line is disabled to avoid i2c
> read/write errors from the interrupt handler as the
> i2c bus itself could be in suspend state.
> In resume function irq  line will be re-enabled.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> ---

Applied, thank you!

[...]
> +#else
> +#define max17042_suspend NULL
> +#define max17042_resume NULL
> +#endif
> +
[...]
> +static const struct dev_pm_ops max17042_pm_ops = {
> +	.suspend		= max17042_suspend,
> +	.resume			= max17042_resume,
> +};
> +
>  static struct i2c_driver max17042_i2c_driver = {
>  	.driver	= {
>  		.name	= "max17042",
>  		.of_match_table = of_match_ptr(max17042_dt_match),
> +		.pm	= &max17042_pm_ops,

It's better to hide dev_pm_ops under CONFIG_PM, and pass NULL in case
of !PM.

FYI, I applied this on top:

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 07dee97..738648d 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -727,7 +727,8 @@ static int max17042_suspend(struct device *dev)
 {
 	struct max17042_chip *chip = dev_get_drvdata(dev);
 
-	/* disable the irq and enable irq_wake
+	/*
+	 * disable the irq and enable irq_wake
 	 * capability to the interrupt line.
 	 */
 	if (chip->client->irq) {
@@ -751,9 +752,15 @@ static int max17042_resume(struct device *dev)
 
 	return 0;
 }
+
+static const struct dev_pm_ops max17042_pm_ops = {
+	.suspend	= max17042_suspend,
+	.resume		= max17042_resume,
+};
+
+#define MAX17042_PM_OPS (&max17042_pm_ops)
 #else
-#define max17042_suspend NULL
-#define max17042_resume NULL
+#define MAX17042_PM_OPS NULL
 #endif
 
 #ifdef CONFIG_OF
@@ -770,16 +777,11 @@ static const struct i2c_device_id max17042_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, max17042_id);
 
-static const struct dev_pm_ops max17042_pm_ops = {
-	.suspend		= max17042_suspend,
-	.resume			= max17042_resume,
-};
-
 static struct i2c_driver max17042_i2c_driver = {
 	.driver	= {
 		.name	= "max17042",
 		.of_match_table = of_match_ptr(max17042_dt_match),
-		.pm	= &max17042_pm_ops,
+		.pm	= MAX17042_PM_OPS,
 	},
 	.probe		= max17042_probe,
 	.remove		= __devexit_p(max17042_remove),
