Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab1LENXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:23:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57453 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab1LENXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:23:33 -0500
Date: Mon, 5 Dec 2011 05:23:13 -0800
From: tip-bot for Don Zickus <dzickus@redhat.com>
Message-ID: <tip-bda62633983f9db49ce0b1a9235b3709c1cda5f0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andi@firstfloor.org, torvalds@linux-foundation.org,
        peterz@infradead.org, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, torvalds@linux-foundation.org,
        peterz@infradead.org, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu, dzickus@redhat.com
In-Reply-To: <1318533267-18880-4-git-send-email-dzickus@redhat.com>
References: <1318533267-18880-4-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86, NMI: Add knob to disable using NMI IPIs to stop cpus
Git-Commit-ID: bda62633983f9db49ce0b1a9235b3709c1cda5f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:23:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bda62633983f9db49ce0b1a9235b3709c1cda5f0
Gitweb:     http://git.kernel.org/tip/bda62633983f9db49ce0b1a9235b3709c1cda5f0
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Thu, 13 Oct 2011 15:14:27 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 12:00:23 +0100

x86, NMI: Add knob to disable using NMI IPIs to stop cpus

Some machines may exhibit problems using the NMI to stop other
cpus. This knob just allows one to revert back to the original
behaviour to help diagnose the problem.

V2:
  make function static

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: seiji.aguchi@hds.com
Cc: vgoyal@redhat.com
Cc: mjg@redhat.com
Cc: tony.luck@intel.com
Cc: gong.chen@intel.com
Cc: satoru.moriya@hds.com
Cc: avi@redhat.com
Cc: Andi Kleen <andi@firstfloor.org>
Link: http://lkml.kernel.org/r/1318533267-18880-4-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kernel-parameters.txt |    4 ++++
 arch/x86/kernel/smp.c               |   13 +++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a0c5c5f..b4339e5 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1796,6 +1796,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	nomfgpt		[X86-32] Disable Multi-Function General Purpose
 			Timer usage (for AMD Geode machines).
 
+	nonmi_ipi	[X86] Disable using NMI IPIs during panic/reboot to
+			shutdown the other cpus.  Instead use the REBOOT_VECTOR
+			irq.
+
 	nopat		[X86] Disable PAT (page attribute table extension of
 			pagetables) support.
 
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index e72b175..113acda 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -249,6 +249,11 @@ static void native_irq_stop_other_cpus(int wait)
 	local_irq_restore(flags);
 }
 
+static void native_smp_disable_nmi_ipi(void)
+{
+	smp_ops.stop_other_cpus = native_irq_stop_other_cpus;
+}
+
 /*
  * Reschedule call back.
  */
@@ -280,6 +285,14 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 	irq_exit();
 }
 
+static int __init nonmi_ipi_setup(char *str)
+{
+        native_smp_disable_nmi_ipi();
+        return 1;
+}
+
+__setup("nonmi_ipi", nonmi_ipi_setup);
+
 struct smp_ops smp_ops = {
 	.smp_prepare_boot_cpu	= native_smp_prepare_boot_cpu,
 	.smp_prepare_cpus	= native_smp_prepare_cpus,
