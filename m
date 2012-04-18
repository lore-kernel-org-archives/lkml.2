Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab2DRG05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 02:26:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56880 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab2DRG0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 02:26:24 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>
CC: <arnd.bergmann@linaro.org>, <cjb@laptop.org>, <alex.limberg@sandisk.com>,
        <ilan.smith@sandisk.com>, <lporzio@micron.com>,
        Venkatraman S <svenkatr@ti.com>
Subject: [RFC PATCH 08/11] mmc: core: Add MMC abort interface
Date: Wed, 18 Apr 2012 11:55:29 +0530
Message-ID: <1334730332-22244-9-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.10.rc2
In-Reply-To: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
References: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HPI (and possibly other) procedures require that an ongoing
mmc request issued to a controller be aborted in the middle
of a transaction. Define a abort interface function to the
controller so that individual host controllers can safely
abort a request, stop the dma and cleanup their statemachine
etc. The implementation is controller dependant

Signed-off-by: Venkatraman S <svenkatr@ti.com>
---
 drivers/mmc/core/core.c  |    8 ++++++++
 include/linux/mmc/host.h |    1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 6cefa01..1963305 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -328,6 +328,14 @@ static void mmc_post_req(struct mmc_host *host, struct mmc_request *mrq,
 	}
 }
 
+static int mmc_abort_req(struct mmc_host *host, struct mmc_request *req)
+{
+	if (host->ops->abort_req)
+		return host->ops->abort_req(host, req);
+
+	return -ENOSYS;
+}
+
 /**
  *	mmc_start_req - start a non-blocking request
  *	@host: MMC host to start command
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index cbde4b7..826e34d 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -98,6 +98,7 @@ struct mmc_host_ops {
 			    int err);
 	void	(*pre_req)(struct mmc_host *host, struct mmc_request *req,
 			   bool is_first_req);
+	int	(*abort_req)(struct mmc_host *host, struct mmc_request *req);
 	void	(*request)(struct mmc_host *host, struct mmc_request *req);
 	/*
 	 * Avoid calling these three functions too often or in a "fast path",
-- 
1.7.10.rc2

