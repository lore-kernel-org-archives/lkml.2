Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab2ILJ45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 05:56:57 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18733 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab2ILJ4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 05:56:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 12 Sep 2012 02:56:23 -0700
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
Subject: [PATCH v6 1/4] Runtime Interpreted Power Sequences
Date: Wed, 12 Sep 2012 18:57:44 +0900
Message-ID: <1347443867-18868-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some device drivers (panel backlights especially) need to follow precise
sequences for powering on and off, involving gpios, regulators, PWMs
with a precise powering order and delays to respect between each steps.
These sequences are board-specific, and do not belong to a particular
driver - therefore they have been performed by board-specific hook
functions to far.

With the advent of the device tree and of ARM kernels that are not
board-tied, we cannot rely on these board-specific hooks anymore but
need a way to implement these sequences in a portable manner. This patch
introduces a simple interpreter that can execute such power sequences
encoded either as platform data or within the device tree.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 .../devicetree/bindings/power_seq/power_seq.txt    | 122 ++++++
 Documentation/power/power_seq.txt                  | 215 ++++++++++
 drivers/power/Kconfig                              |   1 +
 drivers/power/Makefile                             |   1 +
 drivers/power/power_seq/Kconfig                    |   2 +
 drivers/power/power_seq/Makefile                   |   1 +
 drivers/power/power_seq/power_seq.c                | 446 +++++++++++++++++++++
 drivers/power/power_seq/power_seq_delay.c          |  51 +++
 drivers/power/power_seq/power_seq_gpio.c           |  91 +++++
 drivers/power/power_seq/power_seq_pwm.c            |  87 ++++
 drivers/power/power_seq/power_seq_regulator.c      |  87 ++++
 include/linux/power_seq.h                          | 172 ++++++++
 12 files changed, 1276 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_seq/power_seq.txt
 create mode 100644 Documentation/power/power_seq.txt
 create mode 100644 drivers/power/power_seq/Kconfig
 create mode 100644 drivers/power/power_seq/Makefile
 create mode 100644 drivers/power/power_seq/power_seq.c
 create mode 100644 drivers/power/power_seq/power_seq_delay.c
 create mode 100644 drivers/power/power_seq/power_seq_gpio.c
 create mode 100644 drivers/power/power_seq/power_seq_pwm.c
 create mode 100644 drivers/power/power_seq/power_seq_regulator.c
 create mode 100644 include/linux/power_seq.h

diff --git a/Documentation/devicetree/bindings/power_seq/power_seq.txt b/Documentation/devicetree/bindings/power_seq/power_seq.txt
new file mode 100644
index 0000000..2b394eb
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_seq/power_seq.txt
@@ -0,0 +1,122 @@
+Runtime Interpreted Power Sequences
+===================================
+
+Power sequences are sequential descriptions of actions to be performed on
+power-related resources. Having these descriptions in a well-defined data format
+allows us to take much of the board-specific power control code out of the
+kernel and place it into the device tree instead, making kernels less
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
+  - id: name of the regulator to use. Regulator is obtained by
+        regulator_get(dev, id)
+  - enable / disable: one of these two empty properties must be present to
+                      enable or disable the resource
+
+"pwm" type required properties:
+  - id: name of the PWM to use. PWM is obtained by pwm_get(dev, id)
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
+sequences are built and are declared according to their own framework (for
+instance, regulators and pwms are resolved by name using regulator_get() or
+pwm_get()).
+
+After the resources declaration, two sequences follow for powering the backlight
+on and off. Their names are specified by the pwm-backlight device bindings. Once
+the sequences are built by calling devm_power_seq_set_build() with a NULL pseq
+argument, their names can be passed to power_seq_lookup() to retrieve an actual
+sequence.
diff --git a/Documentation/power/power_seq.txt b/Documentation/power/power_seq.txt
new file mode 100644
index 0000000..7f3f2d2
--- /dev/null
+++ b/Documentation/power/power_seq.txt
@@ -0,0 +1,215 @@
+Runtime Interpreted Power Sequences
+===================================
+
+Problem
+-------
+Very commonly, boards need the help of out-of-driver code to turn some of their
+devices on and off. For instance, SoC boards very commonly use a GPIO
+(abstracted to a regulator or not) to control the power supply of a backlight,
+disabling it when the backlight is not used in order to save power. The GPIO
+that should be used, however, as well as the exact power sequence that may
+also involve other resources, is board-dependent and thus unknown to the driver.
+
+This was previously addressed by having hooks in the device's platform data that
+are called whenever the state of the device might reflect a power change. This
+approach, however, introduces board-dependant code into the kernel and is not
+compatible with the device tree.
+
+The Runtime Interpreted Power Sequences (or power sequences for short) aim at
+turning this code into platform data or device tree nodes. Power sequences are
+described using a simple format and run by a lightweight interpreter whenever
+needed. This allows device drivers to work without power callbacks and makes the
+kernel less board-dependant.
+
+What are Power Sequences?
+-------------------------
+A power sequence is a suite of sequential steps each describing an action to be
+performed on a resource. The supported resources and actions operations are:
+- delay (just wait for a given number of microseconds)
+- GPIO (set to 0 or 1)
+- regulator (enable or disable)
+- PWM (enable or disable)
+
+When a power sequence is run, each of its steps is executed one after the other
+until one step fails or the end of the sequence is reached.
+
+Power sequences are named, and grouped into "sets" which correspond to all the
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
+which references instances of platform_power_seq. Each platform_power_seq is a
+single power sequence, and is itself made of a variable length array of steps.
+
+A step is a union of all the platform step structures, which are defined and
+documented in include/linux/power_seq.h. Which one is to be used depends on the
+type of the step. This might sound complicated, but the following example should
+make it clear how the platform data for power sequences is defined. It declares
+two power sequences named "power-on" and "power-off". The
+"power-on" sequence enables a regulator named "power" (retrieved using
+regulator_get()), waits for 10ms, and then set GPIO 110 to 1. "power-off" does
+the opposite.
+
+static struct platform_power_seq power_on_seq = {
+	.id = "power-on",
+	.num_steps = 3,
+	.steps = {
+		{
+			.type = POWER_SEQ_REGULATOR,
+			.regulator = {
+				.id = "power",
+				.enable = true,
+			},
+		},
+		{
+			.type = POWER_SEQ_DELAY,
+			.delay = {
+				.delay = 10000,
+			},
+		},
+		{
+			.type = POWER_SEQ_GPIO,
+			.gpio = {
+				.gpio = 110,
+				.value = 1,
+			},
+		},
+	},
+};
+
+static struct platform_power_seq power_off_seq = {
+	.id = "power-off",
+	.num_steps = 3,
+	.steps = {
+		{
+			.type = POWER_SEQ_GPIO,
+			.gpio = {
+				.gpio = 110,
+				.value = 0,
+			},
+		},
+		{
+			.type = POWER_SEQ_DELAY,
+			.delay = {
+				.delay = 10000,
+			},
+		},
+		{
+			.type = POWER_SEQ_REGULATOR,
+			.regulator = {
+				.id = "power",
+				.enable = false,
+			},
+		},
+	},
+};
+
+static struct platform_power_seq_set platform_power_sequences = {
+	.num_seqs = 2,
+	.seqs = {
+		&power_on_seq,
+		&power_off_seq,
+	},
+};
+
+"platform_power_sequences" can then be passed to devm_power_seq_set_build() in
+order to build the corresponding sequences set and allocate all the necessary
+resources. More on this later in this document.
+
+Device Tree
+-----------
+Power sequences can also be encoded as device tree nodes. The following
+properties and nodes are equivalent to the platform data defined previously:
+
+power-supply = <&power_reg>;
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
+			type = "gpio";
+			gpio = <&gpio 110 0>;
+			value = <1>;
+		};
+	}
+	power-off {
+		step0 {
+			type = "gpio";
+			gpio = <&gpio 110 0>;
+			value = <0>;
+		};
+		step1 {
+			type = "delay";
+			delay = <10000>;
+		};
+		step2 {
+			type = "regulator";
+			id = "power";
+			disable;
+		};
+	}
+};
+
+See Documentation/devicetree/bindings/power_seq/power_seq.txt for the complete
+syntax of the DT bindings.
+
+Usage by Drivers and Resources Management
+-----------------------------------------
+Power sequences make use of resources that must be properly allocated and
+managed. The devm_power_seq_set_build() function builds a power sequence set
+from platform data. It also takes care of resolving and allocating the resources
+referenced by the sequence:
+
+  struct power_seq_set *devm_power_seq_set_build(struct device *dev,
+					   struct platform_power_seq_set *pseq);
+
+As its name states, all memory and resources are devm-allocated. The 'dev'
+argument is the device in the name of which the resources are to be allocated.
+
+If the pseq argument is NULL, then the power sequences are built from the device
+tree data, if any.
+
+On success, the function returns a devm allocated resolved sequences set for
+which all the resources are allocated. In case of failure, an error code is
+returned. If no set can be built because no platform data is passed and the
+device tree node for the device contains no power sequence, the function returns
+NULL.
+
+Once the set is built, power sequences can be retrieved by their name using
+power_seq_lookup:
+
+  struct power_seq *power_seq_lookup(struct power_seq_set *seqs,
+				     const char *id);
+
+A retrieved power sequence can then be executed by power_seq_run:
+
+  int power_seq_run(struct power_seq *seq);
+
+It returns 0 if the sequence has successfully been run, or an error code if a
+problem occurred.
+
+Sometimes, you may want to browse the list of resources allocated by a sequence,
+for instance to ensure that a resource of a given type is present. The
+power_seq_set_resources() function returns a list head that can be used with
+the power_seq_for_each_resource() macro to browse all the resources of a set:
+
+  struct list_head *power_seq_set_resources(struct power_seq_set *seqs);
+  power_seq_for_each_resource(pos, seqs)
+
+Here "pos" will be a pointer to a struct power_seq_resource. This structure
+contains the type of the resource, the information used for identifying it, and
+the resolved resource itself.
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index fcc1bb0..5fdfd84 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -312,3 +312,4 @@ config AB8500_BATTERY_THERM_ON_BATCTRL
 endif # POWER_SUPPLY
 
 source "drivers/power/avs/Kconfig"
+source "drivers/power/power_seq/Kconfig"
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index ee58afb..d3c893b 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -45,3 +45,4 @@ obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
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
index 0000000..0924a03
--- /dev/null
+++ b/drivers/power/power_seq/power_seq.c
@@ -0,0 +1,446 @@
+/*
+ * power_seq.c - A simple power sequence interpreter for platform devices
+ *               and device tree.
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
+struct power_seq_set {
+	struct device *dev;
+	struct list_head resources;
+	struct list_head sequences;
+};
+
+struct power_seq_step {
+	/* Copy of the platform data */
+	struct platform_power_seq_step pdata;
+	/* Resolved resource */
+	struct power_seq_resource *resource;
+};
+
+struct power_seq {
+	/* Set this sequence belongs to */
+	struct power_seq_set *parent_set;
+	const char *id;
+	/* To thread into power_seqs structure */
+	struct list_head list;
+	unsigned int num_steps;
+	struct power_seq_step steps[];
+};
+
+#define power_seq_err(dev, seq, step_nbr, format, ...)			     \
+	dev_err(dev, "%s[%d]: " format, seq->id, step_nbr, ##__VA_ARGS__);
+
+/**
+ * struct power_seq_res_type - operators for power sequences resources
+ * @name:		Name of the resource type. Set to null when a resource
+ *			type support is not compiled in
+ * @need_resource:	Whether a resource needs to be allocated when steps of
+ *			this kind are met. If set to false, res_compare and
+ *			res_alloc need not be set
+ * @of_parse:		Parse a step for this kind of resource from a device
+ *			tree node. The result of parsing must be written into
+ *			step step_nbr of seq
+ * @step_run:		Run a step for this kind of resource
+ * @res_compare:	Return true if the resource used by the resource is the
+ *			same as the one referenced by the step, false otherwise.
+ * @res_alloc:		Resolve and allocate the resource used by pstep into
+ *			seq. The memory for seq is already allocated and its
+ *			type member is already set when this function is called.
+ *			Return error code if the resource cannot be allocated, 0
+ *			if allocation went successfully.
+ */
+struct power_seq_res_ops {
+	const char *name;
+	bool need_resource;
+	int (*of_parse)(struct device *dev, struct device_node *node,
+			struct platform_power_seq *seq, unsigned int step_nbr);
+	int (*step_run)(struct power_seq_step *step);
+	bool (*res_compare)(struct power_seq_resource *res,
+			    struct platform_power_seq_step *step);
+	int (*res_alloc)(struct device *dev,
+			 struct platform_power_seq_step *pstep,
+			 struct power_seq_resource *seq);
+};
+
+static const struct power_seq_res_ops power_seq_types[POWER_SEQ_NUM_TYPES];
+
+#ifdef CONFIG_OF
+static int of_power_seq_parse_enable_properties(struct device *dev,
+						struct device_node *node,
+						struct platform_power_seq *seq,
+						unsigned int step_nbr,
+						bool *enable)
+{
+	if (of_find_property(node, "enable", NULL)) {
+		*enable = true;
+	} else if (of_find_property(node, "disable", NULL)) {
+		*enable = false;
+	} else {
+		power_seq_err(dev, seq, step_nbr,
+			      "missing enable or disable property\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int of_power_seq_parse_step(struct device *dev, struct device_node *node,
+				   struct platform_power_seq *seq,
+				   unsigned int step_nbr)
+{
+	struct platform_power_seq_step *step = &seq->steps[step_nbr];
+	const char *type;
+	int i, err;
+
+	err = of_property_read_string(node, "type", &type);
+	if (err < 0) {
+		power_seq_err(dev, seq, step_nbr,
+			      "cannot read type property\n");
+		return err;
+	}
+	for (i = 0; i < POWER_SEQ_NUM_TYPES; i++) {
+		if (power_seq_types[i].name == NULL)
+			continue;
+		if (!strcmp(type, power_seq_types[i].name))
+			break;
+	}
+	if (i >= POWER_SEQ_NUM_TYPES) {
+		power_seq_err(dev, seq, step_nbr, "unknown type %s\n", type);
+		return -EINVAL;
+	}
+	step->type = i;
+	err = power_seq_types[step->type].of_parse(dev, node, seq, step_nbr);
+
+	return err;
+}
+
+static struct platform_power_seq *of_parse_power_seq(struct device *dev,
+						     struct device_node *node)
+{
+	struct device_node *child = NULL;
+	struct platform_power_seq *pseq;
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
+	pseq->num_steps = num_steps;
+	pseq->id = node->name;
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
+		if (pos >= num_steps || pseq->steps[pos].type != 0) {
+			err = -EINVAL;
+			goto parse_error;
+		}
+
+		err = of_power_seq_parse_step(dev, child, pseq, pos);
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
+/*
+ * build power sequences platform data from a device tree node.
+ *
+ * Sequences must be contained into a subnode named "power-sequences" of the
+ * device root node.
+ *
+ * Memory for the platform sequence is allocated using devm_kzalloc on dev and
+ * can be freed by devm_kfree after power_seq_set_build returned. Beware that on
+ * top of the set itself, platform data for individual sequences should also be
+ * freed.
+ *
+ * Returns the built power sequence set on success, or an error code in case of
+ * failure.
+ */
+static
+struct platform_power_seq_set *devm_of_parse_power_seq_set(struct device *dev)
+{
+	struct platform_power_seq_set *seqs;
+	struct device_node *root = dev->of_node;
+	struct device_node *seq;
+	int num_seqs, sz, i = 0;
+
+	if (!root)
+		return NULL;
+
+	root = of_find_node_by_name(root, "power-sequences");
+	if (!root)
+		return NULL;
+
+	num_seqs = of_get_child_count(root);
+	sz = sizeof(*seqs) + sizeof(seqs->seqs[0]) * num_seqs;
+	seqs = devm_kzalloc(dev, sz, GFP_KERNEL);
+	if (!seqs)
+		return ERR_PTR(-ENOMEM);
+	seqs->num_seqs = num_seqs;
+
+	for_each_child_of_node(root, seq) {
+		struct platform_power_seq *pseq;
+
+		pseq = of_parse_power_seq(dev, seq);
+		if (IS_ERR(pseq))
+			return (void *)pseq;
+
+		seqs->seqs[i++] = pseq;
+	}
+
+	return seqs;
+}
+#endif /* CONFIG_OF */
+
+static struct power_seq_resource *
+power_seq_find_resource(struct list_head *ress,
+			struct platform_power_seq_step *step)
+{
+	struct power_seq_resource *res;
+
+	list_for_each_entry(res, ress, list) {
+		if (res->type != step->type)
+			continue;
+
+		if (power_seq_types[res->type].res_compare(res, step))
+			return res;
+	}
+
+	return NULL;
+}
+
+static struct power_seq *power_seq_build_one(struct device *dev,
+					     struct power_seq_set *seqs,
+					     struct platform_power_seq *pseq)
+{
+	struct power_seq *seq;
+	struct power_seq_resource *res;
+	int i, err;
+
+	seq = devm_kzalloc(dev, sizeof(*seq) + sizeof(seq->steps[0]) *
+			   pseq->num_steps, GFP_KERNEL);
+	if (!seq)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&seq->list);
+	seq->parent_set = seqs;
+	seq->num_steps = pseq->num_steps;
+	seq->id = pseq->id;
+
+	for (i = 0; i < seq->num_steps; i++) {
+		struct platform_power_seq_step *pstep = &pseq->steps[i];
+		struct power_seq_step *step = &seq->steps[i];
+
+		if (pstep->type >= POWER_SEQ_NUM_TYPES ||
+		    power_seq_types[pstep->type].name == NULL) {
+			power_seq_err(dev, seq, i,
+				      "invalid power sequence type %d!",
+				      pstep->type);
+			return ERR_PTR(-EINVAL);
+		}
+
+		memcpy(&step->pdata, pstep, sizeof(step->pdata));
+
+		/* Steps without resource need not to continue */
+		if (!power_seq_types[pstep->type].need_resource)
+			continue;
+
+		/* create resource node if not referenced already */
+		res = power_seq_find_resource(&seqs->resources, pstep);
+		if (!res) {
+			res = devm_kzalloc(dev, sizeof(*res), GFP_KERNEL);
+			if (!res)
+				return ERR_PTR(-ENOMEM);
+
+			res->type = step->pdata.type;
+
+			err = power_seq_types[res->type].res_alloc(dev,
+							     &step->pdata, res);
+			if (err < 0)
+				return ERR_PTR(err);
+
+			list_add_tail(&res->list, &seqs->resources);
+		}
+		step->resource = res;
+	}
+
+	return seq;
+}
+
+/**
+ * power_seq_set_build() - build a set of runnable sequences from platform data or device tree
+ * @dev:	Device that will use the power sequences. All resources will be
+ *		devm-allocated against it
+ * @pseq:	Platform data for the power sequences. It can be freed after
+ *		this function returns. If this parameter is null, power
+ *		sequences are looked up in the device tree.
+ *
+ * All memory and resources (regulators, GPIOs, etc.) are allocated using devm
+ * functions.
+ *
+ * Returns the built sequence on success, an error code in case or failure,
+ * and NULL if neither platform data or device tree nodes are defined.
+ */
+struct power_seq_set *devm_power_seq_set_build(struct device *dev,
+					    struct platform_power_seq_set *pseq)
+{
+	struct power_seq_set *seqs;
+	int i;
+	bool use_dt = false;
+
+	if (!pseq) {
+		use_dt = true;
+		pseq = devm_of_parse_power_seq_set(dev);
+	}
+
+	if (!pseq)
+		return NULL;
+
+	seqs = devm_kzalloc(dev, sizeof(*seqs), GFP_KERNEL);
+
+	if (!seqs)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&seqs->resources);
+	INIT_LIST_HEAD(&seqs->sequences);
+	for (i = 0; i < pseq->num_seqs; i++) {
+		struct power_seq *seq;
+
+		seq = power_seq_build_one(dev, seqs, pseq->seqs[i]);
+		if (IS_ERR(seq))
+			return (void *)seq;
+
+		list_add_tail(&seq->list, &seqs->sequences);
+	}
+
+	/* if we used the DT, free the temporarily built platform data */
+	if (use_dt) {
+		for (i = 0; i < pseq->num_seqs; i++)
+			devm_kfree(dev, pseq->seqs[i]);
+
+		devm_kfree(dev, pseq);
+	}
+
+	return seqs;
+}
+EXPORT_SYMBOL_GPL(devm_power_seq_set_build);
+
+/**
+ * power_seq_lookup - Lookup a power sequence by name from a set
+ * @seqs:	The set to look in
+ * @id:		Name to look after
+ *
+ * Returns a matching power sequence if it exists, NULL if it does not.
+ */
+struct power_seq *power_seq_lookup(struct power_seq_set *seqs, const char *id)
+{
+	struct power_seq *seq;
+
+	list_for_each_entry(seq, &seqs->sequences, list) {
+		if (!strcmp(seq->id, id))
+			return seq;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(power_seq_lookup);
+
+/**
+ * power_seq_set_resources - return a list of all the resources used by a set
+ * @seqs:	Power sequences set we are interested in getting the resources
+ *
+ * The returned list can be parsed using the power_seq_for_each_resource macro.
+ */
+struct list_head *power_seq_set_resources(struct power_seq_set *seqs)
+{
+	return &seqs->resources;
+}
+EXPORT_SYMBOL_GPL(power_seq_set_resources);
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
+	for (i = 0; i < seq->num_steps; i++) {
+		unsigned int type = seq->steps[i].pdata.type;
+
+		err = power_seq_types[type].step_run(&seq->steps[i]);
+		if (err) {
+			power_seq_err(seq->parent_set->dev, seq, i,
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
+static const struct power_seq_res_ops power_seq_types[POWER_SEQ_NUM_TYPES] = {
+	[POWER_SEQ_DELAY] = POWER_SEQ_DELAY_TYPE,
+	[POWER_SEQ_REGULATOR] = POWER_SEQ_REGULATOR_TYPE,
+	[POWER_SEQ_PWM] = POWER_SEQ_PWM_TYPE,
+	[POWER_SEQ_GPIO] = POWER_SEQ_GPIO_TYPE,
+};
+
+MODULE_AUTHOR("Alexandre Courbot <acourbot@nvidia.com>");
+MODULE_DESCRIPTION("Runtime Interpreted Power Sequences");
+MODULE_LICENSE("GPL");
diff --git a/drivers/power/power_seq/power_seq_delay.c b/drivers/power/power_seq/power_seq_delay.c
new file mode 100644
index 0000000..ae94131
--- /dev/null
+++ b/drivers/power/power_seq/power_seq_delay.c
@@ -0,0 +1,51 @@
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
+static int of_power_seq_parse_delay(struct device *dev,
+				    struct device_node *node,
+				    struct platform_power_seq *seq,
+				    unsigned int step_nbr)
+{
+	struct platform_power_seq_step *step = &seq->steps[step_nbr];
+	int err;
+
+	err = of_property_read_u32(node, "delay",
+				   &step->delay.delay);
+	if (err < 0)
+		power_seq_err(dev, seq, step_nbr,
+			      "error reading delay property\n");
+
+	return err;
+}
+#else
+#define of_power_seq_parse_delay NULL
+#endif
+
+static int power_seq_step_run_delay(struct power_seq_step *step)
+{
+	usleep_range(step->pdata.delay.delay,
+		     step->pdata.delay.delay + 1000);
+
+	return 0;
+}
+
+#define POWER_SEQ_DELAY_TYPE {			\
+	.name = "delay",			\
+	.need_resource = false,			\
+	.of_parse = of_power_seq_parse_delay,	\
+	.step_run = power_seq_step_run_delay,	\
+}
diff --git a/drivers/power/power_seq/power_seq_gpio.c b/drivers/power/power_seq/power_seq_gpio.c
new file mode 100644
index 0000000..4f83d4c
--- /dev/null
+++ b/drivers/power/power_seq/power_seq_gpio.c
@@ -0,0 +1,91 @@
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
+static int power_seq_of_parse_gpio(struct device *dev,
+				   struct device_node *node,
+				   struct platform_power_seq *seq,
+				   unsigned int step_nbr)
+{
+	struct platform_power_seq_step *step = &seq->steps[step_nbr];
+	int gpio;
+	int err;
+
+	gpio = of_get_named_gpio(node, "gpio", 0);
+	if (gpio < 0) {
+		power_seq_err(dev, seq, step_nbr,
+			      "error reading gpio property\n");
+		return gpio;
+	}
+	step->gpio.gpio = gpio;
+
+	err = of_property_read_u32(node, "value", &step->gpio.value);
+	if (err < 0) {
+		power_seq_err(dev, seq, step_nbr,
+			      "error reading value property\n");
+	} else if (step->gpio.value < 0 || step->gpio.value > 1) {
+		power_seq_err(dev, seq, step_nbr,
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
+				       struct platform_power_seq_step *step)
+{
+	return res->gpio.gpio == step->gpio.gpio;
+}
+
+static int power_seq_res_alloc_gpio(struct device *dev,
+				    struct platform_power_seq_step *pstep,
+				    struct power_seq_resource *res)
+{
+	int err;
+
+	err = devm_gpio_request_one(dev, pstep->gpio.gpio,
+				    GPIOF_OUT_INIT_LOW, dev_name(dev));
+	if (err) {
+		dev_err(dev, "cannot get gpio %d\n", pstep->gpio.gpio);
+		return err;
+	}
+
+	res->gpio.gpio = pstep->gpio.gpio;
+
+	return 0;
+}
+
+static int power_seq_step_run_gpio(struct power_seq_step *step)
+{
+	gpio_set_value_cansleep(step->resource->gpio.gpio,
+				step->pdata.gpio.value);
+
+	return 0;
+}
+
+#define POWER_SEQ_GPIO_TYPE {					\
+	.name = "gpio",					\
+	.need_resource = true,				\
+	.of_parse = power_seq_of_parse_gpio,		\
+	.step_run = power_seq_step_run_gpio,		\
+	.res_compare = power_seq_res_compare_gpio,	\
+	.res_alloc = power_seq_res_alloc_gpio,		\
+}
diff --git a/drivers/power/power_seq/power_seq_pwm.c b/drivers/power/power_seq/power_seq_pwm.c
new file mode 100644
index 0000000..14f21e1
--- /dev/null
+++ b/drivers/power/power_seq/power_seq_pwm.c
@@ -0,0 +1,87 @@
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
+static int power_seq_of_parse_pwm(struct device *dev,
+				  struct device_node *node,
+				  struct platform_power_seq *seq,
+				  unsigned int step_nbr)
+{
+	struct platform_power_seq_step *step = &seq->steps[step_nbr];
+	int err;
+
+	err = of_property_read_string(node, "id",
+				      &step->pwm.id);
+	if (err) {
+		power_seq_err(dev, seq, step_nbr,
+			      "error reading id property\n");
+		return err;
+	}
+
+	err = of_power_seq_parse_enable_properties(dev, node, seq, step_nbr,
+						   &step->pwm.enable);
+	return err;
+}
+#else
+#define of_power_seq_parse_pwm NULL
+#endif
+
+static bool power_seq_res_compare_pwm(struct power_seq_resource *res,
+				      struct platform_power_seq_step *step)
+{
+	return !strcmp(res->pwm.id, step->pwm.id);
+}
+
+static int power_seq_res_alloc_pwm(struct device *dev,
+				   struct platform_power_seq_step *pstep,
+				   struct power_seq_resource *res)
+{
+	res->pwm.pwm = devm_pwm_get(dev, pstep->pwm.id);
+	if (IS_ERR(res->pwm.pwm)) {
+		dev_err(dev, "cannot get pwm \"%s\"\n", pstep->pwm.id);
+		return PTR_ERR(res->pwm.pwm);
+	}
+	res->pwm.id = pstep->pwm.id;
+
+	return 0;
+}
+
+static int power_seq_step_run_pwm(struct power_seq_step *step)
+{
+	if (step->pdata.pwm.enable) {
+		return pwm_enable(step->resource->pwm.pwm);
+	} else {
+		pwm_disable(step->resource->pwm.pwm);
+		return 0;
+	}
+}
+
+#define POWER_SEQ_PWM_TYPE {				\
+	.name = "pwm",					\
+	.need_resource = true,				\
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
index 0000000..2356578
--- /dev/null
+++ b/drivers/power/power_seq/power_seq_regulator.c
@@ -0,0 +1,87 @@
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
+static int power_seq_of_parse_regulator(struct device *dev,
+					struct device_node *node,
+					struct platform_power_seq *seq,
+					unsigned int step_nbr)
+{
+	struct platform_power_seq_step *step = &seq->steps[step_nbr];
+	int err;
+
+	err = of_property_read_string(node, "id",
+				      &step->regulator.id);
+	if (err) {
+		power_seq_err(dev, seq, step_nbr,
+			      "error reading id property\n");
+		return err;
+	}
+
+	err = of_power_seq_parse_enable_properties(dev, node, seq, step_nbr,
+						   &step->regulator.enable);
+	return err;
+}
+#else
+#define of_power_seq_parse_regulator NULL
+#endif
+
+static bool
+power_seq_res_compare_regulator(struct power_seq_resource *res,
+				struct platform_power_seq_step *step)
+{
+	return !strcmp(res->regulator.id, step->regulator.id);
+}
+
+static int power_seq_res_alloc_regulator(struct device *dev,
+					 struct platform_power_seq_step *pstep,
+					 struct power_seq_resource *res)
+{
+	res->regulator.regulator = devm_regulator_get(dev, pstep->regulator.id);
+	if (IS_ERR(res->regulator.regulator)) {
+		dev_err(dev, "cannot get regulator \"%s\"\n",
+			pstep->regulator.id);
+		return PTR_ERR(res->regulator.regulator);
+	}
+	res->regulator.id = pstep->regulator.id;
+
+	return 0;
+}
+
+static int power_seq_step_run_regulator(struct power_seq_step *step)
+{
+	if (step->pdata.regulator.enable)
+		return regulator_enable(step->resource->regulator.regulator);
+	else
+		return regulator_disable(step->resource->regulator.regulator);
+}
+
+#define POWER_SEQ_REGULATOR_TYPE {			\
+	.name = "regulator",				\
+	.need_resource = true,				\
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
index 0000000..437a61a
--- /dev/null
+++ b/include/linux/power_seq.h
@@ -0,0 +1,172 @@
+/*
+ * power_seq.h
+ *
+ * Simple interpreter for defining power sequences as platform data or device
+ * tree properties.
+ *
+ * Power sequences are designed to replace the callbacks typically used in
+ * board-specific files that implement board-specific power sequences of devices
+ * such as backlights. A power sequence is an array of resources (which can a
+ * regulator, a GPIO, a PWM, ...) with an action to perform on it (enable or
+ * disable) and optional pre and post step delays. By having them interpreted
+ * instead of arbitrarily executed, it is possible to describe these in the
+ * device tree and thus remove board-specific code from the kernel.
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
+#include <net/irda/parameters.h>
+
+struct device;
+struct regulator;
+struct pwm_device;
+struct device_node;
+
+/**
+ * The different kinds of resources that can be controlled during the sequences.
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
+ * struct platform_power_seq_delay_step - platform data for delay steps
+ * @delay:	Amount of time to wait, in microseconds.
+ */
+struct platform_power_seq_delay_step {
+	unsigned int delay;
+};
+
+/**
+ * struct platform_power_seq_regulator_step - platform data for regulator steps
+ * @id:		Name of the regulator to use. The regulator will be obtained
+ *		using devm_regulator_get(dev, name)
+ * @enable:	Whether to enable or disable the regulator during this step
+ */
+struct platform_power_seq_regulator_step {
+	const char *id;
+	bool enable;
+};
+
+/**
+ * struct platform_power_seq_pwm_step - platform data for PWM steps
+ * @id:		Name of the pwm to use. The PWM will be obtained using
+ *		devm_pwm_get(dev, name)
+ * @enable:	Whether to enable or disable the PWM during this step
+ */
+struct platform_power_seq_pwm_step {
+	const char *id;
+	bool enable;
+};
+
+/**
+ * struct platform_power_seq_gpio_step - platform data for GPIO steps
+ * @gpio:	Number of the GPIO to use. The GPIO will be obtained using
+ *		devm_gpio_request_one(dev, number)
+ * @enable:	Whether to enable or disable the GPIO during this step
+ */
+struct platform_power_seq_gpio_step {
+	int gpio;
+	int value;
+};
+
+/**
+ * struct platform_power_seq_step - platform data for power sequences steps
+ * @type:	The type of this step. This decides which member of the union is
+ *		valid for this step.
+ * @delay:	Used if @type == POWER_SEQ_DELAY
+ * @regulator:	Used if @type == POWER_SEQ_REGULATOR
+ * @pwm:	Used if @type == POWER_SEQ_PWN
+ * @gpio:	Used if @type == POWER_SEQ_GPIO
+ */
+struct platform_power_seq_step {
+	enum power_seq_res_type type;
+	union {
+		struct platform_power_seq_delay_step delay;
+		struct platform_power_seq_regulator_step regulator;
+		struct platform_power_seq_pwm_step pwm;
+		struct platform_power_seq_gpio_step gpio;
+	};
+};
+
+/**
+ * struct platform_power_seq - platform data for power sequences
+ * @id:		Name through which this sequence is refered
+ * @num_steps:	Number of steps in that sequence
+ * @steps:	Array of num_steps steps describing the sequence
+ */
+struct platform_power_seq {
+	const char *id;
+	unsigned int num_steps;
+	struct platform_power_seq_step steps[];
+};
+
+/**
+ * struct platform_power_seq_set - platform data for sets of sequences
+ * @num_seqs:	Number of sequences in this set
+ * @seqs:	Array of pointers to individual sequences
+ */
+struct platform_power_seq_set {
+	unsigned int num_seqs;
+	struct platform_power_seq *seqs[];
+};
+
+/**
+ * struct power_seq_resource - resource used by a power sequence set
+ * @pdata:	Pointer to the platform data used to resolve this resource
+ * @regulator:	Resolved regulator if of type POWER_SEQ_REGULATOR
+ * @pwm:	Resolved PWM if of type POWER_SEQ_PWM
+ * @list:	Used to link resources together
+ */
+struct power_seq_resource {
+	enum power_seq_res_type type;
+	/* resolved resource and identifier */
+	union {
+		struct {
+			struct regulator *regulator;
+			const char *id;
+		} regulator;
+		struct {
+			struct pwm_device *pwm;
+			const char *id;
+		} pwm;
+		struct {
+			int gpio;
+		} gpio;
+	};
+	struct list_head list;
+};
+#define power_seq_for_each_resource(pos, seqs)				\
+	list_for_each_entry(pos, power_seq_set_resources(seqs), list)
+
+struct power_seq_resource;
+struct power_seq;
+struct power_seq_set;
+
+struct power_seq_set *devm_power_seq_set_build(struct device *dev,
+					   struct platform_power_seq_set *pseq);
+struct list_head *power_seq_set_resources(struct power_seq_set *seqs);
+struct power_seq *power_seq_lookup(struct power_seq_set *seqs, const char *id);
+int power_seq_run(struct power_seq *seq);
+
+#endif
-- 
1.7.12

