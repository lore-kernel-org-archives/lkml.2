Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2ECOYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:24:39 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45692 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756669Ab2ECOYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:24:36 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <linux-mmc@vger.kernel.org>, <cjb@laptop.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <arnd.bergmann@linaro.org>,
        <alex.lemberg@sandisk.com>, <ilan.smith@sandisk.com>,
        <lporzio@micron.com>, <rmk+kernel@arm.linux.org.uk>,
        Venkatraman S <svenkatr@ti.com>
Subject: [PATCH v2 07/16] mmc: core: helper function for finding preemptible command
Date: Thu, 3 May 2012 19:53:06 +0530
Message-ID: <1336054995-22988-8-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.10.rc2
In-Reply-To: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to table30 in eMMC spec, only some commands
can be preempted by foreground HPI. Provide a helper function
for the HPI procedure to identify if the command is
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

