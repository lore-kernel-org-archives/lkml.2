Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab1LERkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:40:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58724 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab1LERkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:40:01 -0500
Date: Mon, 5 Dec 2011 09:39:44 -0800
From: "tip-bot for Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Message-ID: <tip-bd399063976c6c7a09beb4730ed1d93cadbcc739@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        JBeulich@suse.com, srivatsa.bhat@linux.vnet.ibm.com,
        tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, tglx@linutronix.de,
        srivatsa.bhat@linux.vnet.ibm.com, borislav.petkov@amd.com
In-Reply-To: <4ED8E2270200007800065120@nat28.tlf.novell.com>
References: <20111107123530.12164.31227.stgit@srivatsabhat.in.ibm.com>
	<4ED8E2270200007800065120@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, microcode: Fix the failure path of microcode update driver init code
Git-Commit-ID: bd399063976c6c7a09beb4730ed1d93cadbcc739
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 09:39:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd399063976c6c7a09beb4730ed1d93cadbcc739
Gitweb:     http://git.kernel.org/tip/bd399063976c6c7a09beb4730ed1d93cadbcc739
Author:     Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
AuthorDate: Mon, 7 Nov 2011 18:05:32 +0530
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Mon, 5 Dec 2011 14:21:01 +0100

x86, microcode: Fix the failure path of microcode update driver init code

The microcode update driver's initialization code does not handle
failures correctly. This patch fixes this issue.

Signed-off-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20111107123530.12164.31227.stgit@srivatsabhat.in.ibm.com
Link: http://lkml.kernel.org/r/4ED8E2270200007800065120@nat28.tlf.novell.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_core.c |   28 +++++++++++++++++++---------
 1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index f2d2a66..9d46f5e 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -256,7 +256,7 @@ static int __init microcode_dev_init(void)
 	return 0;
 }
 
-static void microcode_dev_exit(void)
+static void __exit microcode_dev_exit(void)
 {
 	misc_deregister(&microcode_dev);
 }
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
@@ -548,6 +544,20 @@ static int __init microcode_init(void)
 		" <tigran@aivazian.fsnet.co.uk>, Peter Oruba\n");
 
 	return 0;
+
+out_sysdev_driver:
+	get_online_cpus();
+	mutex_lock(&microcode_mutex);
+
+	sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
+
+	mutex_unlock(&microcode_mutex);
+	put_online_cpus();
+
+out_pdev:
+	platform_device_unregister(microcode_pdev);
+	return error;
+
 }
 module_init(microcode_init);
 
