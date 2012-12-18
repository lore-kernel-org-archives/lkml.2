Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab2LRRwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:52:47 -0500
Received: from relay3.sgi.com ([192.48.152.1]:41085 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752299Ab2LRRwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:52:45 -0500
Date: Tue, 18 Dec 2012 11:52:43 -0600
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: [Patch][resend] SGI-XP: Handle non-fatal traps.
Message-ID: <20121218175243.GP3452@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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


To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Robin Holt <holt@sgi.com>

---

This is essentially a resend.  Originally, I sent it to Thomas and Ingo as
they had originally worked with Dean Nelson in his effort to get this area
of code included.  It is not entirely x86 specific so I am assuming that
is why I have not seen any action on the patch and am resending to Andrew.

 drivers/misc/sgi-xp/xpc_main.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

--- linux.orig/drivers/misc/sgi-xp/xpc_main.c
+++ linux/drivers/misc/sgi-xp/xpc_main.c
@@ -53,6 +53,8 @@
 #include <linux/kthread.h>
 #include "xpc.h"
 
+#include <asm/traps.h>
+
 /* define two XPC debug device structures to be used with dev_dbg() et al */
 
 struct device_driver xpc_dbg_name = {
@@ -1079,6 +1081,9 @@ xpc_system_reboot(struct notifier_block
 	return NOTIFY_DONE;
 }
 
+/* Used to only allow one cpu to complete disconnect */
+static unsigned int xpc_die_disconnecting;
+
 /*
  * Notify other partitions to deactivate from us by first disengaging from all
  * references to our memory.
@@ -1092,6 +1097,9 @@ xpc_die_deactivate(void)
 	long keep_waiting;
 	long wait_to_print;
 
+	if (cmpxchg(&xpc_die_disconnecting, 0, 1))
+		return;
+
 	/* keep xpc_hb_checker thread from doing anything (just in case) */
 	xpc_exiting = 1;
 
@@ -1159,7 +1167,7 @@ xpc_die_deactivate(void)
  * about the lack of a heartbeat.
  */
 static int
-xpc_system_die(struct notifier_block *nb, unsigned long event, void *unused)
+xpc_system_die(struct notifier_block *nb, unsigned long event, void *_die_args)
 {
 #ifdef CONFIG_IA64		/* !!! temporary kludge */
 	switch (event) {
@@ -1191,7 +1199,27 @@ xpc_system_die(struct notifier_block *nb
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
