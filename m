Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1LBTrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:47:04 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40575 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab1LBTrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:47:02 -0500
Date: Fri, 2 Dec 2011 20:46:58 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>
Subject: Re: [GIT PULL] x86, microcode fixes for 3.2
Message-ID: <20111202194658.GF15204@aftab>
References: <20111128204311.GA2814@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128204311.GA2814@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 09:43:11PM +0100, Borislav Petkov wrote:
> Hi Ingo,
> 
> please pull the following two fixes for the microcode machinery.
> 
> Thanks.
> 
> The following changes since commit caca6a03d365883564885f2c1da3e88dcf65d139:
> 
>   Linux 3.2-rc3 (2011-11-23 20:20:28 -0800)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git ucode
> 
> Borislav Petkov (1):
>       x86, microcode, AMD: Restrict microcode reporting
> 
> Srivatsa S. Bhat (1):
>       x86, microcode: Fix the failure path of microcode update driver init code

Since you haven't pulled yet, I've updated this one with the better
version below, branch above has been updated too:

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
