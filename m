Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab2JSJFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:05:09 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5815 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2JSJFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:05:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 19 Oct 2012 02:05:01 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Leela Krishna Amudala <l.krishna@samsung.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-pm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v7 1/3] Runtime Interpreted Power Sequences
Date: Fri, 19 Oct 2012 18:06:27 +0900
Message-ID: <1350637589-7405-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350637589-7405-1-git-send-email-acourbot@nvidia.com>
References: <1350637589-7405-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some device drivers (e.g. panel backlights ) need to follow precise
sequences for powering on and off, involving GPIOs, regulators, PWMs
with a precise powering order and delays to respect between each steps.
These sequences are device-specific, and do not belong to a particular
driver - therefore they have been performed by board-specific hook
functions to far.

With the advent of the device tree and of ARM kernels that are not
board-tied, we cannot rely on these board-specific hooks anymore but
need a way to implement these sequences in a portable manner. This patch
introduces a simple interpreter that can execute such power sequences
encoded either as platform data or within the device tree.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 .../devicetree/bindings/power/power_seq.txt        | 121 +++++++
 Documentation/power/power_seq.txt                  | 253 ++++++++++++++
 drivers/power/Kconfig                              |   1 +
 drivers/power/Makefile                             |   1 +
 drivers/power/power_seq/Kconfig                    |   2 +
 drivers/power/power_seq/Makefile                   |   1 +
 drivers/power/power_seq/power_seq.c                | 376 +++++++++++++++++++++
 drivers/power/power_seq/power_seq_delay.c          |  65 ++++
 drivers/power/power_seq/power_seq_gpio.c           |  94 ++++++
 drivers/power/power_seq/power_seq_pwm.c            |  82 +++++
 drivers/power/power_seq/power_seq_regulator.c      |  83 +++++
 include/linux/power_seq.h                          | 203 +++++++++++
 12 files changed, 1282 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/power_seq.txt
 create mode 100644 Documentation/power/power_seq.txt
 create mode 100644 drivers/power/power_seq/Kconfig
 create mode 100644 drivers/power/power_seq/Makefile
 create mode 100644 drivers/power/power_seq/power_seq.c
 create mode 100644 drivers/power/power_seq/power_seq_delay.c
 create mode 100644 drivers/power/power_seq/power_seq_gpio.c
 create mode 100644 drivers/power/power_seq/power_seq_pwm.c
 create mode 100644 drivers/power/power_seq/power_seq_regulator.c
 create mode 100644 include/linux/power_seq.h

diff --git a/Documentation/devicetree/bindings/power/power_seq.txt b/Documentation/devicetree/bindings/power/power_seq.txt
new file mode 100644
index 0000000..7880a6c
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/power_seq.txt
@@ -0,0 +1,121 @@
+Runtime Interpreted Power Sequences
+===================================
+
+Power sequences are sequential descriptions of actions to be performed on
+power-related resources. Having these descriptions in a well-defined data format
+allows us to take much of the board- or device- specific power control code out
+of the kernel and place it into the device tree instead, making kernels less
+board-dependant.
+
+A device typically makes use of multiple power sequences, for different purposes
+such as powering on and off. All the power sequences of a given device are
+grouped into a set. In the device tree, this set is a sub-node of the device
+node named "power-sequences".
+
+Power Sequences Structure
+-------------------------
+Every device that makes use of power sequences must have a "power-sequences"
+node into which individual power sequences are declared as sub-nodes. The name
+of the node becomes the name of the sequence within the power sequences
+framework.
+
+Similarly, each power sequence declares its steps as sub-nodes of itself. Steps
+must be named sequentially, with the first step named step0, the second step1,
+etc. Failure to follow this rule will result in a parsing error.
+
+Power Sequences Steps
+---------------------
+Steps of a sequence describe an action to be performed on a resource. They
+always include a "type" property which indicates what kind of resource this
+step works on. Depending on the resource type, additional properties are defined
+to control the action to be performed.
+
+"delay" type required properties:
+  - delay: delay to wait (in microseconds)
+
+"regulator" type required properties:
+  - id: name of the regulator to use.
+  - enable / disable: one of these two empty properties must be present to
+                      enable or disable the resource
+
+"pwm" type required properties:
+  - id: name of the PWM to use.
+  - enable / disable: one of these two empty properties must be present to
+                      enable or disable the resource
+
+"gpio" type required properties:
+  - gpio: phandle of the GPIO to use.
+  - value: value this GPIO should take. Must be 0 or 1.
+
+Example
+-------
+Here are example sequences declared within a backlight device that use all the
+supported resources types:
+
+	backlight {
+		compatible = "pwm-backlight";
+		...
+
+		/* resources used by the power sequences */
+		pwms = <&pwm 2 5000000>;
+		pwm-names = "backlight";
+		power-supply = <&backlight_reg>;
+
+		power-sequences {
+			power-on {
+				step0 {
+					type = "regulator";
+					id = "power";
+					enable;
+				};
+				step1 {
+					type = "delay";
+					delay = <10000>;
+				};
+				step2 {
+					type = "pwm";
+					id = "backlight";
+					enable;
+				};
+				step3 {
+					type = "gpio";
+					gpio = <&gpio 28 0>;
+					value = <1>;
+				};
+			};
+
+			power-off {
+				step0 {
+					type = "gpio";
+					gpio = <&gpio 28 0>;
+					value = <0>;
+				};
+				step1 {
+					type = "pwm";
+					id = "backlight";
+					disable;
+				};
+				step2 {
+					type = "delay";
+					delay = <10000>;
+				};
+				step3 {
+					type = "regulator";
+					id = "power";
+					disable;
+				};
+			};
+		};
+	};
+
+The first part lists the PWM and regulator resources used by the sequences.
+These resources will be requested on behalf of the backlight device when the
+sequences are built and are declared according to their own bindings (for
+instance, regulators and pwms are resolved by name - note though that name
+declaration is done differently by the two frameworks).
+
+After the resources declaration, two sequences follow for powering the backlight
+on and off. Their names are specified by the pwm-backlight device bindings. Once
+the sequences are built by calling devm_of_parse_power_seq_set() on the
+backlight device, they can be added to a set using
+power_seq_set_add_sequences().
diff --git a/Documentation/power/power_seq.txt b/Documentation/power/power_seq.txt
new file mode 100644
index 0000000..8be0570
--- /dev/null
+++ b/Documentation/power/power_seq.txt
@@ -0,0 +1,253 @@
+Runtime Interpreted Power Sequences
+===================================
+
+Problem
+-------
+Very commonly, boards need the help of out-of-driver code to turn some of their
+devices on and off. For instance, SoC boards might use a GPIO (abstracted to a
+regulator or not) to control the power supply of a backlight. The GPIO that
+should be used, however, as well as the exact power sequence that may also
+involve other resources, is board-dependent and thus unknown to the driver.
+
+This was previously addressed by having hooks in the device's platform data that
+are called whenever the state of the device might need a power status change.
+This approach, however, introduces board-dependant code into the kernel and is
+not compatible with the device tree.
+
+The Runtime Interpreted Power Sequences (or power sequences for short) aim at
+turning this code into platform data or device tree nodes. Power sequences are
+described using a simple format and run by a lightweight interpreter whenever
+needed. This allows device drivers to work without power callbacks and makes the
+kernel less board-dependant.
+
+What are Power Sequences?
+-------------------------
+A power sequence is an array of sequential steps describing an action to be
+performed on a resource. The supported resources and actions operations are:
+- delay (just wait for a given number of microseconds)
+- GPIO (set to 0 or 1)
+- regulator (enable or disable)
+- PWM (enable or disable)
+
+When a power sequence is run, its steps is executed one after the other until
+one step fails or the end of the sequence is reached.
+
+Power sequences are named, and grouped into "sets" which contain all the
+sequences of a device as well as the resources they use.
+
+Power sequences can be declared as platform data or in the device tree.
+
+Platform Data Format
+--------------------
+All relevant data structures for declaring power sequences are located in
+include/linux/power_seq.h.
+
+The platform data for a device may include an instance of platform_power_seq_set
+which references all the power sequences used for a device. The power sequences
+reference resources in their steps, and setup the union member that corresponds
+to the resource's type. Resources, similarly, have a union which relevant member
+depends on their type.
+
+Note that the only "platform data" per se here is platform_power_seq_set. Other
+structures (power_seq and power_seq_resource) will be used at runtime and thus
+*must* survive initialization, so do not declare them with the __initdata
+attribute.
+
+The following example should make it clear how the platform data for power
+sequences is defined. It declares two power sequences named "power-on" and
+"power-off" for a backlight device. The "power-on" sequence enables the "power"
+regulator of the device, waits for 10ms, and then enables PWM "backlight" and
+set GPIO 28 to 1. "power-off" does the opposite.
+
+struct power_seq_resource reg_res = {
+	.type = POWER_SEQ_REGULATOR,
+	.regulator.id = "power",
+};
+
+struct power_seq_resource gpio_res = {
+	.type = POWER_SEQ_GPIO,
+	.gpio.gpio = 28,
+};
+
+struct power_seq_resource pwm_res = {
+	.type = POWER_SEQ_PWM,
+	.pwm.id = "backlight",
+};
+
+struct power_seq_resource delay_res = {
+	.type = POWER_SEQ_DELAY,
+};
+
+struct power_seq power_on_seq = {
+	.id = "power-on",
+	.num_steps = 4,
+	.steps = {
+		{
+			.resource = &reg_res,
+			.regulator.enable = true,
+		}, {
+			.resource = &delay_res,
+			.delay.delay = 10000,
+		}, {
+			.resource = &pwm_res,
+			.pwm.enable = true,
+		}, {
+			.resource = &gpio_res,
+			.gpio.value = 1,
+		},
+	},
+};
+
+struct power_seq power_off_seq = {
+	.id = "power-off",
+	.num_steps = 4,
+	.steps = {
+		{
+			.resource = &gpio_res,
+			.gpio.value = 0,
+		}, {
+			.resource = &pwm_res,
+			.pwm.enable = false,
+		}, {
+			.resource = &delay_res,
+			.delay.delay = 10000,
+		}, {
+			.resource = &reg_res,
+			.regulator.enable = false,
+		},
+	},
+};
+
+struct platform_power_seq_set backlight_power_seqs __initdata = {
+	.num_seqs = 2,
+	.seqs = {
+		&power_on_seq,
+		&power_off_seq,
+	},
+};
+
+"backlight_power_seqs" can then be passed to power_seq_set_add_sequences() in
+order to add the sequences to a set and allocate all the necessary resources.
+More on this later in this document.
+
+Device Tree
+-----------
+Power sequences can also be encoded as device tree nodes. The following
+properties and nodes are equivalent to the platform data defined previously:
+
+pwms = <&pwm 2 5000000>;
+pwm-names = "backlight";
+power-supply = <&vdd_bl_reg>;
+
+power-sequences {
+	power-on {
+		step0 {
+			type = "regulator";
+			id = "power";
+			enable;
+		};
+		step1 {
+			type = "delay";
+			delay = <10000>;
+		};
+		step2 {
+			type = "pwm";
+			id = "backlight";
+			enable;
+		};
+		step3 {
+			type = "gpio";
+			gpio = <&gpio 28 0>;
+			value = <1>;
+		};
+	};
+
+	power-off {
+		step0 {
+			type = "gpio";
+			gpio = <&gpio 28 0>;
+			value = <0>;
+		};
+		step1 {
+			type = "pwm";
+			id = "backlight";
+			disable;
+		};
+		step2 {
+			type = "delay";
+			delay = <10000>;
+		};
+		step3 {
+			type = "regulator";
+			id = "power";
+			disable;
+		};
+	};
+};
+
+See Documentation/devicetree/bindings/power/power_seq.txt for the complete
+syntax of the DT bindings.
+
+Use by Drivers and Resources Management
+---------------------------------------
+Power sequences make use of resources that must be properly allocated and
+managed. The power_seq_set structure manages the sequences and resources for a
+particular device. A driver willing to use power sequences will thus declare one
+instance of power_seq_set per device and initialize it at probe time:
+
+struct my_device_data {
+	struct device *dev;
+	...
+	struct power_set_set power_seqs;
+	...
+};
+
+power_seq_set_init(&my_device->power_seqs, my_device->dev);
+
+The power_seq_set_add_sequence() and power_seq_set_add_sequences() functions are
+then used to add one or several sequences to a set. These functions will also
+allocate all the resources used by the sequence(s) and make sure they are ready
+to be run. All resources are allocated through devm and will thus be freed when
+the set's device is removed.
+
+  int power_seq_set_add_sequence(struct power_seq_set *set,
+			         struct power_seq *seq);
+  int power_seq_set_add_sequences(struct power_seq_set *set,
+				  struct platform_power_seq_set *seqs);
+
+Power sequences added to a set can then be resolved by their name using
+power_seq_lookup():
+
+  struct power_seq *power_seq_lookup(struct power_seq_set *seqs,
+				     const char *id);
+
+power_seq_lookup() returns a ready-to-run pointer to the power sequence which
+name matches the id parameter.
+
+A retrieved power sequence can then be executed by power_seq_run:
+
+  int power_seq_run(struct power_seq *seq);
+
+It returns 0 if the sequence has successfully been run, or an error code if a
+problem occurred.
+
+Sometimes, you may want to browse the list of resources allocated for the
+sequences of a device, for instance to ensure that a resource of a given type is
+present. The power_seq_for_each_resource() macro does this:
+
+  power_seq_for_each_resource(pos, seqs)
+
+Here "pos" will be a pointer to a struct power_seq_resource. This structure
+contains the type of the resource, the information used for identifying it, and
+the resolved resource itself.
+
+Finally, users of the device tree can obtain a platform_power_seq_set structure
+built from the device's node using devm_of_parse_power_seq_set:
+
+  struct platform_power_seq_set *devm_of_parse_power_seq_set(struct device *dev);
+
+The power sequences must be declared under a "power-sequences" node directly
+declared under the device's node. Detailed syntax contained in Documentation/devicetree/bindings/power/power_seq.txt. As the function name
+states, all memory is allocated through devm. The returned
+platform_power_seq_set can be freed after being added to a set, but the
+sequences themselves must be preserved until they are freed by devm.
\ No newline at end of file
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 49a8939..f20d449 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -338,3 +338,4 @@ config AB8500_BATTERY_THERM_ON_BATCTRL
 endif # POWER_SUPPLY
 
 source "drivers/power/avs/Kconfig"
+source "drivers/power/power_seq/Kconfig"
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index b949cf8..883ad4d 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -49,3 +49,4 @@ obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
 obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
 obj-$(CONFIG_POWER_AVS)		+= avs/
 obj-$(CONFIG_CHARGER_SMB347)	+= smb347-charger.o
+obj-$(CONFIG_POWER_SEQ)		+= power_seq/
diff --git a/drivers/power/power_seq/Kconfig b/drivers/power/power_seq/Kconfig
new file mode 100644
index 0000000..3bff26e
--- /dev/null
+++ b/drivers/power/power_seq/Kconfig
@@ -0,0 +1,2 @@
+config POWER_SEQ
+	bool
diff --git a/drivers/power/power_seq/Makefile b/drivers/power/power_seq/Makefile
new file mode 100644
index 0000000..f77a359
--- /dev/null
+++ b/drivers/power/power_seq/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_POWER_SEQ)		+= power_seq.o
diff --git a/drivers/power/power_seq/power_seq.c b/drivers/power/power_seq/power_seq.c
new file mode 100644
index 0000000..255b1a0
--- /dev/null
+++ b/drivers/power/power_seq/power_seq.c
@@ -0,0 +1,376 @@
+/*
+ * power_seq.c - power sequence interpreter for platform devices and device tree
+ *
+ * Author: Alexandre Courbot <acourbot@nvidia.com>
+ *
+ * Copyright (c) 2012 NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include <linux/power_seq.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/device.h>
+
+#include <linux/of.h>
+
+#define power_seq_err(seq, step_nbr, format, ...)			\
+	dev_err(seq->set->dev, "%s[%d]: " format, seq->id, step_nbr,	\
+	##__VA_ARGS__);
+
+/**
+ * struct power_seq_res_ops - operators for power sequences resources
+ * @name:		Name of the resource type. Set to null when a resource
+ *			type support is not compiled in
+ * @of_parse:		Parse a step for this kind of resource from a device
+ *			tree node. The result of parsing must be written into
+ *			step step_nbr of seq
+ * @step_run:		Run a step for this kind of resource
+ * @res_compare:	Return true if the resource used by the resource is the
+ *			same as the one referenced by the step, false otherwise.
+ * @res_alloc:		Resolve and allocate a resource. Return error code if
+ *			the resource cannot be allocated, 0 otherwise
+ */
+struct power_seq_res_ops {
+	const char *name;
+	int (*of_parse)(struct device_node *node, struct power_seq *seq,
+			unsigned int step_nbr, struct power_seq_resource *res);
+	int (*step_run)(struct power_seq_step *step);
+	bool (*res_compare)(struct power_seq_resource *res,
+			    struct power_seq_resource *res2);
+	int (*res_alloc)(struct device *dev,
+			 struct power_seq_resource *res);
+};
+
+static const struct power_seq_res_ops power_seq_ops[POWER_SEQ_NUM_TYPES];
+
+#ifdef CONFIG_OF
+static int of_power_seq_parse_enable_properties(struct device_node *node,
+						struct power_seq *seq,
+						unsigned int step_nbr,
+						bool *enable)
+{
+	if (of_find_property(node, "enable", NULL)) {
+		*enable = true;
+	} else if (of_find_property(node, "disable", NULL)) {
+		*enable = false;
+	} else {
+		power_seq_err(seq, step_nbr,
+			      "missing enable or disable property\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int of_power_seq_parse_step(struct device *dev,
+				   struct device_node *node,
+				   struct power_seq *seq,
+				   unsigned int step_nbr,
+				   struct list_head *resources)
+{
+	struct power_seq_step *step = &seq->steps[step_nbr];
+	struct power_seq_resource res, *res2;
+	const char *type;
+	int i, err;
+
+	err = of_property_read_string(node, "type", &type);
+	if (err < 0) {
+		power_seq_err(seq, step_nbr, "cannot read type property\n");
+		return err;
+	}
+	for (i = 0; i < POWER_SEQ_NUM_TYPES; i++) {
+		if (power_seq_ops[i].name == NULL)
+			continue;
+		if (!strcmp(type, power_seq_ops[i].name))
+			break;
+	}
+	if (i >= POWER_SEQ_NUM_TYPES) {
+		power_seq_err(seq, step_nbr, "unknown type %s\n", type);
+		return -EINVAL;
+	}
+	memset(&res, 0, sizeof(res));
+	res.type = i;
+	err = power_seq_ops[res.type].of_parse(node, seq, step_nbr, &res);
+	if (err < 0)
+		return err;
+
+	/* Use the same instance of the resource if met before */
+	list_for_each_entry(res2, resources, list) {
+		if (res.type == res2->type &&
+		    power_seq_ops[res.type].res_compare(&res, res2))
+			break;
+	}
+	/* Resource never met before, create it */
+	if (&res2->list == resources) {
+		res2 = devm_kzalloc(dev, sizeof(*res2), GFP_KERNEL);
+		if (!res2)
+			return -ENOMEM;
+		memcpy(res2, &res, sizeof(res));
+		list_add_tail(&res2->list, resources);
+	}
+	step->resource = res2;
+
+	return 0;
+}
+
+static struct power_seq *of_parse_power_seq(struct device *dev,
+					    struct device_node *node,
+					    struct list_head *resources)
+{
+	struct device_node *child = NULL;
+	struct power_seq *pseq;
+	int num_steps, sz;
+	int err;
+
+	if (!node)
+		return ERR_PTR(-EINVAL);
+
+	num_steps = of_get_child_count(node);
+	sz = sizeof(*pseq) + sizeof(pseq->steps[0]) * num_steps;
+	pseq = devm_kzalloc(dev, sz, GFP_KERNEL);
+	if (!pseq)
+		return ERR_PTR(-ENOMEM);
+	pseq->id = node->name;
+	pseq->num_steps = num_steps;
+
+	for_each_child_of_node(node, child) {
+		unsigned int pos;
+
+		/* Check that the name's format is correct and within bounds */
+		if (strncmp("step", child->name, 4)) {
+			err = -EINVAL;
+			goto parse_error;
+		}
+
+		err = kstrtouint(child->name + 4, 10, &pos);
+		if (err < 0)
+			goto parse_error;
+
+		/* Invalid step index or step already parsed? */
+		if (pos >= num_steps || pseq->steps[pos].resource != NULL) {
+			err = -EINVAL;
+			goto parse_error;
+		}
+
+		err = of_power_seq_parse_step(dev, child, pseq, pos, resources);
+		if (err)
+			return ERR_PTR(err);
+	}
+
+	return pseq;
+
+parse_error:
+	dev_err(dev, "%s: invalid power step name %s!\n", pseq->id,
+		child->name);
+	return ERR_PTR(err);
+}
+
+/**
+ * devm_of_parse_power_seq_set - build a power_seq_set from the device tree
+ * @dev:	Device to parse the power sequences of
+ *
+ * Sequences must be contained into a subnode named "power-sequences" of the
+ * device root node.
+ *
+ * Memory for the sequence is allocated using devm_kzalloc on dev. The returned
+ * platform_power_seq_set can be freed by devm_kfree after the sequences have
+ * been added, but the sequences themselves must be preserved.
+ *
+ * Returns the built set on success, or an error code in case of failure.
+ */
+struct platform_power_seq_set *devm_of_parse_power_seq_set(struct device *dev)
+{
+	struct platform_power_seq_set *set;
+	struct device_node *root = dev->of_node;
+	struct device_node *seq;
+	struct list_head resources;
+	int n, sz;
+
+	if (!root)
+		return NULL;
+
+	root = of_find_node_by_name(root, "power-sequences");
+	if (!root)
+		return NULL;
+
+	n = of_get_child_count(root);
+	sz = sizeof(*set) + sizeof(struct power_seq *) * n;
+	set = devm_kzalloc(dev, sz, GFP_KERNEL);
+	if (!set)
+		return ERR_PTR(-ENOMEM);
+	set->num_seqs = n;
+
+	n = 0;
+	INIT_LIST_HEAD(&resources);
+	for_each_child_of_node(root, seq) {
+		struct power_seq *pseq;
+
+		pseq = of_parse_power_seq(dev, seq, &resources);
+		if (IS_ERR(pseq))
+			return (void *)pseq;
+
+		set->seqs[n++] = pseq;
+	}
+
+	return set;
+}
+EXPORT_SYMBOL_GPL(devm_of_parse_power_seq_set);
+#endif /* CONFIG_OF */
+
+/**
+ * power_seq_set_init - initialize a power_seq_set
+ * @set:	Set to initialize
+ * @dev:	Device this set is going to belong to
+ */
+void power_seq_set_init(struct power_seq_set *set, struct device *dev)
+{
+	set->dev = dev;
+	INIT_LIST_HEAD(&set->resources);
+	INIT_LIST_HEAD(&set->seqs);
+}
+EXPORT_SYMBOL_GPL(power_seq_set_init);
+
+/**
+ * power_seq_add_sequence - add a power sequence to a set
+ * @set:	Set to add the sequence to
+ * @seq:	Sequence to add
+ *
+ * This step will check that all the resources used by the sequence are
+ * allocated. If they are not, an attempt to allocate them is made. This
+ * operation can fail and and return an error code.
+ *
+ * Returns 0 on success, error code if a resource initialization failed.
+ */
+int power_seq_add_sequence(struct power_seq_set *set, struct power_seq *seq)
+{
+	struct power_seq_resource *res;
+	int i, err;
+
+	for (i = 0; i < seq->num_steps; i++) {
+		struct power_seq_step *step = &seq->steps[i];
+		struct power_seq_resource *step_res = step->resource;
+		list_for_each_entry(res, &set->resources, list) {
+			if (res == step_res)
+				break;
+		}
+		/* resource not allocated yet, allocate and add it */
+		if (&res->list == &set->resources) {
+			err = power_seq_ops[step_res->type].res_alloc(set->dev,
+								      step_res);
+			if (err)
+				return err;
+			list_add_tail(&step->resource->list, &set->resources);
+		}
+	}
+
+	list_add_tail(&seq->list, &set->seqs);
+	seq->set = set;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(power_seq_add_sequence);
+
+/**
+ * power_seq_add_sequences - add power sequences defined as platform data
+ * @set:	Set to add the sequences to
+ * @seqs:	Sequences to add
+ *
+ * See power_seq_add_sequence for more details.
+ *
+ * Returns 0 on success, error code if a resource initialization failed.
+ */
+int power_seq_set_add_sequences(struct power_seq_set *set,
+				struct platform_power_seq_set *seqs)
+{
+	int i, ret;
+
+	for (i = 0; i < seqs->num_seqs; i++) {
+		ret = power_seq_add_sequence(set, seqs->seqs[i]);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(power_seq_set_add_sequences);
+
+/**
+ * power_seq_lookup - Lookup a power sequence by name from a set
+ * @seqs:	The set to look in
+ * @id:		Name to look after
+ *
+ * Returns a matching power sequence if it exists, NULL if it does not.
+ */
+struct power_seq *power_seq_lookup(struct power_seq_set *set, const char *id)
+{
+	struct power_seq *seq;
+
+	list_for_each_entry(seq, &set->seqs, list) {
+		if (!strcmp(seq->id, id))
+			return seq;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(power_seq_lookup);
+
+/**
+ * power_seq_run() - run a power sequence
+ * @seq:	The power sequence to run
+ *
+ * Returns 0 on success, error code in case of failure.
+ */
+int power_seq_run(struct power_seq *seq)
+{
+	unsigned int i;
+	int err;
+
+	if (!seq)
+		return 0;
+
+	if (!seq->set) {
+		pr_err("cannot run a sequence not added to a set");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < seq->num_steps; i++) {
+		unsigned int type = seq->steps[i].resource->type;
+
+		err = power_seq_ops[type].step_run(&seq->steps[i]);
+		if (err) {
+			power_seq_err(seq, i,
+				"error %d while running power sequence step\n",
+				err);
+			return err;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(power_seq_run);
+
+#include "power_seq_delay.c"
+#include "power_seq_regulator.c"
+#include "power_seq_pwm.c"
+#include "power_seq_gpio.c"
+
+static const struct power_seq_res_ops power_seq_ops[POWER_SEQ_NUM_TYPES] = {
+	[POWER_SEQ_DELAY] = POWER_SEQ_DELAY_TYPE,
+	[POWER_SEQ_REGULATOR] = POWER_SEQ_REGULATOR_TYPE,
+	[POWER_SEQ_PWM] = POWER_SEQ_PWM_TYPE,
+	[POWER_SEQ_GPIO] = POWER_SEQ_GPIO_TYPE,
+};
+
+MODULE_AUTHOR("Alexandre Courbot <acourbot@nvidia.com>");
+MODULE_DESCRIPTION("Runtime Interpreted Power Sequences");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/power/power_seq/power_seq_delay.c b/drivers/power/power_seq/power_seq_delay.c
new file mode 100644
index 0000000..5bb0a46
--- /dev/null
+++ b/drivers/power/power_seq/power_seq_delay.c
@@ -0,0 +1,65 @@
+/*
+ * Copyright (c) 2012 NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include <linux/delay.h>
+
+#ifdef CONFIG_OF
+static int of_power_seq_parse_delay(struct device_node *node,
+				    struct power_seq *seq,
+				    unsigned int step_nbr,
+				    struct power_seq_resource *res)
+{
+	struct power_seq_step *step = &seq->steps[step_nbr];
+	int err;
+
+	err = of_property_read_u32(node, "delay",
+				   &step->delay.delay);
+	if (err < 0)
+		power_seq_err(seq, step_nbr, "error reading delay property\n");
+
+	return err;
+}
+#else
+#define of_power_seq_parse_delay NULL
+#endif
+
+static bool power_seq_res_compare_delay(struct power_seq_resource *res,
+					struct power_seq_resource *res2)
+{
+	/* Delay resources are just here to hold the type of steps, so they are
+	 * all equivalent. */
+	return true;
+}
+
+static int power_seq_res_alloc_delay(struct device *dev,
+				     struct power_seq_resource *res)
+{
+	return 0;
+}
+
+static int power_seq_step_run_delay(struct power_seq_step *step)
+{
+	usleep_range(step->delay.delay,
+		     step->delay.delay + 1000);
+
+	return 0;
+}
+
+#define POWER_SEQ_DELAY_TYPE {				\
+	.name = "delay",				\
+	.of_parse = of_power_seq_parse_delay,		\
+	.step_run = power_seq_step_run_delay,		\
+	.res_compare = power_seq_res_compare_delay,	\
+	.res_alloc = power_seq_res_alloc_delay,		\
+}
diff --git a/drivers/power/power_seq/power_seq_gpio.c b/drivers/power/power_seq/power_seq_gpio.c
new file mode 100644
index 0000000..44b4a3d
--- /dev/null
+++ b/drivers/power/power_seq/power_seq_gpio.c
@@ -0,0 +1,94 @@
+/*
+ * Copyright (c) 2012 NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+
+#ifdef CONFIG_OF
+static int power_seq_of_parse_gpio(struct device_node *node,
+				   struct power_seq *seq,
+				   unsigned int step_nbr,
+				   struct power_seq_resource *res)
+{
+	struct power_seq_step *step = &seq->steps[step_nbr];
+	int gpio;
+	int err;
+
+	gpio = of_get_named_gpio(node, "gpio", 0);
+	if (gpio < 0) {
+		power_seq_err(seq, step_nbr, "error reading gpio property\n");
+		return gpio;
+	}
+	res->gpio.gpio = gpio;
+
+	err = of_property_read_u32(node, "value", &step->gpio.value);
+	if (err < 0) {
+		power_seq_err(seq, step_nbr, "error reading value property\n");
+	} else if (step->gpio.value < 0 || step->gpio.value > 1) {
+		power_seq_err(seq, step_nbr,
+			      "value out of range (must be 0 or 1)\n");
+		err = -EINVAL;
+	}
+
+	return err;
+}
+#else
+#define of_power_seq_parse_gpio NULL
+#endif
+
+static bool power_seq_res_compare_gpio(struct power_seq_resource *res,
+				       struct power_seq_resource *res2)
+{
+	return res->gpio.gpio == res2->gpio.gpio;
+}
+
+static int power_seq_res_alloc_gpio(struct device *dev,
+				    struct power_seq_resource *res)
+{
+	int err;
+
+	err = devm_gpio_request(dev, res->gpio.gpio, dev_name(dev));
+	if (err) {
+		dev_err(dev, "cannot get gpio %d\n", res->gpio.gpio);
+		return err;
+	}
+
+	return 0;
+}
+
+static int power_seq_step_run_gpio(struct power_seq_step *step)
+{
+	struct power_seq_resource *res = step->resource;
+
+	/* set the GPIO direction at first use */
+	if (!res->gpio.is_set) {
+		int err = gpio_direction_output(res->gpio.gpio,
+						step->gpio.value);
+		if (err)
+			return err;
+		res->gpio.is_set = true;
+	} else {
+		gpio_set_value_cansleep(res->gpio.gpio, step->gpio.value);
+	}
+
+	return 0;
+}
+
+#define POWER_SEQ_GPIO_TYPE {					\
+	.name = "gpio",					\
+	.of_parse = power_seq_of_parse_gpio,		\
+	.step_run = power_seq_step_run_gpio,		\
+	.res_compare = power_seq_res_compare_gpio,	\
+	.res_alloc = power_seq_res_alloc_gpio,		\
+}
diff --git a/drivers/power/power_seq/power_seq_pwm.c b/drivers/power/power_seq/power_seq_pwm.c
new file mode 100644
index 0000000..c0a1ec3
--- /dev/null
+++ b/drivers/power/power_seq/power_seq_pwm.c
@@ -0,0 +1,82 @@
+/*
+ * Copyright (c) 2012 NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#ifdef CONFIG_PWM
+
+#include <linux/pwm.h>
+
+#ifdef CONFIG_OF
+static int power_seq_of_parse_pwm(struct device_node *node,
+				  struct power_seq *seq,
+				  unsigned int step_nbr,
+				  struct power_seq_resource *res)
+{
+	struct power_seq_step *step = &seq->steps[step_nbr];
+	int err;
+
+	err = of_property_read_string(node, "id", &res->pwm.id);
+	if (err) {
+		power_seq_err(seq, step_nbr, "error reading id property\n");
+		return err;
+	}
+
+	err = of_power_seq_parse_enable_properties(node, seq, step_nbr,
+						   &step->pwm.enable);
+	return err;
+}
+#else
+#define of_power_seq_parse_pwm NULL
+#endif
+
+static bool power_seq_res_compare_pwm(struct power_seq_resource *res,
+				      struct power_seq_resource *res2)
+{
+	return !strcmp(res->pwm.id, res2->pwm.id);
+}
+
+static int power_seq_res_alloc_pwm(struct device *dev,
+				   struct power_seq_resource *res)
+{
+	res->pwm.pwm = devm_pwm_get(dev, res->pwm.id);
+	if (IS_ERR(res->pwm.pwm)) {
+		dev_err(dev, "cannot get pwm \"%s\"\n", res->pwm.id);
+		return PTR_ERR(res->pwm.pwm);
+	}
+
+	return 0;
+}
+
+static int power_seq_step_run_pwm(struct power_seq_step *step)
+{
+	if (step->pwm.enable) {
+		return pwm_enable(step->resource->pwm.pwm);
+	} else {
+		pwm_disable(step->resource->pwm.pwm);
+		return 0;
+	}
+}
+
+#define POWER_SEQ_PWM_TYPE {				\
+	.name = "pwm",					\
+	.of_parse = power_seq_of_parse_pwm,		\
+	.step_run = power_seq_step_run_pwm,		\
+	.res_compare = power_seq_res_compare_pwm,	\
+	.res_alloc = power_seq_res_alloc_pwm,		\
+}
+
+#else
+
+#define POWER_SEQ_PWM_TYPE {}
+
+#endif
diff --git a/drivers/power/power_seq/power_seq_regulator.c b/drivers/power/power_seq/power_seq_regulator.c
new file mode 100644
index 0000000..282cc95
--- /dev/null
+++ b/drivers/power/power_seq/power_seq_regulator.c
@@ -0,0 +1,83 @@
+/*
+ * Copyright (c) 2012 NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#ifdef CONFIG_REGULATOR
+
+#include <linux/regulator/consumer.h>
+
+#ifdef CONFIG_OF
+static int power_seq_of_parse_regulator(struct device_node *node,
+					struct power_seq *seq,
+					unsigned int step_nbr,
+					struct power_seq_resource *res)
+{
+	struct power_seq_step *step = &seq->steps[step_nbr];
+	int err;
+
+	err = of_property_read_string(node, "id",
+				      &res->regulator.id);
+	if (err) {
+		power_seq_err(seq, step_nbr, "error reading id property\n");
+		return err;
+	}
+
+	err = of_power_seq_parse_enable_properties(node, seq, step_nbr,
+						   &step->regulator.enable);
+	return err;
+}
+#else
+#define of_power_seq_parse_regulator NULL
+#endif
+
+static bool
+power_seq_res_compare_regulator(struct power_seq_resource *res,
+				struct power_seq_resource *res2)
+{
+	return !strcmp(res->regulator.id, res2->regulator.id);
+}
+
+static int power_seq_res_alloc_regulator(struct device *dev,
+					 struct power_seq_resource *res)
+{
+	res->regulator.regulator = devm_regulator_get(dev, res->regulator.id);
+	if (IS_ERR(res->regulator.regulator)) {
+		dev_err(dev, "cannot get regulator \"%s\"\n",
+			res->regulator.id);
+		return PTR_ERR(res->regulator.regulator);
+	}
+
+	return 0;
+}
+
+static int power_seq_step_run_regulator(struct power_seq_step *step)
+{
+	if (step->regulator.enable)
+		return regulator_enable(step->resource->regulator.regulator);
+	else
+		return regulator_disable(step->resource->regulator.regulator);
+}
+
+#define POWER_SEQ_REGULATOR_TYPE {			\
+	.name = "regulator",				\
+	.of_parse = power_seq_of_parse_regulator,	\
+	.step_run = power_seq_step_run_regulator,	\
+	.res_compare = power_seq_res_compare_regulator,	\
+	.res_alloc = power_seq_res_alloc_regulator,	\
+}
+
+#else
+
+#define POWER_SEQ_REGULATOR_TYPE {}
+
+#endif
diff --git a/include/linux/power_seq.h b/include/linux/power_seq.h
new file mode 100644
index 0000000..21b95b6
--- /dev/null
+++ b/include/linux/power_seq.h
@@ -0,0 +1,203 @@
+/*
+ * power_seq.h
+ *
+ * Simple interpreter for power sequences defined as platform data or device
+ * tree properties.
+ *
+ * Power sequences are designed to replace the callbacks typically used in
+ * board-specific files that implement board- or device- specific power
+ * sequences (such as those of backlights). A power sequence is an array of
+ * steps referencing resources (regulators, GPIOs, PWMs, ...) with an action to
+ * perform on them. By having the power sequences interpreted, it becomes
+ * possible to describe them in the device tree and thus to remove
+ * board-specific files from the kernel.
+ *
+ * See Documentation/power/power_seqs.txt for detailed information.
+ *
+ * Author: Alexandre Courbot <acourbot@nvidia.com>
+ *
+ * Copyright (c) 2012 NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#ifndef __LINUX_POWER_SEQ_H
+#define __LINUX_POWER_SEQ_H
+
+#include <linux/types.h>
+#include <linux/list.h>
+
+struct device;
+struct regulator;
+struct pwm_device;
+
+/**
+ * The different kinds of resources that can be controlled by the sequences
+ */
+enum power_seq_res_type {
+	POWER_SEQ_DELAY,
+	POWER_SEQ_REGULATOR,
+	POWER_SEQ_PWM,
+	POWER_SEQ_GPIO,
+	POWER_SEQ_NUM_TYPES,
+};
+
+/**
+ * struct power_seq_regulator_resource
+ * @id:		name of the regulator
+ * @regulator:	resolved regulator. Written during resource resolution.
+ */
+struct power_seq_regulator_resource {
+	const char *id;
+	struct regulator *regulator;
+};
+
+/**
+ * struct power_seq_pwm_resource
+ * @id:		name of the PWM
+ * @regulator:	resolved PWM. Written during resource resolution.
+ */
+struct power_seq_pwm_resource {
+	const char *id;
+	struct pwm_device *pwm;
+};
+
+/**
+ * struct power_seq_gpio_resource
+ * @gpio:	number of the GPIO
+ * @is_set:	track GPIO state to set its direction at first use
+ */
+struct power_seq_gpio_resource {
+	int gpio;
+	bool is_set;
+};
+
+/**
+ * struct power_seq_resource - resource used by power sequences
+ * @type:	type of the resource. This decides which member of the union is
+ *		used for this resource
+ * @list:	link resources together in power_seq_set
+ * @regulator:	used if @type == POWER_SEQ_REGULATOR
+ * @pwm:	used if @type == POWER_SEQ_PWM
+ * @gpio:	used if @type == POWER_SEQ_GPIO
+ */
+struct power_seq_resource {
+	enum power_seq_res_type type;
+	struct list_head list;
+	union {
+		struct power_seq_regulator_resource regulator;
+		struct power_seq_pwm_resource pwm;
+		struct power_seq_gpio_resource gpio;
+	};
+};
+#define power_seq_for_each_resource(pos, set)			\
+	list_for_each_entry(pos, &(set)->resources, list)
+
+/**
+ * struct power_seq_delay_step - action data for delay steps
+ * @delay:	amount of time to wait, in microseconds
+ */
+struct power_seq_delay_step {
+	unsigned int delay;
+};
+
+/**
+ * struct power_seq_regulator_step - platform data for regulator steps
+ * @enable:	whether to enable or disable the regulator during this step
+ */
+struct power_seq_regulator_step {
+	bool enable;
+};
+
+/**
+ * struct power_seq_pwm_step - action data for PWM steps
+ * @enable:	whether to enable or disable the PWM during this step
+ */
+struct power_seq_pwm_step {
+	bool enable;
+};
+
+/**
+ * struct power_seq_gpio_step - action data for GPIO steps
+ * @enable:	whether to enable or disable the GPIO during this step
+ */
+struct power_seq_gpio_step {
+	int value;
+};
+
+/**
+ * struct power_seq_step - data for power sequences steps
+ * @resource:	resource used by this step
+ * @delay:	used if resource->type == POWER_SEQ_DELAY
+ * @regulator:	used if resource->type == POWER_SEQ_REGULATOR
+ * @pwm:	used if resource->type == POWER_SEQ_PWN
+ * @gpio:	used if resource->type == POWER_SEQ_GPIO
+ */
+struct power_seq_step {
+	struct power_seq_resource *resource;
+	union {
+		struct power_seq_delay_step delay;
+		struct power_seq_regulator_step regulator;
+		struct power_seq_pwm_step pwm;
+		struct power_seq_gpio_step gpio;
+	};
+};
+
+struct power_seq_set;
+
+/**
+ * struct power_seq - single power sequence
+ * @id:		name of this sequence
+ * @list:	link sequences together in power_seq_set. Leave as-is
+ * @set:	set this sequence belongs to. Written when added to a set
+ * @num_steps:	number of steps in the sequence
+ * @steps:	array of steps that make the sequence
+ */
+struct power_seq {
+	const char *id;
+	struct list_head list;
+	struct power_seq_set *set;
+	unsigned int num_steps;
+	struct power_seq_step steps[];
+};
+
+/**
+ * struct power_seq_set - power sequences and resources used by a device
+ * @dev:	device this set belongs to
+ * @resources:	list of resources used by power sequences
+ * @seqs:	list of power sequences
+ */
+struct power_seq_set {
+	struct device *dev;
+	struct list_head resources;
+	struct list_head seqs;
+};
+
+/**
+ * struct platform_power_seq_set - define power sequences as platform data
+ * @num_seqs:	number of sequences defined
+ * @seqs:	array of num_seqs power sequences
+ */
+struct platform_power_seq_set {
+	unsigned int num_seqs;
+	struct power_seq *seqs[];
+};
+
+struct platform_power_seq_set *devm_of_parse_power_seq_set(struct device *dev);
+void power_seq_set_init(struct power_seq_set *set, struct device *dev);
+int power_seq_set_add_sequence(struct power_seq_set *set,
+			       struct power_seq *seq);
+int power_seq_set_add_sequences(struct power_seq_set *set,
+				struct platform_power_seq_set *seqs);
+struct power_seq *power_seq_lookup(struct power_seq_set *seqs, const char *id);
+int power_seq_run(struct power_seq *seq);
+
+#endif
-- 
1.7.12.3

