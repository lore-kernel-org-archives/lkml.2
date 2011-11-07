Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1KGMfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:35:41 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:39074 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab1KGMfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:35:40 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] x86 Microcode: Fix the failure path of microcode update
 driver init code
To: tigran@aivazian.fsnet.co.uk
Cc: tglx@linutronix.de, bp@amd64.org, mingo@elte.hu, hpa@zytor.com,
        andreas.herrmann3@amd.com, amd64-microcode@amd64.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 07 Nov 2011 18:05:32 +0530
Message-ID: <20111107123530.12164.31227.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11110712-2674-0000-0000-0000011A4CC9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The microcode update driver's initialization code does not handle failures
correctly. This patch fixes this issue.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kernel/microcode_core.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index f2d2a66..c7bdbfa 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -519,10 +519,8 @@ static int __init microcode_init(void)
 
 	microcode_pdev = platform_device_register_simple("microcode", -1,
 							 NULL, 0);
-	if (IS_ERR(microcode_pdev)) {
-		microcode_dev_exit();
+	if (IS_ERR(microcode_pdev))
 		return PTR_ERR(microcode_pdev);
-	}
 
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
@@ -532,14 +530,12 @@ static int __init microcode_init(void)
 	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
 
-	if (error) {
-		platform_device_unregister(microcode_pdev);
-		return error;
-	}
+	if (error)
+		goto out_pdev;
 
 	error = microcode_dev_init();
 	if (error)
-		return error;
+		goto out_sysdev_driver;
 
 	register_syscore_ops(&mc_syscore_ops);
 	register_hotcpu_notifier(&mc_cpu_notifier);
@@ -548,6 +544,13 @@ static int __init microcode_init(void)
 		" <tigran@aivazian.fsnet.co.uk>, Peter Oruba\n");
 
 	return 0;
+
+out_sysdev_driver:
+	sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
+out_pdev:
+	platform_device_unregister(microcode_pdev);
+	return error;
+
 }
 module_init(microcode_init);
 

