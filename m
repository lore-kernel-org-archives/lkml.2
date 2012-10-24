Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683Ab2JXTje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:39:34 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933098Ab2JXTjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:39:32 -0400
Date: Wed, 24 Oct 2012 21:39:19 +0200
From: Richard Weinberger <richard@nod.at>
To: Matthew Leach <matthew@mattleach.net>
Cc: linux-kernel@vger.kernel.org,
        Martin =?UTF-8?B?UMOkcnRlbA==?= <martin.partel@gmail.com>
Subject: Re: [REGRESSION] uml: signal.c build errors
Message-ID: <20121024213919.5543e90b@spider.haslach.nod.at>
In-Reply-To: <87pq48lqut.fsf@mattleach.net>
References: <87pq48lqut.fsf@mattleach.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/dIXUSFwq/xOLd6baGKUpnZk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/dIXUSFwq/xOLd6baGKUpnZk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Am Wed, 24 Oct 2012 00:18:34 +0100
> I have tracked this down to [1] where, indeed, the type of sig_info is
> different; the second parameter in signal.c is 'siginfo_t' where as in
> as-layout.h the second parameter's type is declared as 'struct
> siginfo'.
> 
> [1]: d3c1cfcdb43e023ab1b1c7a555cd9e929026500a

Looks like we have to revert that commit.
Moving everything to siginfo_t requires a non-trivial header cleanup
and may introduce new regressions.

Matthew, does the attached revert patch help?

If yes, I'll submit it ASAP to Linus and for 3.8 we cleanup the UML
headers and reintroduce commit d3c1cfc.

Thanks,
//richard

--MP_/dIXUSFwq/xOLd6baGKUpnZk
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=revert.diff

diff --git a/arch/um/include/shared/as-layout.h b/arch/um/include/shared/as-layout.h
index 694c792..21516c2 100644
--- a/arch/um/include/shared/as-layout.h
+++ b/arch/um/include/shared/as-layout.h
@@ -60,8 +60,7 @@ extern unsigned long host_task_size;
 
 extern int linux_main(int argc, char **argv);
 
-struct siginfo;
-extern void (*sig_info[])(int, struct siginfo *si, struct uml_pt_regs *);
+extern void (*sig_info[])(int, struct uml_pt_regs *);
 
 #endif
 
diff --git a/arch/um/include/shared/irq_user.h b/arch/um/include/shared/irq_user.h
index df56330..f37e228 100644
--- a/arch/um/include/shared/irq_user.h
+++ b/arch/um/include/shared/irq_user.h
@@ -20,8 +20,7 @@ struct irq_fd {
 
 enum { IRQ_READ, IRQ_WRITE };
 
-struct siginfo;
-extern void sigio_handler(int sig, struct siginfo *unused_si, struct uml_pt_regs *regs);
+extern void sigio_handler(int sig, struct uml_pt_regs *regs);
 extern void free_irq_by_fd(int fd);
 extern void reactivate_fd(int fd, int irqnum);
 extern void deactivate_fd(int fd, int irqnum);
diff --git a/arch/um/include/shared/kern_util.h b/arch/um/include/shared/kern_util.h
index 83a91f9..ec2d567 100644
--- a/arch/um/include/shared/kern_util.h
+++ b/arch/um/include/shared/kern_util.h
@@ -9,8 +9,6 @@
 #include <sysdep/ptrace.h>
 #include <sysdep/faultinfo.h>
 
-struct siginfo;
-
 extern int uml_exitcode;
 
 extern int ncpus;
@@ -24,7 +22,7 @@ extern void free_stack(unsigned long stack, int order);
 
 extern int do_signal(void);
 extern void interrupt_end(void);
-extern void relay_signal(int sig, struct siginfo *si, struct uml_pt_regs *regs);
+extern void relay_signal(int sig, struct uml_pt_regs *regs);
 
 extern unsigned long segv(struct faultinfo fi, unsigned long ip,
 			  int is_user, struct uml_pt_regs *regs);
@@ -35,8 +33,9 @@ extern unsigned int do_IRQ(int irq, struct uml_pt_regs *regs);
 extern int smp_sigio_handler(void);
 extern void initial_thread_cb(void (*proc)(void *), void *arg);
 extern int is_syscall(unsigned long addr);
+extern void timer_handler(int sig, struct uml_pt_regs *regs);
 
-extern void timer_handler(int sig, struct siginfo *unused_si, struct uml_pt_regs *regs);
+extern void timer_handler(int sig, struct uml_pt_regs *regs);
 
 extern int start_uml(void);
 extern void paging_init(void);
@@ -60,9 +59,9 @@ extern unsigned long from_irq_stack(int nested);
 extern void syscall_trace(struct uml_pt_regs *regs, int entryexit);
 extern int singlestepping(void *t);
 
-extern void segv_handler(int sig, struct siginfo *unused_si, struct uml_pt_regs *regs);
-extern void bus_handler(int sig, struct siginfo *si, struct uml_pt_regs *regs);
-extern void winch(int sig, struct siginfo *unused_si, struct uml_pt_regs *regs);
+extern void segv_handler(int sig, struct uml_pt_regs *regs);
+extern void bus_handler(int sig, struct uml_pt_regs *regs);
+extern void winch(int sig, struct uml_pt_regs *regs);
 extern void fatal_sigsegv(void) __attribute__ ((noreturn));
 
 
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 36e12f0..81d464e 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -30,7 +30,7 @@ static struct irq_fd **last_irq_ptr = &active_fds;
 
 extern void free_irqs(void);
 
-void sigio_handler(int sig, struct siginfo *unused_si, struct uml_pt_regs *regs)
+void sigio_handler(int sig, struct uml_pt_regs *regs)
 {
 	struct irq_fd *irq_fd;
 	int n;
diff --git a/arch/um/kernel/time.c b/arch/um/kernel/time.c
index 117568d..7ef3b9d 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -13,7 +13,7 @@
 #include <kern_util.h>
 #include <os.h>
 
-void timer_handler(int sig, struct siginfo *unused_si, struct uml_pt_regs *regs)
+void timer_handler(int sig, struct uml_pt_regs *regs)
 {
 	unsigned long flags;
 
diff --git a/arch/um/kernel/trap.c b/arch/um/kernel/trap.c
index 089f398..9c42a0d 100644
--- a/arch/um/kernel/trap.c
+++ b/arch/um/kernel/trap.c
@@ -173,7 +173,7 @@ void fatal_sigsegv(void)
 	os_dump_core();
 }
 
-void segv_handler(int sig, struct siginfo *unused_si, struct uml_pt_regs *regs)
+void segv_handler(int sig, struct uml_pt_regs *regs)
 {
 	struct faultinfo * fi = UPT_FAULTINFO(regs);
 
@@ -259,11 +259,8 @@ unsigned long segv(struct faultinfo fi, unsigned long ip, int is_user,
 	return 0;
 }
 
-void relay_signal(int sig, struct siginfo *si, struct uml_pt_regs *regs)
+void relay_signal(int sig, struct uml_pt_regs *regs)
 {
-	struct faultinfo *fi;
-	struct siginfo clean_si;
-
 	if (!UPT_IS_USER(regs)) {
 		if (sig == SIGBUS)
 			printk(KERN_ERR "Bus error - the host /dev/shm or /tmp "
@@ -273,40 +270,18 @@ void relay_signal(int sig, struct siginfo *si, struct uml_pt_regs *regs)
 
 	arch_examine_signal(sig, regs);
 
-	memset(&clean_si, 0, sizeof(clean_si));
-	clean_si.si_signo = si->si_signo;
-	clean_si.si_errno = si->si_errno;
-	clean_si.si_code = si->si_code;
-	switch (sig) {
-	case SIGILL:
-	case SIGFPE:
-	case SIGSEGV:
-	case SIGBUS:
-	case SIGTRAP:
-		fi = UPT_FAULTINFO(regs);
-		clean_si.si_addr = (void __user *) FAULT_ADDRESS(*fi);
-		current->thread.arch.faultinfo = *fi;
-#ifdef __ARCH_SI_TRAPNO
-		clean_si.si_trapno = si->si_trapno;
-#endif
-		break;
-	default:
-		printk(KERN_ERR "Attempted to relay unknown signal %d (si_code = %d)\n",
-			sig, si->si_code);
-	}
-
-	force_sig_info(sig, &clean_si, current);
+	current->thread.arch.faultinfo = *UPT_FAULTINFO(regs);
+	force_sig(sig, current);
 }
 
-void bus_handler(int sig, struct siginfo *si, struct uml_pt_regs *regs)
+void bus_handler(int sig, struct uml_pt_regs *regs)
 {
 	if (current->thread.fault_catcher != NULL)
 		UML_LONGJMP(current->thread.fault_catcher, 1);
-	else
-		relay_signal(sig, si, regs);
+	else relay_signal(sig, regs);
 }
 
-void winch(int sig, struct siginfo *unused_si, struct uml_pt_regs *regs)
+void winch(int sig, struct uml_pt_regs *regs)
 {
 	do_IRQ(WINCH_IRQ, regs);
 }
diff --git a/arch/um/os-Linux/internal.h b/arch/um/os-Linux/internal.h
index 0dc2c9f..2c3c3ec 100644
--- a/arch/um/os-Linux/internal.h
+++ b/arch/um/os-Linux/internal.h
@@ -1 +1 @@
-void alarm_handler(int sig, struct siginfo *unused_si, mcontext_t *mc);
+void alarm_handler(int, mcontext_t *);
diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index b1469fe..2d22f1f 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -9,13 +9,12 @@
 #include <errno.h>
 #include <signal.h>
 #include <strings.h>
-#include <as-layout.h>
-#include <kern_util.h>
-#include <os.h>
-#include <sysdep/mcontext.h>
-#include "internal.h"
+#include "as-layout.h"
+#include "kern_util.h"
+#include "os.h"
+#include "sysdep/mcontext.h"
 
-void (*sig_info[NSIG])(int, siginfo_t *, struct uml_pt_regs *) = {
+void (*sig_info[NSIG])(int, struct uml_pt_regs *) = {
 	[SIGTRAP]	= relay_signal,
 	[SIGFPE]	= relay_signal,
 	[SIGILL]	= relay_signal,
@@ -25,7 +24,7 @@ void (*sig_info[NSIG])(int, siginfo_t *, struct uml_pt_regs *) = {
 	[SIGIO]		= sigio_handler,
 	[SIGVTALRM]	= timer_handler };
 
-static void sig_handler_common(int sig, siginfo_t *si, mcontext_t *mc)
+static void sig_handler_common(int sig, mcontext_t *mc)
 {
 	struct uml_pt_regs r;
 	int save_errno = errno;
@@ -41,7 +40,7 @@ static void sig_handler_common(int sig, siginfo_t *si, mcontext_t *mc)
 	if ((sig != SIGIO) && (sig != SIGWINCH) && (sig != SIGVTALRM))
 		unblock_signals();
 
-	(*sig_info[sig])(sig, si, &r);
+	(*sig_info[sig])(sig, &r);
 
 	errno = save_errno;
 }
@@ -61,7 +60,7 @@ static void sig_handler_common(int sig, siginfo_t *si, mcontext_t *mc)
 static int signals_enabled;
 static unsigned int signals_pending;
 
-void sig_handler(int sig, siginfo_t *si, mcontext_t *mc)
+void sig_handler(int sig, mcontext_t *mc)
 {
 	int enabled;
 
@@ -73,7 +72,7 @@ void sig_handler(int sig, siginfo_t *si, mcontext_t *mc)
 
 	block_signals();
 
-	sig_handler_common(sig, si, mc);
+	sig_handler_common(sig, mc);
 
 	set_signals(enabled);
 }
@@ -86,10 +85,10 @@ static void real_alarm_handler(mcontext_t *mc)
 		get_regs_from_mc(&regs, mc);
 	regs.is_user = 0;
 	unblock_signals();
-	timer_handler(SIGVTALRM, NULL, &regs);
+	timer_handler(SIGVTALRM, &regs);
 }
 
-void alarm_handler(int sig, struct siginfo *unused_si, mcontext_t *mc)
+void alarm_handler(int sig, mcontext_t *mc)
 {
 	int enabled;
 
@@ -120,7 +119,7 @@ void set_sigstack(void *sig_stack, int size)
 		panic("enabling signal stack failed, errno = %d\n", errno);
 }
 
-static void (*handlers[_NSIG])(int sig, siginfo_t *si, mcontext_t *mc) = {
+static void (*handlers[_NSIG])(int sig, mcontext_t *mc) = {
 	[SIGSEGV] = sig_handler,
 	[SIGBUS] = sig_handler,
 	[SIGILL] = sig_handler,
@@ -133,7 +132,7 @@ static void (*handlers[_NSIG])(int sig, siginfo_t *si, mcontext_t *mc) = {
 };
 
 
-static void hard_handler(int sig, siginfo_t *si, void *p)
+static void hard_handler(int sig, siginfo_t *info, void *p)
 {
 	struct ucontext *uc = p;
 	mcontext_t *mc = &uc->uc_mcontext;
@@ -162,7 +161,7 @@ static void hard_handler(int sig, siginfo_t *si, void *p)
 		while ((sig = ffs(pending)) != 0){
 			sig--;
 			pending &= ~(1 << sig);
-			(*handlers[sig])(sig, si, mc);
+			(*handlers[sig])(sig, mc);
 		}
 
 		/*
@@ -274,12 +273,9 @@ void unblock_signals(void)
 		 * Deal with SIGIO first because the alarm handler might
 		 * schedule, leaving the pending SIGIO stranded until we come
 		 * back here.
-		 *
-		 * SIGIO's handler doesn't use siginfo or mcontext,
-		 * so they can be NULL.
 		 */
 		if (save_pending & SIGIO_MASK)
-			sig_handler_common(SIGIO, NULL, NULL);
+			sig_handler_common(SIGIO, NULL);
 
 		if (save_pending & SIGVTALRM_MASK)
 			real_alarm_handler(NULL);
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index 4625949..a135db5 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -346,7 +346,6 @@ void userspace(struct uml_pt_regs *regs)
 	int err, status, op, pid = userspace_pid[0];
 	/* To prevent races if using_sysemu changes under us.*/
 	int local_using_sysemu;
-	siginfo_t si;
 
 	/* Handle any immediate reschedules or signals */
 	interrupt_end();
@@ -408,17 +407,13 @@ void userspace(struct uml_pt_regs *regs)
 
 		if (WIFSTOPPED(status)) {
 			int sig = WSTOPSIG(status);
-
-			ptrace(PTRACE_GETSIGINFO, pid, 0, &si);
-
 			switch (sig) {
 			case SIGSEGV:
 				if (PTRACE_FULL_FAULTINFO ||
 				    !ptrace_faultinfo) {
 					get_skas_faultinfo(pid,
 							   &regs->faultinfo);
-					(*sig_info[SIGSEGV])(SIGSEGV, &si,
-							     regs);
+					(*sig_info[SIGSEGV])(SIGSEGV, regs);
 				}
 				else handle_segv(pid, regs);
 				break;
@@ -426,14 +421,14 @@ void userspace(struct uml_pt_regs *regs)
 			        handle_trap(pid, regs, local_using_sysemu);
 				break;
 			case SIGTRAP:
-				relay_signal(SIGTRAP, &si, regs);
+				relay_signal(SIGTRAP, regs);
 				break;
 			case SIGVTALRM:
 				now = os_nsecs();
 				if (now < nsecs)
 					break;
 				block_signals();
-				(*sig_info[sig])(sig, &si, regs);
+				(*sig_info[sig])(sig, regs);
 				unblock_signals();
 				nsecs = timer.it_value.tv_sec *
 					UM_NSEC_PER_SEC +
@@ -447,7 +442,7 @@ void userspace(struct uml_pt_regs *regs)
 			case SIGFPE:
 			case SIGWINCH:
 				block_signals();
-				(*sig_info[sig])(sig, &si, regs);
+				(*sig_info[sig])(sig, regs);
 				unblock_signals();
 				break;
 			default:
diff --git a/arch/um/os-Linux/time.c b/arch/um/os-Linux/time.c
index fac388c..fbb2bcf 100644
--- a/arch/um/os-Linux/time.c
+++ b/arch/um/os-Linux/time.c
@@ -87,7 +87,7 @@ static int after_sleep_interval(struct timespec *ts)
 
 static void deliver_alarm(void)
 {
-	alarm_handler(SIGVTALRM, NULL, NULL);
+	alarm_handler(SIGVTALRM, NULL);
 }
 
 static unsigned long long sleep_time(unsigned long long nsecs)

--MP_/dIXUSFwq/xOLd6baGKUpnZk--
