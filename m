Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab1FEOpV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 10:45:21 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:10193 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab1FEOpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 10:45:18 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/X5zri/u5Y1+fsZ6BmRA==
X-RZG-CLASS-ID: mo00
Message-ID: <4DEB9673.4000204@die-jansens.de>
Date: Sun, 05 Jun 2011 16:45:07 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
References: <20110605081747.GA17920@elte.hu> <4DEB4FA7.3050400@die-jansens.de> <20110605095555.GA22058@elte.hu> <4DEB58D8.4000805@die-jansens.de> <20110605110132.GB23463@elte.hu> <20110605111933.GA24592@elte.hu> <20110605113627.GA25724@elte.hu> <4DEB6F3A.3000109@die-jansens.de> <20110605133958.GA27812@elte.hu> <4DEB8A93.30601@die-jansens.de> <20110605140602.GA29338@elte.hu>
In-Reply-To: <20110605140602.GA29338@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------010400080107020202000007"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010400080107020202000007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 05.06.2011 16:06, Ingo Molnar wrote:
>
> * Arne Jansen<lists@die-jansens.de>  wrote:
>
>> On 05.06.2011 15:39, Ingo Molnar wrote:
>>>
>>> * Arne Jansen<lists@die-jansens.de>   wrote:
>>>
>>>>>> Warning: it's entirely untested.
>>>>
>>>> How is the output supposed to come through? shouldn't printk revert
>>>> to early_printk instead of just returning?
>>>
>>> oh, right you are.
>>>
>>> Does the patch below work? It does early-printk within printk().
>>
>> Too late, I already built my on early_vprintk ;)
>
> heh :-)
>
> Mind posting the patch? Your tested patch is infinitely more valuable
> than my not-even-build-tested patch ;-)

It's basically just your patch. I attached it nevertheless...

-Arne


--------------010400080107020202000007
Content-Type: text/x-patch;
 name="printk_kill.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="printk_kill.patch"

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index cd28a35..0623126 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -171,7 +171,7 @@ static struct console early_serial_console = {
 
 /* Direct interface for emergencies */
 static struct console *early_console = &early_vga_console;
-static int __initdata early_console_initialized;
+int early_console_initialized;
 
 asmlinkage void early_printk(const char *fmt, ...)
 {
@@ -185,6 +185,15 @@ asmlinkage void early_printk(const char *fmt, ...)
 	va_end(ap);
 }
 
+asmlinkage void early_vprintk(const char *fmt, va_list ap)
+{
+	char buf[512];
+	int n;
+
+	n = vscnprintf(buf, sizeof(buf), fmt, ap);
+	early_console->write(early_console, buf, n);
+}
+
 static inline void early_console_register(struct console *con, int keep_early)
 {
 	if (early_console->index != -1) {
diff --git a/include/linux/printk.h b/include/linux/printk.h
index ee048e7..6bb6963 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -86,8 +86,11 @@ int no_printk(const char *fmt, ...)
 	return 0;
 }
 
+extern int early_console_initialized;
+
 extern asmlinkage __attribute__ ((format (printf, 1, 2)))
 void early_printk(const char *fmt, ...);
+void early_vprintk(const char *fmt, va_list args);
 
 extern int printk_needs_cpu(int cpu);
 extern void printk_tick(void);
@@ -112,6 +115,8 @@ extern int printk_delay_msec;
 extern int dmesg_restrict;
 extern int kptr_restrict;
 
+extern void printk_kill(void);
+
 void log_buf_kexec_setup(void);
 #else
 static inline __attribute__ ((format (printf, 1, 0)))
diff --git a/kernel/printk.c b/kernel/printk.c
index da8ca81..38f880f 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -490,6 +490,19 @@ static void __call_console_drivers(unsigned start, unsigned end)
 	}
 }
 
+/*
+ * This is independent of any log levels - a global
+ * kill switch that turns off all of printk.
+ *
+ * Used by the NMI watchdog if early-printk is enabled.
+ */
+static int __read_mostly printk_killswitch;
+
+void printk_kill(void)
+{
+	printk_killswitch = 1;
+}
+
 static int __read_mostly ignore_loglevel;
 
 static int __init ignore_loglevel_setup(char *str)
@@ -804,6 +817,15 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	size_t plen;
 	char special;
 
+	/*
+	 * Fall back to early_printk if a debugging subsystem has
+	 * killed printk output
+	 */
+	if (unlikely(printk_killswitch)) {
+		early_vprintk(fmt, args);
+		return 1;
+	}
+
 	boot_delay_msec();
 	printk_delay();
 
@@ -1504,6 +1526,7 @@ void register_console(struct console *newcon)
 		for_each_console(bcon)
 			if (bcon->flags & CON_BOOT)
 				unregister_console(bcon);
+		early_console_initialized = 0;
 	} else {
 		printk(KERN_INFO "%sconsole [%s%d] enabled\n",
 			(newcon->flags & CON_BOOT) ? "boot" : "" ,
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 140dce7..18fca3d 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -197,6 +197,8 @@ static struct perf_event_attr wd_hw_attr = {
 	.disabled	= 1,
 };
 
+static DEFINE_SPINLOCK(watchdog_output_lock);
+
 /* Callback function for perf event subsystem */
 static void watchdog_overflow_callback(struct perf_event *event, int nmi,
 		 struct perf_sample_data *data,
@@ -223,10 +225,20 @@ static void watchdog_overflow_callback(struct perf_event *event, int nmi,
 		if (__this_cpu_read(hard_watchdog_warn) == true)
 			return;
 
-		if (hardlockup_panic)
+		/*
+		 * If early-printk is enabled then make sure we do not
+		 * lock up in printk() and kill console logging:
+		 */
+		if (early_console_initialized)
+			printk_kill();
+
+		if (hardlockup_panic) {
 			panic("Watchdog detected hard LOCKUP on cpu %d", this_cpu);
-		else
+		} else {
+			spin_lock(&watchdog_output_lock);
 			WARN(1, "Watchdog detected hard LOCKUP on cpu %d", this_cpu);
+			spin_unlock(&watchdog_output_lock);
+		}
 
 		__this_cpu_write(hard_watchdog_warn, true);
 		return;

--------------010400080107020202000007--
