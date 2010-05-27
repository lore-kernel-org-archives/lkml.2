Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab0E0Waa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:30:30 -0400
Received: from s12.ALPHA-c2.vectant.ne.jp ([222.230.51.12]:39384 "EHLO
	s12.ALPHA-c2.vectant.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753653Ab0E0Wa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:30:28 -0400
X-Greylist: delayed 1971 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 May 2010 18:30:28 EDT
Message-Id: <201005272156.AA00412@tamuki.linet.gr.jp>
From: TAMUKI Shoichi <tamuki@linet.gr.jp>
Date: Fri, 28 May 2010 06:56:45 +0900
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Andy Green <andy@warmcat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] panic: keep blinking in spite of long spin timer mode
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To keep panic_timeout accuracy when running under a hypervisor, the
current implementation only spins on long time (1 second) calls to
mdelay.  That brings a good effect, but we must give up blinking even
if we have a panic_blink.

This patch keeps blinking in spite of long spin timer mode.

We now have new kernel parameter (panic_longspin) to enable long spin
timer mode when kernel panics.  This is to be used when running under
a hypervisor (default is disable).

Signed-off-by: TAMUKI Shoichi <tamuki@linet.gr.jp>
---
 Documentation/kernel-parameters.txt |    7 +-
 arch/arm/mach-s3c2440/mach-gta02.c  |   17 +----
 drivers/input/serio/i8042.c         |   25 +-------
 include/linux/kernel.h              |    2 
 kernel/panic.c                      |   81 +++++++++++++++++---------
 5 files changed, 70 insertions(+), 62 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fc89cac..7709450 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -918,9 +918,6 @@ and is between 256 and 4096 characters. It is defined in the file
 			     controller
 	i8042.nopnp	[HW] Don't use ACPIPnP / PnPBIOS to discover KBD/AUX
 			     controllers
-	i8042.panicblink=
-			[HW] Frequency with which keyboard LEDs should blink
-			     when kernel panics (default is 0.5 sec)
 	i8042.reset	[HW] Reset the controller during init and cleanup
 	i8042.unlock	[HW] Unlock (ignore) the keylock
 
@@ -1870,6 +1867,10 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	panic=		[KNL] Kernel behaviour on panic
 			Format: <timeout>
+	panic_longspin	[KNL] Enable long spin timer mode when kernel panics.
+			      This is to be used when running under a hyper-
+			      visor (default is disable)
+	panicblink=	[KNL] The speed of panic blink (default is 12 wpm)
 
 	parkbd.port=	[HW] Parallel port number the keyboard adapter is
 			connected to, default is 0.
diff --git a/arch/arm/mach-s3c2440/mach-gta02.c b/arch/arm/mach-s3c2440/mach-gta02.c
index 45799c6..c68958d 100644
--- a/arch/arm/mach-s3c2440/mach-gta02.c
+++ b/arch/arm/mach-s3c2440/mach-gta02.c
@@ -90,24 +90,17 @@
 static struct pcf50633 *gta02_pcf;
 
 /*
- * This gets called every 1ms when we paniced.
+ * This gets called frequently when we paniced.
  */
 
-static long gta02_panic_blink(long count)
+static long gta02_panic_blink(int state)
 {
 	long delay = 0;
-	static long last_blink;
-	static char led;
+	char led;
 
-	/* Fast blink: 200ms period. */
-	if (count - last_blink < 100)
-		return 0;
-
-	led ^= 1;
+	led = (state) ? 1 : 0;
 	gpio_direction_output(GTA02_GPIO_AUX_LED, led);
 
-	last_blink = count;
-
 	return delay;
 }
 
@@ -614,7 +607,7 @@ static void gta02_poweroff(void)
 
 static void __init gta02_machine_init(void)
 {
-	/* Set the panic callback to make AUX LED blink at ~5Hz. */
+	/* Set the panic callback to turn AUX LED on or off. */
 	panic_blink = gta02_panic_blink;
 
 	s3c_pm_init();
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 6440a8f..c32d9b3 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -61,10 +61,6 @@ static bool i8042_noloop;
 module_param_named(noloop, i8042_noloop, bool, 0);
 MODULE_PARM_DESC(noloop, "Disable the AUX Loopback command while probing for the AUX port");
 
-static unsigned int i8042_blink_frequency = 500;
-module_param_named(panicblink, i8042_blink_frequency, uint, 0600);
-MODULE_PARM_DESC(panicblink, "Frequency with which keyboard LEDs should blink when kernel panics");
-
 #ifdef CONFIG_X86
 static bool i8042_dritek;
 module_param_named(dritek, i8042_dritek, bool, 0);
@@ -1032,8 +1028,8 @@ static void i8042_controller_reset(void)
 
 
 /*
- * i8042_panic_blink() will flash the keyboard LEDs and is called when
- * kernel panics. Flashing LEDs is useful for users running X who may
+ * i8042_panic_blink() will turn the keyboard LEDs on or off and is called
+ * when kernel panics. Flashing LEDs is useful for users running X who may
  * not see the console and will help distingushing panics from "real"
  * lockups.
  *
@@ -1043,22 +1039,12 @@ static void i8042_controller_reset(void)
 
 #define DELAY do { mdelay(1); if (++delay > 10) return delay; } while(0)
 
-static long i8042_panic_blink(long count)
+static long i8042_panic_blink(int state)
 {
 	long delay = 0;
-	static long last_blink;
-	static char led;
-
-	/*
-	 * We expect frequency to be about 1/2s. KDB uses about 1s.
-	 * Make sure they are different.
-	 */
-	if (!i8042_blink_frequency)
-		return 0;
-	if (count - last_blink < i8042_blink_frequency)
-		return 0;
+	char led;
 
-	led ^= 0x01 | 0x04;
+	led = (state) ? 0x01 | 0x04 : 0;
 	while (i8042_read_status() & I8042_STR_IBF)
 		DELAY;
 	dbg("%02x -> i8042 (panic blink)", 0xed);
@@ -1071,7 +1057,6 @@ static long i8042_panic_blink(long count)
 	dbg("%02x -> i8042 (panic blink)", led);
 	i8042_write_data(led);
 	DELAY;
-	last_blink = count;
 	return delay;
 }
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index cc5e3ff..424d130 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -172,7 +172,7 @@ static inline void might_fault(void)
 #endif
 
 extern struct atomic_notifier_head panic_notifier_list;
-extern long (*panic_blink)(long time);
+extern long (*panic_blink)(int state);
 NORET_TYPE void panic(const char * fmt, ...)
 	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
 extern void oops_enter(void);
diff --git a/kernel/panic.c b/kernel/panic.c
index dbe13db..82e9b95 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -31,39 +31,48 @@ static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
 
 int panic_timeout;
+static bool panic_longspin = false;
+static int panic_blink_wpm = 12;
 
 ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
 EXPORT_SYMBOL(panic_notifier_list);
 
+static long no_blink(int state)
+{
+	return 0;
+}
+
 /* Returns how long it waited in ms */
-long (*panic_blink)(long time);
+long (*panic_blink)(int state);
 EXPORT_SYMBOL(panic_blink);
 
-static void panic_blink_one_second(void)
+long panic_blink_enter(long count)
 {
-	static long i = 0, end;
-
-	if (panic_blink) {
-		end = i + MSEC_PER_SEC;
-
-		while (i < end) {
-			i += panic_blink(i);
-			mdelay(1);
-			i++;
-		}
+	int len;
+	long delay = 0;
+	static int state = 1;
+	static int first = 1;
+	static long next_count = 0;
+
+	if (panic_blink_wpm <= 0 || panic_blink_wpm > 100)
+		panic_blink_wpm = 12;
+	len = 3600 / panic_blink_wpm;
+	if (!first && count - next_count < 0)
+		return 0;
+	if (!panic_blink)
+		panic_blink = no_blink;
+	if (state) {
+		delay += panic_blink(0);
+		state = 0;
+		if (first)
+			first = 0;
 	} else {
-		/*
-		 * When running under a hypervisor a small mdelay may get
-		 * rounded up to the hypervisor timeslice. For example, with
-		 * a 1ms in 10ms hypervisor timeslice we might inflate a
-		 * mdelay(1) loop by 10x.
-		 *
-		 * If we have nothing to blink, spin on 1 second calls to
-		 * mdelay to avoid this.
-		 */
-		mdelay(MSEC_PER_SEC);
+		delay += panic_blink(1);
+		state = 1;
 	}
+	next_count = count + len;
+	return delay;
 }
 
 /**
@@ -79,6 +88,7 @@ NORET_TYPE void panic(const char * fmt, ...)
 	static char buf[1024];
 	va_list args;
 	long i;
+	int step = 1;
 
 	/*
 	 * It's possible to come here directly from a panic-assertion and
@@ -116,6 +126,21 @@ NORET_TYPE void panic(const char * fmt, ...)
 
 	bust_spinlocks(0);
 
+	/*
+	 * When running under a hypervisor a small mdelay may get
+	 * rounded up to the hypervisor timeslice. For example, with
+	 * a 1ms in 10ms hypervisor timeslice we might inflate a
+	 * mdelay(1) loop by 10x.
+	 *
+	 * If panic_longspin is true, spin on 240 millisecond calls to
+	 * mdelay to avoid this.
+	 */
+	if (panic_longspin) {
+		step = 240;
+		if (panic_blink_wpm > 5)
+			panic_blink_wpm = 5;
+	}
+
 	if (panic_timeout > 0) {
 		/*
 		 * Delay timeout seconds before rebooting the machine.
@@ -123,9 +148,10 @@ NORET_TYPE void panic(const char * fmt, ...)
 		 */
 		printk(KERN_EMERG "Rebooting in %d seconds..", panic_timeout);
 
-		for (i = 0; i < panic_timeout; i++) {
+		for (i = 0; i < panic_timeout * 1000; i += step) {
 			touch_nmi_watchdog();
-			panic_blink_one_second();
+			i += panic_blink_enter(i);
+			mdelay(step);
 		}
 		/*
 		 * This will not be a clean reboot, with everything
@@ -151,9 +177,10 @@ NORET_TYPE void panic(const char * fmt, ...)
 	}
 #endif
 	local_irq_enable();
-	while (1) {
+	for (i = 0; ; i += step) {
 		touch_softlockup_watchdog();
-		panic_blink_one_second();
+		i += panic_blink_enter(i);
+		mdelay(step);
 	}
 }
 
@@ -436,4 +463,6 @@ EXPORT_SYMBOL(__stack_chk_fail);
 #endif
 
 core_param(panic, panic_timeout, int, 0644);
+core_param(panic_longspin, panic_longspin, bool, 0644);
+core_param(panicblink, panic_blink_wpm, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
