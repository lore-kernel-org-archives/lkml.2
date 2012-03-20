Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab2CTBBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 21:01:13 -0400
Received: from mail1.windriver.com ([147.11.146.13]:65492 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab2CTBBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 21:01:12 -0400
Message-ID: <4F67D6BA.2000500@windriver.com>
Date: Mon, 19 Mar 2012 20:00:42 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 4/4] kgdb: x86: Detach gdb if machine shuts down or reboots
References: <cover.1331900215.git.jan.kiszka@siemens.com> <f0f7cff3e5a7679de73a3338138f023ed3aca39c.1331900215.git.jan.kiszka@siemens.com> <4F635E06.8070006@windriver.com> <4F673981.8030709@siemens.com>
In-Reply-To: <4F673981.8030709@siemens.com>
X-Enigmail-Version: 1.4
Content-Type: multipart/mixed;
	boundary="------------010207040001070301070808"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------010207040001070301070808
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 03/19/2012 08:49 AM, Jan Kiszka wrote:
> 
> An arch-independent hook has its advantages, no question. Maybe we
> should just start this way and then evolved on top as needed.
> 

Sounds good to me.  I added the reboot notifier patch into the merge queue for kgdb/kdb.

> I was wondering why those other archs do not use the notifier. Maybe one
> motivation is to avoid that too much code is excluded from the debugger
> by detaching too early. Could possibly be addressed by making
> detach-on-reboot runtime configurable.

There really isn't a whole lot of code between reboot hook invoked from kernel_restart_prepare(), and the place where the reset is invoked.  Specifically it looked like:

        usermodehelper_disable();
        device_shutdown();
        syscore_shutdown();
        machine_restart(cmd);

Attached is the patch you asked for the conditional behavior with respect to the reboot hook.  This also implements the ability to stop on a reboot that is not a panic().

Cheers,
Jason.

--------------010207040001070301070808
Content-Type: text/x-diff;
	name="0001-kgdb-debug_core-add-the-ability-to-control-the-reboo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-kgdb-debug_core-add-the-ability-to-control-the-reboo.pa";
	filename*1="tch"

>From 7bd0d272730f276b996110d8777d8deacbcb3d15 Mon Sep 17 00:00:00 2001
From: Jason Wessel <jason.wessel@windriver.com>
Date: Mon, 19 Mar 2012 19:35:55 -0500
Subject: [PATCH] kgdb,debug_core: add the ability to control the reboot
 notifier

Sometimes it is desirable to stop the kernel debugger before allowing
a system to reboot either with kdb or kgdb.  This patch adds the
ability to turn the reboot notifier on and off or enter the debugger
and stop kernel execution before rebooting.

It is possible to change the setting after booting the kernel with the
following:

echo 1 > /sys/module/debug_core/parameters/kgdbreboot

It is also possible to change this setting using kdb / kgdb to
manipulate the variable directly.

Using KDB:
   mm kgdbreboot 1

Using gdb:
   set kgdbreboot=1

Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 Documentation/DocBook/kgdb.tmpl |   17 +++++++++++++++++
 kernel/debug/debug_core.c       |   16 ++++++++++++++++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
index d71b57f..4ee4ba3 100644
--- a/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -362,6 +362,23 @@
    </para>
   </para>
   </sect1>
+   <sect1 id="kgdbreboot">
+   <title>Run time parameter: kgdbreboot</title>
+   <para> The kgdbreboot feature allows you to change how the debugger
+   deals with the reboot notification.  You have 3 choices for the
+   behavior.  The default behavior is always set to 0.</para>
+   <orderedlist>
+   <listitem><para>echo -1 > /sys/module/debug_core/parameters/kgdbreboot</para>
+   <para>Ignore the reboot notification entirely.</para>
+   </listitem>
+   <listitem><para>echo 0 > /sys/module/debug_core/parameters/kgdbreboot</para>
+   <para>Send the detach message to any attached debugger client.</para>
+   </listitem>
+   <listitem><para>echo 1 > /sys/module/debug_core/parameters/kgdbreboot</para>
+   <para>Enter the debugger on reboot notify.</para>
+   </listitem>
+   </orderedlist>
+  </sect1>
   </chapter>
   <chapter id="usingKDB">
   <title>Using kdb</title>
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 3c1ad4e..3f88a45 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -76,6 +76,8 @@ static int			exception_level;
 struct kgdb_io		*dbg_io_ops;
 static DEFINE_SPINLOCK(kgdb_registration_lock);
 
+/* Action for the reboot notifiter, a global allow kdb to change it */
+static int kgdbreboot;
 /* kgdb console driver is loaded */
 static int kgdb_con_registered;
 /* determine if kgdb console output should be used */
@@ -97,6 +99,7 @@ static int __init opt_kgdb_con(char *str)
 early_param("kgdbcon", opt_kgdb_con);
 
 module_param(kgdb_use_con, int, 0644);
+module_param(kgdbreboot, int, 0644);
 
 /*
  * Holds information about breakpoints in a kernel. These breakpoints are
@@ -788,8 +791,21 @@ void __init dbg_late_init(void)
 static int
 dbg_notify_reboot(struct notifier_block *this, unsigned long code, void *x)
 {
+	/*
+	 * Take the following action on reboot notify depending on value:
+	 *    1 == Enter debugger
+	 *    0 == [the default] detatch debug client
+	 *   -1 == Do nothing... and use this until the board resets
+	 */
+	switch (kgdbreboot) {
+	case 1:
+		kgdb_breakpoint();
+	case -1:
+		goto done;
+	}
 	if (!dbg_kdb_mode)
 		gdbstub_exit(code);
+done:
 	return NOTIFY_DONE;
 }
 
-- 
1.7.5.4


--------------010207040001070301070808--
