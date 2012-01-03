Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab2ACOKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 09:10:39 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34124 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab2ACOKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 09:10:36 -0500
Message-ID: <4F030C2D.3000808@ti.com>
Date: Tue, 3 Jan 2012 15:09:49 +0100
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>, <sameo@linux.intel.com>
CC: <rob.herring@calxeda.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-i2c@vger.kernel.org>,
        <ben-linux@fluff.org>, Balaji T K <balajitk@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH v4 03/12] mfd: twl-core: Add initial DT support for twl4030/twl6030
References: <1324565806-31142-1-git-send-email-b-cousson@ti.com> <1324565806-31142-4-git-send-email-b-cousson@ti.com> <20120102090454.GO18381@ponder.secretlab.ca>
In-Reply-To: <20120102090454.GO18381@ponder.secretlab.ca>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/2/2012 10:04 AM, Grant Likely wrote:
> On Thu, Dec 22, 2011 at 03:56:37PM +0100, Benoit Cousson wrote:
>> Add initial device-tree support for twl familly chips.
>> The current version is missing the regulator entries due
>> to the lack of DT regulator bindings for the moment.
>> Only the simple sub-modules that do not depend on
>> platform_data information can be initialized properly.
>>
>> Add irqdomain support.
>>
>> Add documentation for the Texas Instruments TWL Integrated Chip.
>>
>> Signed-off-by: Benoit Cousson<b-cousson@ti.com>
>> Cc: Balaji T K<balajitk@ti.com>
>> Cc: Graeme Gregory<gg@slimlogic.co.uk>
>> Cc: Samuel Ortiz<sameo@linux.intel.com>
>> ---
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index f1391c2..f0de088 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -200,6 +200,7 @@ config MENELAUS
>>   config TWL4030_CORE
>>   	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
>>   	depends on I2C=y&&  GENERIC_HARDIRQS
>> +	select IRQ_DOMAIN
> 
> As discussed on linux-next, this breaks powerpc.  Drivers cannot select
> IRQ_DOMAIN, it can only be selected by architectures.  Drivers must depend
> on it instead.

OK, good to know. The previous version was already breaking non-ARM platform because the IRQ_DOMAIN was not defined, hence this update.
I was able to check that this patch was fixing at least x86... but did not have any way to check the PPC build.

To be honest, I did not fully understand that this flag was there because some arch does not support IRQ domain yet and thus it should be selected at arch level.

Samuel,
Here is the updated version, and hopefully the last one, including Grant's fix.

Thanks,
Benoit

---
>From c213f7c905a1ec66f6d394db2f6ff4c1cd74b991 Mon Sep 17 00:00:00 2001
From: Benoit Cousson <b-cousson@ti.com>
Date: Mon, 29 Aug 2011 16:20:23 +0200
Subject: [PATCH v5 03/12] mfd: twl-core: Add initial DT support for twl4030/twl6030

Add initial device-tree support for twl familly chips.
The current version is missing the regulator entries due
to the lack of DT regulator bindings for the moment.
Only the simple sub-modules that do not depend on
platform_data information can be initialized properly.

Add irqdomain support.

Add documentation for the Texas Instruments TWL Integrated Chip.

Signed-off-by: Benoit Cousson <b-cousson@ti.com>
Cc: Balaji T K <balajitk@ti.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Acked-by: Rob Herring <rob.herring@calxeda.com>
[grant.likely@secretlab.ca: Fix IRQ_DOMAIN dependency in kconfig]
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 .../devicetree/bindings/mfd/twl-familly.txt        |   47 ++++++++++++++++++
 drivers/mfd/Kconfig                                |    2 +-
 drivers/mfd/twl-core.c                             |   51 +++++++++++++++++++-
 3 files changed, 98 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/twl-familly.txt

diff --git a/Documentation/devicetree/bindings/mfd/twl-familly.txt b/Documentation/devicetree/bindings/mfd/twl-familly.txt
new file mode 100644
index 0000000..ff4cacd
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/twl-familly.txt
@@ -0,0 +1,47 @@
+Texas Instruments TWL family
+
+The TWLs are Integrated Power Management Chips.
+Some version might contain much more analog function like
+USB transceiver or Audio amplifier.
+These chips are connected to an i2c bus.
+
+
+Required properties:
+- compatible : Must be "ti,twl4030";
+  For Integrated power-management/audio CODEC device used in OMAP3
+  based boards
+- compatible : Must be "ti,twl6030";
+  For Integrated power-management used in OMAP4 based boards
+- interrupts : This i2c device has an IRQ line connected to the main SoC
+- interrupt-controller : Since the twl support several interrupts internally,
+  it is considered as an interrupt controller cascaded to the SoC one.
+- #interrupt-cells = <1>;
+- interrupt-parent : The parent interrupt controller.
+
+Optional node:
+- Child nodes contain in the twl. The twl family is made of several variants
+  that support a different number of features.
+  The children nodes will thus depend of the capability of the variant.
+
+
+Example:
+/*
+ * Integrated Power Management Chip
+ * http://www.ti.com/lit/ds/symlink/twl6030.pdf
+ */
+twl@48 {
+    compatible = "ti,twl6030";
+    reg = <0x48>;
+    interrupts = <39>; /* IRQ_SYS_1N cascaded to gic */
+    interrupt-controller;
+    #interrupt-cells = <1>;
+    interrupt-parent = <&gic>;
+    #address-cells = <1>;
+    #size-cells = <0>;
+
+    twl_rtc {
+        compatible = "ti,twl_rtc";
+        interrupts = <11>;
+        reg = <0>;
+    };
+};
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index f1391c2..09fea20 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -199,7 +199,7 @@ config MENELAUS
 
 config TWL4030_CORE
 	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y && GENERIC_HARDIRQS && IRQ_DOMAIN
 	help
 	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.
 	  This core driver provides register access and IRQ handling
diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index bfbd660..698bf0d 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -34,6 +34,11 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/device.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/irqdomain.h>
 
 #include <linux/regulator/machine.h>
 
@@ -144,6 +149,9 @@
 
 #define TWL_MODULE_LAST TWL4030_MODULE_LAST
 
+#define TWL4030_NR_IRQS    8
+#define TWL6030_NR_IRQS    20
+
 /* Base Address defns for twl4030_map[] */
 
 /* subchip/slave 0 - USB ID */
@@ -255,6 +263,7 @@ struct twl_client {
 
 static struct twl_client twl_modules[TWL_NUM_SLAVES];
 
+static struct irq_domain domain;
 
 /* mapping the module id to slave id and base address */
 struct twl_mapping {
@@ -1183,14 +1192,48 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	int				status;
 	unsigned			i;
 	struct twl4030_platform_data	*pdata = client->dev.platform_data;
+	struct device_node		*node = client->dev.of_node;
 	u8 temp;
 	int ret = 0;
+	int nr_irqs = TWL4030_NR_IRQS;
+
+	if ((id->driver_data) & TWL6030_CLASS)
+		nr_irqs = TWL6030_NR_IRQS;
+
+	if (node && !pdata) {
+		/*
+		 * XXX: Temporary pdata until the information is correctly
+		 * retrieved by every TWL modules from DT.
+		 */
+		pdata = devm_kzalloc(&client->dev,
+				     sizeof(struct twl4030_platform_data),
+				     GFP_KERNEL);
+		if (!pdata)
+			return -ENOMEM;
+	}
 
 	if (!pdata) {
 		dev_dbg(&client->dev, "no platform data?\n");
 		return -EINVAL;
 	}
 
+	status = irq_alloc_descs(-1, pdata->irq_base, nr_irqs, 0);
+	if (IS_ERR_VALUE(status)) {
+		dev_err(&client->dev, "Fail to allocate IRQ descs\n");
+		return status;
+	}
+
+	pdata->irq_base = status;
+	pdata->irq_end = pdata->irq_base + nr_irqs;
+
+	domain.irq_base = pdata->irq_base;
+	domain.nr_irq = nr_irqs;
+#ifdef CONFIG_OF_IRQ
+	domain.of_node = of_node_get(node);
+	domain.ops = &irq_domain_simple_ops;
+#endif
+	irq_domain_add(&domain);
+
 	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C) == 0) {
 		dev_dbg(&client->dev, "can't talk I2C?\n");
 		return -EIO;
@@ -1270,7 +1313,13 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		twl_i2c_write_u8(TWL4030_MODULE_INTBR, temp, REG_GPPUPDCTR1);
 	}
 
-	status = add_children(pdata, id->driver_data);
+#ifdef CONFIG_OF_DEVICE
+	if (node)
+		status = of_platform_populate(node, NULL, NULL, &client->dev);
+	else
+#endif
+		status = add_children(pdata, id->driver_data);
+
 fail:
 	if (status < 0)
 		twl_remove(client);
-- 
1.7.0.4




 


