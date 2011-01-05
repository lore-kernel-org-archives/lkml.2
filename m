Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab1AEOIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 09:08:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:58339 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab1AEOH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 09:07:56 -0500
Date: Wed, 5 Jan 2011 14:07:33 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jan.kiszka@web.de, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jan.kiszka@web.de, tglx@linutronix.de, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <1294198689-15447-1-git-send-email-dzickus@redhat.com>
References: <1294198689-15447-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Only call smp_processor_id in non-preempt cases
Message-ID: <tip-9ab181fa9ff73a38fccd0a4f1c40a38dfe62b535@git.kernel.org>
Git-Commit-ID: 9ab181fa9ff73a38fccd0a4f1c40a38dfe62b535
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 Jan 2011 14:07:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ab181fa9ff73a38fccd0a4f1c40a38dfe62b535
Gitweb:     http://git.kernel.org/tip/9ab181fa9ff73a38fccd0a4f1c40a38dfe62b535
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Tue, 4 Jan 2011 22:38:07 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 5 Jan 2011 14:22:57 +0100

x86: Only call smp_processor_id in non-preempt cases

There are some paths that walk the die_chain with preemption on.
Make sure we are in an NMI call before we start doing anything.

This was triggered by do_general_protection calling notify_die
with DIE_GPF.

Reported-by: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Don Zickus <dzickus@redhat.com>
LKML-Reference: <1294198689-15447-1-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/hw_nmi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index c57d0b5..2b40a60 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -51,7 +51,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 {
 	struct die_args *args = __args;
 	struct pt_regs *regs;
-	int cpu = smp_processor_id();
+	int cpu;
 
 	switch (cmd) {
 	case DIE_NMI:
@@ -63,6 +63,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 	}
 
 	regs = args->regs;
+	cpu = smp_processor_id();
 
 	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
 		static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
