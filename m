Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab0HYVN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 17:13:26 -0400
Received: from toccata.ens-lyon.org ([140.77.166.68]:51729 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab0HYVNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 17:13:24 -0400
Date: Wed, 25 Aug 2010 23:12:57 +0200
From: Sebastien Hinderer <Sebastien.Hinderer@ens-lyon.org>
To: Andreas Mohr <andi@lisas.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        Samuel Thibault <Samuel.Thibault@ens-lyon.org>
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
Message-ID: <20100825211257.GA636@pema>
References: <20100825094925.GA3632@pema>
 <20100825161214.GA15087@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100825161214.GA15087@rhlx01.hs-esslingen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> excellent! Now if as the next step before inclusion you also add the usual DMI check
> (as done by many drivers such as acerhdf etc.),
> someone inexperienced who is dumb enough to enable it for his unrelated machine
> will actually survive an otherwise raw I/O port access and poweroff
> vector change ;))

The machine does not support DMI, I have mentionned that in the module.

> Unless these non-APM, non-ACPI machines don't have any DMI support
> either and thus won't even have dmidecode work.....
> (in which case I'd strongly suggest adding a 0x340+x port value read verification
> to bail driver install in case the machine doesn't have this
> hardware).

I did that, but I have noprecise documentation about what the legitimate
values are, so I just compared the read value with 0xff. This prevents
the module from being loaded in qemu for instance.

Shérab.

commit 197e523553a791f97536143001f22abd36f7992c
Author: Shérab <Sebastien.Hinderer@ens-lyon.org>
Date:   Wed Aug 25 23:00:14 2010 +0200

    Eurobraille/Iris power off.
    
    The Iris machines from EuroBraille do not have APM or ACPI support
    to shut themselves down properly.  A special I/O sequence is
    needed to do so.  This modle runs this I/O sequence at
    kernel shutdown.
    
    This is only for Iris machines from EuroBraille.
    Signed-off-by: Shérab <Sebastien.Hinderer@ens-lyon.org>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ac7827f..88bf897 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -493,6 +493,19 @@ config X86_ES7000
 	  Support for Unisys ES7000 systems.  Say 'Y' here if this kernel is
 	  supposed to run on an IA32-based Unisys ES7000 system.
 
+config X86_32_IRIS
+	tristate "Eurobraille/Iris poweroff module"
+	depends on X86_32
+	---help---
+	  The Iris machines from EuroBraille do not have APM or ACPI support
+	  to shut themselves down properly.  A special I/O sequence is
+	  needed to do so, which is what this module does at
+	  kernel shutdown.
+
+	  This is only for Iris machines from EuroBraille.
+
+	  If unused, say N.
+
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
 	prompt "Single-depth WCHAN output"
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0925676..98dd1c8 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -115,6 +115,7 @@ obj-$(CONFIG_MICROCODE)			+= microcode.o
 obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
+obj-$(CONFIG_X86_32_IRIS)		+= iris.o
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/iris.c b/arch/x86/kernel/iris.c
new file mode 100644
index 0000000..8856ef3
--- /dev/null
+++ b/arch/x86/kernel/iris.c
@@ -0,0 +1,80 @@
+/*
+ * Eurobraille/Iris power off support.
+ *
+ * Eurobraille's Iris machine is a PC with no APM or ACPI support.
+ * It is shutdown by a special I/O sequence which this module provides.
+ *
+ *  Copyright (C) Shérab <Sebastien.Hinderer@ens-lyon.org>
+ *
+ * This program is free software ; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation ; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY ; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with the program ; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/pm.h>
+#include <linux/delay.h>
+#include <asm/io.h>
+
+#define IRIS_GIO_BASE 0x340
+#define IRIS_GIO_INPUT IRIS_GIO_BASE
+#define IRIS_GIO_OUTPUT (IRIS_GIO_BASE + 1)
+#define IRIS_GIO_PULSE 0x80 /* First byte to send */
+#define IRIS_GIO_REST 0x0 /* Second byte to send */
+#define IRIS_GIO_NODEV 0xff /* Likely not an Iris */
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sébastien Hinderer <Sebastien.Hinderer@ens-lyon.org>");
+MODULE_DESCRIPTION("A power_off handler for Iris devices from EuroBraille");
+MODULE_SUPPORTED_DEVICE("Eurobraille/Iris");
+
+static void (*old_pm_power_off)(void);
+
+static void iris_power_off(void)
+{
+	outb(IRIS_GIO_PULSE, IRIS_GIO_OUTPUT);
+	msleep(850);
+	outb(IRIS_GIO_REST, IRIS_GIO_OUTPUT);
+}
+
+/*
+ * Before installing the power_off handler, try to make sure the OS is
+ * running on an Iris.  Since Iris does not support DMI, this is done
+ * by reading its input port and seeing whether the read value is
+ * meaningful.
+ */
+static int iris_init(void)
+{
+	unsigned char status = inb(IRIS_GIO_INPUT);
+	if (status == IRIS_GIO_NODEV) {
+		printk(KERN_ERR "This machine does not seem to be an Iris. Power_off handler not installed.\n");
+		return -ENODEV;
+	}
+	old_pm_power_off = pm_power_off;
+	pm_power_off = &iris_power_off;
+	printk(KERN_INFO "Iris power_off handler installed.\n");
+	return 0;
+}
+
+static void iris_exit(void)
+{
+	pm_power_off = old_pm_power_off;
+	printk(KERN_INFO "Iris power_off handler uninstalled.\n");
+}
+
+module_init(iris_init);
+module_exit(iris_exit);
+
