Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab2IEKYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:24:16 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:55118 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758578Ab2IEKYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:24:11 -0400
Subject: [PATCH 1/3] x86/mce: Make sysfs tunables available globally across
 all cpus
To: tony.luck@intel.com, andi@firstfloor.org, bp@amd64.org
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: gong.chen@linux.intel.com, ananth@in.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, gregkh@suse.de, linux-edac@vger.kernel.org
Date: Wed, 05 Sep 2012 15:51:56 +0530
Message-ID: <20120905102156.9423.27806.stgit@localhost.localdomain>
In-Reply-To: <20120905102049.9423.6413.stgit@localhost.localdomain>
References: <20120905102049.9423.6413.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12090510-2674-0000-0000-000005DA481A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the MCE attributes currently exported via sysfs appear under
/sys/devices/system/machinecheck/machinecheck<n>/. Pretty much all of
these are global in nature and not specific to a processor. So, make these
available under /sys/devices/system/machinecheck/ where they rightly belong.
Update documentation to also point to the new location so that user-space
tools can pick up on the new location. We would eventually want to remove
these from the per-cpu location.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 Documentation/x86/x86_64/machinecheck |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce.c      |   24 +++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86/x86_64/machinecheck b/Documentation/x86/x86_64/machinecheck
index b1fb302..02b84a6 100644
--- a/Documentation/x86/x86_64/machinecheck
+++ b/Documentation/x86/x86_64/machinecheck
@@ -31,8 +31,8 @@ bankNctl
 	Note that BIOS maintain another mask to disable specific events
 	per bank.  This is not visible here
 
-The following entries appear for each CPU, but they are truly shared
-between all CPUs.
+The following entries are shared between all CPUs and appear under
+/sys/devices/system/machinecheck:
 
 check_interval
 	How often to poll for corrected machine check errors, in seconds
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index c311122..bf276eb 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2205,6 +2205,7 @@ static struct dev_ext_attribute dev_attr_cmci_disabled = {
 	&mce_cmci_disabled
 };
 
+/* Use this _only_ for per-cpu attributes */
 static struct device_attribute *mce_device_attrs[] = {
 	&dev_attr_tolerant.attr,
 	&dev_attr_check_interval.attr,
@@ -2216,6 +2217,27 @@ static struct device_attribute *mce_device_attrs[] = {
 	NULL
 };
 
+/* All new global attributes go here */
+static struct attribute *mce_device_global_attrs[] = {
+	&dev_attr_tolerant.attr.attr,
+	&dev_attr_check_interval.attr.attr,
+	&dev_attr_trigger.attr,
+	&dev_attr_monarch_timeout.attr.attr,
+	&dev_attr_dont_log_ce.attr.attr,
+	&dev_attr_ignore_ce.attr.attr,
+	&dev_attr_cmci_disabled.attr.attr,
+	NULL
+};
+
+static struct attribute_group mce_device_attr_group = {
+	.attrs = mce_device_global_attrs,
+};
+
+static const struct attribute_group *mce_device_attr_groups[] = {
+	&mce_device_attr_group,
+	NULL,
+};
+
 static cpumask_var_t mce_device_initialized;
 
 static void mce_device_release(struct device *dev)
@@ -2397,7 +2419,7 @@ static __init int mcheck_init_device(void)
 
 	mce_init_banks();
 
-	err = subsys_system_register(&mce_subsys, NULL);
+	err = subsys_system_register(&mce_subsys, mce_device_attr_groups);
 	if (err)
 		return err;
 

