Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab1IVRvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:51:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44447 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1IVRvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:51:44 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, Colin Cross <ccross@google.com>,
        Olof Johansson <olof@lixom.net>, Erik Gilling <konkers@android.com>,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dilan Lee <dilee@nvidia.com>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH v2] i2c-tegra: Use the suspend_noirq/resume_noirq not suspend/resume
Date: Thu, 22 Sep 2011 11:51:32 -0600
Message-Id: <1316713892-357-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dilan Lee <dilee@nvidia.com>

Various drivers need to use the I2C bus during suspend. Generally, this
is already supported, since devices are suspended based on (the inverse of)
probe order, and an I2C-based device can't probe until the I2C bus upon
which it sits has been probed first.

However, some subsystems, notably ASoC, do not enjoy such simple bus/child
probing relationships. In particular, an ASoC machine driver (and hence a
sound card) may probe very early on before all its required resources are
available. After all required resources become available, the overall
machine driver initialization is performed. Suspend of a sound card occurs
based on the machine driver's probe timing, which may mean suspend occurs
after an I2C bus has been suspended. In turn, components within the sound
card suspend when the overall card suspends. If one of those components
is an I2C device, this may mean the device attempts to suspend after the
I2C bus it sits upon. Conversely, resume may occur before the I2C bus is
available. Consequently, I2C accesses during suspend/resume will fail.

This causes the following issue:

  We found the register settings of wm8903(an audio codec) can't be modified
  in snd_soc_suspend since I2C bus has been suspended before snd_soc_suspend.

  Pop noise will occur when system resume from LP0 if the register settings
  of wm8903 haven't be modified correctly in snd_soc_suspend.

To solve this, the I2C bus driver is modified to use suspend_noirq and
resume_noirq instead of suspend and resume. This delays the I2C bus suspend
until after the ASoC card-level suspend, and everything works.

It is acknowledged that this is not an ideal solution. However, this solution
is the best currently available within the kernel.

Suggested alternatives are:

* Implement an explicit dependency management system within the kernel for
  device suspend/resume, such that I2C bus would not be suspended before
  the sound card that requires it. It is reported that Linus rejected this
  proposal since he wanted suspend ordering to be based on probe ordering.

* Enhance device probing such that the ASoC sound card device could defer
  its probing until all required resources were available. This would
  then cause the overall sound card suspend to occur at an appropriate early
  time. Grant Likely was reported to have been working towards this goal.

[swarren: Rewrote patch description to reflect upstream discussion]

Signed-off-by: Dilan Lee <dilee@nvidia.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
v2: Summarized the email thread in patch description.
    Added Arnd/Mark's ack/review tags

 drivers/i2c/busses/i2c-tegra.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index b402435..15ad866 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -705,8 +705,9 @@ static int tegra_i2c_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int tegra_i2c_suspend(struct platform_device *pdev, pm_message_t state)
+static int tegra_i2c_suspend_noirq(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct tegra_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
 
 	i2c_lock_adapter(&i2c_dev->adapter);
@@ -716,8 +717,9 @@ static int tegra_i2c_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int tegra_i2c_resume(struct platform_device *pdev)
+static int tegra_i2c_resume_noirq(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct tegra_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
 	int ret;
 
@@ -736,6 +738,14 @@ static int tegra_i2c_resume(struct platform_device *pdev)
 
 	return 0;
 }
+
+static const struct dev_pm_ops tegra_i2c_dev_pm_ops = {
+	.suspend_noirq = tegra_i2c_suspend_noirq,
+	.resume_noirq = tegra_i2c_resume_noirq,
+};
+#define TEGRA_I2C_DEV_PM_OPS (&tegra_i2c_dev_pm_ops)
+#else
+#define TEGRA_I2C_DEV_PM_OPS NULL
 #endif
 
 #if defined(CONFIG_OF)
@@ -752,14 +762,11 @@ MODULE_DEVICE_TABLE(of, tegra_i2c_of_match);
 static struct platform_driver tegra_i2c_driver = {
 	.probe   = tegra_i2c_probe,
 	.remove  = tegra_i2c_remove,
-#ifdef CONFIG_PM
-	.suspend = tegra_i2c_suspend,
-	.resume  = tegra_i2c_resume,
-#endif
 	.driver  = {
 		.name  = "tegra-i2c",
 		.owner = THIS_MODULE,
 		.of_match_table = tegra_i2c_of_match,
+		.pm    = TEGRA_I2C_DEV_PM_OPS,
 	},
 };
 
-- 
1.7.0.4

