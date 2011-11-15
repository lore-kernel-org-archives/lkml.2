Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab1KOVca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:32:30 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:37719 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432Ab1KOVcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:32:25 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, tglx@linutronix.de,
        x86@kernel.org, hpa@zytor.com, len.brown@intel.com,
        joseph.cihula@intel.com, linux-pm@lists.linux-foundation.org,
        tboot-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        liang.tang@oracle.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/7] xen/acpi/sleep: Enable ACPI sleep via the acpi_os_prepare_sleep_register
Date: Tue, 15 Nov 2011 16:31:07 -0500
Message-Id: <1321392671-9128-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321392671-9128-1-git-send-email-konrad.wilk@oracle.com>
References: <1321392671-9128-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4EC2DA44.017A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the registration callback to call in the Xen's
ACPI sleep functionality. This means that during S3/S5
we make a hypercall XENPF_enter_acpi_sleep with the
proper PM1A/PM1B registers.

Based of Ke Yu's <ke.yu@intel.com> initial idea.
[ From http://xenbits.xensource.com/linux-2.6.18-xen.hg
change c68699484a65 ]

[v1: Added Copyright and license]
[v2: Added check if PM1A/B the 16-bits MSB contain something. The spec
     only uses 16-bits but might have more in future]
Signed-off-by: Liang Tang <liang.tang@oracle.com>
[v1: Improved the git commit description]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |    3 ++
 drivers/xen/Makefile     |    2 +-
 drivers/xen/acpi.c       |   62 ++++++++++++++++++++++++++++++++++++++++++++++
 include/xen/acpi.h       |   59 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 125 insertions(+), 1 deletions(-)
 create mode 100644 drivers/xen/acpi.c
 create mode 100644 include/xen/acpi.h

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index da8afd5..bb0c864 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -42,6 +42,7 @@
 #include <xen/page.h>
 #include <xen/hvm.h>
 #include <xen/hvc-console.h>
+#include <xen/acpi.h>
 
 #include <asm/paravirt.h>
 #include <asm/apic.h>
@@ -1277,6 +1278,8 @@ asmlinkage void __init xen_start_kernel(void)
 
 		/* Make sure ACS will be enabled */
 		pci_request_acs();
+
+		xen_acpi_sleep_register();
 	}
 		
 
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 974fffd..0435996 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -17,7 +17,7 @@ obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
 obj-$(CONFIG_XEN_PVHVM)			+= platform-pci.o
 obj-$(CONFIG_XEN_TMEM)			+= tmem.o
 obj-$(CONFIG_SWIOTLB_XEN)		+= swiotlb-xen.o
-obj-$(CONFIG_XEN_DOM0)			+= pci.o
+obj-$(CONFIG_XEN_DOM0)			+= pci.o acpi.o
 obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
 
 xen-evtchn-y				:= evtchn.o
diff --git a/drivers/xen/acpi.c b/drivers/xen/acpi.c
new file mode 100644
index 0000000..9f81a0f
--- /dev/null
+++ b/drivers/xen/acpi.c
@@ -0,0 +1,62 @@
+/******************************************************************************
+ * acpi.c
+ * acpi file for domain 0 kernel
+ *
+ * Copyright (c) 2011 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+ * Copyright (c) 2011 Yu Ke ke.yu@intel.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#include <xen/acpi.h>
+#include <xen/interface/platform.h>
+#include <asm/xen/hypercall.h>
+#include <asm/xen/hypervisor.h>
+
+acpi_status xen_acpi_notify_hypervisor_state(u8 sleep_state,
+				     u32 pm1a_cnt, u32 pm1b_cnt)
+{
+	struct xen_platform_op op = {
+		.cmd = XENPF_enter_acpi_sleep,
+		.interface_version = XENPF_INTERFACE_VERSION,
+		.u = {
+			.enter_acpi_sleep = {
+				.pm1a_cnt_val = (u16)pm1a_cnt,
+				.pm1b_cnt_val = (u16)pm1b_cnt,
+				.sleep_state = sleep_state,
+			},
+		},
+	};
+
+	if ((pm1a_cnt & 0xffff0000) || (pm1b_cnt & 0xffff0000)) {
+		WARN(1, "Using more than 16bits of PM1A/B 0x%x/0x%x!"
+		     "Email xen-devel@lists.xensource.com  Thank you.\n", \
+		     pm1a_cnt, pm1b_cnt);
+		return AE_ERROR;
+	}
+
+	HYPERVISOR_dom0_op(&op);
+	return AE_ERROR;
+}
diff --git a/include/xen/acpi.h b/include/xen/acpi.h
new file mode 100644
index 0000000..69a6890
--- /dev/null
+++ b/include/xen/acpi.h
@@ -0,0 +1,59 @@
+/******************************************************************************
+ * acpi.h
+ * acpi file for domain 0 kernel
+ *
+ * Copyright (c) 2011 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+ * Copyright (c) 2011 Yu Ke <ke.yu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#ifndef _XEN_ACPI_H
+#define _XEN_ACPI_H
+
+#include <linux/types.h>
+
+#ifdef CONFIG_XEN_DOM0
+#include <asm/xen/hypervisor.h>
+#include <xen/xen.h>
+#include <linux/acpi.h>
+#include <acpi/acpiosxf.h>
+
+acpi_status xen_acpi_notify_hypervisor_state(u8 sleep_state,
+				     u32 pm1a_cnt, u32 pm1b_cnd);
+
+static inline void xen_acpi_sleep_register(void)
+{
+	if (xen_initial_domain())
+		acpi_os_prepare_sleep_register(
+			&xen_acpi_notify_hypervisor_state);
+}
+#else
+static inline void xen_acpi_sleep_register(void)
+{
+}
+#endif
+
+#endif	/* _XEN_ACPI_H */
-- 
1.7.7.1

