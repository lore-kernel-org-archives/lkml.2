Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab1E0ELN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 00:11:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52809 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1E0ELM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 00:11:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDF244D.8000005@jp.fujitsu.com>
Date: Fri, 27 May 2011 13:10:53 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 09/12] x86, mce: cleanup mce_create/remove_device
References: <4DDF21DE.9040705@jp.fujitsu.com>
In-Reply-To: <4DDF21DE.9040705@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use temporary local sysdev to make code simple.
No change in logic.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2628743..9fe9e6e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1921,28 +1921,28 @@ static cpumask_var_t mce_dev_initialized;
 /* Per cpu sysdev init. All of the cpus still share the same ctrl bank: */
 static __cpuinit int mce_create_device(unsigned int cpu)
 {
+	struct sys_device *sysdev = &per_cpu(mce_dev, cpu);
 	int err;
 	int i, j;
 
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 
-	memset(&per_cpu(mce_dev, cpu).kobj, 0, sizeof(struct kobject));
-	per_cpu(mce_dev, cpu).id	= cpu;
-	per_cpu(mce_dev, cpu).cls	= &mce_sysclass;
+	memset(&sysdev->kobj, 0, sizeof(struct kobject));
+	sysdev->id  = cpu;
+	sysdev->cls = &mce_sysclass;
 
-	err = sysdev_register(&per_cpu(mce_dev, cpu));
+	err = sysdev_register(sysdev);
 	if (err)
 		return err;
 
 	for (i = 0; mce_attrs[i]; i++) {
-		err = sysdev_create_file(&per_cpu(mce_dev, cpu), mce_attrs[i]);
+		err = sysdev_create_file(sysdev, mce_attrs[i]);
 		if (err)
 			goto error;
 	}
 	for (j = 0; j < banks; j++) {
-		err = sysdev_create_file(&per_cpu(mce_dev, cpu),
-					&mce_banks[j].attr);
+		err = sysdev_create_file(sysdev, &mce_banks[j].attr);
 		if (err)
 			goto error2;
 	}
@@ -1951,30 +1951,31 @@ static __cpuinit int mce_create_device(unsigned int cpu)
 	return 0;
 error2:
 	while (--j >= 0)
-		sysdev_remove_file(&per_cpu(mce_dev, cpu), &mce_banks[j].attr);
+		sysdev_remove_file(sysdev, &mce_banks[j].attr);
 error:
 	while (--i >= 0)
-		sysdev_remove_file(&per_cpu(mce_dev, cpu), mce_attrs[i]);
+		sysdev_remove_file(sysdev, mce_attrs[i]);
 
-	sysdev_unregister(&per_cpu(mce_dev, cpu));
+	sysdev_unregister(sysdev);
 
 	return err;
 }
 
 static __cpuinit void mce_remove_device(unsigned int cpu)
 {
+	struct sys_device *sysdev = &per_cpu(mce_dev, cpu);
 	int i;
 
 	if (!cpumask_test_cpu(cpu, mce_dev_initialized))
 		return;
 
 	for (i = 0; mce_attrs[i]; i++)
-		sysdev_remove_file(&per_cpu(mce_dev, cpu), mce_attrs[i]);
+		sysdev_remove_file(sysdev, mce_attrs[i]);
 
 	for (i = 0; i < banks; i++)
-		sysdev_remove_file(&per_cpu(mce_dev, cpu), &mce_banks[i].attr);
+		sysdev_remove_file(sysdev, &mce_banks[i].attr);
 
-	sysdev_unregister(&per_cpu(mce_dev, cpu));
+	sysdev_unregister(sysdev);
 	cpumask_clear_cpu(cpu, mce_dev_initialized);
 }
 
-- 
1.7.1


