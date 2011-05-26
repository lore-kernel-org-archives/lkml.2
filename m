Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab1EZRMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:12:24 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:56101 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab1EZRMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:12:22 -0400
Date: Thu, 26 May 2011 22:42:09 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com
Subject: [Patch 1/6] XPANIC: Add extended panic interface
Message-ID: <20110526171209.GA17988@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20110526170722.GB23266@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526170722.GB23266@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit e668fa1aea7844ac4c7ea09030a2f3e647a4adb1
Author: Andi Kleen <ak@linux.intel.com>
Date:   Fri Nov 19 18:36:44 2010 +0100

    XPANIC: Add extended panic interface
    
    One panic size doesn't fit all.
    
    Machine check has some special requirements on panic, like:
    - It wants to do a reboot timeout by default so that the machine
    check event can be logged to disk after warm reboot.
    - For memory errors it usually doesn't want to do crash dumps because
    that can lead to crash loops (dumping corrupted memory would
    lead to another machine check)
    - It doesn't want to do backtraces because machine checks
    are not a kernel bug.
    
    In a earlier patch this was done with various adhoc hacks,
    but it's cleaner to extend panic to a 'xpanic' that directly
    gets a flag and timeout argument.
    
    The only user right now will be x86 machine checks, but I consider
    it likely that other users will switch to this too.
    
    For example one obvious candidate would be the "no root
    found" panic which doesn't really deserve a backtrace.
    
    I exported a vpanic() interface too as a global. That's not
    needed by the current user, but the interface has to exist
    internally anyways and I could see how other code would
    find a v* variant of panic useful.
    
    Originally based on a suggestion by H. Peter Anvin.
    Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/kernel.h |   11 +++++++++++
 kernel/panic.c         |   41 +++++++++++++++++++++++++++++++----------
 2 files changed, 42 insertions(+), 10 deletions(-)

Index: linux-2.6.slim_kdump/include/linux/kernel.h
===================================================================
--- linux-2.6.slim_kdump.orig/include/linux/kernel.h
+++ linux-2.6.slim_kdump/include/linux/kernel.h
@@ -175,10 +175,21 @@ static inline void might_fault(void)
 }
 #endif
 
+enum panic_flags {
+	PANIC_NO_KEXEC     = (1 << 0),
+	PANIC_NO_BACKTRACE = (1 << 1),
+};
+
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(int state);
 NORET_TYPE void panic(const char * fmt, ...)
 	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
+NORET_TYPE void xpanic(enum panic_flags flags, int timeout,
+		       const char *fmt, ...)
+	__attribute__ ((NORET_AND format (printf, 3, 4))) __cold;
+NORET_TYPE void vpanic(enum panic_flags flags, int timeout,
+		       const char *fmt,
+		       va_list ap) __noreturn __cold;
 extern void oops_enter(void);
 extern void oops_exit(void);
 void print_oops_end_marker(void);
Index: linux-2.6.slim_kdump/kernel/panic.c
===================================================================
--- linux-2.6.slim_kdump.orig/kernel/panic.c
+++ linux-2.6.slim_kdump/kernel/panic.c
@@ -57,14 +57,37 @@ EXPORT_SYMBOL(panic_blink);
  *
  *	This function never returns.
  */
-NORET_TYPE void panic(const char * fmt, ...)
+NORET_TYPE void panic(const char *fmt, ...)
+{
+	va_list ap;
+	va_start(ap, fmt);
+	vpanic(0, 0, fmt, ap);
+}
+EXPORT_SYMBOL(panic);
+
+NORET_TYPE void xpanic(enum panic_flags flags, int timeout,
+                       const char *fmt, ...)
+{
+	va_list ap;
+	va_start(ap, fmt);
+	xpanic(flags, timeout, fmt, ap);
+}
+EXPORT_SYMBOL(xpanic);
+
+NORET_TYPE void vpanic(enum panic_flags flags, int timeout,
+		       const char * fmt, va_list args)
 {
 	static char buf[1024];
-	va_list args;
 	long i, i_next = 0;
 	int state = 0;
 
 	/*
+	 * Let user always override panic_timeout.
+	 */
+	if (panic_timeout > 0)
+		timeout = panic_timeout;
+
+	/*
 	 * It's possible to come here directly from a panic-assertion and
 	 * not have preempt disabled. Some functions called from here want
 	 * preempt to be disabled. No point enabling it later though...
@@ -73,12 +96,11 @@ NORET_TYPE void panic(const char * fmt,
 
 	console_verbose();
 	bust_spinlocks(1);
-	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
-	va_end(args);
 	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
 #ifdef CONFIG_DEBUG_BUGVERBOSE
-	dump_stack();
+	if (!(flags & PANIC_NO_BACKTRACE))
+		dump_stack();
 #endif
 
 	/*
@@ -86,7 +108,8 @@ NORET_TYPE void panic(const char * fmt,
 	 * everything else.
 	 * Do we want to call this before we try to display a message?
 	 */
-	crash_kexec(NULL);
+	if (!(flags & PANIC_NO_KEXEC))
+		crash_kexec(NULL);
 
 	kmsg_dump(KMSG_DUMP_PANIC);
 
@@ -104,7 +127,7 @@ NORET_TYPE void panic(const char * fmt,
 	if (!panic_blink)
 		panic_blink = no_blink;
 
-	if (panic_timeout > 0) {
+	if (timeout > 0) {
 		/*
 		 * Delay timeout seconds before rebooting the machine.
 		 * We can't use the "normal" timers since we just panicked.
@@ -152,9 +175,7 @@ NORET_TYPE void panic(const char * fmt,
 		mdelay(PANIC_TIMER_STEP);
 	}
 }
-
-EXPORT_SYMBOL(panic);
-
+EXPORT_SYMBOL(vpanic);
 
 struct tnt {
 	u8	bit;
