Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1JITmN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 15:42:13 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39231 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1JITmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 15:42:09 -0400
Message-ID: <4E91F908.5010006@linux.vnet.ibm.com>
Date: Mon, 10 Oct 2011 01:12:00 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Borislav Petkov <borislav.petkov@amd.com>, Borislav Petkov <bp@amd64.org>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "amd64-microcode@amd64.org" <amd64-microcode@amd64.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] CPU hotplug,x86 Microcode: Don't request microcode
 from userspace unnecessarily
References: <4E90B6F9.8020804@linux.vnet.ibm.com> <20111009112755.GC17926@aftab> <4E91F82E.4080007@linux.vnet.ibm.com>
In-Reply-To: <4E91F82E.4080007@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

 arch/x86/kernel/microcode_core.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index f924280..33c8a67 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -483,7 +483,14 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
 		pr_debug("CPU%d removed\n", cpu);
 		break;
-	case CPU_DEAD:
+
+	/*
+	 * When a CPU goes offline, don't free up or invalidate the copy of
+	 * the microcode in kernel memory, so that we can reuse it when the
+	 * CPU comes back online without unnecessarily requesting the userspace
+	 * for it again.
+	 */
+
 	case CPU_UP_CANCELED_FROZEN:
 		/* The CPU refused to come up during a system resume */
 		microcode_fini_cpu(cpu);


