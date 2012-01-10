Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab2AJDAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 22:00:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34596 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755843Ab2AJDAA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 22:00:00 -0500
Message-ID: <1326164389.3432.29.camel@deadeye>
Subject: [PATCHv2 1/2] cpu: Do not return errors from cpu_dev_init() which
 will be ignored
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
        Thorsten Glaser <tg@mirbsd.de>,
        Debian kernel team <debian-kernel@lists.debian.org>,
        linux-m68k@vger.kernel.org, debian-68k@lists.debian.org,
        Richard Weinberger <richard@nod.at>
Date: Tue, 10 Jan 2012 02:59:49 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_dev_init() is only called from driver_init(), which does not check
its return value.  Therefore make cpu_dev_init() return void.

We must register the CPU subsystem, so panic if this fails.

If sched_create_sysfs_power_savings_entries() fails, the damage is
contained, so ignore this (as before).

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/base/base.h |    2 +-
 drivers/base/cpu.c  |   13 +++++--------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 7a6ae42..b858dfd 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -94,7 +94,7 @@ extern int hypervisor_init(void);
 static inline int hypervisor_init(void) { return 0; }
 #endif
 extern int platform_bus_init(void);
-extern int cpu_dev_init(void);
+extern void cpu_dev_init(void);
 
 extern int bus_add_device(struct device *dev);
 extern void bus_probe_device(struct device *dev);
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 9a5578e..bba70d0 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -2,6 +2,7 @@
  * CPU subsystem support
  */
 
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
@@ -274,16 +275,12 @@ bool cpu_is_hotpluggable(unsigned cpu)
 }
 EXPORT_SYMBOL_GPL(cpu_is_hotpluggable);
 
-int __init cpu_dev_init(void)
+void __init cpu_dev_init(void)
 {
-	int err;
-
-	err = subsys_system_register(&cpu_subsys, cpu_root_attr_groups);
-	if (err)
-		return err;
+	if (subsys_system_register(&cpu_subsys, cpu_root_attr_groups))
+		panic("Failed to register CPU subsystem");
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	err = sched_create_sysfs_power_savings_entries(cpu_subsys.dev_root);
+	sched_create_sysfs_power_savings_entries(cpu_subsys.dev_root);
 #endif
-	return err;
 }
-- 
1.7.8.2



