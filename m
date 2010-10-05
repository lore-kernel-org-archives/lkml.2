Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab0JEWJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 18:09:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45826 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab0JEWJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 18:09:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rUoTI3pmVpgG248ci8W/q7Ff5Mcc+Y/GtVPfLyEpZb61GBIJ6clxoxSXHfHvzPTTwa
         XO9qSdIk2Pwj0sIzsebIPZ+Bmh8PUpB0bc/VnmLSg6xonbBeBWEKy8XD4GQz4Xw7RZtH
         QD0tCG5r746/0V4hX8OCq+w5YRY8oIrXeY0gU=
MIME-Version: 1.0
In-Reply-To: <20101005203508.7df590db@lxorguk.ukuu.org.uk>
References: <1280560182-7071-1-git-send-email-marek.vasut@gmail.com>
	<4C862EB3.4080006@compulab.co.il>
	<20100907125335.GD25830@sirena.org.uk>
	<201009091027.18176.marek.vasut@gmail.com>
	<20100909094120.GB1988@rakim.wolfsonmicro.main>
	<4CAACA63.6090202@compulab.co.il>
	<20101005161608.GD19730@core.coreip.homeip.net>
	<20101005164037.GA20555@opensource.wolfsonmicro.com>
	<20101005180703.GD21399@core.coreip.homeip.net>
	<20101005185942.GA22808@opensource.wolfsonmicro.com>
	<20101005203508.7df590db@lxorguk.ukuu.org.uk>
Date: Wed, 6 Oct 2010 00:09:39 +0200
Message-ID: <AANLkTimTW6v3N9aRA0h15SWXbBc_W0dhpf5rEeqBqGbf@mail.gmail.com>
Subject: Re: [PATCH v2] Input: Make ADS7846 independent on regulator
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-arm-kernel@lists.infradead.org, vapier@gentoo.org,
        khilman@deeprootsystems.com, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/5 Alan Cox <alan@lxorguk.ukuu.org.uk>:

> I actually see two ways of attacking that, one is that the dummy
> regulator *and* the compiled in regulator system have a standard
> regulator value that can be passed which means "report success, move
> along nothing to see" that could be passed into drivers,

Something like this patch series? If people like it I'll test it a bit
more and submit this 2-patch series.


From: Linus Walleij <linus.walleij@stericsson.com>
Date: Tue, 5 Oct 2010 23:23:47 +0200
Subject: [PATCH 1/2] regulator: add a relaxed regulor_try_get()

This wrapper function will accept non-existing regulators and
not treat them as errors. Consumers will have to NULL-check their
regulators.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 include/linux/regulator/consumer.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/include/linux/regulator/consumer.h
b/include/linux/regulator/consumer.h
index ebd7472..6ee7fdc 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -36,6 +36,7 @@
 #define __LINUX_REGULATOR_CONSUMER_H_

 #include <linux/device.h>
+#include <linux/err.h>

 /*
  * Regulator operating modes.
@@ -297,4 +298,23 @@ static inline void regulator_set_drvdata(struct
regulator *regulator,

 #endif

+/*
+ * Try to get a regulator, if it fails, no big deal.
+ * This wrapper function is intended to be used for code
+ * where regulator control is optional for the particular
+ * consumer, but still the regulator framework may be in
+ * use for other things in the platform.
+ */
+static inline struct regulator *regulator_try_get(struct device *dev,
+	const char *id)
+{
+	struct regulator *reg = regulator_get(dev, id);
+
+	/* It's just that this regulator is not (yet) defined */
+	if (IS_ERR(reg) && PTR_ERR(reg) == -ENODEV)
+		return NULL;
+
+	return reg;
+}
+
 #endif
-- 
1.7.2.3

From: Linus Walleij <linus.walleij@stericsson.com>
Date: Wed, 6 Oct 2010 00:04:25 +0200
Subject: [PATCH 2/2] regulator: handle NULL regulators in core

If the user has selected to use regulator_try_get() to fetch
regulators, we bail out of consumer operations if the regulator
happens to be NULL.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/regulator/core.c |   64 +++++++++++++++++++++++++++++++++++++++------
 1 files changed, 55 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cc8b337..989e4e4 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1337,9 +1337,12 @@ static int _regulator_enable(struct regulator_dev *rdev)
  */
 int regulator_enable(struct regulator *regulator)
 {
-	struct regulator_dev *rdev = regulator->rdev;
+	struct regulator_dev *rdev;
 	int ret = 0;

+	if (regulator == NULL)
+		return 0;
+	rdev = regulator->rdev;
 	mutex_lock(&rdev->mutex);
 	ret = _regulator_enable(rdev);
 	mutex_unlock(&rdev->mutex);
@@ -1406,9 +1409,12 @@ static int _regulator_disable(struct regulator_dev *rdev)
  */
 int regulator_disable(struct regulator *regulator)
 {
-	struct regulator_dev *rdev = regulator->rdev;
+	struct regulator_dev *rdev;
 	int ret = 0;

+	if (regulator == NULL)
+		return 0;
+	rdev = regulator->rdev;
 	mutex_lock(&rdev->mutex);
 	ret = _regulator_disable(rdev);
 	mutex_unlock(&rdev->mutex);
@@ -1456,6 +1462,8 @@ int regulator_force_disable(struct regulator *regulator)
 {
 	int ret;

+	if (regulator == NULL)
+		return 0;
 	mutex_lock(&regulator->rdev->mutex);
 	regulator->uA_load = 0;
 	ret = _regulator_force_disable(regulator->rdev);
@@ -1489,6 +1497,8 @@ int regulator_is_enabled(struct regulator *regulator)
 {
 	int ret;

+	if (regulator == NULL)
+		return 1;
 	mutex_lock(&regulator->rdev->mutex);
 	ret = _regulator_is_enabled(regulator->rdev);
 	mutex_unlock(&regulator->rdev->mutex);
@@ -1507,8 +1517,11 @@ EXPORT_SYMBOL_GPL(regulator_is_enabled);
  */
 int regulator_count_voltages(struct regulator *regulator)
 {
-	struct regulator_dev	*rdev = regulator->rdev;
+	struct regulator_dev	*rdev;

+	if (regulator == NULL)
+		return 0;
+	rdev = regulator->rdev;
 	return rdev->desc->n_voltages ? : -EINVAL;
 }
 EXPORT_SYMBOL_GPL(regulator_count_voltages);
@@ -1525,10 +1538,15 @@ EXPORT_SYMBOL_GPL(regulator_count_voltages);
  */
 int regulator_list_voltage(struct regulator *regulator, unsigned selector)
 {
-	struct regulator_dev	*rdev = regulator->rdev;
-	struct regulator_ops	*ops = rdev->desc->ops;
+	struct regulator_dev	*rdev;
+	struct regulator_ops	*ops;
 	int			ret;

+	if (regulator == NULL)
+		return 0;
+	rdev = regulator->rdev;
+	ops = rdev->desc->ops;
+
 	if (!ops->list_voltage || selector >= rdev->desc->n_voltages)
 		return -EINVAL;

@@ -1561,6 +1579,8 @@ int regulator_is_supported_voltage(struct
regulator *regulator,
 {
 	int i, voltages, ret;

+	if (regulator == NULL)
+		return 0;
 	ret = regulator_count_voltages(regulator);
 	if (ret < 0)
 		return ret;
@@ -1596,9 +1616,12 @@ int regulator_is_supported_voltage(struct
regulator *regulator,
  */
 int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 {
-	struct regulator_dev *rdev = regulator->rdev;
+	struct regulator_dev *rdev;
 	int ret;

+	if (regulator == NULL)
+		return 0;
+	rdev = regulator->rdev;
 	mutex_lock(&rdev->mutex);

 	/* sanity check */
@@ -1644,6 +1667,9 @@ int regulator_get_voltage(struct regulator *regulator)
 {
 	int ret;

+	if (regulator == NULL)
+		return 0;
+
 	mutex_lock(&regulator->rdev->mutex);

 	ret = _regulator_get_voltage(regulator->rdev);
@@ -1673,9 +1699,13 @@ EXPORT_SYMBOL_GPL(regulator_get_voltage);
 int regulator_set_current_limit(struct regulator *regulator,
 			       int min_uA, int max_uA)
 {
-	struct regulator_dev *rdev = regulator->rdev;
+	struct regulator_dev *rdev;
 	int ret;

+	if (regulator == NULL)
+		return 0;
+	rdev = regulator->rdev;
+
 	mutex_lock(&rdev->mutex);

 	/* sanity check */
@@ -1725,6 +1755,8 @@ out:
  */
 int regulator_get_current_limit(struct regulator *regulator)
 {
+	if (regulator == NULL)
+		return 0;
 	return _regulator_get_current_limit(regulator->rdev);
 }
 EXPORT_SYMBOL_GPL(regulator_get_current_limit);
@@ -1742,10 +1774,14 @@ EXPORT_SYMBOL_GPL(regulator_get_current_limit);
  */
 int regulator_set_mode(struct regulator *regulator, unsigned int mode)
 {
-	struct regulator_dev *rdev = regulator->rdev;
+	struct regulator_dev *rdev;
 	int ret;
 	int regulator_curr_mode;

+	if (regulator == NULL)
+		return 0;
+	rdev = regulator->rdev;
+
 	mutex_lock(&rdev->mutex);

 	/* sanity check */
@@ -1801,6 +1837,8 @@ out:
  */
 unsigned int regulator_get_mode(struct regulator *regulator)
 {
+	if (regulator == NULL)
+		return REGULATOR_MODE_NORMAL;
 	return _regulator_get_mode(regulator->rdev);
 }
 EXPORT_SYMBOL_GPL(regulator_get_mode);
@@ -1833,11 +1871,15 @@ EXPORT_SYMBOL_GPL(regulator_get_mode);
  */
 int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 {
-	struct regulator_dev *rdev = regulator->rdev;
+	struct regulator_dev *rdev;
 	struct regulator *consumer;
 	int ret, output_uV, input_uV, total_uA_load = 0;
 	unsigned int mode;

+	if (regulator == NULL)
+		return REGULATOR_MODE_NORMAL;
+	rdev = regulator->rdev;
+
 	mutex_lock(&rdev->mutex);

 	regulator->uA_load = uA_load;
@@ -1907,6 +1949,8 @@ EXPORT_SYMBOL_GPL(regulator_set_optimum_mode);
 int regulator_register_notifier(struct regulator *regulator,
 			      struct notifier_block *nb)
 {
+	if (regulator == NULL)
+		return 0;
 	return blocking_notifier_chain_register(&regulator->rdev->notifier,
 						nb);
 }
@@ -1922,6 +1966,8 @@ EXPORT_SYMBOL_GPL(regulator_register_notifier);
 int regulator_unregister_notifier(struct regulator *regulator,
 				struct notifier_block *nb)
 {
+	if (regulator == NULL)
+		return 0;
 	return blocking_notifier_chain_unregister(&regulator->rdev->notifier,
 						  nb);
 }
-- 
1.7.2.3

Yours,
Linus Walleij
