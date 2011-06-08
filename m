Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab1FHB7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 21:59:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49857 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab1FHB7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 21:59:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DEED777.7080205@jp.fujitsu.com>
Date: Wed, 08 Jun 2011 10:59:19 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@gmail.com>
Subject: [PATCH 09/12] x86, mce: cleanup mce_create/remove_device
References: <4DEED509.1040504@jp.fujitsu.com>
In-Reply-To: <4DEED509.1040504@jp.fujitsu.com>
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
index 2cc98d5..f3f648c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1925,28 +1925,28 @@ static cpumask_var_t mce_dev_initialized;
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
@@ -1955,30 +1955,31 @@ static __cpuinit int mce_create_device(unsigned int cpu)
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


