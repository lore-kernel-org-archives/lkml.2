Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab2GZMa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 08:30:29 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:24938
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193Ab2GZM3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 08:29:04 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz13e6Kzz1202hzz8275bh8275dhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M7RPC6-02-2A4-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: <cpufreq@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Matthew Garrett <mjg@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Renninger <trenn@suse.de>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@amd.com>
Subject: [PATCH 8/8] Documentation: Add documentation for boost control switch
Date: Thu, 26 Jul 2012 14:28:44 +0200
Message-ID: <1343305724-2809-9-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1343305724-2809-1-git-send-email-andre.przywara@amd.com>
References: <1343305724-2809-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new acpi-cpufreq driver supports a system global control switch
to disable the frequency boosting feature of some (x86) CPUs.
Provide documentation about the rationale and the usage.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |   12 +++
 Documentation/cpu-freq/boost.txt                   |   94 ++++++++++++++++++++
 2 files changed, 106 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/cpu-freq/boost.txt

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 5dab364..1107a2e 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -176,3 +176,15 @@ Description:	Disable L3 cache indices
 		All AMD processors with L3 caches provide this functionality.
 		For details, see BKDGs at
 		http://developer.amd.com/documentation/guides/Pages/default.aspx
+
+
+What:		/sys/devices/system/cpu/cpufreq/boost
+Date:		August 2012
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Processor frequency boosting control
+
+		This switch controls the boost setting for the whole system.
+		Boosting allows the CPU and the firmware to run at a frequency
+		beyound it's nominal limit.
+		More details can be found in Documentation/cpu-freq/boost.txt
+
diff --git a/Documentation/cpu-freq/boost.txt b/Documentation/cpu-freq/boost.txt
new file mode 100644
index 0000000..0085494
--- /dev/null
+++ b/Documentation/cpu-freq/boost.txt
@@ -0,0 +1,94 @@
+Processor boosting control
+
+	- information for users -
+
+Quick guide for the impatient:
+--------------------
+/sys/devices/system/cpu/cpufreq/boost
+controls the boost setting for the whole system. You can read and write
+that file with either "0" (boosting disabled) or "1" (boosting allowed).
+Reading or writing 1 does not mean that the system is boosting at this
+very moment, but only that the CPU _may_ raise the frequency at it's
+discretion.
+--------------------
+
+Introduction
+-------------
+Some CPUs support a functionality to raise the operating frequency of
+some cores in a multi-core package if certain conditions apply, mostly
+if the whole chip is not fully utilized and below it's intended thermal
+budget. This is done without operating system control by a combination
+of hardware and firmware.
+On Intel CPUs this is called "Turbo Boost", AMD calls it "Turbo-Core",
+in technical documentation "Core performance boost". In Linux we use
+the term "boost" for convenience.
+
+Rationale for disable switch
+----------------------------
+
+Though the idea is to just give better performance without any user
+intervention, sometimes the need arises to disable this functionality.
+Most systems offer a switch in the (BIOS) firmware to disable the
+functionality at all, but a more fine-grained and dynamic control would
+be desirable:
+1. While running benchmarks, reproducible results are important. Since
+   the boosting functionality depends on the load of the whole package,
+   single thread performance can vary. By explicitly disabling the boost
+   functionality at least for the benchmark's run-time the system will run
+   at a fixed frequency and results are reproducible again.
+2. To examine the impact of the boosting functionality it is helpful
+   to do tests with and without boosting.
+3. Boosting means overclocking the processor, though under controlled
+   conditions. By raising the frequency and the voltage the processor
+   will consume more power than without the boosting, which may be
+   undesirable for instance for mobile users. Disabling boosting may
+   save power here, though this depends on the workload.
+
+
+User controlled switch
+----------------------
+
+To allow the user to toggle the boosting functionality, the acpi-cpufreq
+driver exports a sysfs knob to disable it. There is a file:
+/sys/devices/system/cpu/cpufreq/boost
+which can either read "0" (boosting disabled) or "1" (boosting enabled).
+Reading the file is always supported, even if the processor does not
+support boosting. In this case the file will be read-only and always
+reads as "0". Explicitly changing the permissions and writing to that
+file anyway will return EINVAL.
+
+On supported CPUs one can write either a "0" or a "1" into this file.
+This will either disable the boost functionality on all cores in the
+whole system (0) or will allow the hardware to boost at will (1).
+
+Writing a "1" does not explicitly boost the system, but just allows the
+CPU (and the firmware) to boost at their discretion. Some implementations
+take external factors like the chip's temperature into account, so 
+boosting once does not necessarily mean that it will occur every time
+even using the exact same software setup.
+
+
+AMD legacy cpb switch
+---------------------
+The AMD powernow-k8 driver used to support a very similar switch to
+disable or enable the "Core Performance Boost" feature of some AMD CPUs.
+This switch was instantiated in each CPU's cpufreq directory
+(/sys/devices/system/cpu[0-9]*/cpufreq) and was called "cpb".
+Though the per CPU existence hints at a more fine grained control, the
+actual implementation only supported a system-global switch semantics,
+which was simply reflected into each CPU's file. Writing a 0 or 1 into it
+would pull the other CPUs to the same state.
+For compatibility reasons this file and its behavior is still supported
+on AMD CPUs, though it is now protected by a config switch
+(X86_ACPI_CPUFREQ_CPB). On Intel CPUs this file will never be created,
+even with the config option set.
+This functionality is considered legacy and will be removed in some future
+kernel version.
+
+More fine grained boosting control
+----------------------------------
+
+Technically it is possible to switch the boosting functionality at least
+on a per package basis, for some CPUs even per core. Currently the driver
+does not support it, but this may be implemented in the future.
+
-- 
1.7.4.4


