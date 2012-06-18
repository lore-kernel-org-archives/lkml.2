Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab2FREbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 00:31:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42220 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2FREbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 00:31:18 -0400
Date: Sun, 17 Jun 2012 21:29:28 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org, durgadoss.r@intel.com
Subject: Re: [PATCHv2] power_supply: Register battery as a thermal zone
Message-ID: <20120618042927.GA25372@lizard>
References: <1336576007-8772-1-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1336576007-8772-1-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 08:36:47PM +0530, Jenny TC wrote:
> Battery and charger contribute to Thermals in most of the embedded
> devices. So, it makes sense to identify them as Thermal zones in a
> particular platform.
> 
> This patch registers a thermal zone if the power supply is reporting
> a temperature property. The thermal zone will be used by platform's
> thermal management solution.
> 
> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> ---

Once again, thanks for the patch! It's a nice feature.

[...]
> @@ -206,6 +258,9 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
>  	goto success;
>  
>  create_triggers_failed:
> +	if (psy->tzd)
> +		thermal_zone_device_unregister(psy->tzd);

This causes errors:

  CC      drivers/power/pda_power.o
drivers/power/power_supply_core.c: In function ‘power_supply_register’:
drivers/power/power_supply_core.c:261:9: error: ‘struct power_supply’ has no member named ‘tzd’
drivers/power/power_supply_core.c:262:37: error: ‘struct power_supply’ has no member named ‘tzd’
make[2]: *** [drivers/power/power_supply_core.o] Error 1

I think we should just introduce unregister_thermal(). So, that's
what I've applied:

commit 3be330bf8860dc6079da5acc81295787a04cf4c9
Author: Jenny TC <jenny.tc@intel.com>
Date:   Wed May 9 20:36:47 2012 +0530

    power_supply: Register battery as a thermal zone
    
    Battery and charger contribute to Thermals in most of the embedded
    devices. So, it makes sense to identify them as Thermal zones in a
    particular platform.
    
    This patch registers a thermal zone if the power supply is reporting
    a temperature property. The thermal zone will be used by platform's
    thermal management solution.
    
    Signed-off-by: Jenny TC <jenny.tc@intel.com>
    Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 6ad6127..ff990d2 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -17,6 +17,7 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/power_supply.h>
+#include <linux/thermal.h>
 #include "power_supply.h"
 
 /* exported for the APM Power driver, APM emulation */
@@ -169,6 +170,63 @@ static void power_supply_dev_release(struct device *dev)
 	kfree(dev);
 }
 
+#ifdef CONFIG_THERMAL
+static int power_supply_read_temp(struct thermal_zone_device *tzd,
+		unsigned long *temp)
+{
+	struct power_supply *psy;
+	union power_supply_propval val;
+	int ret;
+
+	WARN_ON(tzd == NULL);
+	psy = tzd->devdata;
+	ret = psy->get_property(psy, POWER_SUPPLY_PROP_TEMP, &val);
+
+	/* Convert tenths of degree Celsius to milli degree Celsius. */
+	if (!ret)
+		*temp = val.intval * 100;
+
+	return ret;
+}
+
+static struct thermal_zone_device_ops psy_tzd_ops = {
+	.get_temp = power_supply_read_temp,
+};
+
+static int psy_register_thermal(struct power_supply *psy)
+{
+	int i;
+
+	/* Register battery zone device psy reports temperature */
+	for (i = 0; i < psy->num_properties; i++) {
+		if (psy->properties[i] == POWER_SUPPLY_PROP_TEMP) {
+			psy->tzd = thermal_zone_device_register(psy->name, 0,
+					psy, &psy_tzd_ops, 0, 0, 0, 0);
+			if (IS_ERR(psy->tzd))
+				return PTR_ERR(psy->tzd);
+			break;
+		}
+	}
+	return 0;
+}
+
+static void psy_unregister_thermal(struct power_supply *psy)
+{
+	if (IS_ERR_OR_NULL(psy->tzd))
+		return;
+	thermal_zone_device_unregister(psy->tzd);
+}
+#else
+static int psy_register_thermal(struct power_supply *psy)
+{
+	return 0;
+}
+
+static void psy_unregister_thermal(struct power_supply *psy)
+{
+}
+#endif
+
 int power_supply_register(struct device *parent, struct power_supply *psy)
 {
 	struct device *dev;
@@ -197,6 +255,10 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 	if (rc)
 		goto device_add_failed;
 
+	rc = psy_register_thermal(psy);
+	if (rc)
+		goto register_thermal_failed;
+
 	rc = power_supply_create_triggers(psy);
 	if (rc)
 		goto create_triggers_failed;
@@ -206,6 +268,8 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 	goto success;
 
 create_triggers_failed:
+	psy_unregister_thermal(psy);
+register_thermal_failed:
 	device_del(dev);
 kobject_set_name_failed:
 device_add_failed:
@@ -220,6 +284,7 @@ void power_supply_unregister(struct power_supply *psy)
 	cancel_work_sync(&psy->changed_work);
 	sysfs_remove_link(&psy->dev->kobj, "powers");
 	power_supply_remove_triggers(psy);
+	psy_unregister_thermal(psy);
 	device_unregister(psy->dev);
 }
 EXPORT_SYMBOL_GPL(power_supply_unregister);
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 3b912be..59ed2dd 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -173,6 +173,9 @@ struct power_supply {
 	/* private */
 	struct device *dev;
 	struct work_struct changed_work;
+#ifdef CONFIG_THERMAL
+	struct thermal_zone_device *tzd;
+#endif
 
 #ifdef CONFIG_LEDS_TRIGGERS
 	struct led_trigger *charging_full_trig;
