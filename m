Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab2DRG0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 02:26:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50412 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab2DRG0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 02:26:22 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>
CC: <arnd.bergmann@linaro.org>, <cjb@laptop.org>, <alex.limberg@sandisk.com>,
        <ilan.smith@sandisk.com>, <lporzio@micron.com>,
        Venkatraman S <svenkatr@ti.com>
Subject: [RFC PATCH 07/11] mmc: core: add preemptibility tracking fields to mmc command
Date: Wed, 18 Apr 2012 11:55:28 +0530
Message-ID: <1334730332-22244-8-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.10.rc2
In-Reply-To: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
References: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set a preemptibility command atrribute to MMC commands. This
can be later used by write (multi block), trim etc for
evaluating if a HPI is applicable.

Note the starting time of executing a command so a decision
can be made if it is too late for preemption.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
---
 drivers/mmc/core/core.c  |    5 +++++
 include/linux/mmc/core.h |    4 ++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 027c579..6cefa01 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -258,6 +258,11 @@ static int __mmc_start_req(struct mmc_host *host, struct mmc_request *mrq)
 		complete(&mrq->completion);
 		return -ENOMEDIUM;
 	}
+	if (mmc_is_preemptible_command(mrq->cmd))
+		mrq->cmd->cmd_attr |= MMC_CMD_PREEMPTIBLE;
+	else
+		mrq->cmd->cmd_attr &= ~MMC_CMD_PREEMPTIBLE;
+	mrq->cmd->started_time = jiffies;
 	mmc_start_request(host, mrq);
 	return 0;
 }
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 680e256..d86144e 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -76,6 +76,10 @@ struct mmc_command {
  */
 #define mmc_cmd_type(cmd)	((cmd)->flags & MMC_CMD_MASK)
 
+	unsigned int		cmd_attr; /*Runtime attributes of the command */
+#define MMC_CMD_PREEMPTIBLE	BIT(0)
+#define MMC_CMD_PREEMPTED	BIT(1)
+	unsigned long		started_time;
 	unsigned int		retries;	/* max number of retries */
 	unsigned int		error;		/* command error */
 
-- 
1.7.10.rc2

