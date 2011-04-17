Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab1DQVQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 17:16:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57598 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab1DQVQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 17:16:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/14] PM: Add missing syscore_suspend() and syscore_resume() calls
Date: Sun, 17 Apr 2011 23:06:49 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, linux-arm-kernel@lists.infradead.org,
        Ben Dooks <ben-linux@fluff.org>, Mike Frysinger <vapier@gentoo.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, Jiri Kosina <jkosina@suse.cz>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
References: <201103280125.11750.rjw@sisk.pl> <201104172301.54115.rjw@sisk.pl>
In-Reply-To: <201104172301.54115.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104172306.49462.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Device suspend/resume infrastructure is used not only by the suspend
and hibernate code in kernel/power, but also by , APM, Xen and the
kexec jump feature.  However, commit 40dc166cb5dddbd36aa4ad11c03915ea
(PM / Core: Introduce struct syscore_ops for core subsystems PM)
failed to add syscore_suspend() and syscore_resume() calls to that
code, which generally leads to breakage when the features in question
are used.

To fix this problem, add the missing syscore_suspend() and
syscore_resume() calls to arch/x86/kernel/apm_32.c, kernel/kexec.c
and drivers/xen/manage.c.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/apm_32.c |    5 +++++
 drivers/xen/manage.c     |    9 ++++++++-
 kernel/kexec.c           |    7 +++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c
+++ linux-2.6/kernel/kexec.c
@@ -33,6 +33,7 @@
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
 #include <linux/kmsg_dump.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1532,6 +1533,11 @@ int kernel_kexec(void)
 		local_irq_disable();
 		/* Suspend system devices */
 		error = sysdev_suspend(PMSG_FREEZE);
+		if (!error) {
+			error = syscore_suspend();
+			if (error)
+				sysdev_resume();
+		}
 		if (error)
 			goto Enable_irqs;
 	} else
@@ -1546,6 +1552,7 @@ int kernel_kexec(void)
 
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
+		syscore_resume();
 		sysdev_resume();
  Enable_irqs:
 		local_irq_enable();
Index: linux-2.6/drivers/xen/manage.c
===================================================================
--- linux-2.6.orig/drivers/xen/manage.c
+++ linux-2.6/drivers/xen/manage.c
@@ -8,6 +8,7 @@
 #include <linux/sysrq.h>
 #include <linux/stop_machine.h>
 #include <linux/freezer.h>
+#include <linux/syscore_ops.h>
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
@@ -70,8 +71,13 @@ static int xen_suspend(void *data)
 	BUG_ON(!irqs_disabled());
 
 	err = sysdev_suspend(PMSG_FREEZE);
+	if (!err) {
+		err = syscore_suspend();
+		if (err)
+			sysdev_resume();
+	}
 	if (err) {
-		printk(KERN_ERR "xen_suspend: sysdev_suspend failed: %d\n",
+		printk(KERN_ERR "xen_suspend: system core suspend failed: %d\n",
 			err);
 		return err;
 	}
@@ -95,6 +101,7 @@ static int xen_suspend(void *data)
 		xen_timer_resume();
 	}
 
+	syscore_resume();
 	sysdev_resume();
 
 	return 0;
Index: linux-2.6/arch/x86/kernel/apm_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apm_32.c
+++ linux-2.6/arch/x86/kernel/apm_32.c
@@ -228,6 +228,7 @@
 #include <linux/kthread.h>
 #include <linux/jiffies.h>
 #include <linux/acpi.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -1238,6 +1239,7 @@ static int suspend(int vetoable)
 
 	local_irq_disable();
 	sysdev_suspend(PMSG_SUSPEND);
+	syscore_suspend();
 
 	local_irq_enable();
 
@@ -1255,6 +1257,7 @@ static int suspend(int vetoable)
 		apm_error("suspend", err);
 	err = (err == APM_SUCCESS) ? 0 : -EIO;
 
+	syscore_resume();
 	sysdev_resume();
 	local_irq_enable();
 
@@ -1280,6 +1283,7 @@ static void standby(void)
 
 	local_irq_disable();
 	sysdev_suspend(PMSG_SUSPEND);
+	syscore_suspend();
 	local_irq_enable();
 
 	err = set_system_power_state(APM_STATE_STANDBY);
@@ -1287,6 +1291,7 @@ static void standby(void)
 		apm_error("standby", err);
 
 	local_irq_disable();
+	syscore_resume();
 	sysdev_resume();
 	local_irq_enable();
 

