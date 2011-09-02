Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab1IBA4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 20:56:19 -0400
Received: from claw.goop.org ([74.207.240.146]:43181 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932892Ab1IBAzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 20:55:35 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 08/13] xen/pvticketlock: disable interrupts while blocking
Date: Thu,  1 Sep 2011 17:55:01 -0700
Message-Id: <38bb37e15f6e5056d5238adac945bc1837a996ec.1314922370.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

We need to make sure interrupts are disabled while we're relying on the
contents of the per-cpu lock_waiting values, otherwise an interrupt
handler could come in, try to take some other lock, block, and overwrite
our values.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/spinlock.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 4c46144..2ed5d05 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -98,6 +98,7 @@ static void xen_lock_spinning(struct arch_spinlock *lock, unsigned want)
 	struct xen_lock_waiting *w = &__get_cpu_var(lock_waiting);
 	int cpu = smp_processor_id();
 	u64 start;
+	unsigned long flags;
 
 	/* If kicker interrupts not initialized yet, just spin */
 	if (irq == -1)
@@ -105,6 +106,10 @@ static void xen_lock_spinning(struct arch_spinlock *lock, unsigned want)
 
 	start = spin_time_start();
 
+	/* Make sure interrupts are disabled to ensure that these
+	   per-cpu values are not overwritten. */
+	local_irq_save(flags);
+
 	w->want = want;
 	w->lock = lock;
 
@@ -139,6 +144,9 @@ static void xen_lock_spinning(struct arch_spinlock *lock, unsigned want)
 out:
 	cpumask_clear_cpu(cpu, &waiting_cpus);
 	w->lock = NULL;
+
+	local_irq_restore(flags);
+
 	spin_time_accum_blocked(start);
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_lock_spinning);
-- 
1.7.6

