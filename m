Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2H2Hnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 03:43:41 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:43271 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab2H2Hnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 03:43:39 -0400
Subject: [PATCH RFC] x86/mce: Move MCE sysfs attributes out of the per-cpu
 location
To: tony.luck@intel.com, andi@firstfloor.org, bp@amd64.org
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: ananth@in.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        linux-edac@vger.kernel.org
Date: Wed, 29 Aug 2012 13:11:55 +0530
Message-ID: <20120829074154.6755.98941.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12082907-0260-0000-0000-000001C34AEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the MCE attributes currently exported via sysfs appear under
/sys/devices/system/machinecheck/machinecheck<n>/. Pretty much all of these
are global in nature and not specific to a processor. We have around 7
attributes duplicated across each processor and on multi-core multi-socket
machines, this amounts to quite a large number. So, move these out under
/sys/devices/system/machinecheck/ where they rightly belong.

Note: I'm not sure if it's ok to change sysfs entries and this does break
userspace tools that depend on the current path for some of these attributes.
So, they will need to be updated to use the new path. However, if we ever get
to a point where cpu0 can be offlined, these tools will need to be updated
anyway (as they mostly hardcode machinecheck0 currently)

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   46 ++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index c311122..c8eeaa6 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2205,17 +2205,26 @@ static struct dev_ext_attribute dev_attr_cmci_disabled = {
 	&mce_cmci_disabled
 };
 
-static struct device_attribute *mce_device_attrs[] = {
-	&dev_attr_tolerant.attr,
-	&dev_attr_check_interval.attr,
-	&dev_attr_trigger,
-	&dev_attr_monarch_timeout.attr,
-	&dev_attr_dont_log_ce.attr,
-	&dev_attr_ignore_ce.attr,
-	&dev_attr_cmci_disabled.attr,
+static struct attribute *mce_device_attrs[] = {
+	&dev_attr_tolerant.attr.attr,
+	&dev_attr_check_interval.attr.attr,
+	&dev_attr_trigger.attr,
+	&dev_attr_monarch_timeout.attr.attr,
+	&dev_attr_dont_log_ce.attr.attr,
+	&dev_attr_ignore_ce.attr.attr,
+	&dev_attr_cmci_disabled.attr.attr,
 	NULL
 };
 
+static struct attribute_group mce_device_attr_group = {
+	.attrs = mce_device_attrs,
+};
+
+static const struct attribute_group *mce_device_attr_groups[] = {
+	&mce_device_attr_group,
+	NULL,
+};
+
 static cpumask_var_t mce_device_initialized;
 
 static void mce_device_release(struct device *dev)
@@ -2228,7 +2237,7 @@ static __cpuinit int mce_device_create(unsigned int cpu)
 {
 	struct device *dev;
 	int err;
-	int i, j;
+	int i;
 
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
@@ -2244,26 +2253,18 @@ static __cpuinit int mce_device_create(unsigned int cpu)
 	if (err)
 		return err;
 
-	for (i = 0; mce_device_attrs[i]; i++) {
-		err = device_create_file(dev, mce_device_attrs[i]);
+	for (i = 0; i < banks; i++) {
+		err = device_create_file(dev, &mce_banks[i].attr);
 		if (err)
 			goto error;
 	}
-	for (j = 0; j < banks; j++) {
-		err = device_create_file(dev, &mce_banks[j].attr);
-		if (err)
-			goto error2;
-	}
 	cpumask_set_cpu(cpu, mce_device_initialized);
 	per_cpu(mce_device, cpu) = dev;
 
 	return 0;
-error2:
-	while (--j >= 0)
-		device_remove_file(dev, &mce_banks[j].attr);
 error:
 	while (--i >= 0)
-		device_remove_file(dev, mce_device_attrs[i]);
+		device_remove_file(dev, &mce_banks[i].attr);
 
 	device_unregister(dev);
 
@@ -2278,9 +2279,6 @@ static __cpuinit void mce_device_remove(unsigned int cpu)
 	if (!cpumask_test_cpu(cpu, mce_device_initialized))
 		return;
 
-	for (i = 0; mce_device_attrs[i]; i++)
-		device_remove_file(dev, mce_device_attrs[i]);
-
 	for (i = 0; i < banks; i++)
 		device_remove_file(dev, &mce_banks[i].attr);
 
@@ -2397,7 +2395,7 @@ static __init int mcheck_init_device(void)
 
 	mce_init_banks();
 
-	err = subsys_system_register(&mce_subsys, NULL);
+	err = subsys_system_register(&mce_subsys, mce_device_attr_groups);
 	if (err)
 		return err;
 

