Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab1ARFNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 00:13:37 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52052 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1ARFNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 00:13:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sWtc1jyp1407EHO8MSJwmMTDWmlV5I3LEFA1DARbhL6W+gaAqgdc8Z93A7gBEK40ew
         cy7DUj93+nmWM1KxhCxzeh8imKdOcmfbVycCveQYmaxCNUmGrDIfSn7Y9ZCL4ajxvnM/
         fwhU84P4JO1ieu7lgOjabtZrk6fFGfk0YlubQ=
Date: Mon, 17 Jan 2011 21:13:28 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: riyer@nvidia.com
Cc: tsoni@codeaurora.org, pavel@ucw.cz, shubhrajyoti@ti.com,
        ccross@android.com, konkers@android.com, olof@lixom.net,
        achew@nvidia.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v5] input: tegra-kbc - Add tegra keyboard driver
Message-ID: <20110118051328.GE23851@core.coreip.homeip.net>
References: <1294943248-18631-1-git-send-email-riyer@nvidia.com>
 <20110118051216.GD23851@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110118051216.GD23851@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 09:12:16PM -0800, Dmitry Torokhov wrote:
> On Thu, Jan 13, 2011 at 10:27:28AM -0800, riyer@nvidia.com wrote:
> > From: Rakesh Iyer <riyer@nvidia.com>
> > 
> > This patch adds support for the internal matrix keyboard controller for
> > Nvidia Tegra platforms.
> > 
> > Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
> > ---
> > Changes Done -
> > Wrap the users field check within the mutex.
> > Remove the KBC_MAX_KEYS define and use existing KBC_MAX_KEY.
> > Patch v4 was named incorrectly as PATCH 1/1, so skipping ahead to PATCH v5.
> > 
> 
> As I said, we should tty to reused definitions from matrix_keypad for
> matrix keypads. Does the following still work for you?
> 

And if it does then could you please try this one as well?

Thanks.

-- 
Dmitry

Input: tegra-kbc - convert to dev_pm_ops

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/tegra-kbc.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)


diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index a6ec3fc..c3c0c65 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -658,9 +658,10 @@ static int __devexit tegra_kbc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int tegra_kbc_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int tegra_kbc_suspend(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct tegra_kbc *kbc = platform_get_drvdata(pdev);
 
 	if (device_may_wakeup(&pdev->dev)) {
@@ -679,8 +680,9 @@ static int tegra_kbc_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int tegra_kbc_resume(struct platform_device *pdev)
+static int tegra_kbc_resume(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct tegra_kbc *kbc = platform_get_drvdata(pdev);
 	int err = 0;
 
@@ -698,17 +700,16 @@ static int tegra_kbc_resume(struct platform_device *pdev)
 }
 #endif
 
+static SIMPLE_DEV_PM_OPS(tegra_kbc_pm_ops, tegra_kbc_suspend, tegra_kbc_resume);
+
 static struct platform_driver tegra_kbc_driver = {
 	.probe		= tegra_kbc_probe,
 	.remove		= __devexit_p(tegra_kbc_remove),
-#ifdef CONFIG_PM
-	.suspend	= tegra_kbc_suspend,
-	.resume		= tegra_kbc_resume,
-#endif
 	.driver	= {
 		.name	= "tegra-kbc",
 		.owner  = THIS_MODULE,
-	}
+		.pm	= &tegra_kbc_pm_ops,
+	},
 };
 
 static void __exit tegra_kbc_exit(void)
