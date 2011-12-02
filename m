Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1LBTpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:45:24 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40552 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1LBTpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:45:23 -0500
Date: Fri, 2 Dec 2011 20:45:18 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Jan Beulich <JBeulich@suse.com>, Borislav Petkov <bp@amd64.org>,
        mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [PATCH] x86: fix error paths in microcode_init()
Message-ID: <20111202194518.GE15204@aftab>
References: <4ED8E2270200007800065120@nat28.tlf.novell.com>
 <20111202143517.GA16690@gere.osrc.amd.com>
 <4ED8F46E0200007800065178@nat28.tlf.novell.com>
 <4ED8EB7D.5070802@linux.vnet.ibm.com>
 <20111202152403.GB16690@gere.osrc.amd.com>
 <4ED8FDE102000078000651E5@nat28.tlf.novell.com>
 <4ED8FF7C.2090509@linux.vnet.ibm.com>
 <4ED90EBF02000078000652BE@nat28.tlf.novell.com>
 <4ED901F5.3080302@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED901F5.3080302@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 10:21:01PM +0530, Srivatsa S. Bhat wrote:
> Wow! Good to know that we have an agreement :-)
> Boris, it is again up to you to choose among the two(Signed-off-by or Acked-by)
> for Jan. Hehe ;-)

Well,

since Ingo hasn't pulled yet, I merged the two patches after adding the
required S-O-Bs into the following:

--
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Mon, 7 Nov 2011 18:05:32 +0530
Subject: [PATCH] x86, microcode: Fix the failure path of microcode update
 driver init code

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
 
-- 
1.7.8.rc0



-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
