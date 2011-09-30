Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762Ab1I3TH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 15:07:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758705Ab1I3THT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 15:07:19 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, ying.huang@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        avi@redhat.com, jeremy@goop.org, Don Zickus <dzickus@redhat.com>
Subject: [V7][PATCH 2/6] x86, nmi: create new NMI handler routines
Date: Fri, 30 Sep 2011 15:06:20 -0400
Message-Id: <1317409584-23662-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1317409584-23662-1-git-send-email-dzickus@redhat.com>
References: <1317409584-23662-1-git-send-email-dzickus@redhat.com>
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

V4:
  - handle kstrndup failure

V5:
  - converted the list to list_head and used the list_XXX_rcu stuff
    to manipulate it (based on Ying's idea).
  - removed unused NMI_EXTERNAL for now (until we actually have a user)

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/nmi.h |   18 +++++
 arch/x86/kernel/nmi.c      |  153 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 171 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 4886a68..480b69b 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -42,6 +42,24 @@ void arch_trigger_all_cpu_backtrace(void);
 #define NMI_LOCAL_NORMAL_PRIOR	(NMI_LOCAL_BIT | NMI_NORMAL_PRIOR)
 #define NMI_LOCAL_LOW_PRIOR	(NMI_LOCAL_BIT | NMI_LOW_PRIOR)
 
+#define NMI_FLAG_FIRST	1
+
+enum {
+	NMI_LOCAL=0,
+	NMI_UNKNOWN,
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
index 68d758a..327748d 100644
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
@@ -21,6 +24,33 @@
 #include <linux/atomic.h>
 #include <asm/traps.h>
 #include <asm/mach_traps.h>
+#include <asm/nmi.h>
+
+#define NMI_MAX_NAMELEN	16
+struct nmiaction {
+	struct list_head list;
+	nmi_handler_t handler;
+	unsigned int flags;
+	char *name;
+};
+
+struct nmi_desc {
+	spinlock_t lock;
+	struct list_head head;
+};
+
+static struct nmi_desc nmi_desc[NMI_MAX] = 
+{
+	{
+		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[0].lock),
+		.head = LIST_HEAD_INIT(nmi_desc[0].head),
+	},
+	{
+		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[1].lock),
+		.head = LIST_HEAD_INIT(nmi_desc[1].head),
+	},
+
+};
 
 static int ignore_nmis;
 
@@ -38,6 +68,129 @@ static int __init setup_unknown_nmi_panic(char *str)
 }
 __setup("unknown_nmi_panic", setup_unknown_nmi_panic);
 
+#define nmi_to_desc(type) (&nmi_desc[type])
+
+static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
+{
+	struct nmi_desc *desc = nmi_to_desc(type);
+	struct nmiaction *a;
+	int handled=0;
+
+	rcu_read_lock();
+
+	/*
+	 * NMIs are edge-triggered, which means if you have enough
+	 * of them concurrently, you can lose some because only one
+	 * can be latched at any given time.  Walk the whole list
+	 * to handle those situations.
+	 */
+	list_for_each_entry_rcu(a, &desc->head, list) {
+
+		handled += a->handler(type, regs);
+
+	}
+
+	rcu_read_unlock();
+
+	/* return total number of NMI events handled */
+	return handled;
+}
+
+static int __setup_nmi(unsigned int type, struct nmiaction *action)
+{
+	struct nmi_desc *desc = nmi_to_desc(type);
+	unsigned long flags;
+
+	spin_lock_irqsave(&desc->lock, flags);
+
+	/*
+	 * some handlers need to be executed first otherwise a fake
+	 * event confuses some handlers (kdump uses this flag)
+	 */
+	if (action->flags & NMI_FLAG_FIRST)
+		list_add_rcu(&action->list, &desc->head);
+	else
+		list_add_tail_rcu(&action->list, &desc->head);
+	
+	spin_unlock_irqrestore(&desc->lock, flags);
+	return 0;
+}
+
+static struct nmiaction *__free_nmi(unsigned int type, const char *name)
+{
+	struct nmi_desc *desc = nmi_to_desc(type);
+	struct nmiaction *n;
+	unsigned long flags;
+
+	spin_lock_irqsave(&desc->lock, flags);
+
+	list_for_each_entry_rcu(n, &desc->head, list) {
+		/*
+		 * the name passed in to describe the nmi handler
+		 * is used as the lookup key
+		 */
+		if (!strcmp(n->name, name)) {
+			WARN(in_nmi(),
+				"Trying to free NMI (%s) from NMI context!\n", n->name);
+			list_del_rcu(&n->list);
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&desc->lock, flags);
+	synchronize_rcu();
+	return (n);
+}
+
+int register_nmi_handler(unsigned int type, nmi_handler_t handler,
+			unsigned long nmiflags, const char *devname)
+{
+	struct nmiaction *action;
+	int retval = -ENOMEM;
+
+	if (!handler)
+		return -EINVAL;
+
+	action = kzalloc(sizeof(struct nmiaction), GFP_KERNEL);
+	if (!action)
+		goto fail_action;
+
+	action->handler = handler;
+	action->flags = nmiflags;
+	action->name = kstrndup(devname, NMI_MAX_NAMELEN, GFP_KERNEL);
+	if (!action->name)
+		goto fail_action_name;
+
+	retval = __setup_nmi(type, action);
+
+	if (retval)
+		goto fail_setup_nmi;
+
+	return retval;
+
+fail_setup_nmi:
+	kfree(action->name);
+fail_action_name:
+	kfree(action);
+fail_action:	
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

