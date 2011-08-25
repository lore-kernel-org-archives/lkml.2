Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1HYQqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:46:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab1HYQqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:46:44 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, ying.huang@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        Don Zickus <dzickus@redhat.com>
Subject: [V3][PATCH 2/6] x86, nmi: create new NMI handler routines
Date: Thu, 25 Aug 2011 12:45:44 -0400
Message-Id: <1314290748-23569-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
References: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NMI handlers used to rely on the notifier infrastructure.  This worked
great until we wanted to support handling multiple events better.

One of the key ideas to the nmi handling is to process _all_ the handlers for
each NMI.  The reason behind this switch is because NMIs are edge triggered.
If enough NMIs are triggered, then they could be lost because the cpu can
only latch at most one NMI (besides the one currently being processed).

In order to deal with this we have decided to process all the NMI handlers
for each NMI.  This allows the handlers to determine if they recieved an
event or not (the ones that can not determine this will be left to fend
for themselves on the unknown NMI list).

As a result of this change it is now possible to have an extra NMI that
was destined to be received for an already processed event.  Because the
event was processed in the previous NMI, this NMI gets dropped and becomes
an 'unknown' NMI.  This of course will cause printks that scare people.

However, we prefer to have extra NMIs as opposed to losing NMIs and as such
are have developed a basic mechanism to catch most of them.  That will be
a later patch.

To accomplish this idea, I unhooked the nmi handlers from the notifier
routines and created a new mechanism loosely based on doIRQ.  The reason
for this is the notifier routines have a couple of shortcomings.  One we
could't guarantee all future NMI handlers used NOTIFY_OK instead of
NOTIFY_STOP.  Second, we couldn't keep track of the number of events being
handled in each routine (most only handle one, perf can handle more than one).
Third, I wanted to eventually display which nmi handlers are registered in
the system in /proc/interrupts to help see who is generating NMIs.

The patch below just implements the new infrastructure but doesn't wire it up
yet (that is the next patch).  Its design is based on doIRQ structs and the
atomic notifier routines.  So the rcu stuff in the patch isn't entirely untested
(as the notifier routines have soaked it) but it should be double checked in
case I copied the code wrong.

V2:
  - use kstrdup to copy/allocate device name
  - fix-up _GPL oops

V3:
  - fix leak in register_nmi_handler error path
  - removed _raw annotations from rcu_dereference

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/nmi.h |   19 ++++++
 arch/x86/kernel/nmi.c      |  149 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 168 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 4886a68..6d04b28 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -42,6 +42,25 @@ void arch_trigger_all_cpu_backtrace(void);
 #define NMI_LOCAL_NORMAL_PRIOR	(NMI_LOCAL_BIT | NMI_NORMAL_PRIOR)
 #define NMI_LOCAL_LOW_PRIOR	(NMI_LOCAL_BIT | NMI_LOW_PRIOR)
 
+#define NMI_FLAG_FIRST	1
+
+enum {
+	NMI_LOCAL=0,
+	NMI_UNKNOWN,
+	NMI_EXTERNAL,
+	NMI_MAX
+};
+
+#define NMI_DONE	0
+#define NMI_HANDLED	1
+
+typedef int (*nmi_handler_t)(unsigned int, struct pt_regs *);
+
+int register_nmi_handler(unsigned int, nmi_handler_t, unsigned long,
+			 const char *);
+
+void unregister_nmi_handler(unsigned int, const char *);
+
 void stop_nmi(void);
 void restart_nmi(void);
 
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 68d758a..e65295c 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -13,6 +13,9 @@
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
 #include <linux/nmi.h>
+#include <linux/delay.h>
+#include <linux/hardirq.h>
+#include <linux/slab.h>
 
 #if defined(CONFIG_EDAC)
 #include <linux/edac.h>
@@ -21,6 +24,28 @@
 #include <linux/atomic.h>
 #include <asm/traps.h>
 #include <asm/mach_traps.h>
+#include <asm/nmi.h>
+
+#define NMI_MAX_NAMELEN	16
+struct nmiaction {
+	struct nmiaction __rcu *next;
+	nmi_handler_t handler;
+	unsigned int flags;
+	char *name;
+};
+
+struct nmi_desc {
+	spinlock_t lock;
+	struct nmiaction __rcu *head;
+};
+
+static struct nmi_desc nmi_desc[NMI_MAX] = 
+{
+	{	.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[0].lock), },
+	{	.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[1].lock), },
+	{	.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[2].lock), },
+
+};
 
 static int ignore_nmis;
 
@@ -38,6 +63,130 @@ static int __init setup_unknown_nmi_panic(char *str)
 }
 __setup("unknown_nmi_panic", setup_unknown_nmi_panic);
 
+#define nmi_to_desc(type) (&nmi_desc[type])
+
+static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
+{
+	struct nmi_desc *desc = nmi_to_desc(type);
+	struct nmiaction *next_a, *a, **ap = &desc->head;
+	int handled=0;
+
+	rcu_read_lock();
+
+	a = rcu_dereference(*ap);
+
+	/*
+	 * NMIs are edge-triggered, which means if you have enough
+	 * of them concurrently, you can lose some because only one
+	 * can be latched at any given time.  Walk the whole list
+	 * to handle those situations.
+	 */
+	while (a) {
+		next_a = rcu_dereference(a->next);
+
+		handled += a->handler(type, regs);
+
+		a = next_a;
+	}
+	rcu_read_unlock();
+
+	/* return total number of NMI events handled */
+	return handled;
+}
+
+static int __setup_nmi(unsigned int type, struct nmiaction *action)
+{
+	struct nmi_desc *desc = nmi_to_desc(type);
+	struct nmiaction **a = &(desc->head);
+	unsigned long flags;
+
+	spin_lock_irqsave(&desc->lock, flags);
+
+	/*
+	 * some handlers need to be executed first otherwise a fake
+	 * event confuses some handlers (kdump uses this flag)
+	 */
+	if (!(action->flags & NMI_FLAG_FIRST))
+		while ((*a) != NULL)
+			a = &((*a)->next);
+	
+	action->next = *a;
+	rcu_assign_pointer(*a, action);
+
+	spin_unlock_irqrestore(&desc->lock, flags);
+	return 0;
+}
+
+static struct nmiaction *__free_nmi(unsigned int type, const char *name)
+{
+	struct nmi_desc *desc = nmi_to_desc(type);
+	struct nmiaction *n, **np = &(desc->head);
+	unsigned long flags;
+
+	spin_lock_irqsave(&desc->lock, flags);
+
+	while ((*np) != NULL) {
+		n = *np;
+
+		/*
+		 * the name passed in to describe the nmi handler
+		 * is used as the lookup key
+		 */
+		if (!strcmp(n->name, name)) {
+			WARN(in_nmi(),
+				"Trying to free NMI (%s) from NMI context!\n", n->name);
+			rcu_assign_pointer(*np, n->next);
+			break;
+		}
+		np = &(n->next);
+	}
+
+	spin_unlock_irqrestore(&desc->lock, flags);
+	synchronize_rcu();
+	return (*np);
+}
+
+int register_nmi_handler(unsigned int type, nmi_handler_t handler,
+			unsigned long nmiflags, const char *devname)
+{
+	struct nmiaction *action;
+	int retval;
+
+	if (!handler)
+		return -EINVAL;
+
+	action = kzalloc(sizeof(struct nmiaction), GFP_KERNEL);
+	if (!action)
+		return -ENOMEM;
+
+	action->handler = handler;
+	action->flags = nmiflags;
+	action->name = kstrndup(devname, NMI_MAX_NAMELEN, GFP_KERNEL);
+
+	retval = __setup_nmi(type, action);
+
+	if (retval) {
+		kfree(action->name);
+		kfree(action);
+	}
+	
+	return retval;
+}
+EXPORT_SYMBOL_GPL(register_nmi_handler);
+
+void unregister_nmi_handler(unsigned int type, const char *name)
+{
+	struct nmiaction *a;
+
+	a = __free_nmi(type, name);
+	if (a) {
+		kfree(a->name);
+		kfree(a);
+	}
+}
+
+EXPORT_SYMBOL_GPL(unregister_nmi_handler);
+
 static notrace __kprobes void
 pci_serr_error(unsigned char reason, struct pt_regs *regs)
 {
-- 
1.7.6

