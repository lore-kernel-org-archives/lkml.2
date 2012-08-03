Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab2HCTkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 15:40:47 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36891 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab2HCTko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 15:40:44 -0400
Date: Fri, 3 Aug 2012 12:36:39 -0700
From: Silas Boyd-Wickizer <sbw@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Harald Welte <laforge@openezx.org>, x86@kernel.org
Subject: [PATCH 4/4 V2] Use get_online_cpus to avoid races involving CPU
 hotplug
Message-ID: <20120803193638.GE4227@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

coretemp_init in drivers/hwmon/coretemp.c loops with
for_each_online_cpu, adding platform_devices and sysfs interfaces,
then calls register_hotcpu_notifier.  There is a race if a CPU is
offlined or onlined after the loop, but before
register_hotcpu_notifier.  The race might result in the absence of a
platform_device+sysfs interface for an online CPU, or the presence of
a platform_device+sysfs interface for an offline CPU.  A similar race
occurs during coretemp_exit, after the module calls
unregister_hotcpu_notifier, but before it unregisters all devices, a
CPU might offline and a device for an offline CPU will exist for a
short while.

This fix surrounds for_each_online_cpu and register_hotcpu_notifier
with get_online_cpus+put_online_cpus; and surrounds
unregister_hotcpu_notifier and device unregistering with
get_online_cpus+put_online_cpus.

Build tested.

Signed-off-by: Silas Boyd-Wickizer <sbw@mit.edu>
---
 drivers/hwmon/coretemp.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 637c51c..9483e90 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -815,17 +815,20 @@ static int __init coretemp_init(void)
 	if (err)
 		goto exit;
 
+	get_online_cpus();
 	for_each_online_cpu(i)
 		get_core_online(i);
 
 #ifndef CONFIG_HOTPLUG_CPU
 	if (list_empty(&pdev_list)) {
+		put_online_cpus();
 		err = -ENODEV;
 		goto exit_driver_unreg;
 	}
 #endif
 
 	register_hotcpu_notifier(&coretemp_cpu_notifier);
+	put_online_cpus();
 	return 0;
 
 #ifndef CONFIG_HOTPLUG_CPU
@@ -840,6 +843,7 @@ static void __exit coretemp_exit(void)
 {
 	struct pdev_entry *p, *n;
 
+	get_online_cpus();
 	unregister_hotcpu_notifier(&coretemp_cpu_notifier);
 	mutex_lock(&pdev_list_mutex);
 	list_for_each_entry_safe(p, n, &pdev_list, list) {
@@ -848,6 +852,7 @@ static void __exit coretemp_exit(void)
 		kfree(p);
 	}
 	mutex_unlock(&pdev_list_mutex);
+	put_online_cpus();
 	platform_driver_unregister(&coretemp_driver);
 }
 
-- 
1.7.10.4

