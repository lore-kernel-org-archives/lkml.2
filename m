Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab1EERCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 13:02:47 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:14438 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab1EERCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 13:02:44 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [RFC PATCH v3 1/6] of: Allow scripts/dtc/libfdt to be used from kernel code
Date: Thu,  5 May 2011 10:02:24 -0700
Message-Id: <1304614949-30460-2-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1304614949-30460-1-git-send-email-ddaney@caviumnetworks.com>
References: <1304614949-30460-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 05 May 2011 17:02:44.0382 (UTC) FILETIME=[40735BE0:01CC0B46]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To use it you need to do this in your Kconfig:

	select LIBFDT

And in the Makefile of the code using libfdt something like:

ccflags-y := -include linux/libfdt_env.h -I$(src)/../../../scripts/dtc/libfdt

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 drivers/of/Kconfig         |    3 +++
 drivers/of/Makefile        |    2 ++
 drivers/of/libfdt/Makefile |    8 ++++++++
 include/linux/libfdt.h     |    8 ++++++++
 include/linux/libfdt_env.h |   13 +++++++++++++
 5 files changed, 34 insertions(+), 0 deletions(-)
 create mode 100644 drivers/of/libfdt/Makefile
 create mode 100644 include/linux/libfdt.h
 create mode 100644 include/linux/libfdt_env.h

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index d06a637..9b0474e 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -4,6 +4,9 @@ config DTC
 config OF
 	bool
 
+config LIBFDT
+	bool
+
 menu "Device Tree and Open Firmware support"
 	depends on OF
 
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index f7861ed..a8dec2f 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -10,3 +10,5 @@ obj-$(CONFIG_OF_NET)	+= of_net.o
 obj-$(CONFIG_OF_SPI)	+= of_spi.o
 obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
 obj-$(CONFIG_OF_PCI)	+= of_pci.o
+
+obj-$(CONFIG_LIBFDT) += libfdt/
diff --git a/drivers/of/libfdt/Makefile b/drivers/of/libfdt/Makefile
new file mode 100644
index 0000000..bda11fe
--- /dev/null
+++ b/drivers/of/libfdt/Makefile
@@ -0,0 +1,8 @@
+ccflags-y := -include linux/libfdt_env.h -I$(src)/../../../scripts/dtc/libfdt
+
+obj-y = fdt.o fdt_wip.o fdt_ro.o
+
+
+$(obj)/%.o: $(src)/../../../scripts/dtc/libfdt/%.c FORCE
+	$(call cmd,force_checksrc)
+	$(call if_changed_rule,cc_o_c)
diff --git a/include/linux/libfdt.h b/include/linux/libfdt.h
new file mode 100644
index 0000000..4c0306c
--- /dev/null
+++ b/include/linux/libfdt.h
@@ -0,0 +1,8 @@
+#ifndef _INCLUDE_LIBFDT_H_
+#define _INCLUDE_LIBFDT_H_
+
+#include <linux/libfdt_env.h>
+#include "../../scripts/dtc/libfdt/fdt.h"
+#include "../../scripts/dtc/libfdt/libfdt.h"
+
+#endif /* _INCLUDE_LIBFDT_H_ */
diff --git a/include/linux/libfdt_env.h b/include/linux/libfdt_env.h
new file mode 100644
index 0000000..01508c7
--- /dev/null
+++ b/include/linux/libfdt_env.h
@@ -0,0 +1,13 @@
+#ifndef _LIBFDT_ENV_H
+#define _LIBFDT_ENV_H
+
+#include <linux/string.h>
+
+#include <asm/byteorder.h>
+
+#define fdt32_to_cpu(x) be32_to_cpu(x)
+#define cpu_to_fdt32(x) cpu_to_be32(x)
+#define fdt64_to_cpu(x) be64_to_cpu(x)
+#define cpu_to_fdt64(x) cpu_to_be64(x)
+
+#endif /* _LIBFDT_ENV_H */
-- 
1.7.2.3

