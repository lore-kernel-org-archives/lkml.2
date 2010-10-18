Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab0JRW1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 18:27:25 -0400
Received: from usindmx04.hds.com ([207.126.252.15]:59427 "EHLO
	usindmx04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab0JRW1Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 18:27:24 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
        "anders.grafstrom@netinsight.net" <anders.grafstrom@netinsight.net>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eparis@redhat.com" <eparis@redhat.com>, "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Mon, 18 Oct 2010 18:24:11 -0400
Subject: [RFC][Patch] Adding kmsg_dump() to
 reboot/halt/poweroff/emergency_restart path
Thread-Topic: [RFC][Patch] Adding kmsg_dump() to
 reboot/halt/poweroff/emergency_restart path
Thread-Index: ActvETT/9p9PowcwTqeInxIjhQPHfgAAAVeA
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C11B4B724@USINDEVS01.corp.hds.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Final messages from reboot, halt and poweroff aren't output to disk because klogd/syslogd 
has been killed and root file system has been turned read-only.

Final messages from emergency_restart aren't output to disk as well because system may
reboot before klogd/syslogd outputs messages to disk.

Therefore, it is better to put kmsg_dumper in reboot/halt/poweroff/emergency_restart path.
Any comments/advices are welcome.

Seiji

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 include/linux/kmsg_dump.h |    4 ++++
 kernel/printk.c           |    4 ++++
 kernel/sys.c              |    6 ++++++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/kmsg_dump.h b/include/linux/kmsg_dump.h
index 24b4414..2a0d7d6 100644
--- a/include/linux/kmsg_dump.h
+++ b/include/linux/kmsg_dump.h
@@ -18,6 +18,10 @@ enum kmsg_dump_reason {
 	KMSG_DUMP_OOPS,
 	KMSG_DUMP_PANIC,
 	KMSG_DUMP_KEXEC,
+	KMSG_DUMP_RESTART,
+	KMSG_DUMP_HALT,
+	KMSG_DUMP_POWEROFF,
+	KMSG_DUMP_EMERG,
 };
 
 /**
diff --git a/kernel/printk.c b/kernel/printk.c
index 6d6b09f..6a63848 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1516,6 +1516,10 @@ static const char const *kmsg_reasons[] = {
 	[KMSG_DUMP_OOPS]	= "oops",
 	[KMSG_DUMP_PANIC]	= "panic",
 	[KMSG_DUMP_KEXEC]	= "kexec",
+	[KMSG_DUMP_RESTART]	= "restart",
+	[KMSG_DUMP_HALT]	= "halt",
+	[KMSG_DUMP_POWEROFF]	= "poweroff",
+	[KMSG_DUMP_EMERG]	= "emergency_restart",
 };
 
 static const char *kmsg_to_str(enum kmsg_dump_reason reason)
diff --git a/kernel/sys.c b/kernel/sys.c
index 7f5a0cd..3eab886 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -43,6 +43,8 @@
 #include <linux/kprobes.h>
 #include <linux/user_namespace.h>
 
+#include <linux/kmsg_dump.h>
+
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/unistd.h>
@@ -285,6 +287,7 @@ out_unlock:
  */
 void emergency_restart(void)
 {
+	kmsg_dump(KMSG_DUMP_EMERG);
 	machine_emergency_restart();
 }
 EXPORT_SYMBOL_GPL(emergency_restart);
@@ -312,6 +315,7 @@ void kernel_restart(char *cmd)
 		printk(KERN_EMERG "Restarting system.\n");
 	else
 		printk(KERN_EMERG "Restarting system with command '%s'.\n", cmd);
+	kmsg_dump(KMSG_DUMP_RESTART);
 	machine_restart(cmd);
 }
 EXPORT_SYMBOL_GPL(kernel_restart);
@@ -333,6 +337,7 @@ void kernel_halt(void)
 	kernel_shutdown_prepare(SYSTEM_HALT);
 	sysdev_shutdown();
 	printk(KERN_EMERG "System halted.\n");
+	kmsg_dump(KMSG_DUMP_HALT);
 	machine_halt();
 }
 
@@ -351,6 +356,7 @@ void kernel_power_off(void)
 	disable_nonboot_cpus();
 	sysdev_shutdown();
 	printk(KERN_EMERG "Power down.\n");
+	kmsg_dump(KMSG_DUMP_POWEROFF);
 	machine_power_off();
 }
 EXPORT_SYMBOL_GPL(kernel_power_off);
-- 
1.7.2.2

