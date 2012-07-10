Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab2GJGJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:09:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51984 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab2GJGJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:09:18 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FFBC703.8010604@jp.fujitsu.com>
Date: Tue, 10 Jul 2012 15:09:07 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lenb@kernel.org>, <srivatsa.bhat@linux.vnet.ibm.com>,
        <toshi.kani@hp.com>
Subject: [PATCH v2 2/3] acpi : prevent cpu from becoming online
References: <4FFBC66B.7030606@jp.fujitsu.com>
In-Reply-To: <4FFBC66B.7030606@jp.fujitsu.com>
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
itself. If the patch changes _cpu_cp() logic, the race disappears as below:

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

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
 drivers/acpi/processor_driver.c |   12 ++++++++++++
 kernel/cpu.c                    |    8 +++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

Index: linux-3.5-rc6/drivers/acpi/processor_driver.c
===================================================================
--- linux-3.5-rc6.orig/drivers/acpi/processor_driver.c	2012-07-10 13:58:20.862931557 +0900
+++ linux-3.5-rc6/drivers/acpi/processor_driver.c	2012-07-10 14:05:46.318365136 +0900
@@ -850,8 +850,18 @@ static int acpi_processor_handle_eject(s
 			return ret;
 	}

+	get_online_cpus();
+	/*
+	 * Someone might online the cpu again at this point. So we check that
+	 * cpu has been onlined or not. If cpu is online, it returns -EBUSY.
+	 */
+	if (unlikely(cpu_online(pr->id))) {
+		put_online_cpus();
+		return -EBUSY;
+	}
 	arch_unregister_cpu(pr->id);
 	acpi_unmap_lsapic(pr->id);
+	put_online_cpus();
 	return ret;
 }
 #else
Index: linux-3.5-rc6/kernel/cpu.c
===================================================================
--- linux-3.5-rc6.orig/kernel/cpu.c	2012-07-08 09:23:56.000000000 +0900
+++ linux-3.5-rc6/kernel/cpu.c	2012-07-10 14:15:26.065113805 +0900
@@ -343,11 +343,14 @@ static int __cpuinit _cpu_up(unsigned in
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct task_struct *idle;

-	if (cpu_online(cpu) || !cpu_present(cpu))
-		return -EINVAL;
-
 	cpu_hotplug_begin();

+	if (cpu_online(cpu) || !cpu_present(cpu)) {
+		ret =  -EINVAL;
+		goto out;
+	}
+
+
 	idle = idle_thread_get(cpu);
 	if (IS_ERR(idle)) {
 		ret = PTR_ERR(idle);

