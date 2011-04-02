Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab1DBTMw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 15:12:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:44519 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756239Ab1DBTMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 15:12:50 -0400
Date: Sat, 2 Apr 2011 21:12:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiaotian Feng <dfeng@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/mutex.c
In-Reply-To: <4D970CB6.3070604@redhat.com>
Message-ID: <alpine.LFD.2.00.1104021653010.22266@localhost6.localdomain6>
References: <4D970CB6.3070604@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Apr 2011, Xiaotian Feng wrote:
>     I've got following warnings when I'm trying to resume from suspend, so
> sparse_lock is not safe enough as a mutex for the suspend resume case, can
> we simply convert sparse_lock back to spinlock?

What the heck? We do not just convert a mutex to a spinlock because a
warning triggers. And it was a mutex already in 2.6.38 w/o any such
problems.

And it is safe enough for the resume case as well, it simply cannot go
to sleep because nothing else can hold that mutex in the early resume
code. We take the mutex during early boot as well, but there the might
sleep checks are disabled. And we should do the very same thing in the
early resume code as well. Rafael, PeterZ ???

But that's a different issue and not the real problem.

So now instead of thinking about spinlock it would have been pretty
simple to figure out that the warning is triggered due to commit
d72274e5.

But of course we dont want to revert d72274e5 either, though it's easy
to figure out from the call chain that the fundamental stupidity is in
the hpet resume code.

Why the hell does it call arch_setup_hpet_msi()? That interrupt was
completely setup _BEFORE_ we went into suspend. And I don't see any
code which tears down the interrupt on suspend. So we run through a
full setup for nothing. And when we have interrupt remapping enabled
it even leaks an irte, because it allocates a new one. Utter crap.
init_one_hpet_msi_clockevent() has the same stupid call.

So no, the mutex stays a mutex and we fix crap where the crap is.

The following completely untested patch should solve that. Actually we
should be more clever and do the affinity magic in the new function as
well, so we can get rid of this weird disable/set_affinity/enable
hack, but that's a different story.

Thanks,

	tglx
---
 arch/x86/include/asm/hpet.h    |    2 ++
 arch/x86/kernel/apic/io_apic.c |   11 +++++++++++
 arch/x86/kernel/hpet.c         |    5 +++--
 3 files changed, 16 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/include/asm/hpet.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hpet.h
+++ linux-2.6/arch/x86/include/asm/hpet.h
@@ -83,11 +83,13 @@ extern void hpet_msi_read(struct hpet_de
 
 #ifdef CONFIG_PCI_MSI
 extern int arch_setup_hpet_msi(unsigned int irq, unsigned int id);
+extern int arch_start_hpet_msi(unsigned int irq, unsigned int id);
 #else
 static inline int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 {
 	return -EINVAL;
 }
+static inline int arch_start_hpet_msi(unsigned int irq, unsigned int id) { }
 #endif
 
 #ifdef CONFIG_HPET_EMULATE_RTC
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3477,6 +3477,17 @@ int arch_setup_hpet_msi(unsigned int irq
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 	return 0;
 }
+
+int arch_start_hpet_msi(unsigned int irq, unsigned int id)
+{
+	struct msi_msg msg;
+	int ret = msi_compose_msg(NULL, irq, &msg, id);
+
+	if (!ret)
+		hpet_msi_write(irq_get_handler_data(irq), &msg);
+	return ret;
+}
+
 #endif
 
 #endif /* CONFIG_PCI_MSI */
Index: linux-2.6/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/hpet.c
+++ linux-2.6/arch/x86/kernel/hpet.c
@@ -370,7 +370,8 @@ static void hpet_set_mode(enum clock_eve
 			hpet_enable_legacy_int();
 		} else {
 			struct hpet_dev *hdev = EVT_TO_HPET_DEV(evt);
-			hpet_setup_msi_irq(hdev->irq);
+
+			arch_start_hpet_msi(hdev->irq, hpet_blockid);
 			disable_irq(hdev->irq);
 			irq_set_affinity(hdev->irq, cpumask_of(hdev->cpu));
 			enable_irq(hdev->irq);
@@ -555,7 +556,7 @@ static void init_one_hpet_msi_clockevent
 	if (!(hdev->flags & HPET_DEV_VALID))
 		return;
 
-	if (hpet_setup_msi_irq(hdev->irq))
+	if (arch_start_hpet_msi(hdev->irq, hpet_blockid))
 		return;
 
 	hdev->cpu = cpu;


