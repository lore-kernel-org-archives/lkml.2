Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab2JYAwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:52:17 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61109 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758948Ab2JYAwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:52:09 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Alexander Graf <agraf@suse.de>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 3/5] kvm: Directly account vtime to system on guest switch
Date: Thu, 25 Oct 2012 02:51:51 +0200
Message-Id: <1351126313-17804-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1351126313-17804-1-git-send-email-fweisbec@gmail.com>
References: <1351126313-17804-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switching to or from guest context is done on ioctl context.
So by the time we call kvm_guest_enter() or kvm_guest_exit()
we know we are not running the idle task.

As a result, we can directly account the cputime using
vtime_account_system_irqsafe().

There are two good reasons to do this:

* We avoid some useless checks on guest switch. It optimizes
a bit this fast path.

* In the case of CONFIG_IRQ_TIME_ACCOUNTING, calling vtime_account()
checks for irq time to account. This is pointless since we know
we are not in an irq on guest switch. This is wasting cpu cycles
for no good reason. vtime_account_system() OTOH is a no-op in
this config option.

* s390 doesn't disable irqs in its implementation of vtime_account().
If vtime_account() in kvm races with an irq, the pending time might
be accounted twice. With vtime_account_system_irqsafe() we are protected.

A further optimization may consist in introducing a vtime_account_guest()
that directly calls account_guest_time().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Alexander Graf <agraf@suse.de>
Cc: Xiantao Zhang <xiantao.zhang@intel.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/kvm_host.h |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 93bfc9f..f17158b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -737,7 +737,11 @@ static inline int kvm_deassign_device(struct kvm *kvm,
 static inline void kvm_guest_enter(void)
 {
 	BUG_ON(preemptible());
-	vtime_account(current);
+	/*
+	 * This is running in ioctl context so we can avoid
+	 * the call to vtime_account() with its unnecessary idle check.
+	 */
+	vtime_account_system_irqsafe(current);
 	current->flags |= PF_VCPU;
 	/* KVM does not hold any references to rcu protected data when it
 	 * switches CPU into a guest mode. In fact switching to a guest mode
@@ -751,7 +755,11 @@ static inline void kvm_guest_enter(void)
 
 static inline void kvm_guest_exit(void)
 {
-	vtime_account(current);
+	/*
+	 * This is running in ioctl context so we can avoid
+	 * the call to vtime_account() with its unnecessary idle check.
+	 */
+	vtime_account_system_irqsafe(current);
 	current->flags &= ~PF_VCPU;
 }
 
-- 
1.7.5.4

