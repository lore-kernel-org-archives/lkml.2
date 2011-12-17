Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171Ab1LQAwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 19:52:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1LQAwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 19:52:08 -0500
Date: Fri, 16 Dec 2011 16:52:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: Re: [PATCH] panic: Don't print redundant backtraces on oops
Message-Id: <20111216165207.cc75af5c.akpm@linux-foundation.org>
In-Reply-To: <1323304603-27895-1-git-send-email-andi@firstfloor.org>
References: <1323304603-27895-1-git-send-email-andi@firstfloor.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Dec 2011 16:36:43 -0800
Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> When an oops causes a panic and panic prints another backtrace it's
> pretty common to have the original oops data be scrolled away on a 80x50
> screen.
> 
> The second backtrace is quite redundant and not needed anyways.
> 
> So don't print the panic backtrace when oops_in_progress is true.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  kernel/panic.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/panic.c b/kernel/panic.c
> index b2659360..398412b 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -78,7 +78,8 @@ NORET_TYPE void panic(const char * fmt, ...)
>  	va_end(args);
>  	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
>  #ifdef CONFIG_DEBUG_BUGVERBOSE
> -	dump_stack();
> +	if (!oops_in_progress)
> +		dump_stack();
>  #endif

This is kinda related to Michael's
kdump-fix-crash_kexec-smp_send_stop-race-in-panic.patch, below.

afacit Michael's patch will prevent panic-within-panic, and it does
this by accident becasue we never thought about it.  But it won't fix
panic-within-other-oops.

Is there some clever way in which we can satisfy both requirements in
one hit?



From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: kdump: fix crash_kexec()/smp_send_stop() race in panic()

When two CPUs call panic at the same time there is a possible race
condition that can stop kdump.  The first CPU calls crash_kexec() and the
second CPU calls smp_send_stop() in panic() before crash_kexec() finished
on the first CPU.  So the second CPU stops the first CPU and therefore
kdump fails:

1st CPU:
panic()->crash_kexec()->mutex_trylock(&kexec_mutex)-> do kdump

2nd CPU:
panic()->crash_kexec()->kexec_mutex already held by 1st CPU
       ->smp_send_stop()-> stop 1st CPU (stop kdump)

This patch fixes the problem by introducing a spinlock in panic that
allows only one CPU to process crash_kexec() and the subsequent panic
code.

All other CPUs call the weak function panic_smp_self_stop() that stops the
CPU itself.  This function can be overloaded by architecture code.  For
example "tile" can use their lower-power "nap" instruction for that.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff -puN kernel/panic.c~kdump-fix-crash_kexec-smp_send_stop-race-in-panic kernel/panic.c
--- a/kernel/panic.c~kdump-fix-crash_kexec-smp_send_stop-race-in-panic
+++ a/kernel/panic.c
@@ -49,6 +49,15 @@ static long no_blink(int state)
 long (*panic_blink)(int state);
 EXPORT_SYMBOL(panic_blink);
 
+/*
+ * Stop ourself in panic -- architecture code may override this
+ */
+void __weak panic_smp_self_stop(void)
+{
+	while (1)
+		cpu_relax();
+}
+
 /**
  *	panic - halt the system
  *	@fmt: The text string to print
@@ -59,6 +68,7 @@ EXPORT_SYMBOL(panic_blink);
  */
 void panic(const char *fmt, ...)
 {
+	static DEFINE_SPINLOCK(panic_lock);
 	static char buf[1024];
 	va_list args;
 	long i, i_next = 0;
@@ -68,8 +78,14 @@ void panic(const char *fmt, ...)
 	 * It's possible to come here directly from a panic-assertion and
 	 * not have preempt disabled. Some functions called from here want
 	 * preempt to be disabled. No point enabling it later though...
+	 *
+	 * Only one CPU is allowed to execute the panic code from here. For
+	 * multiple parallel invocations of panic, all other CPUs either
+	 * stop themself or will wait until they are stopped by the 1st CPU
+	 * with smp_send_stop().
 	 */
-	preempt_disable();
+	if (!spin_trylock(&panic_lock))
+		panic_smp_self_stop();
 
 	console_verbose();
 	bust_spinlocks(1);
_

