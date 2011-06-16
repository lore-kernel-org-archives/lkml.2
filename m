Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab1FPLTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:19:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:45239 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab1FPLTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:19:41 -0400
Date: Thu, 16 Jun 2011 11:19:33 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Message-ID: <tip-f6783c4234e65bd6f85596d97745ccdbf041cb63@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        seto.hidetoshi@jp.fujitsu.com, tony.luck@intel.com, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de, tony.luck@intel.com,
        borislav.petkov@amd.com
In-Reply-To: <4DEED777.7080205@jp.fujitsu.com>
References: <4DEED777.7080205@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:ras/core] x86, mce: Cleanup mce_create()/remove_device()
Git-Commit-ID: f6783c4234e65bd6f85596d97745ccdbf041cb63
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Jun 2011 11:19:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6783c4234e65bd6f85596d97745ccdbf041cb63
Gitweb:     http://git.kernel.org/tip/f6783c4234e65bd6f85596d97745ccdbf041cb63
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Wed, 8 Jun 2011 10:59:19 +0900
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Thu, 16 Jun 2011 12:10:12 +0200

x86, mce: Cleanup mce_create()/remove_device()

Use temporary local variable sysdev to simplify the code. No change in
logic.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/4DEED777.7080205@jp.fujitsu.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
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
 
