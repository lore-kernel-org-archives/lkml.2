Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab1JBTFY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 15:05:24 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:59039 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab1JBTFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 15:05:19 -0400
Message-ID: <4E88B5E0.6080503@linux.vnet.ibm.com>
Date: Mon, 03 Oct 2011 00:35:04 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Tejun Heo <tj@kernel.org>, tigran@aivazian.fsnet.co.uk, tglx@linutronix.de,
        mingo@elte.hu, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [BUGFIX][PATCH] Freezer, CPU hotplug, x86 Microcode: Fix task freezing
 failures
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch addresses the warnings found in the logs in the
task freezing failure bug reported in https://lkml.org/lkml/2011/9/5/28

The warnings appear because of the reason explained below:

There are microcode callbacks registered for CPU hotplug events such
as a CPU getting offlined or onlined. When a CPU is offlined
with tasks being frozen (as in the case of disabling the non-boot CPUs
while preparing for a system suspend operation), the CPU_DEAD_FROZEN
notification is sent, for which the microcode callback does not
do anything. In particular, it does not free or invalidate the CPU
microcode which it had got from userspace earlier. Hence when that CPU
comes back online with tasks being frozen (as in the case of re-enabling
the non-boot CPUs during a resume operation after suspend), the microcode
callback applies the microcode (which it already possesses) to that CPU.

However, during a pure CPU hotplug operation, tasks are not frozen and
hence the CPU_DEAD notification is sent. Upon this event notification,
the microcode callback frees the copy of microcode it has and
invalidates it. And during a CPU online, it tries to apply the microcode
to the CPU, but since it doesn't have the copy of the microcode, it depends
on a userspace utility to get the microcode. This is perfectly fine when
doing plain CPU hotplug operations alone.

Things go wrong when a CPU hotplug stress test is carried out along with
a suspend/resume operation running simultaneously. Upon getting a CPU_DEAD
notification (for example, when a CPU offline occurs with tasks not frozen),
the microcode callback frees up the microcode and invalidates it. Later
when that CPU gets onlined with tasks being frozen, the microcode callback
(for the CPU_ONLINE_FROZEN event) tries to apply the microcode to the CPU;
doesn't find it and hence depends on the (currently frozen) userspace to
get the microcode again. This leads to the numerous "WARNING"s at
drivers/base/firmware_class.c which eventually leads to task freezing failures
in the suspend code path, as has been reported.

So, this patch addresses this issue by ensuring that microcode is not freed
from kernel memory, nor invalidated when a CPU goes offline. Thus once the
kernel gets the microcode during boot-up, it will never have to depend on
userspace ever again to get microcode, since it never releases the copy it
already has. So every run of the microcode callback for CPU online event will
now succeed irrespective of whether userspace is frozen or not. As a result,
this fixes the task freezing failure encountered while running CPU hotplug
stress test along with suspend/resume operations simultaneously.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kernel/microcode_core.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index f924280..cd7ef2f 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -483,7 +483,15 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
 		pr_debug("CPU%d removed\n", cpu);
 		break;
-	case CPU_DEAD:
+
+	/*
+	 * Do not invalidate the microcode if a CPU goes offline,
+	 * because it would be impossible to get the microcode again
+	 * from userspace when the CPU comes back up, if the userspace
+	 * happens to be frozen at that moment by the freezer subsystem,
+	 * for example, due to a suspend operation in progress.
+	 */
+
 	case CPU_UP_CANCELED_FROZEN:
 		/* The CPU refused to come up during a system resume */
 		microcode_fini_cpu(cpu);


