Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab3AIVj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:39:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:41965 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933196Ab3AIUiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Robin Holt <holt@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 16/80] SGI-XP: handle non-fatal traps
Date: Wed,  9 Jan 2013 12:35:08 -0800
Message-Id: <20130109201502.460305774@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Holt <holt@sgi.com>

commit 891348ca0f66206f1dc0e30d63757e3df1ae2d15 upstream.

We found a user code which was raising a divide-by-zero trap.  That trap
would lead to XPC connections between system-partitions being torn down
due to the die_chain notifier callouts it received.

This also revealed a different issue where multiple callers into
xpc_die_deactivate() would all attempt to do the disconnect in parallel
which would sometimes lock up but often overwhelm the console on very
large machines as each would print at least one line of output at the
end of the deactivate.

I reviewed all the users of the die_chain notifier and changed the code
to ignore the notifier callouts for reasons which will not actually lead
to a system to continue on to call die().

[akpm@linux-foundation.org: fix ia64]
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/sgi-xp/xpc_main.c |   34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

--- a/drivers/misc/sgi-xp/xpc_main.c
+++ b/drivers/misc/sgi-xp/xpc_main.c
@@ -53,6 +53,10 @@
 #include <linux/kthread.h>
 #include "xpc.h"
 
+#ifdef CONFIG_X86_64
+#include <asm/traps.h>
+#endif
+
 /* define two XPC debug device structures to be used with dev_dbg() et al */
 
 struct device_driver xpc_dbg_name = {
@@ -1079,6 +1083,9 @@ xpc_system_reboot(struct notifier_block
 	return NOTIFY_DONE;
 }
 
+/* Used to only allow one cpu to complete disconnect */
+static unsigned int xpc_die_disconnecting;
+
 /*
  * Notify other partitions to deactivate from us by first disengaging from all
  * references to our memory.
@@ -1092,6 +1099,9 @@ xpc_die_deactivate(void)
 	long keep_waiting;
 	long wait_to_print;
 
+	if (cmpxchg(&xpc_die_disconnecting, 0, 1))
+		return;
+
 	/* keep xpc_hb_checker thread from doing anything (just in case) */
 	xpc_exiting = 1;
 
@@ -1159,7 +1169,7 @@ xpc_die_deactivate(void)
  * about the lack of a heartbeat.
  */
 static int
-xpc_system_die(struct notifier_block *nb, unsigned long event, void *unused)
+xpc_system_die(struct notifier_block *nb, unsigned long event, void *_die_args)
 {
 #ifdef CONFIG_IA64		/* !!! temporary kludge */
 	switch (event) {
@@ -1191,7 +1201,27 @@ xpc_system_die(struct notifier_block *nb
 		break;
 	}
 #else
-	xpc_die_deactivate();
+	struct die_args *die_args = _die_args;
+
+	switch (event) {
+	case DIE_TRAP:
+		if (die_args->trapnr == X86_TRAP_DF)
+			xpc_die_deactivate();
+
+		if (((die_args->trapnr == X86_TRAP_MF) ||
+		     (die_args->trapnr == X86_TRAP_XF)) &&
+		    !user_mode_vm(die_args->regs))
+			xpc_die_deactivate();
+
+		break;
+	case DIE_INT3:
+	case DIE_DEBUG:
+		break;
+	case DIE_OOPS:
+	case DIE_GPF:
+	default:
+		xpc_die_deactivate();
+	}
 #endif
 
 	return NOTIFY_DONE;


