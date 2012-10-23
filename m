Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149Ab2JWNxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:53:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:44658 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140Ab2JWNxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:53:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="237191105"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 14/26] mmc: panic write: bypass bus ref locking
Date: Tue, 23 Oct 2012 16:48:12 +0300
Message-Id: <1351000104-13015-15-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
References: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 drivers/mmc/core/core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 4fd7061..3daec19 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1418,6 +1418,11 @@ static inline void mmc_bus_get(struct mmc_host *host)
 {
 	unsigned long flags;
 
+	if (mmc_am_panic_task(host)) {
+		host->bus_refs++;
+		return;
+	}
+
 	spin_lock_irqsave(&host->lock, flags);
 	host->bus_refs++;
 	spin_unlock_irqrestore(&host->lock, flags);
@@ -1431,6 +1436,11 @@ static inline void mmc_bus_put(struct mmc_host *host)
 {
 	unsigned long flags;
 
+	if (mmc_am_panic_task(host)) {
+		host->bus_refs--;
+		return;
+	}
+
 	spin_lock_irqsave(&host->lock, flags);
 	host->bus_refs--;
 	if ((host->bus_refs == 0) && host->bus_ops)
-- 
1.7.9.5

