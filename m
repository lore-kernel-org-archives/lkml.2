Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032946Ab2CPPi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:38:26 -0400
Received: from mail1.windriver.com ([147.11.146.13]:60829 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031171Ab2CPPiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:38:25 -0400
Message-ID: <4F635E06.8070006@windriver.com>
Date: Fri, 16 Mar 2012 10:36:38 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>
Subject: Re: [PATCH 4/4] kgdb: x86: Detach gdb if machine shuts down or reboots
References: <cover.1331900215.git.jan.kiszka@siemens.com> <f0f7cff3e5a7679de73a3338138f023ed3aca39c.1331900215.git.jan.kiszka@siemens.com>
In-Reply-To: <f0f7cff3e5a7679de73a3338138f023ed3aca39c.1331900215.git.jan.kiszka@siemens.com>
X-Enigmail-Version: 1.4
Content-Type: multipart/mixed;
	boundary="------------040102010608020602040401"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------040102010608020602040401
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 03/16/2012 07:17 AM, Jan Kiszka wrote:
> Hook into machine restart/power-off/halt handlers and call gdbstub_exit
> so that a attached gdb frontend is properly informed. If kgdb is
> disabled or no frontend attached, gdbstub_exit will do nothing.
> 


We have long had an out of tree patch which hooked the reboot notifier, vs adding call backs to the actual reboot functions.  It seems at first glance that all of cases that Jan probably cares about are actually caught by the reboot notifier.

I attached the patch I am referencing, and perhaps Jan can try it out.   It applies on top of Jan's series at the moment.

A few more comments first.

>  static void __machine_emergency_restart(int emergency)
>  {
>  	reboot_emergency = emergency;
> +	gdbstub_exit(1);


If we do have to add callbacks at the arch level, my preference is to pass the stop code like you would have received in the reboot notifier.  Specifically something like:  gdbstub_exit(SYS_RESTART).

>  	machine_ops.emergency_restart();
>  }
>  
> @@ -730,6 +732,7 @@ struct machine_ops machine_ops = {
>  
>  void machine_power_off(void)
>  {
> +	gdbstub_exit(0);


Similarly gdbstub_exit(SYS_HALT) and so on.

Jan, what do you think about trying the reboot notifier version?

Thanks,
Jason.

--------------040102010608020602040401
Content-Type: text/x-diff; name="kgdb-detach-on-reboot-notify.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kgdb-detach-on-reboot-notify.patch"

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] kgdb,debug-core,gdbstub: Hook the reboot notifier for debugger detach

The gdbstub and kdb should get detached if the system is rebooting.
Calling gdbstub_exit() will set the proper debug core state and send a
message to any debugger that is connected to correctly detach.

An attached debugger will receive the exit code from
include/linux/reboot.h based on SYS_HALT, SYS_REBOOT, etc...

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/debug_core.c |   17 +++++++++++++++++
 kernel/debug/gdbstub.c    |    5 ++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -41,6 +41,7 @@
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/sysrq.h>
+#include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/kgdb.h>
 #include <linux/kdb.h>
@@ -784,6 +785,20 @@ void __init dbg_late_init(void)
 	kdb_init(KDB_INIT_FULL);
 }
 
+static int
+dbg_notify_reboot(struct notifier_block *this, unsigned long code, void *x)
+{
+	if (!dbg_kdb_mode)
+		gdbstub_exit(code);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block dbg_reboot_notifier = {
+	.notifier_call		= dbg_notify_reboot,
+	.next			= NULL,
+	.priority		= INT_MAX,
+};
+
 static void kgdb_register_callbacks(void)
 {
 	if (!kgdb_io_module_registered) {
@@ -791,6 +806,7 @@ static void kgdb_register_callbacks(void
 		kgdb_arch_init();
 		if (!dbg_is_early)
 			kgdb_arch_late();
+		register_reboot_notifier(&dbg_reboot_notifier);
 		atomic_notifier_chain_register(&panic_notifier_list,
 					       &kgdb_panic_event_nb);
 #ifdef CONFIG_MAGIC_SYSRQ
@@ -812,6 +828,7 @@ static void kgdb_unregister_callbacks(vo
 	 */
 	if (kgdb_io_module_registered) {
 		kgdb_io_module_registered = 0;
+		unregister_reboot_notifier(&dbg_reboot_notifier);
 		atomic_notifier_chain_unregister(&panic_notifier_list,
 					       &kgdb_panic_event_nb);
 		kgdb_arch_exit();
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -1110,8 +1110,11 @@ void gdbstub_exit(int status)
 {
 	unsigned char checksum, ch, buffer[3];
 	int loop;
+	if (!kgdb_connected)
+		return;
+	kgdb_connected = 0;
 
-	if (!dbg_io_ops || !kgdb_connected)
+	if (!dbg_io_ops || dbg_kdb_mode)
 		return;
 
 	buffer[0] = 'W';

--------------040102010608020602040401--
