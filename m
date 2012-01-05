Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab2AENru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 08:47:50 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45338 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2AENrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 08:47:49 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
	<1324402840-32451-3-git-send-email-b29396@freescale.com>
	<74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
	<7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
	<74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
Date: Thu, 5 Jan 2012 21:47:48 +0800
Message-ID: <CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux mappings
From: Dong Aisheng <dongas86@gmail.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Sun, Dec 25, 2011 at 11:37 AM, Stephen Warren <swarren@nvidia.com> wrote:
> Dong Aisheng-B29396 wrote at Thursday, December 22, 2011 1:18 AM:
> ...
>> Up to here I understand that your propose is co-locate pinmux Resource within device
>> Node definitions and define pinmux maps in the iomuxc device node.
>> (If I understand wrongly, please let me know)
>> It's just like:
>> Sdhci1: sdhci@1000 {
>>     compatible = "...";
>>     regs = <...>;
>>     pinmux = <&pmx>;
>>     pinmux-usage = {
>>         // Some representation of the pins/groups/functions used
>>         // by just this HW block.
>>     };
>> };
>>
>> iomuxc@020e0000 {
>>     compatible = "fsl,imx6-pinmux";
>>     usage {
>>         sd4 {
>>             dev = <&sdhci1>;
>>         };
>>         sd3 {
>>             dev = <&sdhci2>;
>>         };
>>         ...
>>     };
>> };
>> My concern is that would pass the effort to each driver to handle pinmux-usage.
>
> See a little above for what I was thinking.
>
> That said, we could  probably handle a standardized pinmux-usage property
> in each driver without impacting each driver too much; it's just that the
> core driver code, or the pinctrl code, would have to scan all device nodes
> for this property and act on it, rather than the drivers for each node,
> rather like regs/interrupts are handled by core code and converted to
> device resources.
>
> ...
>> The same question applies to clock and regulator: does each device need
>> Define its clock and regulator properties?
>
> Yes, in those cases I believe each device does contain a phandle to the
> resources it uses.
>

I tried this way that each device node contains a phandle named
'pinmux' pointing
to a specific pinmux function. When the device calling pinmux_get we will
find the pinmux function and its pinctrl device via this phandle, then
we can construct
a pinmux map to use for this device.
Then we do not need define pinmux map table in dts file any more.
This looks better than before from hw point of vew in define device nodes.

I paste the initial patch here for your review to see if it's ok.
However there're still two issues:
1) since we still do not have a standardized pinmux function
definition(it looks not easy to define since it varies on different
platforms and pinctrl core also does not require a standardized
function, not sure if we should define one)
we can not get pin group info via dt in a standardized way for
construct pinmux map.
That means we do not support parsing multi pin groups for one function from dt.
However it will not affect the function in most case since board dts
file usually know which pin group for which function and usually one
pin group are defined.
I still do not see if any requirement of multi pin groups are needed via dt.
2) we still do not support hog_on_boot due to we do not have pinmux
map tables in dt and it varies a bit
on the using from non-dt platform,
I'm still trying to figuring out a way to cover this issue.
If you have any good suggestion please let me know.

>From 651113ff5909cd054396e97f25f386f846046a55 Mon Sep 17 00:00:00 2001
From: Dong Aisheng <b29396@freescale.com>
Date: Thu, 5 Jan 2012 21:11:08 +0800
Subject: [PATCH 1/1] pinctrl: add dt binding support for pinmux mappings

Since dt already has the pinmux map information in dts file, it does
not have a pinmux maps table registered in machine code as non-dt
platfrom does. Instead, it will create a pinmux map for each device
dynamically by parsing the device node when calling pinmux_get.

To support this, each device wanting to use a pinmux function should
define a phandle named 'pinmux' pointing to a specific pinmux function
under its device node. And the pinmux function nodes should be defined
under the pinctrl device it belongs to.

The pinmux core will use this phandle to find the pinmux function
name and the pinctrl device this function belongs to to construct
a pinmux map for this device to use.

The constraints are that we still do not support parsing multi groups
for a function via dt, that means only first group will be used.
Usually this does not affect the pinmux to work well via dt since the
board dts file knows which pin group for which function and we do not
need to define more than one useless groups for that function.

Another constraint is that we still do not support hog_on_boot via dt
since dt does not have a pinmux map table and we need to create it
dynamically. We still need to find a good way to cover this issue.

Signed-off-by: Dong Aisheng <b29396@freescale.com>
---
 .../devicetree/bindings/pinctrl/pinctrl.txt        |   49 ++++++++++++++
 arch/arm/boot/dts/imx6q-sabreauto.dts              |   24 +++++++
 drivers/pinctrl/core.c                             |   69 ++++++++++++++++++++
 drivers/pinctrl/core.h                             |    2 +
 drivers/pinctrl/pinmux.c                           |   27 +++++++-
 5 files changed, 169 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl.txt
b/Documentation/devicetree/bindings/pinctrl/pinctrl.txt
new file mode 100644
index 0000000..013e733
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl.txt
@@ -0,0 +1,49 @@
+The pin control subsystem
+
+The pin control subsystem supports parsing pinmux map from device tree.
+To support this, each device wanting to use a pinmux function should
+define a phandle named 'pinmux' pointing to a specific pinmux function
+under its device node. And the pinmux function nodes should be defined
+under the pinctrl device it belongs to.
+
+The pinmux core will use this phandle to find the pinmux function
+name and the pinctrl device this function belongs to to construct
+a pinmux map for this device to use.
+
+Examples:
+soc {
+	aips-bus@02000000 { /* AIPS1 */
+		iomuxc@020e0000 {
+			pinctrl_uart4: uart4 {
+				func-name = "uart4";
+				grp-name = "uart4grp";
+				grp-pins = <107 108>;
+				num-pins = <2>;
+				grp-mux = <4 4>;
+				num-mux = <2>;
+			};
+
+			pinctrl_sd4: sd4 {
+				func-name = "sd4";
+				grp-name = "sd4grp";
+				grp-pins = <170 171 180 181 182 183 184 185 186 187>;
+				num-pins = <10>;
+				grp-mux = <0 0 1 1 1 1 1 1 1 1>;
+				num-mux = <10>;
+			};
+		};
+	};
+
+	aips-bus@02100000 { /* AIPS2 */
+		usdhc@0219c000 { /* uSDHC4 */
+			fsl,card-wired;
+			status = "okay";
+			pinmux = <&pinctrl_sd4>;
+		};
+
+		uart3: uart@021f0000 { /* UART4 */
+			status = "okay";
+			pinmux = <&pinctrl_uart4>;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/imx6q-sabreauto.dts
b/arch/arm/boot/dts/imx6q-sabreauto.dts
index 072974e..0863b1d 100644
--- a/arch/arm/boot/dts/imx6q-sabreauto.dts
+++ b/arch/arm/boot/dts/imx6q-sabreauto.dts
@@ -26,6 +26,28 @@
 	};

 	soc {
+		aips-bus@02000000 { /* AIPS1 */
+			iomuxc@020e0000 {
+				pinctrl_uart4: uart4 {
+					func-name = "uart4";
+					grp-name = "uart4grp";
+					grp-pins = <107 108>;
+					num-pins = <2>;
+					grp-mux = <4 4>;
+					num-mux = <2>;
+				};
+
+				pinctrl_sd4: sd4 {
+					func-name = "sd4";
+					grp-name = "sd4grp";
+					grp-pins = <170 171 180 181 182 183 184 185 186 187>;
+					num-pins = <10>;
+					grp-mux = <0 0 1 1 1 1 1 1 1 1>;
+					num-mux = <10>;
+				};
+			};
+		};
+
 		aips-bus@02100000 { /* AIPS2 */
 			enet@02188000 {
 				phy-mode = "rgmii";
@@ -42,10 +64,12 @@
 			usdhc@0219c000 { /* uSDHC4 */
 				fsl,card-wired;
 				status = "okay";
+				pinmux = <&pinctrl_sd4>;
 			};

 			uart3: uart@021f0000 { /* UART4 */
 				status = "okay";
+				pinmux = <&pinctrl_uart4>;
 			};
 		};
 	};
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 39f393b..09de5fa 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -20,6 +20,7 @@
 #include <linux/err.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/of_device.h>
 #include <linux/spinlock.h>
 #include <linux/sysfs.h>
 #include <linux/debugfs.h>
@@ -48,6 +49,74 @@ void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev)
 EXPORT_SYMBOL_GPL(pinctrl_dev_get_drvdata);

 /**
+ * of_get_pinctrl_dev_from_dev() - look up pin controller device via dt
+ * @dev: a device pointer
+ * @map: the pinmux map returned
+ *
+ * Looks up a pin control device matching a certain device name and return
+ * a pinmux map constructed from dt info.
+ */
+struct pinctrl_dev *of_get_pinctrl_dev_from_dev(struct device *dev,
+						struct pinmux_map **map)
+{
+	struct pinctrl_dev *pctldev = NULL;
+	struct device_node *pinmux_np;
+	struct device_node *pinctrl_np;
+	struct pinmux_map *p;
+	bool found = false;
+	char str[16];
+
+	if (!dev || !dev->of_node)
+		return NULL;
+
+	dev_dbg(dev, "find pinctrl dev and pinmux map from device tree\n");
+
+	pinmux_np = of_parse_phandle(dev->of_node, "pinmux", 0);
+	if (!pinmux_np) {
+		dev_err(dev, "unable to get the phandle pinmux\n");
+		return NULL;
+	}
+
+	/* pinmux function nodes should be subnodes of pinctrl device */
+	pinctrl_np = of_get_parent(pinmux_np);
+	if (!pinctrl_np)
+		return NULL;
+
+	mutex_lock(&pinctrldev_list_mutex);
+	list_for_each_entry(pctldev, &pinctrldev_list, node) {
+		if (pctldev->dev->of_node == pinctrl_np) {
+			found = true;
+			break;
+		}
+	}
+	mutex_unlock(&pinctrldev_list_mutex);
+
+	if (found) {
+		/*
+		 * construct a pinmux map from device tree for this device
+		 * Note: for dt we do not specify the pin group, instead we
+		 * use the first group as default.
+		 */
+		p = devm_kzalloc(dev, sizeof(struct pinmux_map), GFP_KERNEL);
+		if (!p)
+			return NULL;
+		*map = p;
+		snprintf(str, 15, "map_%s", pinmux_np->name);
+		p->name = kstrdup(str, GFP_KERNEL);
+		if (!p->name)
+			return NULL;
+		p->function = pinmux_np->name;
+		p->ctrl_dev = pctldev->dev;
+		p->dev = dev;
+		dev_dbg(dev, "found pinctrl: %s  map: %s function %s dev %s\n",
+			dev_name(p->ctrl_dev), p->name,
+			p->function, dev_name(dev));
+	}
+
+	return found ? pctldev : NULL;
+}
+
+/**
  * get_pinctrl_dev_from_dev() - look up pin controller device
  * @dev: a device pointer, this may be NULL but then devname needs to be
  *	defined instead
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 5375582..6077508 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -69,6 +69,8 @@ struct pin_desc {

 struct pinctrl_dev *get_pinctrl_dev_from_dev(struct device *dev,
 					     const char *dev_name);
+struct pinctrl_dev *of_get_pinctrl_dev_from_dev(struct device *dev,
+						struct pinmux_map **map);
 struct pin_desc *pin_desc_get(struct pinctrl_dev *pctldev, unsigned int pin);
 int pin_get_from_name(struct pinctrl_dev *pctldev, const char *name);
 int pinctrl_get_device_gpio_range(unsigned gpio,
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 432feb6..cc1b32a 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -20,6 +20,7 @@
 #include <linux/err.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/of_device.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/sysfs.h>
@@ -696,7 +697,7 @@ static void pinmux_free_groups(struct pinmux *pmx)
 struct pinmux *pinmux_get(struct device *dev, const char *name)
 {

-	struct pinmux_map const *map = NULL;
+	struct pinmux_map *map = NULL;
 	struct pinctrl_dev *pctldev = NULL;
 	const char *devname = NULL;
 	struct pinmux *pmx;
@@ -727,7 +728,29 @@ struct pinmux *pinmux_get(struct device *dev,
const char *name)
 	pmx->func_selector = UINT_MAX;
 	INIT_LIST_HEAD(&pmx->groups);

-	/* Iterate over the pinmux maps to locate the right ones */
+	/*
+	 * do a dt based lookup first to see if we can find a pinctrl device
+	 * and a pinmux map for a specific device. If not found fallback
+	 * to search the pinmux_maps as before.
+	 */
+	pctldev = of_get_pinctrl_dev_from_dev(dev, &map);
+	if (pctldev) {
+		ret = pinmux_enable_muxmap(pctldev, pmx, dev,
+					   devname, map);
+		if (ret) {
+			pinmux_free_groups(pmx);
+			kfree(pmx);
+			return ERR_PTR(ret);
+		}
+		num_maps++;
+	}
+
+	/*
+	 * Iterate over the pinmux maps to locate the right ones
+	 * Note: if we're using dt binding, we do not have a predefined pinmux
+	 * maps table registered in machine code as non-dt platfrom does.
+	 * Then, pinmux_maps_num is 0 by default.
+	 */
 	for (i = 0; i < pinmux_maps_num; i++) {
 		map = &pinmux_maps[i];
 		found_map = false;
-- 
1.7.0.4


Regards
Dong Aisheng
