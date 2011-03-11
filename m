Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab1CKOpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 09:45:43 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59647 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab1CKOpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 09:45:40 -0500
MIME-Version: 1.0
In-Reply-To: <20110311122536.GG1760@opensource.wolfsonmicro.com>
References: <1299840868-20613-1-git-send-email-linus.walleij@stericsson.com>
	<20110311122536.GG1760@opensource.wolfsonmicro.com>
Date: Fri, 11 Mar 2011 15:45:39 +0100
Message-ID: <AANLkTim+woyefRXw83RxEDFLmbxHKc25MPa7XQB2_fxE@mail.gmail.com>
Subject: Re: [PATCH 1/4] regulator: add set_voltage_time[_sel] infrastructure
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 1:25 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Mar 11, 2011 at 11:54:28AM +0100, Linus Walleij wrote:
>
>> +     /* Don't obtain this if it's not going to be used */
>> +     if (rdev->desc->ops->set_voltage_time) {
>> +             int old_voltage = -1;
>> +
>> +             ret = _regulator_get_voltage(rdev);
>> +             if (ret < 0)
>> +                     return ret;
>> +             old_voltage = ret;
>> +             /* Here we can figure out desired delay immediately */
>> +             ret = rdev->desc->ops->set_voltage_time(rdev, old_voltage,
>> +                                                     min_uV, max_uV);
>
> I think this should be taking to as the argument rather than min and
> max.  We're going to figure out an actual concrete voltage or selector
> during the set voltage process so there's no point in having to go
> through and pick a specific voltage twice.  Actually, given that
> list_voltage() pretty much mandates selectors we can probably just only
> have a selector based version of this API then use the selector that got
> returned when we set the voltage.


So I remove some stuff and end up like this:

commit f33521d68746c0219d98e9b1f29b75966dabcbf2
Author: Linus Walleij <linus.walleij@linaro.org>
Date:   Fri Mar 11 11:24:43 2011 +0100

    regulator: add set_voltage_time_sel infrastructure

    This makes it possible to set the stabilization time for voltage
    regulators in the same manner as enable_time(). The interface
    only supports regulators that implements fixed selectors.

    Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9fa2095..569b198 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1629,6 +1629,7 @@ static int _regulator_do_set_voltage(struct
regulator_dev *rdev,
                                     int min_uV, int max_uV)
 {
        int ret;
+       int delay = 0;
        unsigned int selector;

        trace_regulator_set_voltage(rdev_get_name(rdev), min_uV, max_uV);
@@ -1662,6 +1663,22 @@ static int _regulator_do_set_voltage(struct
regulator_dev *rdev,
                        }
                }

+               /*
+                * If we can't obtain the old selector there is not enough
+                * info to call set_voltage_time_sel().
+                */
+               if (rdev->desc->ops->set_voltage_time_sel &&
+                   rdev->desc->ops->get_voltage_sel) {
+                       unsigned int old_selector = 0;
+
+                       ret = rdev->desc->ops->get_voltage_sel(rdev);
+                       if (ret < 0)
+                               return ret;
+                       old_selector = ret;
+                       delay = rdev->desc->ops->set_voltage_time_sel(rdev,
+                                               old_selector, selector);
+               }
+
                if (best_val != INT_MAX) {
                        ret = rdev->desc->ops->set_voltage_sel(rdev, selector);
                        selector = best_val;
@@ -1672,6 +1689,14 @@ static int _regulator_do_set_voltage(struct
regulator_dev *rdev,
                ret = -EINVAL;
        }

+       /* Insert any necessary delays */
+       if (delay >= 1000) {
+               mdelay(delay / 1000);
+               udelay(delay % 1000);
+       } else if (delay) {
+               udelay(delay);
+       }
+
        if (ret == 0)
                _notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE,
                                     NULL);
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index b8ed16a..6c433b8 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -63,7 +63,11 @@ enum regulator_status {
  *                    when running with the specified parameters.
  *
  * @enable_time: Time taken for the regulator voltage output voltage to
- *               stabalise after being enabled, in microseconds.
+ *               stabilise after being enabled, in microseconds.
+ * @set_voltage_time_sel: Time taken for the regulator voltage output voltage
+ *               to stabilise after being set to a new value, in microseconds.
+ *               The function provides the from and to voltage selector, the
+ *               function should return the worst case.
  *
  * @set_suspend_voltage: Set the voltage for the regulator when the system
  *                       is suspended.
@@ -103,8 +107,11 @@ struct regulator_ops {
        int (*set_mode) (struct regulator_dev *, unsigned int mode);
        unsigned int (*get_mode) (struct regulator_dev *);

-       /* Time taken to enable the regulator */
+       /* Time taken to enable or set voltage on the regulator */
        int (*enable_time) (struct regulator_dev *);
+       int (*set_voltage_time_sel) (struct regulator_dev *,
+                                    unsigned int old_selector,
+                                    unsigned int new_selector);

        /* report regulator status ... most other accessors report
         * control inputs, this reports results of combining inputs


(This is sufficient for us now anyway.)

> I also think we should be exporting this to consumers as things like
> cpufreq are interested in the latency for voltage changes.

Can we take that when we have a consumer that wants it? Looking
at it it becomes rather complex, since consumers don't know the
core-internal selectors, just discrete enumerated voltages, so these
have to be mapped back to selectors etc, that's pretty much ovehead
code that sits unused.

(If you insist, I will implement it.)

Linus Walleij
