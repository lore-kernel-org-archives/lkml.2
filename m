Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab2LKFOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 00:14:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:40994 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab2LKFOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 00:14:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,256,1355126400"; 
   d="scan'208";a="262219159"
Subject: [PATCH] smpboot: calling smpboot_register_percpu_thread is unsafe
 during one CPU being down
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tglx@linutronix.de, paul.mckenney@linaro.org,
        srivatsa.bhat@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Dec 2012 22:17:47 +0800
Message-ID: <1355235467.6184.10.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When one CPU is going down, and smpboot_register_percpu_thread is called,
there is the race issue below:
T1(CPUA):                                      T2(CPUB):
_cpu_down()                                    smpboot_register_percpu_thread()
  smpboot_park_threads()                       ...
  __stop_machine()                               __smpboot_create_thread(CPU_Dying)
                                                 [Currently, the being down CPU is online yet]
    take_cpu_down()                              smpboot_unpark_thread(CPU_Dying)
      __cpu_disable()                              ....
        native_cpu_disable()
   ....                                          Here the new kthread will get running
                                                 based on the CPU_Dying
        set_cpu_online(cpu, false)
   ....
   cpu_notify(CPU_DYING)

After notified the CPU_DYING, the new created kthead for dying CPU will
be migrated to another CPU in migration_call().

Here we need use get_online_cpus()/put_online_cpus() when calling
function smpboot_register_percpu_thread().

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/smpboot.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index d6c5fc0..3fe708a 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -266,6 +266,7 @@ int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
 	unsigned int cpu;
 	int ret = 0;
 
+	get_online_cpus();
 	mutex_lock(&smpboot_threads_lock);
 	for_each_online_cpu(cpu) {
 		ret = __smpboot_create_thread(plug_thread, cpu);
@@ -278,6 +279,7 @@ int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
 	list_add(&plug_thread->list, &hotplug_threads);
 out:
 	mutex_unlock(&smpboot_threads_lock);
+	put_online_cpus();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(smpboot_register_percpu_thread);
-- 
1.7.0.4



