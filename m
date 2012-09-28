Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab2I1KkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 06:40:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45277 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab2I1KkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 06:40:04 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50657E71.4050001@jp.fujitsu.com>
Date: Fri, 28 Sep 2012 19:39:45 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <srivatsa.bhat@linux.vnet.ibm.com>, <toshi.kani@hp.com>, <lenb@kernel.org>,
        <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] acpi : prevent cpu from becoming online
References: <50657D92.3010106@jp.fujitsu.com>
In-Reply-To: <50657D92.3010106@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if acpi_processor_handle_eject() offlines cpu, there is a chance
to online the cpu after that. So the patch closes the window by using
get/put_online_cpus().

Why does the patch change _cpu_up() logic?

The patch cares the race of hot-remove cpu and _cpu_up(). If the patch
does not change it, there is the following race.

hot-remove cpu                         |  _cpu_up()
------------------------------------- ------------------------------------
call acpi_processor_handle_eject()     |
     call cpu_down()                   |
     call get_online_cpus()            |
                                       | call cpu_hotplug_begin() and stop here
     call arch_unregister_cpu()        |
     call acpi_unmap_lsapic()          |
     call put_online_cpus()            |
                                       | start and continue _cpu_up()
     return acpi_processor_remove()    |
continue hot-remove the cpu            |

So _cpu_up() can continue to itself. And hot-remove cpu can also continue
itself. If the patch changes _cpu_up() logic, the race disappears as below:

hot-remove cpu                         | _cpu_up()
-----------------------------------------------------------------------
call acpi_processor_handle_eject()     |
     call cpu_down()                   |
     call get_online_cpus()            |
                                       | call cpu_hotplug_begin() and stop here
     call arch_unregister_cpu()        |
     call acpi_unmap_lsapic()          |
          cpu's cpu_present is set     |
          to false by set_cpu_present()|
     call put_online_cpus()            |
                                       | start _cpu_up()
                                       | check cpu_present() and return -EINVAL
     return acpi_processor_remove()    |
continue hot-remove the cpu            |

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Reviewed-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
 drivers/acpi/processor_driver.c |   14 ++++++++++++++
 kernel/cpu.c                    |    8 +++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

Index: linux-3.6-rc7/drivers/acpi/processor_driver.c
===================================================================
--- linux-3.6-rc7.orig/drivers/acpi/processor_driver.c	2012-09-28 19:16:33.207858261 +0900
+++ linux-3.6-rc7/drivers/acpi/processor_driver.c	2012-09-28 19:23:05.129858476 +0900
@@ -857,8 +857,22 @@ static int acpi_processor_handle_eject(s
 			return ret;
 	}
 
+	get_online_cpus();
+	/*
+	 * The cpu might become online again at this point. So we check whether
+	 * the cpu has been onlined or not. If the cpu became online, it means
+	 * that someone wants to use the cpu. So acpi_processor_handle_eject()
+	 * returns -EAGAIN.
+	 */
+	if (unlikely(cpu_online(pr->id))) {
+		put_online_cpus();
+		pr_warn("Failed to remove CPU %d, because other task "
+			"brought the CPU back online\n", pr->id);
+		return -EAGAIN;
+	}
 	arch_unregister_cpu(pr->id);
 	acpi_unmap_lsapic(pr->id);
+	put_online_cpus();
 	return ret;
 }
 #else
Index: linux-3.6-rc7/kernel/cpu.c
===================================================================
--- linux-3.6-rc7.orig/kernel/cpu.c	2012-09-24 10:10:57.000000000 +0900
+++ linux-3.6-rc7/kernel/cpu.c	2012-09-28 19:19:32.321858402 +0900
@@ -343,11 +343,13 @@ static int __cpuinit _cpu_up(unsigned in
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct task_struct *idle;
 
-	if (cpu_online(cpu) || !cpu_present(cpu))
-		return -EINVAL;
-
 	cpu_hotplug_begin();
 
+	if (cpu_online(cpu) || !cpu_present(cpu)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	idle = idle_thread_get(cpu);
 	if (IS_ERR(idle)) {
 		ret = PTR_ERR(idle);


