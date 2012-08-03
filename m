Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab2HCAJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 20:09:07 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50020 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2HCAJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 20:09:04 -0400
Date: Thu, 2 Aug 2012 17:05:00 -0700
From: Silas Boyd-Wickizer <sbw@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/3] Use get_online_cpus to avoid races involving
 for_each_online_cpu
Message-ID: <20120803000500.GB3443@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If arch/x86/kernel/msr.c is a module, a CPU might offline or online
between the for_each_online_cpu(i) loop and the call to
register_hotcpu_notifier in msr_init or the call to
unregister_hotcpu_notifier in msr_exit. The potential races can lead
to leaks/duplicates, attempts to destroy non-existant devices, or
random pointer dereferences.

For example, in msr_init if:

        for_each_online_cpu(i) {
                err = msr_device_create(i);
                if (err != 0)
                        goto out_class;
        }
        <----- CPU offlines
        register_hotcpu_notifier(&msr_class_cpu_notifier);

and the CPU never onlines before msr_exit, then the module will never
call msr_device_destroy for the associated CPU.

This fix surrounds for_each_online_cpu and register_hotcpu_notifier or
unregister_hotcpu_notifier with get_online_cpus+put_online_cpus.

Tested on a VM.

Signed-off-by: Silas Boyd-Wickizer <sbw@mit.edu>
---
 arch/x86/kernel/msr.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index eb11369..a7c5661 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -257,12 +257,14 @@ static int __init msr_init(void)
 		goto out_chrdev;
 	}
 	msr_class->devnode = msr_devnode;
+	get_online_cpus();
 	for_each_online_cpu(i) {
 		err = msr_device_create(i);
 		if (err != 0)
 			goto out_class;
 	}
 	register_hotcpu_notifier(&msr_class_cpu_notifier);
+	put_online_cpus();
 
 	err = 0;
 	goto out;
@@ -271,6 +273,7 @@ out_class:
 	i = 0;
 	for_each_online_cpu(i)
 		msr_device_destroy(i);
+	put_online_cpus();
 	class_destroy(msr_class);
 out_chrdev:
 	__unregister_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr");
@@ -281,11 +284,13 @@ out:
 static void __exit msr_exit(void)
 {
 	int cpu = 0;
+	get_online_cpus();
 	for_each_online_cpu(cpu)
 		msr_device_destroy(cpu);
 	class_destroy(msr_class);
 	__unregister_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr");
 	unregister_hotcpu_notifier(&msr_class_cpu_notifier);
+	put_online_cpus();
 }
 
 module_init(msr_init);
-- 
1.7.10.4

