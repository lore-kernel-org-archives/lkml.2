Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab0IVVsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 17:48:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51192 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab0IVVso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 17:48:44 -0400
From: Nishanth Menon <nm@ti.com>
To: lkml <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        l-o <linux-omap@vger.kernel.org>,
        l-a <linux-arm-kernel@lists.infradead.org>,
        linux-doc <linux-doc@vger.kernel.org>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <rdunlap@xenotime.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH v3] power: introduce library for device-specific OPPs
Date: Wed, 22 Sep 2010 16:47:34 -0500
Message-Id: <1285192054-454-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <[PATCH] opp: introduce library for device-specific OPPs>
References: <[PATCH] opp: introduce library for device-specific OPPs>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SOCs have a standard set of tuples consisting of frequency and
voltage pairs that the device will support per voltage domain. These
are called Operating Performance Points or OPPs. The actual
definitions of OPP varies over silicon versions. For a specific domain,
we can have a set of {frequency, voltage} pairs. As the kernel boots
and more information is available, a default set of these are activated
based on the precise nature of device. Further on operation, based on
conditions prevailing in the system (such as temperature), some OPP
availability may be temporarily controlled by the SoC frameworks.

To implement an OPP, some sort of power management support is necessary
hence this library depends on CONFIG_PM.

Contributions include:
Sanjeev Premi for the initial concept:
	http://patchwork.kernel.org/patch/50998/
Kevin Hilman for converting original design to device-based
Kevin Hilman and Paul Walmsey for cleaning up many of the function
abstractions, improvements and data structure handling
Romit Dasgupta for using enums instead of opp pointers
Thara Gopinath, Eduardo Valentin and Vishwanath BS for fixes and
cleanups.
Linus Walleij for recommending this layer be made generic for usage
in other architectures beyond OMAP and ARM.
Mark Brown, Andrew Morton, Rafael J Wysocki for valuable improvements.

Discussions and comments from:
http://marc.info/?l=linux-omap&m=126033945313269&w=2
http://marc.info/?l=linux-omap&m=125482970102327&w=2
http://marc.info/?t=125809247500002&r=1&w=2
http://marc.info/?l=linux-omap&m=126025973426007&w=2
http://marc.info/?t=128152609200064&r=1&w=2
http://marc.info/?t=128468723000002&r=1&w=2
incorporated.

Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Madhusudhan Chikkature Rajashekar <madhu.cr@ti.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Roberto Granados Dorado <x0095451@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Sergio Alberto Aguirre Rodriguez <saaguirre@ti.com>
Cc: Tero Kristo <Tero.Kristo@nokia.com>
Cc: Eduardo Valentin <eduardo.valentin@nokia.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Sanjeev Premi <premi@ti.com>
Cc: Thara Gopinath <thara@ti.com>
Cc: Vishwanath BS <vishwanath.bs@ti.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
V3:
  Bunch of documentation update based on feedback
  removed opp_def - opp_add enables the opp by default
  lock usage optimization

Sample usage:
 http://pastebin.mozilla.org/794786 -> cleanups for OMAP power
 http://pastebin.mozilla.org/794787 -> Sample OPP initialization for OMAP

V2:
https://patchwork.kernel.org/patch/189532/
  Incorporated review comments from v1. major changes being:
  $subject change to reflect this is for power.
  Documentation revamp and including it in the patch :)
  OPP_DEF removed - lets introduce this if needed or leave it to
  SOC frameworks to organize code as needed.
  Rename of enable to available to better reflect the intent
  few fixes and typos
  Introduced mutex based locking for controlling access to list
  modification (note: query functions are still unsafe- rationale
		 in the patch below)
  A new home for opp.c in drivers/base/power (moved from lib/)
  A few optimization in function flow and additional error checks
  added to exposed functions
  offline aligned with Kevin for cleaning up the copyrights

V1:
	http://marc.info/?t=128468723000002&r=1&w=2

 Documentation/power/00-INDEX |    2 +
 Documentation/power/opp.txt  |  330 ++++++++++++++++++++++++++
 drivers/base/power/Makefile  |    1 +
 drivers/base/power/opp.c     |  534 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/opp.h          |  103 ++++++++
 kernel/power/Kconfig         |   14 ++
 6 files changed, 984 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/power/opp.txt
 create mode 100644 drivers/base/power/opp.c
 create mode 100644 include/linux/opp.h

diff --git a/Documentation/power/00-INDEX b/Documentation/power/00-INDEX
index fb742c2..45e9d4a 100644
--- a/Documentation/power/00-INDEX
+++ b/Documentation/power/00-INDEX
@@ -14,6 +14,8 @@ interface.txt
 	- Power management user interface in /sys/power
 notifiers.txt
 	- Registering suspend notifiers in device drivers
+opp.txt
+	- Operating Performance Point library
 pci.txt
 	- How the PCI Subsystem Does Power Management
 pm_qos_interface.txt
diff --git a/Documentation/power/opp.txt b/Documentation/power/opp.txt
new file mode 100644
index 0000000..7e41e33
--- /dev/null
+++ b/Documentation/power/opp.txt
@@ -0,0 +1,330 @@
+*=============*
+* OPP Library *
+*=============*
+
+Contents
+--------
+1. Introduction
+2. Initial OPP List Registration
+3. OPP Search Functions
+4. OPP Availability Control Functions
+5. OPP Data Retrieval Functions
+6. Cpufreq Table Generation
+7. Data Structures
+
+1. Introduction
+===============
+Complex SOCs of today consists of a multiple sub-modules working in conjunction.
+In an operational system executing varied use cases, not all modules in the SoC
+need to function at their highest performing frequency all the time. To
+facilitate this, sub-modules in a SoC are grouped into domains, allowing some
+domains to run at lower voltage and frequency while other domains are loaded
+more. The set of discrete tuples consisting of frequency and voltage pairs that
+the device will support per domain are called Operating Performance Points or
+OPPs.
+
+OPP library provides a set of helper functions to organize and query the OPP
+information. The library is located in drivers/base/power/opp.c and the header
+is located in include/linux/opp.h. OPP library can be enabled by enabling
+CONFIG_PM_OPP from power management menuconfig menu. OPP library depends on
+CONFIG_PM as certain SOCs such as Texas Instrument's OMAP framework allows to
+optionally boot at a certain OPP without needing cpufreq.
+
+Typical usage of the OPP library is as follows:
+(users)		-> registers a set of default OPPs		-> (library)
+SoC framework	-> modifies on required cases certain OPPs	-> OPP layer
+		-> queries to search/retrieve information	->
+
+OPP layer expects each domain to be represented by a unique device pointer. SoC
+framework registers a set of initial OPPs per device with the OPP layer. This
+list is expected to be an optimally small number typically around 5 per device.
+This initial list contains a set of OPPs that the framework expects to be safely
+enabled by default in the system.
+
+Note on OPP Availability:
+------------------------
+As the system proceeds to operate, SoC framework may choose to make certain
+OPPs available or not available on each device based on various external
+factors. Example usage: Thermal management or other exceptional situations where
+SoC framework might choose to disable a higher frequency OPP to safely continue
+operations until that OPP could be re-enabled if possible.
+
+OPP library facilitates this concept in it's implementation. The following
+operational functions operate only on available opps:
+opp_find_freq_{ceil, floor}, opp_get_voltage, opp_get_freq, opp_get_opp_count
+and opp_init_cpufreq_table
+
+opp_find_freq_exact is meant to be used to find the opp pointer which can then
+be used for opp_enable/disable functions to make an opp available as required.
+
+WARNING: Users of OPP library should refresh their availability count using
+get_opp_count if opp_enable/disable functions are invoked for a device, the
+exact mechanism to trigger these or the notification mechanism to other
+dependent subsystems such as cpufreq are left to the discretion of the SoC
+specific framework which uses the OPP library. Similar care needs to be taken
+care to refresh the cpufreq table in cases of these operations.
+
+WARNING on OPP List Modification Vs Query operations:
+----------------------------------------------------
+The OPP layer's query functions are expected to be used in multiple contexts
+(including calls from interrupt locked context) based on SoC framework
+implementation. Only OPP modification functions are guaranteed exclusivity by
+the OPP library. Exclusivity between query functions and modification functions
+should be handled by the users such as the SoC framework appropriately; else,
+there is a risk for the query functions to retrieve stale data.
+
+2. Initial OPP List Registration
+================================
+The SoC implementation calls opp_add function iteratively to add OPPs per
+device. It is expected that the SoC framework will register the OPP entries
+optimally- typical numbers range to be less than 5. The list generated by
+registering the OPPs is maintained by OPP library throughout the device
+operation. The SoC framework can subsequently control the availability of the
+OPPs dynamically using the opp_enable / disable functions.
+
+opp_add - Add a new OPP for a specific domain represented by the device pointer.
+	The OPP is defined using the frequency and voltage. Once added, the OPP
+	is assumed to be available and control of it's availability can be done
+	with the opp_enable/disable functions. OPP library internally stores
+	and manages this information in the opp struct. This function may be
+	used by SoC framework to define a optimal list as per the demands of
+	SoC usage environment.
+
+	WARNING: Do not use these functions in interrupt context.
+
+	Example:
+	 soc_pm_init()
+	 {
+		/* Do things */
+		r = opp_add(mpu_dev, 1000000, 900000);
+		if (!r) {
+			pr_err("%s: unable to register mpu opp(%d)\n", r);
+			goto no_cpufreq;
+		}
+		/* Do cpufreq things */
+	 no_cpufreq:
+		/* Do remaining things */
+	 }
+
+3. OPP Search Functions
+=======================
+High level framework such as cpufreq operates on frequencies. To map the
+frequency back to the corresponding OPP, OPP library provides handy functions
+to search the OPP list that OPP library internally manages. These search
+functions return the matching pointer representing the opp if a match is
+found, else returns error. These errors are expected to be handled by standard
+error checks such as IS_ERR() and appropriate actions taken by the caller.
+
+opp_find_freq_exact - Search for an OPP based on an *exact* frequency and
+	availability. This function is especially useful to enable an OPP which
+	is not available by default.
+	Example: In a case when SoC framework detects a situation where a
+	higher frequency could be made available, it can use this function to
+	find the OPP prior to call the opp_enable to actually make it available.
+	 opp = opp_find_freq_exact(dev, 1000000000, false);
+	 if (!IS_ERR(opp))
+		ret = opp_enable(opp);
+	NOTE: This is the only search function that operates on OPPs which are
+	not available.
+
+opp_find_freq_floor - Search for an available OPP which is *at most* the
+	provided frequency. This function is useful while searching for a lesser
+	match OR operating on OPP information in the order of decreasing
+	frequency.
+	Example: To find the highest opp for a device:
+	 freq = ULONG_MAX;
+	 opp_find_freq_floor(dev, &freq);
+
+opp_find_freq_ceil - Search for an available OPP which is *at least* the
+	provided frequency. This function is useful while searching for a
+	higher match OR operating on OPP information in the order of increasing
+	frequency.
+	Example 1: To find the lowest opp for a device:
+	 freq = 0;
+	 opp_find_freq_ceil(dev, &freq);
+	Example 2: A simplified implementation of a SoC cpufreq_driver->target:
+	 soc_cpufreq_target(..)
+	 {
+		/* Do stuff like policy checks etc. */
+		/* Find the best frequency match for the req */
+		opp = opp_find_freq_ceil(dev, &freq);
+		if (!IS_ERR(opp))
+			soc_switch_to_freq_voltage(opp, freq);
+		else
+			/* do something when we cant satisfy the req */
+		/* do other stuff */
+	 }
+
+4. OPP Availability Control Functions
+=====================================
+A default OPP list registered with the OPP library may not cater to all possible
+situation. The OPP library provides a set of functions to modify the
+availability of a OPP within the OPP list. This allows SoC frameworks to have
+fine grained dynamic control of which sets of OPPs are operationally available.
+These functions are intended to *temporarily* remove an OPP in conditions such
+as thermal considerations (e.g. don't use OPPx until the temperature drops).
+
+WARNING: Do not use these functions in interrupt context.
+
+opp_enable - Make a OPP available for operation.
+	Example: Lets say that 1GHz OPP is to be made available only if the
+	SoC temperature is lower than a certain threshold. The SoC framework
+	implementation might choose to do something as follows:
+	 if (cur_temp < temp_low_thresh) {
+		/* Enable 1GHz if it was disabled */
+		opp = opp_find_freq_exact(dev, 1000000000, false);
+		if (!IS_ERR(opp))
+			ret = opp_enable(opp);
+	 }
+
+opp_disable - Make an OPP to be not available for operation
+	Example: Lets say that 1GHz OPP is to be disabled if the temperature
+	exceeds a threshold value. The SoC framework implementation might
+	choose to do something as follows:
+	 if (cur_temp > temp_high_thresh) {
+		/* Disable 1GHz if it was enabled */
+		opp = opp_find_freq_exact(dev, 1000000000, true);
+		if (!IS_ERR(opp))
+			ret = opp_disable(opp);
+	 }
+
+5. OPP Data Retrieval Functions
+===============================
+Since OPP library abstracts away the OPP information, a set of functions to pull
+information from the OPP structure is necessary. Once an OPP pointer is
+retrieved using the search functions, the following functions can be used by SoC
+framework to retrieve the information represented inside the OPP layer.
+
+opp_get_voltage - Retrieve the voltage represented by the opp pointer.
+	Example: At a cpufreq transition to a different frequency, SoC
+	framework requires to set the voltage represented by the OPP using
+	the regulator framework to the Power Management chip providing the
+	voltage.
+	 soc_switch_to_freq_voltage(opp, ..)
+	 {
+		/* do things */
+		v = opp_get_voltage(opp);
+		if (v)
+			regulator_set_voltage(.., v);
+		/* do other things */
+	 }
+
+opp_get_freq - Retrieve the freq represented by the opp pointer.
+	Example: Lets say the SoC framework stores the pointes to the min
+	and max OPPs that a device supports to save on a search during a hot
+	path such as switching OPPs.
+	 soc_pm_init()
+	 {
+		/* do things */
+		freq = ULONG_MAX;
+		max_opp = opp_find_freq_floor(dev, &freq);
+		freq = 0;
+		min_opp = opp_find_freq_ceil(dev, &freq);
+		/* do other things */
+	 }
+	A simplified implementation of a SoC cpufreq_driver->target:
+	 soc_cpufreq_target(..)
+	 {
+		/* do things.. */
+		if (target_freq > opp_get_freq(max_opp) ||
+				target_freq < opp_get_freq(min_opp))
+			return -EINVAL;
+		/* do other things */
+	 }
+
+opp_get_opp_count - Retrieve the number of available opps for a device
+	Example: Lets say a co-processor in the SoC needs to know the available
+	frequencies in a table, the main processor can notify as following:
+	 soc_notify_coproc_available_frequencies()
+	 {
+		/* Do things */
+		num_available = opp_get_opp_count(dev);
+		speeds = kzalloc(sizeof(u32) * num_available, GFP_KERNEL);
+		/* populate the table in increasing order */
+		freq = 0;
+		while (!IS_ERR(opp = opp_find_freq_ceil(dev, &freq))) {
+			speeds[i] = freq;
+			freq++;
+			i++;
+		}
+		soc_notify_coproc(AVAILABLE_FREQs, speeds, num_available);
+		/* Do other things */
+	 }
+
+6. Cpufreq Table Generation
+===========================
+opp_init_cpufreq_table - cpufreq framework typically is initialized with
+	cpufreq_frequency_table_cpuinfo which is provided with the list of
+	frequencies that are available for operation. This function provides
+	a ready to use conversion routine to translate the OPP layer's internal
+	information about the available frequencies into a format readily
+	providable to cpufreq.
+	Example:
+	 soc_pm_init()
+	 {
+		/* Do things */
+		r = opp_init_cpufreq_table(dev, &freq_table);
+		if (!r)
+			cpufreq_frequency_table_cpuinfo(policy, freq_table);
+		/* Do other things */
+	 }
+
+	NOTE: This function is available only if CONFIG_CPU_FREQ is enabled in
+	addition to CONFIG_PM as power management feature is required to
+	dynamically scale voltage and frequency in a system.
+
+7. Data Structures
+==================
+Typically an SoC contains multiple voltage domains which are variable. Each
+domain is represented by a device pointer. The relationship to OPP can be
+represented as follows:
+SoC
+ |- device 1
+ |	|- opp 1 (availability, freq, voltage)
+ |	|- opp 2 ..
+ ...	...
+ |	`- opp n ..
+ |- device 2
+ ...
+ `- device m
+
+OPP library maintains a internal list that the SoC framework populates and
+accessed by various functions as described above. However, the structures
+representing the actual OPPs and domains are internal to the OPP library itself
+to allow for suitable abstraction reusable across systems.
+
+struct opp - The internal data structure of OPP library which is used to
+	represent an OPP. In addition to the freq, voltage, availability
+	information, it also contains internal book keeping information required
+	for the OPP library to operate on.  Pointer to this structure is
+	provided back to the users such as SoC framework to be used as a
+	identifier for OPP in the interactions with OPP layer.
+
+	WARNING: The struct opp pointer should not be parsed or modified by the
+	users. The defaults of for an instance is populated by opp_add, but the
+	availability of the OPP can be modified by opp_enable/disable functions.
+
+struct device - This is used to identify a domain to the OPP layer. The
+	nature of the device and it's implementation is left to the user of
+	OPP library such as the SoC framework.
+
+Overall, in a simplistic view, the data structure operations is represented as
+following:
+
+Initialization / modification:
+            +-----+        /- opp_enable
+opp_add --> | opp | <-------
+  |         +-----+        \- opp_disable
+  \-------> domain_info(device)
+
+Search functions:
+             /-- opp_find_freq_ceil  ---\   +-----+
+domain_info<---- opp_find_freq_exact -----> | opp |
+             \-- opp_find_freq_floor ---/   +-----+
+
+Retrieval functions:
++-----+     /- opp_get_voltage
+| opp | <---
++-----+     \- opp_get_freq
+
+domain_info <- opp_get_opp_count
diff --git a/drivers/base/power/Makefile b/drivers/base/power/Makefile
index cbccf9a..abe46ed 100644
--- a/drivers/base/power/Makefile
+++ b/drivers/base/power/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_PM_SLEEP)	+= main.o wakeup.o
 obj-$(CONFIG_PM_RUNTIME)	+= runtime.o
 obj-$(CONFIG_PM_OPS)	+= generic_ops.o
 obj-$(CONFIG_PM_TRACE_RTC)	+= trace.o
+obj-$(CONFIG_PM_OPP)	+= opp.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
 ccflags-$(CONFIG_PM_VERBOSE)   += -DDEBUG
diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
new file mode 100644
index 0000000..311fd7f
--- /dev/null
+++ b/drivers/base/power/opp.c
@@ -0,0 +1,534 @@
+/*
+ * Generic OPP Interface
+ *
+ * Copyright (C) 2009-2010 Texas Instruments Incorporated.
+ *	Nishanth Menon
+ *	Romit Dasgupta
+ *	Kevin Hilman
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/cpufreq.h>
+#include <linux/list.h>
+#include <linux/opp.h>
+
+/*
+ * Internal data structure organization with the OPP layer library is as
+ * follows:
+ * dev_opp_list (root)
+ *	|- device 1 (represents voltage domain 1)
+ *	|	|- opp 1 (availability, freq, voltage)
+ *	|	|- opp 2 ..
+ *	...	...
+ *	|	`- opp n ..
+ *	|- device 2 (represents the next voltage domain)
+ *	...
+ *	`- device m (represents mth voltage domain)
+ * device 1, 2.. are represented by dev_opp structure while each opp
+ * is represented by the opp structure.
+ */
+
+/**
+ * struct opp - Generic OPP description structure
+ * @node:	opp list node. The nodes are maintained throughout the lifetime
+ *		of boot. It is expected only an optimal set of OPPs are
+ *		added to the library by the SoC framework.
+ *		IMPORTANT: the opp nodes should be maintained in increasing
+ *		order
+ * @available:	true/false - marks if this OPP as available or not
+ * @rate:	Frequency in hertz
+ * @u_volt:	Nominal voltage in microvolts corresponding to this OPP
+ * @dev_opp:	points back to the device_opp struct this opp belongs to
+ *
+ * This structure stores the OPP information for a given device.
+ */
+struct opp {
+	struct list_head node;
+
+	bool available;
+	unsigned long rate;
+	unsigned long u_volt;
+
+	struct device_opp *dev_opp;
+};
+
+/**
+ * struct device_opp - Device opp structure
+ * @node:	list node - contains the devices with OPPs that
+ *		have been registered
+ * @lock:	Lock to allow exclusive modification in the list for the device
+ * @dev:	device pointer
+ * @opp_list:	list of opps
+ * @available_opp_count: how many opps are actually available
+ *
+ * This is an internal data structure maintaining the link to opps attached to
+ * a device. This structure is not meant to be shared to users as it is
+ * meant for book keeping and private to OPP library
+ */
+struct device_opp {
+	struct list_head node;
+	/* mutex for exclusive modification of device OPP list */
+	struct mutex lock;
+
+	struct device *dev;
+
+	struct list_head opp_list;
+	u32 available_opp_count;
+};
+
+/*
+ * The root of the list of all devices. All device_opp structures branch off
+ * from here, with each device_opp containing the list of opp it supports in
+ * various states of availability.
+ */
+static LIST_HEAD(dev_opp_list);
+/* Lock to allow exclusive modification to the device list */
+static DEFINE_MUTEX(dev_opp_list_lock);
+
+/**
+ * find_device_opp() - find device_opp struct using device pointer
+ * @dev:	device pointer used to lookup device OPPs
+ *
+ * Search list of device OPPs for one containing matching device.
+ *
+ * Returns pointer to 'struct device_opp' if found, otherwise -ENODEV or
+ * -EINVAL based on type of error.
+ */
+static struct device_opp *find_device_opp(struct device *dev)
+{
+	struct device_opp *tmp_dev_opp, *dev_opp = ERR_PTR(-ENODEV);
+
+	if (unlikely(!dev || IS_ERR(dev))) {
+		pr_err("%s: Invalid parameters being passed\n", __func__);
+		return ERR_PTR(-EINVAL);
+	}
+
+	list_for_each_entry(tmp_dev_opp, &dev_opp_list, node) {
+		if (tmp_dev_opp->dev == dev) {
+			dev_opp = tmp_dev_opp;
+			break;
+		}
+	}
+
+	return dev_opp;
+}
+
+/**
+ * opp_get_voltage() - Gets the voltage corresponding to an available opp
+ * @opp:	opp for which voltage has to be returned for
+ *
+ * Return voltage in micro volt corresponding to the opp, else
+ * return 0
+ *
+ * WARNING: using this api simultaneously with opp_add/enable/disable may
+ * result in stale data. To ensure sanity of results, callers must ensure
+ * exclusivity from mentioned functions in some form.
+ */
+unsigned long opp_get_voltage(const struct opp *opp)
+{
+	if (unlikely(!opp || IS_ERR(opp)) || !opp->available) {
+		pr_err("%s: Invalid parameters being passed\n", __func__);
+		return 0;
+	}
+
+	return opp->u_volt;
+}
+
+/**
+ * opp_get_freq() - Gets the frequency corresponding to an available opp
+ * @opp:	opp for which frequency has to be returned for
+ *
+ * Return frequency in hertz corresponding to the opp, else
+ * return 0
+ *
+ * WARNING: using this api simultaneously with opp_add/enable/disable may
+ * result in stale data. To ensure sanity of results, callers must ensure
+ * exclusivity from mentioned functions in some form.
+ */
+unsigned long opp_get_freq(const struct opp *opp)
+{
+	if (unlikely(!opp || IS_ERR(opp)) || !opp->available) {
+		pr_err("%s: Invalid parameters being passed\n", __func__);
+		return 0;
+	}
+
+	return opp->rate;
+}
+
+/**
+ * opp_get_opp_count() - Get number of opps available in the opp list
+ * @dev:	device for which we do this operation
+ *
+ * This function returns the number of available opps if there are any,
+ * else returns 0 if none or the corresponding error value.
+ *
+ * WARNING: using this api simultaneously with opp_add/enable/disable may
+ * result in stale data. To ensure sanity of results, callers must ensure
+ * exclusivity from mentioned functions in some form.
+ */
+int opp_get_opp_count(struct device *dev)
+{
+	struct device_opp *dev_opp;
+
+	dev_opp = find_device_opp(dev);
+	if (IS_ERR(dev_opp))
+		return PTR_ERR(dev_opp);
+
+	return dev_opp->available_opp_count;
+}
+
+/**
+ * opp_find_freq_exact() - search for an exact frequency
+ * @dev:		device for which we do this operation
+ * @freq:		frequency to search for
+ * @is_available:	true/false - match for available opp
+ *
+ * Searches for exact match in the opp list and returns pointer to the matching
+ * opp if found, else returns ERR_PTR in case of error and should be handled
+ * using IS_ERR.
+ *
+ * Note: available is a modifier for the search. if available=true, then the
+ * match is for exact matching frequency and is available in the stored OPP
+ * table. if false, the match is for exact frequency which is not available.
+ *
+ * This provides a mechanism to enable an opp which is not available currently
+ * or the opposite as well.
+ *
+ * WARNING: using this api simultaneously with opp_add/enable/disable may
+ * result in stale data. To ensure sanity of results, callers must ensure
+ * exclusivity from mentioned functions in some form.
+ */
+struct opp *opp_find_freq_exact(struct device *dev,
+				     unsigned long freq, bool available)
+{
+	struct device_opp *dev_opp;
+	struct opp *temp_opp, *opp = ERR_PTR(-ENODEV);
+
+	dev_opp = find_device_opp(dev);
+	if (IS_ERR(dev_opp))
+		return opp;
+
+	list_for_each_entry(temp_opp, &dev_opp->opp_list, node) {
+		if (temp_opp->available == available &&
+				temp_opp->rate == freq) {
+			opp = temp_opp;
+			break;
+		}
+	}
+
+	return opp;
+}
+
+/**
+ * opp_find_freq_ceil() - Search for an rounded ceil freq
+ * @dev:	device for which we do this operation
+ * @freq:	Start frequency
+ *
+ * Search for the matching ceil *available* OPP from a starting freq
+ * for a device.
+ *
+ * Returns matching *opp and refreshes *freq accordingly, else returns
+ * ERR_PTR in case of error and should be handled using IS_ERR.
+ *
+ * Example usages:
+ *	* find match/next highest available frequency *
+ *	freq = 350000;
+ *	opp = opp_find_freq_ceil(dev, &freq))
+ *	if (IS_ERR(opp))
+ *		pr_err("unable to find a higher frequency\n");
+ *	else
+ *		pr_info("match freq = %ld\n", freq);
+ *
+ *	* print all supported frequencies in ascending order *
+ *	freq = 0; * Search for the lowest available frequency *
+ *	while (!IS_ERR(opp = opp_find_freq_ceil(OPP_MPU, &freq)) {
+ *		pr_info("freq = %ld\n", freq);
+ *		freq++; * for next higher match *
+ *	}
+ *
+ * WARNING: using this api simultaneously with opp_add/enable/disable may
+ * result in stale data. To ensure sanity of results, callers must ensure
+ * exclusivity from mentioned functions in some form.
+ */
+struct opp *opp_find_freq_ceil(struct device *dev, unsigned long *freq)
+{
+	struct device_opp *dev_opp;
+	struct opp *temp_opp, *opp = ERR_PTR(-ENODEV);
+
+	if (!dev || !freq) {
+		pr_err("%s: invalid param dev=%p freq=%p\n", __func__,
+				dev, freq);
+		return ERR_PTR(-EINVAL);
+	}
+	dev_opp = find_device_opp(dev);
+	if (IS_ERR(dev_opp))
+		return opp;
+
+	list_for_each_entry(temp_opp, &dev_opp->opp_list, node) {
+		if (temp_opp->available && temp_opp->rate >= *freq) {
+			opp = temp_opp;
+			*freq = opp->rate;
+			break;
+		}
+	}
+
+	return opp;
+}
+
+/**
+ * opp_find_freq_floor() - Search for a rounded floor freq
+ * @dev:	device for which we do this operation
+ * @freq:	Start frequency
+ *
+ * Search for the matching floor *available* OPP from a starting freq
+ * for a device.
+ *
+ * Returns matching *opp and refreshes *freq accordingly, else returns
+ * ERR_PTR in case of error and should be handled using IS_ERR.
+ *
+ * WARNING: using this api simultaneously with opp_add/enable/disable may
+ * result in stale data. To ensure sanity of results, callers must ensure
+ * exclusivity from mentioned functions in some form.
+ *
+ * Example usages:
+ *	* find match/next lowest available frequency
+ *	freq = 350000;
+ *	opp = opp_find_freq_floor(dev, &freq)))
+ *	if (IS_ERR(opp))
+ *		pr_err ("unable to find a lower frequency\n");
+ *	else
+ *		pr_info("match freq = %ld\n", freq);
+ *
+ *	* print all supported frequencies in descending order *
+ *	freq = ULONG_MAX; * search highest available frequency *
+ *	while (!IS_ERR(opp = opp_find_freq_floor(OPP_MPU, &freq)) {
+ *		pr_info("freq = %ld\n", freq);
+ *		freq--; * for next lower match *
+ *	}
+ *
+ * WARNING: using this api simultaneously with opp_add/enable/disable may
+ * result in stale data. To ensure sanity of results, callers must ensure
+ * exclusivity from mentioned functions in some form.
+ */
+struct opp *opp_find_freq_floor(struct device *dev, unsigned long *freq)
+{
+	struct device_opp *dev_opp;
+	struct opp *temp_opp, *opp = ERR_PTR(-ENODEV);
+
+	if (!dev || !freq) {
+		pr_err("%s: invalid param dev=%p freq=%p\n", __func__,
+				dev, freq);
+		return ERR_PTR(-EINVAL);
+	}
+	dev_opp = find_device_opp(dev);
+	if (IS_ERR(dev_opp))
+		return opp;
+
+	list_for_each_entry_reverse(temp_opp, &dev_opp->opp_list, node) {
+		if (temp_opp->available && temp_opp->rate <= *freq) {
+			opp = temp_opp;
+			*freq = opp->rate;
+			break;
+		}
+	}
+
+	return opp;
+}
+
+/**
+ * opp_add()  - Add an OPP table from a table definitions
+ * @dev:	device for which we do this operation
+ * @freq:	Frequency in Hz for this OPP
+ * @u_volt:	Voltage in uVolts for this OPP
+ *
+ * This function adds an opp definition to the opp list and returns status.
+ * The opp is made available by default and it can be controlled using
+ * opp_enable/disable functions.
+ *
+ * WARNING: This function should not be used in interrupt context.
+ */
+int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
+{
+	struct device_opp *tmp_dev_opp, *dev_opp = NULL;
+	struct opp *opp, *new_opp;
+	struct list_head *head;
+
+	/* Check for existing list for 'dev' */
+	list_for_each_entry(tmp_dev_opp, &dev_opp_list, node) {
+		if (dev == tmp_dev_opp->dev) {
+			dev_opp = tmp_dev_opp;
+			break;
+		}
+	}
+
+	/* allocate new OPP node */
+	new_opp = kzalloc(sizeof(struct opp), GFP_KERNEL);
+	if (!new_opp) {
+		pr_warning("%s: unable to allocate new opp node\n",
+			__func__);
+		return -ENOMEM;
+	}
+
+	if (!dev_opp) {
+		/* Allocate a new device OPP table */
+		dev_opp = kzalloc(sizeof(struct device_opp), GFP_KERNEL);
+		if (!dev_opp) {
+			kfree(new_opp);
+			pr_warning("%s: unable to allocate device structure\n",
+				__func__);
+			return -ENOMEM;
+		}
+
+		dev_opp->dev = dev;
+		INIT_LIST_HEAD(&dev_opp->opp_list);
+		mutex_init(&dev_opp->lock);
+
+		/* Secure the device list modification */
+		mutex_lock(&dev_opp_list_lock);
+		list_add(&dev_opp->node, &dev_opp_list);
+		mutex_unlock(&dev_opp_list_lock);
+	}
+
+	/* populate the opp table */
+	new_opp->rate = freq;
+	new_opp->u_volt = u_volt;
+	new_opp->available = true;
+
+	/* make the dev_opp modification safe */
+	mutex_lock(&dev_opp->lock);
+	/* Insert new OPP in order of increasing frequency */
+	head = &dev_opp->opp_list;
+	list_for_each_entry_reverse(opp, &dev_opp->opp_list, node) {
+		if (new_opp->rate >= opp->rate) {
+			head = &opp->node;
+			break;
+		}
+	}
+	list_add(&new_opp->node, head);
+	if (new_opp->available)
+		dev_opp->available_opp_count++;
+	mutex_unlock(&dev_opp->lock);
+
+	return 0;
+}
+
+/**
+ * opp_enable() - Enable a specific OPP
+ * @opp:	Pointer to opp
+ *
+ * Enables a provided opp. If the operation is valid, this returns 0, else the
+ * corresponding error value. It is meant to be used for users an OPP available
+ * after being temporarily made unavailable with opp_disable.
+ *
+ * OPP used here is from the opp_find_freq_* or other search functions
+ * WARNING: This function should not be used in interrupt context.
+ */
+int opp_enable(struct opp *opp)
+{
+	if (unlikely(!opp || IS_ERR(opp))) {
+		pr_err("%s: Invalid parameters being passed\n", __func__);
+		return -EINVAL;
+	}
+
+	mutex_lock(&opp->dev_opp->lock);
+	if (!opp->available && opp->dev_opp)
+		opp->dev_opp->available_opp_count++;
+
+	opp->available = true;
+	mutex_unlock(&opp->dev_opp->lock);
+
+	return 0;
+}
+
+/**
+ * opp_disable() - Disable a specific OPP
+ * @opp:	Pointer to opp
+ *
+ * Disables a provided opp. If the operation is valid, this returns
+ * 0, else the corresponding error value. It is meant to be a temporary
+ * control by users to make this OPP not available until the circumstances are
+ * right to make it available again (with a call to opp_enable).
+ *
+ * OPP used here is from the opp_find_freq_* or other search functions
+ * WARNING: This function should not be used in interrupt context.
+ */
+int opp_disable(struct opp *opp)
+{
+	if (unlikely(!opp || IS_ERR(opp))) {
+		pr_err("%s: Invalid parameters being passed\n", __func__);
+		return -EINVAL;
+	}
+
+	mutex_lock(&opp->dev_opp->lock);
+	if (opp->available && opp->dev_opp)
+		opp->dev_opp->available_opp_count--;
+
+	opp->available = false;
+	mutex_unlock(&opp->dev_opp->lock);
+
+	return 0;
+}
+
+#ifdef CONFIG_CPU_FREQ
+/**
+ * opp_init_cpufreq_table() - create a cpufreq table for a device
+ * @dev:	device for which we do this operation
+ * @table:	Cpufreq table returned back to caller
+ *
+ * Generate a cpufreq table for a provided device- this assumes that the
+ * opp list is already initialized and ready for usage.
+ *
+ * This function allocates required memory for the cpufreq table. It is
+ * expected that the caller does the required maintenance such as freeing
+ * the table as required.
+ *
+ * WARNING: using this api simultaneously with opp_add/enable/disable may
+ * result in stale data. To ensure sanity of results, callers must ensure
+ * exclusivity from mentioned functions in some form. It is equally important
+ * for the callers to ensure refreshing their copy of the table if any of the
+ * mentioned functions have been invoked in the interim.
+ */
+void opp_init_cpufreq_table(struct device *dev,
+			    struct cpufreq_frequency_table **table)
+{
+	struct device_opp *dev_opp;
+	struct opp *opp;
+	struct cpufreq_frequency_table *freq_table;
+	int i = 0;
+
+	dev_opp = find_device_opp(dev);
+	if (IS_ERR(dev_opp)) {
+		pr_warning("%s: unable to find device\n", __func__);
+		return;
+	}
+
+	freq_table = kzalloc(sizeof(struct cpufreq_frequency_table) *
+			     (dev_opp->available_opp_count + 1), GFP_ATOMIC);
+	if (!freq_table) {
+		pr_warning("%s: failed to allocate frequency table\n",
+			   __func__);
+		return;
+	}
+
+	list_for_each_entry(opp, &dev_opp->opp_list, node) {
+		if (opp->available) {
+			freq_table[i].index = i;
+			freq_table[i].frequency = opp->rate / 1000;
+			i++;
+		}
+	}
+
+	freq_table[i].index = i;
+	freq_table[i].frequency = CPUFREQ_TABLE_END;
+
+	*table = &freq_table[0];
+}
+#endif		/* CONFIG_CPU_FREQ */
diff --git a/include/linux/opp.h b/include/linux/opp.h
new file mode 100644
index 0000000..c29f93b
--- /dev/null
+++ b/include/linux/opp.h
@@ -0,0 +1,103 @@
+/*
+ * Generic OPP Interface
+ *
+ * Copyright (C) 2009-2010 Texas Instruments Incorporated.
+ *	Nishanth Menon
+ *	Romit Dasgupta
+ *	Kevin Hilman
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __ASM_OPP_H
+#define __ASM_OPP_H
+
+#include <linux/err.h>
+#include <linux/cpufreq.h>
+
+struct opp;
+
+#if defined(CONFIG_PM_OPP)
+
+unsigned long opp_get_voltage(const struct opp *opp);
+
+unsigned long opp_get_freq(const struct opp *opp);
+
+int opp_get_opp_count(struct device *dev);
+
+struct opp *opp_find_freq_exact(struct device *dev, unsigned long freq,
+				bool available);
+
+struct opp *opp_find_freq_floor(struct device *dev, unsigned long *freq);
+
+struct opp *opp_find_freq_ceil(struct device *dev, unsigned long *freq);
+
+int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt);
+
+int opp_enable(struct opp *opp);
+
+int opp_disable(struct opp *opp);
+
+#else
+static inline unsigned long opp_get_voltage(const struct opp *opp)
+{
+	return 0;
+}
+
+static inline unsigned long opp_get_freq(const struct opp *opp)
+{
+	return 0;
+}
+
+static inline int opp_get_opp_count(struct device *dev)
+{
+	return 0;
+}
+
+static inline struct opp *opp_find_freq_exact(struct device *dev,
+					unsigned long freq, bool available)
+{
+	return ERR_PTR(-EINVAL);
+}
+
+static inline struct opp *opp_find_freq_floor(struct device *dev,
+					unsigned long *freq)
+{
+	return ERR_PTR(-EINVAL);
+}
+
+static inline struct opp *opp_find_freq_ceil(struct device *dev,
+					unsigned long *freq)
+{
+	return ERR_PTR(-EINVAL);
+}
+
+static inline int opp_add(struct device *dev, unsigned long freq,
+					unsigned long u_volt);
+{
+	return -EINVAL;
+}
+
+static inline int opp_enable(struct opp *opp)
+{
+	return 0;
+}
+
+static inline int opp_disable(struct opp *opp)
+{
+	return 0;
+}
+#endif		/* CONFIG_PM */
+
+#if defined(CONFIG_CPU_FREQ) && defined(CONFIG_PM_OPP)
+void opp_init_cpufreq_table(struct device *dev,
+			    struct cpufreq_frequency_table **table);
+#else
+static inline void opp_init_cpufreq_table(struct device *dev,
+			    struct cpufreq_frequency_table **table)
+{
+}
+#endif		/* CONFIG_CPU_FREQ */
+
+#endif		/* __ASM_OPP_H */
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index ca6066a..634eab6 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -242,3 +242,17 @@ config PM_OPS
 	bool
 	depends on PM_SLEEP || PM_RUNTIME
 	default y
+
+config PM_OPP
+	bool "Enable Operating Performance Point(OPP) Layer library"
+	depends on PM
+	---help---
+	  SOCs have a standard set of tuples consisting of frequency and
+	  voltage pairs that the device will support per voltage domain. This
+	  is called Operating Performance Point or OPP. The actual definitions
+	  of OPP varies over silicon within the same family of devices.
+
+	  OPP layer organizes the data internally using device pointers
+	  representing individual voltage domains and provides SOC
+	  implementations a ready to use framework to manage OPPs.
+	  For more information, read <file:Documentation/power/opp.txt>
-- 
1.6.3.3

