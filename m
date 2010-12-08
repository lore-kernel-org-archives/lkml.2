Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab0LHE2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 23:28:35 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53039 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab0LHE2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 23:28:33 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6190"; a="65899435"
X-IronPort-AV: E=Sophos;i="4.59,313,1288594800"; 
   d="scan'208";a="34584817"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 3/6] msm: scm-boot: Support for setting cold/warm boot addresses
Date: Tue,  7 Dec 2010 20:28:18 -0800
Message-Id: <1291782501-3909-4-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291782501-3909-1-git-send-email-johlstei@codeaurora.org>
References: <1291782501-3909-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stepan Moskovchenko <stepanm@codeaurora.org>

Add support for setting the cold boot address of core 1 and
the warm boot addresses of cores 0 and 1 using a secure
domain call.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/Makefile   |    2 +-
 arch/arm/mach-msm/scm-boot.c |   39 +++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/scm-boot.h |   38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-msm/scm-boot.c
 create mode 100644 arch/arm/mach-msm/scm-boot.h

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index eed503b..34cd0a8 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -18,7 +18,7 @@ obj-$(CONFIG_MSM_PROC_COMM) += clock.o
 obj-$(CONFIG_ARCH_QSD8X50) += sirc.o
 obj-$(CONFIG_MSM_SMD) += smd.o smd_debug.o
 obj-$(CONFIG_MSM_SMD) += last_radio_log.o
-obj-$(CONFIG_MSM_SCM) += scm.o
+obj-$(CONFIG_MSM_SCM) += scm.o scm-boot.o
 
 obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o devices-msm7x00.o
 obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
diff --git a/arch/arm/mach-msm/scm-boot.c b/arch/arm/mach-msm/scm-boot.c
new file mode 100644
index 0000000..5671d58
--- /dev/null
+++ b/arch/arm/mach-msm/scm-boot.c
@@ -0,0 +1,39 @@
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include "scm.h"
+#include "scm-boot.h"
+
+/*
+ * Set the cold/warm boot address for one of the CPU cores.
+ */
+int scm_set_boot_addr(void *addr, int flags)
+{
+	struct {
+		unsigned int flags;
+		void *addr;
+	} cmd;
+
+	cmd.addr = addr;
+	cmd.flags = flags;
+	return scm_call(SCM_SVC_BOOT, SCM_BOOT_ADDR,
+			&cmd, sizeof(cmd), NULL, 0);
+}
+EXPORT_SYMBOL(scm_set_boot_addr);
diff --git a/arch/arm/mach-msm/scm-boot.h b/arch/arm/mach-msm/scm-boot.h
new file mode 100644
index 0000000..fdc1374
--- /dev/null
+++ b/arch/arm/mach-msm/scm-boot.h
@@ -0,0 +1,38 @@
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are
+ * met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above
+ *       copyright notice, this list of conditions and the following
+ *       disclaimer in the documentation and/or other materials provided
+ *       with the distribution.
+ *     * Neither the name of Code Aurora Forum, Inc. nor the names of its
+ *       contributors may be used to endorse or promote products derived
+ *       from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
+ * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
+ * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+#ifndef __MACH_SCM_BOOT_H
+#define __MACH_SCM_BOOT_H
+
+#define SCM_BOOT_ADDR			0x1
+#define SCM_FLAG_COLDBOOT_CPU1		0x1
+#define SCM_FLAG_WARMBOOT_CPU1		0x2
+#define SCM_FLAG_WARMBOOT_CPU0		0x4
+
+int scm_set_boot_addr(void *addr, int flags);
+
+#endif
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

