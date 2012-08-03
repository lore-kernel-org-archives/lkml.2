Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab2HCALN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 20:11:13 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56716 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab2HCALM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 20:11:12 -0400
Date: Thu, 2 Aug 2012 17:07:08 -0700
From: Silas Boyd-Wickizer <sbw@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Harald Welte <laforge@openezx.org>, x86@kernel.org
Subject: [PATCH 3/3] Use get_online_cpus to avoid races involving
 for_each_online_cpu
Message-ID: <20120803000708.GD3443@mit.edu>
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
will attempt to platform devices with the same ID.

This fix surrounds for_each_online_cpu and register_hotcpu_notifier
with get_online_cpus+put_online_cpus.

Build tested.

Signed-off-by: Silas Boyd-Wickizer <sbw@mit.edu>
---
 drivers/hwmon/via-cputemp.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hwmon/via-cputemp.c b/drivers/hwmon/via-cputemp.c
index 8689664..9ad07c3 100644
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
-- 
1.7.10.4

