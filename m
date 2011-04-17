Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1DQVTD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 17:19:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57718 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629Ab1DQVQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 17:16:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/14] ARM / SA1100: Use struct syscore_ops for "core" power management
Date: Sun, 17 Apr 2011 23:10:02 +0200
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
Message-Id: <201104172310.02794.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Replace the sysdev class and struct sys_device used for power
management by the SA1100 interrupt-handling code with a
struct syscore_ops object which is simpler.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-sa1100/irq.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

Index: linux-2.6/arch/arm/mach-sa1100/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-sa1100/irq.c
+++ linux-2.6/arch/arm/mach-sa1100/irq.c
@@ -14,7 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/ioport.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 
 #include <mach/hardware.h>
 #include <asm/mach/irq.h>
@@ -234,7 +234,7 @@ static struct sa1100irq_state {
 	unsigned int	iccr;
 } sa1100irq_state;
 
-static int sa1100irq_suspend(struct sys_device *dev, pm_message_t state)
+static int sa1100irq_suspend(void)
 {
 	struct sa1100irq_state *st = &sa1100irq_state;
 
@@ -264,7 +264,7 @@ static int sa1100irq_suspend(struct sys_
 	return 0;
 }
 
-static int sa1100irq_resume(struct sys_device *dev)
+static void sa1100irq_resume(void)
 {
 	struct sa1100irq_state *st = &sa1100irq_state;
 
@@ -277,24 +277,17 @@ static int sa1100irq_resume(struct sys_d
 
 		ICMR = st->icmr;
 	}
-	return 0;
 }
 
-static struct sysdev_class sa1100irq_sysclass = {
-	.name		= "sa11x0-irq",
+static struct syscore_ops sa1100irq_syscore_ops = {
 	.suspend	= sa1100irq_suspend,
 	.resume		= sa1100irq_resume,
 };
 
-static struct sys_device sa1100irq_device = {
-	.id		= 0,
-	.cls		= &sa1100irq_sysclass,
-};
-
 static int __init sa1100irq_init_devicefs(void)
 {
-	sysdev_class_register(&sa1100irq_sysclass);
-	return sysdev_register(&sa1100irq_device);
+	register_syscore_ops(&sa1100irq_syscore_ops);
+	return 0;
 }
 
 device_initcall(sa1100irq_init_devicefs);

