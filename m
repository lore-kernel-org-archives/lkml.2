Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab2HCTjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 15:39:35 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46219 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab2HCTjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 15:39:33 -0400
Date: Fri, 3 Aug 2012 12:35:28 -0700
From: Silas Boyd-Wickizer <sbw@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Harald Welte <laforge@openezx.org>, x86@kernel.org
Subject: [PATCH 3/4 V2] Use get_online_cpus to avoid races involving CPU
 hotplug
Message-ID: <20120803193528.GD4227@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

via_cputemp_init in drivers/hwmon/via-cputemp.c loops with
for_each_online_cpu, adding platform_devices, then calls
register_hotcpu_notifier.  If a CPU is offlined between the loop and
register_hotcpu_notifier, then later onlined, via_cputemp_device_add
will attempt to add platform devices with the same ID.  A similar race
occurs during via_cputemp_exit, after the module calls
unregister_hotcpu_notifier, a CPU might offline and a device will
exist for a CPU that is offline.

This fix surrounds for_each_online_cpu and register_hotcpu_notifier
with get_online_cpus+put_online_cpus; and surrounds
unregister_hotcpu_notifier and device unregistering with
get_online_cpus+put_online_cpus.

Build tested.

Signed-off-by: Silas Boyd-Wickizer <sbw@mit.edu>
---
 drivers/hwmon/via-cputemp.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwmon/via-cputemp.c b/drivers/hwmon/via-cputemp.c
index 8689664..54b01ac 100644
--- a/drivers/hwmon/via-cputemp.c
+++ b/drivers/hwmon/via-cputemp.c
@@ -328,6 +328,7 @@ static int __init via_cputemp_init(void)
 	if (err)
 		goto exit;
 
+	get_online_cpus();
 	for_each_online_cpu(i) {
 		struct cpuinfo_x86 *c = &cpu_data(i);
 
@@ -347,12 +348,14 @@ static int __init via_cputemp_init(void)
 
 #ifndef CONFIG_HOTPLUG_CPU
 	if (list_empty(&pdev_list)) {
+		put_online_cpus();
 		err = -ENODEV;
 		goto exit_driver_unreg;
 	}
 #endif
 
 	register_hotcpu_notifier(&via_cputemp_cpu_notifier);
+	put_online_cpus();
 	return 0;
 
 #ifndef CONFIG_HOTPLUG_CPU
@@ -367,6 +370,7 @@ static void __exit via_cputemp_exit(void)
 {
 	struct pdev_entry *p, *n;
 
+	get_online_cpus();
 	unregister_hotcpu_notifier(&via_cputemp_cpu_notifier);
 	mutex_lock(&pdev_list_mutex);
 	list_for_each_entry_safe(p, n, &pdev_list, list) {
@@ -375,6 +379,7 @@ static void __exit via_cputemp_exit(void)
 		kfree(p);
 	}
 	mutex_unlock(&pdev_list_mutex);
+	put_online_cpus();
 	platform_driver_unregister(&via_cputemp_driver);
 }
 
-- 
1.7.10.4

