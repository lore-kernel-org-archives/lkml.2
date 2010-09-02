Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab0IBMvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 08:51:17 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:50516 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab0IBMvQ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Thu, 2 Sep 2010 08:51:16 -0400
Message-Id: <4C7FB9E30200007800013F5E@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 02 Sep 2010 13:51:15 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: adjust setting of tsc_unstable
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Directly setting tsc_unstable (as done by unsynchronized_tsc() and
dmi_mark_tsc_unstable()) isn't correct, as it doesn't enforce the
(side) effect of altering clocksource_tsc, thus still allowing this
clock source to be monitored by the watchdog, eventually leading to a
"clocksource unstable" message.

unsynchronized_tsc(), according to all its other return paths, really
should leave calling of mark_tsc_unstable() to its caller.

dmi_mark_tsc_unstable() should call mark_tsc_unstable() itself.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/tsc.h |    2 +-
 arch/x86/kernel/tsc.c      |    8 +++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

--- linux-2.6.36-rc3/arch/x86/include/asm/tsc.h
+++ 2.6.36-rc3-x86-mark-tsc-unstable/arch/x86/include/asm/tsc.h
@@ -46,7 +46,7 @@ static __always_inline cycles_t vget_cyc
 }
 
 extern void tsc_init(void);
-extern void mark_tsc_unstable(char *reason);
+extern void mark_tsc_unstable(const char *reason);
 extern int unsynchronized_tsc(void);
 extern int check_tsc_unstable(void);
 extern unsigned long native_calibrate_tsc(void);
--- linux-2.6.36-rc3/arch/x86/kernel/tsc.c
+++ 2.6.36-rc3-x86-mark-tsc-unstable/arch/x86/kernel/tsc.c
@@ -796,7 +796,7 @@ static struct clocksource clocksource_ts
 #endif
 };
 
-void mark_tsc_unstable(char *reason)
+void mark_tsc_unstable(const char *reason)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
@@ -816,9 +816,7 @@ EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 
 static int __init dmi_mark_tsc_unstable(const struct dmi_system_id *d)
 {
-	printk(KERN_NOTICE "%s detected: marking TSC unstable.\n",
-			d->ident);
-	tsc_unstable = 1;
+	mark_tsc_unstable(d->ident);
 	return 0;
 }
 
@@ -874,7 +872,7 @@ __cpuinit int unsynchronized_tsc(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
 		/* assume multi socket systems are not synchronized: */
 		if (num_possible_cpus() > 1)
-			tsc_unstable = 1;
+			return 1;
 	}
 
 	return tsc_unstable;



