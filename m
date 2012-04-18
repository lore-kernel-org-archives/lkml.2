Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab2DRG0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 02:26:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42925 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab2DRG0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 02:26:09 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>
CC: <arnd.bergmann@linaro.org>, <cjb@laptop.org>, <alex.limberg@sandisk.com>,
        <ilan.smith@sandisk.com>, <lporzio@micron.com>,
        Venkatraman S <svenkatr@ti.com>
Subject: [RFC PATCH 06/11] mmc: core: Helper function for finding preemptible command
Date: Wed, 18 Apr 2012 11:55:27 +0530
Message-ID: <1334730332-22244-7-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.10.rc2
In-Reply-To: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
References: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Table 30 in eMMC spec, only some commands
can be preempted by HPI. Provide a helper function for
the HPI procedure to identify if the command is
preemptible.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
---
 include/linux/mmc/core.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 1b431c7..680e256 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -10,6 +10,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/completion.h>
+#include <linux/mmc/mmc.h>
 
 struct request;
 struct mmc_data;
@@ -192,6 +193,18 @@ static inline void mmc_claim_host(struct mmc_host *host)
 	__mmc_claim_host(host, NULL);
 }
 
+static inline bool mmc_is_preemptible_command(struct mmc_command *cmd)
+{
+	if ((cmd->opcode == MMC_SWITCH && (cmd->arg == EXT_CSD_BKOPS_START ||
+		cmd->arg == EXT_CSD_SANITIZE_START ||
+		cmd->arg == EXT_CSD_FLUSH_CACHE))
+		|| (cmd->opcode == MMC_ERASE)
+		|| (cmd->opcode == MMC_WRITE_MULTIPLE_BLOCK)
+		|| (cmd->opcode == MMC_WRITE_BLOCK))
+		return true;
+	return false;
+}
+
 extern u32 mmc_vddrange_to_ocrmask(int vdd_min, int vdd_max);
 
 #endif /* LINUX_MMC_CORE_H */
-- 
1.7.10.rc2

