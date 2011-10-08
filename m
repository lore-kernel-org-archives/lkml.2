Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1JHUtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 16:49:22 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:40332 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1JHUtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 16:49:20 -0400
Message-ID: <4E90B6F9.8020804@linux.vnet.ibm.com>
Date: Sun, 09 Oct 2011 02:17:53 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, mingo@redhat.com,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        andreas.herrmann3@amd.com, amd64-microcode@amd64.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] CPU hotplug,x86 Microcode: Don't request microcode from userspace
 unnecessarily
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11100811-3568-0000-0000-0000007D5EB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Requesting the microcode from userspace *every time* when onlining CPUs
(during a CPU hotplug operation) is unnecessary.

So, this patch ensures that once the kernel gets the microcode after booting,
it is not freed nor invalidated when a CPU goes offline, so that it can be
reused when that CPU comes back online, without requesting userspace for it
again. As a result, the CPU hotplug operations become faster as well.

Tested-by: Borislav Petkov <bp@amd64.org>
Acked-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kernel/microcode_core.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index f924280..3fd0189 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -483,7 +483,13 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
 		pr_debug("CPU%d removed\n", cpu);
 		break;
-	case CPU_DEAD:
+
+	/* When a CPU goes offline, don't free up or invalidate the copy of
+	 * the microcode in kernel memory, so that we can reuse it when the
+	 * CPU comes back online without unnecessarily requesting the userspace
+	 * for it again.
+	 */
+
 	case CPU_UP_CANCELED_FROZEN:
 		/* The CPU refused to come up during a system resume */
 		microcode_fini_cpu(cpu);


