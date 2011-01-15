Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab1AOLDS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 06:03:18 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:37962 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1AOLDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 06:03:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=GCZPU8QNhNl8fLJpo8HPv0g4GqzDlaydULx7b8FejcmMxPYU0yViC4fV+UC/BRX+J5
         xlykLR+4TYi69NTJK4UO4qK55vA2Gya1Gwxdak8ok/LYOOvFjOwPlm+0KWUr4UzU7+XH
         NpoKBDCsM+j4v4YSKosIfXu9eyzqnbCLgtTaI=
Date: Sat, 15 Jan 2011 19:03:02 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        fweisbec@gmail.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] panic: ratelimit panic messages
Message-ID: <20110115110301.GA3968@darkstar>
References: <1294198711-15492-1-git-send-email-dzickus@redhat.com>
 <1294198711-15492-2-git-send-email-dzickus@redhat.com>
 <20110105145128.3b635ae7.akpm@linux-foundation.org>
 <AANLkTinWqVHN=1hMmz-wqz2ot=MP8SCQmgjtPMFLmDG3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinWqVHN=1hMmz-wqz2ot=MP8SCQmgjtPMFLmDG3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 04:29:13PM +0800, Dave Young wrote:
> On Thu, Jan 6, 2011 at 6:51 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Tue,  4 Jan 2011 22:38:30 -0500
> > Don Zickus <dzickus@redhat.com> wrote:
> >
> >> Sometimes when things go bad, so much spew is coming on the console it is hard
> >> to figure out what happened.  This patch allows you to ratelimit the panic
> >> messages with the intent that the first panic message will provide the info
> >> we need to figure out what happened.
> >>
> >> Adds new kernel param 'panic_ratelimit=on/<integer in seconds>'
> >>
> >
> > Terminological whinge: panic() is a specific kernel API which ends up
> > doing a sort-of-oops thing.  So the graph is
> >
> >        panic           -> oops
> >        other-things    -> oops
> >
> > Your patch doesn't affect only panics - it also affects oops, BUG(),
> > etc.  So I'd suggest that this patch should do s/panic/oops/g.
> >
> >> ---
> >>  Documentation/kernel-parameters.txt |    6 ++++++
> >>  kernel/panic.c                      |   30 ++++++++++++++++++++++++++++++
> >>  2 files changed, 36 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> >> index 316c723..1416964 100644
> >> --- a/Documentation/kernel-parameters.txt
> >> +++ b/Documentation/kernel-parameters.txt
> >> @@ -1807,6 +1807,12 @@ and is between 256 and 4096 characters. It is defined in the file
> >>       panic=          [KNL] Kernel behaviour on panic
> >>                       Format: <timeout>
> >>
> >> +     panic_ratelimit=        [KNL] ratelimit the panic messages
> >> +                     Useful for slowing down multiple panics to capture
> >> +                     the first one before it scrolls off the screen
> >> +                     Format: "on" or some integer in seconds
> >> +                     "on" defaults to 10 minutes
> >> +
> >
> > We keep on hacking away at this and things never seem to get much
> > better.  It's still the case that a large number of our oops reports
> > are damaged because the important parts of the oops trace scrolled off
> > the screen.
> >
> > I therefore propose
> >
> >        oops_lines_delay=N,M
> >
> > which will cause the kernel to pause for M milliseconds after emitting
> > N lines of oops output.  Bonus marks for handling linewrap!
> 
> I ever try to do similar things to printk_delay, something like
> printk_lines_delay,
> or give printk_delay one more parameter of lines.
> 
> What do you think about this approach?
> 

I refreshed my old patch about this, please see following patch:
---

printk_delay helps us to capture printk messages on some unconvenient
senarios, ie.  on halt phase.  But the messages is still not easy to read.

So this patch add another sysctl variable printk_delay_lines to make the
messages can be delayed after multi printks.  Thus we can take pictures by
camera easily and the messages will be more readable.

kmesg will delay printk_delay_msecs milliseconds after every
printk_delay_lines printks when printk_delay > 0.

Additional, merge boot_delay into printk_delay function.  remove
boot_delay boot param, add printk_delay and printk_delay_lines instead.

Now, we can set the value by:

1. sysctl interface:
/proc/sys/kernel/printk_delay
/proc/sys/kernel/printk_delay_lines

2. boot params:
printk_delay
printk_delay_lines

printk_delay_lines range from 1 - 10000, default value is 1

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 Documentation/kernel-parameters.txt |   20 +++++++++-
 Documentation/sysctl/kernel.txt     |    9 ++++
 include/linux/printk.h              |    1 
 kernel/printk.c                     |   70 +++++++++++++++++++-----------------
 kernel/sysctl.c                     |    9 ++++
 lib/Kconfig.debug                   |   18 ---------
 6 files changed, 74 insertions(+), 53 deletions(-)

--- linux-2.6.orig/Documentation/kernel-parameters.txt	2011-01-15 17:40:02.137333554 +0800
+++ linux-2.6/Documentation/kernel-parameters.txt	2011-01-15 17:46:04.235371899 +0800
@@ -385,9 +385,25 @@ and is between 256 and 4096 characters. 
 			Format: <io>,<irq>,<mode>
 			See header of drivers/net/hamradio/baycom_ser_hdx.c.
 
-	boot_delay=	Milliseconds to delay each printk during boot.
+	printk_delay=	Milliseconds to delay each printk.
 			Values larger than 10 seconds (10000) are changed to
-			no delay (0).
+			no delay (0). It can be set via sysctl after boot,
+			the proc file is: /proc/sys/kernel/printk_delay
+			For boot phase printk delay, It is likely that you
+			would also need to use "lpj=M" to preset the
+			"loops per jiffie" value. See a previous boot log for
+			the "lpj" value to use for your system, and then set
+			"lpj=M" before setting "printk_delay=N".
+			NOTE:  Using this option may adversely affect
+			SMP systems. I.e., processors other than the first one
+			may not boot up. It also may cause DETECT_SOFTLOCKUP
+			to detect what it believes to be lockup conditions.
+			Format: integer
+
+	printk_delay_lines=	Delay after every printk_delay_lines printk.
+			Values larger than 10000 are changed to 1.
+			It can be set via sysctl after boot,
+			the proc file is: /proc/sys/kernel/printk_delay_lines
 			Format: integer
 
 	bootmem_debug	[KNL] Enable bootmem allocator debug messages.
--- linux-2.6.orig/Documentation/sysctl/kernel.txt	2011-01-15 17:40:02.137333554 +0800
+++ linux-2.6/Documentation/sysctl/kernel.txt	2011-01-15 17:46:04.235371899 +0800
@@ -402,6 +402,15 @@ Value from 0 - 10000 is allowed.
 
 ==============================================================
 
+printk_delay_lines:
+
+Delay printk message every printk_delay_lines printks
+in printk_delay milliseconds
+
+Value from 1 - 10000 is allowed.
+
+==============================================================
+
 randomize-va-space:
 
 This option can be used to select the type of process address
--- linux-2.6.orig/include/linux/printk.h	2011-01-15 17:40:02.134000239 +0800
+++ linux-2.6/include/linux/printk.h	2011-01-15 17:46:04.235371899 +0800
@@ -109,6 +109,7 @@ extern bool printk_timed_ratelimit(unsig
 				   unsigned int interval_msec);
 
 extern int printk_delay_msec;
+extern int printk_delay_lines;
 extern int dmesg_restrict;
 extern int kptr_restrict;
 
--- linux-2.6.orig/kernel/printk.c	2011-01-15 17:40:02.134000239 +0800
+++ linux-2.6/kernel/printk.c	2011-01-15 18:43:25.984078816 +0800
@@ -203,40 +203,42 @@ out:
 
 __setup("log_buf_len=", log_buf_len_setup);
 
-#ifdef CONFIG_BOOT_PRINTK_DELAY
-
-static int boot_delay; /* msecs delay after each printk during bootup */
-static unsigned long long loops_per_msec;	/* based on boot_delay */
-
-static int __init boot_delay_setup(char *str)
+static unsigned long long loops_per_msec;     /* based on preset_lpj */
+static int __init printk_delay_setup(char *str)
 {
 	unsigned long lpj;
 
 	lpj = preset_lpj ? preset_lpj : 1000000;	/* some guess */
 	loops_per_msec = (unsigned long long)lpj / 1000 * HZ;
+	get_option(&str, &printk_delay_msec);
+	if (printk_delay_msec < 0 || printk_delay_msec > 10 * 1000)
+		printk_delay_msec = 0;
+
+		pr_debug("printk_delay_msec: %u, preset_lpj: %ld, lpj: %lu, "
+			"HZ: %d, loops_per_msec: %llu\n",
+			printk_delay_msec, preset_lpj, lpj, HZ, loops_per_msec);
 
-	get_option(&str, &boot_delay);
-	if (boot_delay > 10 * 1000)
-		boot_delay = 0;
-
-	pr_debug("boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
-		"HZ: %d, loops_per_msec: %llu\n",
-		boot_delay, preset_lpj, lpj, HZ, loops_per_msec);
 	return 1;
 }
-__setup("boot_delay=", boot_delay_setup);
+__setup("printk_delay=", printk_delay_setup);
 
-static void boot_delay_msec(void)
+static int __init printk_delay_lines_setup(char *str)
 {
-	unsigned long long k;
-	unsigned long timeout;
+	get_option(&str, &printk_delay_lines);
+	if (printk_delay_lines < 1 || printk_delay_lines > 10 * 1000)
+		printk_delay_lines = 1;
 
-	if (boot_delay == 0 || system_state != SYSTEM_BOOTING)
-		return;
+	return 1;
+}
+__setup("printk_delay_lines=", printk_delay_lines_setup);
 
-	k = (unsigned long long)loops_per_msec * boot_delay;
+static void boot_delay(void)
+{
+	unsigned long long k;
+	unsigned long timeout;
 
-	timeout = jiffies + msecs_to_jiffies(boot_delay);
+	k = (unsigned long long)loops_per_msec * printk_delay_msec;
+	timeout = jiffies + msecs_to_jiffies(printk_delay_msec);
 	while (k) {
 		k--;
 		cpu_relax();
@@ -250,11 +252,6 @@ static void boot_delay_msec(void)
 		touch_nmi_watchdog();
 	}
 }
-#else
-static inline void boot_delay_msec(void)
-{
-}
-#endif
 
 #ifdef CONFIG_SECURITY_DMESG_RESTRICT
 int dmesg_restrict = 1;
@@ -697,16 +694,25 @@ static int new_text_line = 1;
 static char printk_buf[1024];
 
 int printk_delay_msec __read_mostly;
+int printk_delay_lines __read_mostly = 1;
 
 static inline void printk_delay(void)
 {
 	if (unlikely(printk_delay_msec)) {
+		static atomic_t l = ATOMIC_INIT(0);
 		int m = printk_delay_msec;
 
-		while (m--) {
-			mdelay(1);
-			touch_nmi_watchdog();
-		}
+		atomic_cmpxchg(&l, 0, printk_delay_lines);
+		if (atomic_dec_return(&l))
+			return;
+
+		if (system_state == SYSTEM_BOOTING)
+			boot_delay();
+		else
+			while (m--) {
+				mdelay(1);
+				touch_nmi_watchdog();
+			}
 	}
 }
 
@@ -718,9 +724,6 @@ asmlinkage int vprintk(const char *fmt, 
 	int this_cpu;
 	char *p;
 
-	boot_delay_msec();
-	printk_delay();
-
 	preempt_disable();
 	/* This stops the holder of console_sem just where we want him */
 	raw_local_irq_save(flags);
@@ -839,6 +842,7 @@ out_restore_irqs:
 	raw_local_irq_restore(flags);
 
 	preempt_enable();
+	printk_delay();
 	return printed_len;
 }
 EXPORT_SYMBOL(printk);
--- linux-2.6.orig/kernel/sysctl.c	2011-01-15 17:40:02.134000239 +0800
+++ linux-2.6/kernel/sysctl.c	2011-01-15 17:46:04.238705214 +0800
@@ -716,6 +716,15 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
+	{
+		.procname	= "printk_delay_lines",
+		.data		= &printk_delay_lines,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
+		.extra2		= &ten_thousand,
+	},
 #endif
 	{
 		.procname	= "ngroups_max",
--- linux-2.6.orig/lib/Kconfig.debug	2011-01-15 17:40:02.137333554 +0800
+++ linux-2.6/lib/Kconfig.debug	2011-01-15 17:46:04.238705214 +0800
@@ -814,24 +814,6 @@ config FRAME_POINTER
 	  larger and slower, but it gives very useful debugging information
 	  in case of kernel bugs. (precise oopses/stacktraces/warnings)
 
-config BOOT_PRINTK_DELAY
-	bool "Delay each boot printk message by N milliseconds"
-	depends on DEBUG_KERNEL && PRINTK && GENERIC_CALIBRATE_DELAY
-	help
-	  This build option allows you to read kernel boot messages
-	  by inserting a short delay after each one.  The delay is
-	  specified in milliseconds on the kernel command line,
-	  using "boot_delay=N".
-
-	  It is likely that you would also need to use "lpj=M" to preset
-	  the "loops per jiffie" value.
-	  See a previous boot log for the "lpj" value to use for your
-	  system, and then set "lpj=M" before setting "boot_delay=N".
-	  NOTE:  Using this option may adversely affect SMP systems.
-	  I.e., processors other than the first one may not boot up.
-	  BOOT_PRINTK_DELAY also may cause DETECT_SOFTLOCKUP to detect
-	  what it believes to be lockup conditions.
-
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL
