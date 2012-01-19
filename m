Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab2ASV01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 16:26:27 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1334 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993Ab2ASV00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 16:26:26 -0500
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jan 2012 16:26:26 EST
X-Mailer: QUALCOMM Windows Eudora Version 7.1.0.9
Date: Thu, 19 Jan 2012 22:18:10 +0100
To: linux-kernel@vger.kernel.org
From: "N. Coesel" <nico@nctdev.nl>
Subject: Cpufreq shutdown patch (kernel 2.6.35.3)
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Message-ID: <CPSMTPM-CMT109lZGdO0011ecc5@CPSMTPM-CMT109.kpnxchange.com>
X-OriginalArrivalTime: 19 Jan 2012 21:20:09.0190 (UTC) FILETIME=[1F434860:01CCD6F0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear readers,
I've found a problem in drivers/cpufreq/cpufreq.c. The driver does 
not execute the exit member of the low level driver when shutting 
down for a reboot (reset). This potentially leaves the power supply 
at a too low voltage to boot the system properly. The patch below 
adds a shutdown function which executes the exit member of the low 
level driver which allows a system to be properly prepared for a reset.

--- drivers/cpufreq/cpufreq.c.orig      2010-08-20 20:55:55.000000000 +0200
+++ drivers/cpufreq/cpufreq.c   2012-01-19 21:50:46.000000000 +0100
@@ -1431,11 +1431,34 @@ fail:
         return ret;
  }

+
+static int cpufreq_shutdown(struct sys_device *sysdev)
+{
+       struct cpufreq_policy *cpu_policy;
+       int cpu = sysdev->id;
+       int ret =0;
+
+       if (!cpu_online(cpu))
+               return 0;
+
+       cpu_policy = cpufreq_cpu_get(cpu);
+       if (!cpu_policy)
+               return -EINVAL;
+
+//     printk("cpufreq_shutdown %d \n", cpu);
+       if (cpufreq_driver->exit)
+               ret = cpufreq_driver->exit(cpu_policy);
+
+       return ret;
+}
+
+
  static struct sysdev_driver cpufreq_sysdev_driver = {
         .add            = cpufreq_add_dev,
         .remove         = cpufreq_remove_dev,
         .suspend        = cpufreq_suspend,
         .resume         = cpufreq_resume,
+       .shutdown = cpufreq_shutdown,
  };



Signed of by: Nico Coesel nico@nctdev.nl


