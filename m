Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab1BQPti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:49:38 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:55983 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab1BQPtf convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Thu, 17 Feb 2011 10:49:35 -0500
Message-Id: <4D5D51D202000078000326FE@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 17 Feb 2011 15:50:26 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH, resend] x86: adjust setting of tsc_unstable
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Directly setting tsc_unstable (as done by dmi_mark_tsc_unstable(),
recently fixed for unsynchronized_tsc()) isn't correct, as it
doesn't enforce the (side) effect of altering clocksource_tsc, thus
still allowing this clock source to be monitored by the watchdog,
eventually leading to a "clocksource unstable" message.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/tsc.h |    2 +-
 arch/x86/kernel/tsc.c      |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

--- 2.6.38-rc5/arch/x86/include/asm/tsc.h
+++ 2.6.38-rc5-x86-mark-tsc-unstable/arch/x86/include/asm/tsc.h
@@ -46,7 +46,7 @@ static __always_inline cycles_t vget_cyc
 }
 
 extern void tsc_init(void);
-extern void mark_tsc_unstable(char *reason);
+extern void mark_tsc_unstable(const char *reason);
 extern int unsynchronized_tsc(void);
 extern int check_tsc_unstable(void);
 extern unsigned long native_calibrate_tsc(void);
--- 2.6.38-rc5/arch/x86/kernel/tsc.c
+++ 2.6.38-rc5-x86-mark-tsc-unstable/arch/x86/kernel/tsc.c
@@ -800,7 +800,7 @@ static struct clocksource clocksource_ts
 #endif
 };
 
-void mark_tsc_unstable(char *reason)
+void mark_tsc_unstable(const char *reason)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
@@ -821,9 +821,7 @@ EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 
 static int __init dmi_mark_tsc_unstable(const struct dmi_system_id *d)
 {
-	printk(KERN_NOTICE "%s detected: marking TSC unstable.\n",
-			d->ident);
-	tsc_unstable = 1;
+	mark_tsc_unstable(d->ident);
 	return 0;
 }
 



