Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab2J2Mwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 08:52:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:29859 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab2J2Mwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 08:52:32 -0400
Date: Mon, 29 Oct 2012 08:39:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Jan Beulich <jbeulich@suse.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Message-ID: <20121029123950.GK2708@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com>
 <5089676602000078000A4928@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923353723C7@SHSMSX101.ccr.corp.intel.com>
 <508A89CB020000780008E6ED@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335372883@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537292E@SHSMSX101.ccr.corp.intel.com>
 <20121026201409.GF2708@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC8292335373918@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335373918@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 03:38:14AM +0000, Liu, Jinsong wrote:
> It's doable to register a stub for xen. However, it's not preferred, say, to make xen pad as module, considering the case 'rmmod xen_acpi_pad' then 'insmod acpi_pad'? Under such case there is risk of mwait #UD, if we want to remove mwait check as 'patch 2/2: Revert-pad-config-check-in-xen_check_mwait.patch' did, advantages of which is to enjoy deep Cx.

You are missing my point. This is what I was thinking off:


>From 5f30320b8a1c21d60a2c22e98bcf013b7773938b Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 29 Oct 2012 08:38:22 -0400
Subject: [PATCH] xen/acpi: Provide a stub function to register for ACPI PAD
 module.

TODO: Give more details.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/Kconfig             |    5 ++
 drivers/xen/Makefile            |    3 +-
 drivers/xen/xen-acpi-pad-stub.c |  128 +++++++++++++++++++++++++++++++++++++++
 drivers/xen/xen-acpi.h          |    2 +
 4 files changed, 137 insertions(+), 1 deletions(-)
 create mode 100644 drivers/xen/xen-acpi-pad-stub.c
 create mode 100644 drivers/xen/xen-acpi.h

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index d4dffcd..9156a08 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -204,4 +204,9 @@ config XEN_MCE_LOG
 	  Allow kernel fetching MCE error from Xen platform and
 	  converting it into Linux mcelog format for mcelog tools
 
+config XEN_ACPI_PAD_STUB
+	bool
+	depends on XEN_DOM0 && X86_64 && ACPI
+	default n
+
 endmenu
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 0e863703..d1895d9 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -9,9 +9,10 @@ nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_features.o			:= $(nostackp)
 
 dom0-$(CONFIG_PCI) += pci.o
-dom0-$(CONFIG_USB_SUPPORT) += dbgp.o
+dom0-$(CONFIG_USB_EHCI_HCD) += dbgp.o
 dom0-$(CONFIG_ACPI) += acpi.o
 dom0-$(CONFIG_X86) += pcpu.o
+dom0-$(CONFIG_XEN_ACPI_PAD_STUB)	+= xen-acpi-pad-stub.o
 obj-$(CONFIG_XEN_DOM0)			+= $(dom0-y)
 obj-$(CONFIG_BLOCK)			+= biomerge.o
 obj-$(CONFIG_XEN_XENCOMM)		+= xencomm.o
diff --git a/drivers/xen/xen-acpi-pad-stub.c b/drivers/xen/xen-acpi-pad-stub.c
new file mode 100644
index 0000000..cac9a39
--- /dev/null
+++ b/drivers/xen/xen-acpi-pad-stub.c
@@ -0,0 +1,128 @@
+/*
+ * Copyright 2012 by Oracle Inc
+ * Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+ *
+ * This code borrows ideas from https://lkml.org/lkml/2011/11/30/249
+ * so many thanks go to Kevin Tian <kevin.tian@intel.com>
+ * and Yu Ke <ke.yu@intel.com>.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include <linux/cpumask.h>
+#include <linux/freezer.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <acpi/acpi_bus.h>
+#include <acpi/acpi_drivers.h>
+#include <acpi/processor.h>
+
+#include <xen/xen.h>
+#include <xen/interface/platform.h>
+#include <xen/interface/version.h>
+#include <asm/xen/hypercall.h>
+
+/* TODO: Needs comments. */
+static struct acpi_device_ops *xen_acpi_pad_ops;
+static bool __read_mostly xen_acpi_pad_registered;
+static DEFINE_SPINLOCK(xen_acpi_pad_spinlock);
+
+int xen_register_acpi_pad_owner(struct acpi_device_ops *ops)
+{
+	if (xen_acpi_pad_ops)
+		return -EEXIST;
+
+	spin_lock(&xen_acpi_pad_spinlock);
+	xen_acpi_pad_ops = ops;
+	spin_unlock(&xen_acpi_pad_spinlock);
+	return 0;
+}
+int xen_unregister_acpi_pad_owner(struct acpi_device_ops *ops)
+{
+	spin_lock(&xen_acpi_pad_spinlock);
+	if (xen_acpi_pad_ops != ops) {
+		spin_unlock(&xen_acpi_pad_spinlock);
+		return -ENODEV;
+	}
+	xen_acpi_pad_ops = NULL;
+	spin_unlock(&xen_acpi_pad_spinlock);
+	return 0;
+}
+
+static int xen_acpi_pad_remove(struct acpi_device *device, int type)
+{
+	int ret = -ENOSYS;
+
+	spin_lock(&xen_acpi_pad_spinlock);
+	if (xen_acpi_pad_ops && xen_acpi_pad_ops->remove)
+		ret = xen_acpi_pad_ops->remove(device, type);
+	spin_unlock(&xen_acpi_pad_spinlock);
+	return ret;
+}
+static int xen_acpi_pad_add(struct acpi_device *device)
+{
+	int ret = -ENOSYS;
+	spin_lock(&xen_acpi_pad_spinlock);
+	if (xen_acpi_pad_ops && xen_acpi_pad_ops->add)
+		ret = xen_acpi_pad_ops->add(device);
+	spin_unlock(&xen_acpi_pad_spinlock);
+	return ret;
+}
+
+static const struct acpi_device_id pad_device_ids[] = {
+	{"ACPI000C", 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, pad_device_ids);
+#define ACPI_PROCESSOR_AGGREGATOR_CLASS "acpi_pad"
+
+static struct acpi_driver xen_acpi_pad_driver = {
+	.name = "processor_aggregator",
+	.class = ACPI_PROCESSOR_AGGREGATOR_CLASS,
+	.ids = pad_device_ids,
+	.ops = {
+		.add = xen_acpi_pad_add,
+		.remove = xen_acpi_pad_remove,
+	},
+};
+
+static int __init xen_acpi_pad_stub_init(void)
+{
+	int ret = -ENOSYS;
+	unsigned version;
+
+	if (!xen_initial_domain())
+		return -ENODEV;
+
+	version = HYPERVISOR_xen_version(XENVER_version, NULL);
+
+	if ((version >> 16 >= 4) && ((version & 0xffff) >= 2)) {
+        	ret = acpi_bus_register_driver(&xen_acpi_pad_driver);
+        	if (!ret)
+			xen_acpi_pad_registered = true;
+    	}
+    	return ret;
+}
+#if 0
+/* For testing purposes. */
+static void __exit xen_acpi_pad_stub_exit(void)
+{
+	if (xen_acpi_pad_registered)
+		acpi_bus_unregister_driver(&xen_acpi_pad_driver);
+	/* The driver should have unregistered first ! */
+	if (WARN_ON(xen_acpi_pad_ops))
+		xen_acpi_pad_ops = NULL;
+}
+#endif
+subsys_initcall(xen_acpi_pad_stub_init);
diff --git a/drivers/xen/xen-acpi.h b/drivers/xen/xen-acpi.h
new file mode 100644
index 0000000..a0867b2
--- /dev/null
+++ b/drivers/xen/xen-acpi.h
@@ -0,0 +1,2 @@
+int xen_register_acpi_pad_owner(struct acpi_device_ops *ops);
+int xen_unregister_acpi_pad_owner(struct acpi_device_ops *ops);
-- 
1.7.7.6

> 
> IMHO to prevent mwait #UD, native pad should never have chance to register successfully when running under Xen. So it's better never unregister/disable xen pad.

With the registration stub I mentioned that won't be a problem.

> 
> Konrad Rzeszutek Wilk wrote:
> >> --- a/drivers/xen/Makefile
> >> +++ b/drivers/xen/Makefile
> >> @@ -29,6 +29,7 @@ obj-$(CONFIG_XEN_MCE_LOG)		+= mcelog.o
> >>  obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
> >>  obj-$(CONFIG_XEN_PRIVCMD)		+= xen-privcmd.o
> >>  obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+= xen-acpi-processor.o
> >> +obj-$(CONFIG_XEN_DOM0)			+= xen_acpi_pad.o
> > 
> > We should have a Kconfig option. In it, please mention what
> > version of hypervisor supports this functionality.
> > 
> 
> Kconfig option for xen pad is not preferred, considering if we disable xen pad and then register native pad driver? (of course the precondition is that we do not register stub for xen).

That should be OK with the stub.

> 
> >> +#include <linux/kernel.h>
> >> +#include <linux/types.h>
> >> +#include <acpi/acpi_bus.h>
> >> +#include <acpi/acpi_drivers.h>
> >> +#include <asm/xen/hypercall.h>
> >> +
> >> +#if defined(CONFIG_ACPI_PROCESSOR_AGGREGATOR) || \
> >> +		defined(CONFIG_ACPI_PROCESSOR_AGGREGATOR_MODULE)
> > 
> > I don't think you need that.
> > 
> 
> OK.
> 
> >> +
> >> +static int __init xen_acpi_pad_init(void)
> >> +{
> >> +	/* Only DOM0 is responsible for Xen acpi pad */
> >> +	if (xen_initial_domain())
> >> +		return acpi_bus_register_driver(&xen_acpi_pad_driver); +
> >> +	return -ENODEV;
> >> +}
> >> +subsys_initcall(xen_acpi_pad_init);
> > 
> > 
> > No way of making this a module? It would be nice - perhaps have a stub
> > function that registers the bus but does not do anything until this
> > proper module is loaded?
> > 
> 
> It's doable but not preferred, reason as above.
> 
> >> +
> >> +#endif
> >> diff --git a/include/xen/interface/platform.h
> >> b/include/xen/interface/platform.h index 4755b5f..0f44376 100644 ---
> >> a/include/xen/interface/platform.h +++
> >> b/include/xen/interface/platform.h @@ -324,6 +324,22 @@ struct
> >>  xenpf_cpu_ol { };
> >>  DEFINE_GUEST_HANDLE_STRUCT(xenpf_cpu_ol);
> >> 
> >> +/*
> >> + * CMD 58 and 59 are reserved for cpu hotadd and memory hotadd,
> >> + * which already occupied at Xen hypervisor side.
> >            ^- are
> > 
> 
> Sure.
> 
> Thanks,
> Jinsong
