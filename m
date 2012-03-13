Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab2CMAtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:49:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:48123 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758908Ab2CMAXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:21 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Chris Ball <cjb@laptop.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 109/196] mmc: sdhci: Check mrq != NULL in sdhci_tasklet_finish
Date: Mon, 12 Mar 2012 20:20:22 -0400
Message-Id: <1331598109-31424-64-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Ball <cjb@laptop.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 0c9c99a765321104cc5f9c97f949382a9ba4927e upstream.

It seems that under certain circumstances the sdhci_tasklet_finish()
call can be entered with mrq set to NULL, causing the system to crash
with a NULL pointer de-reference.

Seen on S3C6410 system.  Based on a patch by Dimitris Papastamos.

Reported-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/mmc/host/sdhci.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 6441e22..be410d7 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1268,6 +1268,13 @@ static void sdhci_tasklet_finish(unsigned long param)
 
 	host = (struct sdhci_host*)param;
 
+        /*
+         * If this tasklet gets rescheduled while running, it will
+         * be run again afterwards but without any active request.
+         */
+	if (!host->mrq)
+		return;
+
 	spin_lock_irqsave(&host->lock, flags);
 
 	del_timer(&host->timer);
-- 
1.7.9.3

