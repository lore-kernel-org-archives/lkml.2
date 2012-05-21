Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438Ab2EUUOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:14:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60984 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758297Ab2EUUOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:14:43 -0400
Date: Mon, 21 May 2012 22:14:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/locking changes for v3.5
Message-ID: <20120521201438.GA9270@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-locking-for-linus

   HEAD: 6ff968cca1dfebd4b6fcade87c11658dbfc96932 x86/nmi: Fix the type of the nmiaction.flags field

This update:

 - extends and simplifies x86 NMI callback handling code to 
   enhance and fix the HP hw-watchdog driver

 - simplifies the x86 NMI callback handling code to fix a 
   kmemcheck bug.

 - enhances the hung-task debugger

 Thanks,

	Ingo

------------------>
Betty Dall (1):
      x86/nmi: Fix the type of the nmiaction.flags field

Don Zickus (2):
      watchdog, hpwdt: Remove priority option for NMI callback
      x86/nmi: Add new NMI queues to deal with IO_CHK and SERR

Li Zhong (1):
      x86/nmi: Fix page faults by nmiaction if kmemcheck is enabled

Sasha Levin (1):
      hung task debugging: Inject NMI when hung and going to panic


 arch/x86/include/asm/nmi.h |   22 ++++++++++-
 arch/x86/kernel/nmi.c      |   83 +++++++++++++-------------------------------
 drivers/watchdog/hpwdt.c   |   46 +++++++++++++------------
 kernel/hung_task.c         |    4 ++-
 4 files changed, 71 insertions(+), 84 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index fd3f9f1..0e3793b 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -27,6 +27,8 @@ void arch_trigger_all_cpu_backtrace(void);
 enum {
 	NMI_LOCAL=0,
 	NMI_UNKNOWN,
+	NMI_SERR,
+	NMI_IO_CHECK,
 	NMI_MAX
 };
 
@@ -35,8 +37,24 @@ enum {
 
 typedef int (*nmi_handler_t)(unsigned int, struct pt_regs *);
 
-int register_nmi_handler(unsigned int, nmi_handler_t, unsigned long,
-			 const char *);
+struct nmiaction {
+	struct list_head	list;
+	nmi_handler_t		handler;
+	unsigned long		flags;
+	const char		*name;
+};
+
+#define register_nmi_handler(t, fn, fg, n)		\
+({							\
+	static struct nmiaction fn##_na = {		\
+		.handler = (fn),			\
+		.name = (n),				\
+		.flags = (fg),				\
+	};						\
+	__register_nmi_handler((t), &fn##_na);	\
+})
+
+int __register_nmi_handler(unsigned int, struct nmiaction *);
 
 void unregister_nmi_handler(unsigned int, const char *);
 
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 47acaf3..585be4b 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -31,14 +31,6 @@
 #include <asm/nmi.h>
 #include <asm/x86_init.h>
 
-#define NMI_MAX_NAMELEN	16
-struct nmiaction {
-	struct list_head list;
-	nmi_handler_t handler;
-	unsigned int flags;
-	char *name;
-};
-
 struct nmi_desc {
 	spinlock_t lock;
 	struct list_head head;
@@ -54,6 +46,14 @@ static struct nmi_desc nmi_desc[NMI_MAX] =
 		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[1].lock),
 		.head = LIST_HEAD_INIT(nmi_desc[1].head),
 	},
+	{
+		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[2].lock),
+		.head = LIST_HEAD_INIT(nmi_desc[2].head),
+	},
+	{
+		.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[3].lock),
+		.head = LIST_HEAD_INIT(nmi_desc[3].head),
+	},
 
 };
 
@@ -107,11 +107,14 @@ static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs,
 	return handled;
 }
 
-static int __setup_nmi(unsigned int type, struct nmiaction *action)
+int __register_nmi_handler(unsigned int type, struct nmiaction *action)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
 	unsigned long flags;
 
+	if (!action->handler)
+		return -EINVAL;
+
 	spin_lock_irqsave(&desc->lock, flags);
 
 	/*
@@ -120,6 +123,8 @@ static int __setup_nmi(unsigned int type, struct nmiaction *action)
 	 * to manage expectations
 	 */
 	WARN_ON_ONCE(type == NMI_UNKNOWN && !list_empty(&desc->head));
+	WARN_ON_ONCE(type == NMI_SERR && !list_empty(&desc->head));
+	WARN_ON_ONCE(type == NMI_IO_CHECK && !list_empty(&desc->head));
 
 	/*
 	 * some handlers need to be executed first otherwise a fake
@@ -133,8 +138,9 @@ static int __setup_nmi(unsigned int type, struct nmiaction *action)
 	spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
 }
+EXPORT_SYMBOL(__register_nmi_handler);
 
-static struct nmiaction *__free_nmi(unsigned int type, const char *name)
+void unregister_nmi_handler(unsigned int type, const char *name)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
 	struct nmiaction *n;
@@ -157,61 +163,16 @@ static struct nmiaction *__free_nmi(unsigned int type, const char *name)
 
 	spin_unlock_irqrestore(&desc->lock, flags);
 	synchronize_rcu();
-	return (n);
 }
-
-int register_nmi_handler(unsigned int type, nmi_handler_t handler,
-			unsigned long nmiflags, const char *devname)
-{
-	struct nmiaction *action;
-	int retval = -ENOMEM;
-
-	if (!handler)
-		return -EINVAL;
-
-	action = kzalloc(sizeof(struct nmiaction), GFP_KERNEL);
-	if (!action)
-		goto fail_action;
-
-	action->handler = handler;
-	action->flags = nmiflags;
-	action->name = kstrndup(devname, NMI_MAX_NAMELEN, GFP_KERNEL);
-	if (!action->name)
-		goto fail_action_name;
-
-	retval = __setup_nmi(type, action);
-
-	if (retval)
-		goto fail_setup_nmi;
-
-	return retval;
-
-fail_setup_nmi:
-	kfree(action->name);
-fail_action_name:
-	kfree(action);
-fail_action:	
-
-	return retval;
-}
-EXPORT_SYMBOL_GPL(register_nmi_handler);
-
-void unregister_nmi_handler(unsigned int type, const char *name)
-{
-	struct nmiaction *a;
-
-	a = __free_nmi(type, name);
-	if (a) {
-		kfree(a->name);
-		kfree(a);
-	}
-}
-
 EXPORT_SYMBOL_GPL(unregister_nmi_handler);
 
 static notrace __kprobes void
 pci_serr_error(unsigned char reason, struct pt_regs *regs)
 {
+	/* check to see if anyone registered against these types of errors */
+	if (nmi_handle(NMI_SERR, regs, false))
+		return;
+
 	pr_emerg("NMI: PCI system error (SERR) for reason %02x on CPU %d.\n",
 		 reason, smp_processor_id());
 
@@ -241,6 +202,10 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 {
 	unsigned long i;
 
+	/* check to see if anyone registered against these types of errors */
+	if (nmi_handle(NMI_IO_CHECK, regs, false))
+		return;
+
 	pr_emerg(
 	"NMI: IOCK error (debug interrupt?) for reason %02x on CPU %d.\n",
 		 reason, smp_processor_id());
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index cbc7cee..6e414b5 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -147,7 +147,6 @@ struct cmn_registers {
 
 static unsigned int hpwdt_nmi_decoding;
 static unsigned int allow_kdump;
-static unsigned int priority;		/* hpwdt at end of die_notify list */
 static unsigned int is_icru;
 static DEFINE_SPINLOCK(rom_lock);
 static void *cru_rom_addr;
@@ -723,28 +722,35 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 	}
 
 	/*
-	 * If the priority is set to 1, then we will be put first on the
-	 * die notify list to handle a critical NMI. The default is to
-	 * be last so other users of the NMI signal can function.
+	 * Only one function can register for NMI_UNKNOWN
 	 */
-	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout,
-					(priority) ? NMI_FLAG_FIRST : 0,
-					"hpwdt");
-	if (retval != 0) {
-		dev_warn(&dev->dev,
-			"Unable to register a die notifier (err=%d).\n",
-			retval);
-		if (cru_rom_addr)
-			iounmap(cru_rom_addr);
-	}
+	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout, 0, "hpwdt");
+	if (retval)
+		goto error;
+	retval = register_nmi_handler(NMI_SERR, hpwdt_pretimeout, 0, "hpwdt");
+	if (retval)
+		goto error1;
+	retval = register_nmi_handler(NMI_IO_CHECK, hpwdt_pretimeout, 0, "hpwdt");
+	if (retval)
+		goto error2;
 
 	dev_info(&dev->dev,
 			"HP Watchdog Timer Driver: NMI decoding initialized"
-			", allow kernel dump: %s (default = 0/OFF)"
-			", priority: %s (default = 0/LAST).\n",
-			(allow_kdump == 0) ? "OFF" : "ON",
-			(priority == 0) ? "LAST" : "FIRST");
+			", allow kernel dump: %s (default = 0/OFF)\n",
+			(allow_kdump == 0) ? "OFF" : "ON");
 	return 0;
+
+error2:
+	unregister_nmi_handler(NMI_SERR, "hpwdt");
+error1:
+	unregister_nmi_handler(NMI_UNKNOWN, "hpwdt");
+error:
+	dev_warn(&dev->dev,
+		"Unable to register a die notifier (err=%d).\n",
+		retval);
+	if (cru_rom_addr)
+		iounmap(cru_rom_addr);
+	return retval;
 }
 
 static void hpwdt_exit_nmi_decoding(void)
@@ -881,10 +887,6 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 #ifdef CONFIG_HPWDT_NMI_DECODING
 module_param(allow_kdump, int, 0);
 MODULE_PARM_DESC(allow_kdump, "Start a kernel dump after NMI occurs");
-
-module_param(priority, int, 0);
-MODULE_PARM_DESC(priority, "The hpwdt driver handles NMIs first or last"
-		" (default = 0/Last)\n");
 #endif /* !CONFIG_HPWDT_NMI_DECODING */
 
 module_init(hpwdt_init);
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index c21449f..6df6149 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -108,8 +108,10 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
 
 	touch_nmi_watchdog();
 
-	if (sysctl_hung_task_panic)
+	if (sysctl_hung_task_panic) {
+		trigger_all_cpu_backtrace();
 		panic("hung_task: blocked tasks");
+	}
 }
 
 /*
