Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab1JYKQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 06:16:47 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6052 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467Ab1JYKQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 06:16:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 25 Oct 2011 03:16:44 -0700
From: vbyravarasu@nvidia.com
To: pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com, gregkh@suse.de
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        vbyravarasu@nvidia.com
Subject: [PATCH] PM: fix calculation mistake in roll-over cases
Date: Tue, 25 Oct 2011 15:50:52 +0530
Message-Id: <1319538052-2480-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: venu byravarasu <vbyravarasu@nvidia.com>

In case of jiffies roll over, delta is made zero.
Hence fixing it, after taking roll over into consideration.

Signed-off-by: venu byravarasu <vbyravarasu@nvidia.com>
---
When jiffies roll over, calculation of time spent in the
current state (stored in variable 'delta') is incorrect.
Hence fixing it, after taking roll over into consideration.

 drivers/base/power/runtime.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 1079e03..bd93fb0 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -30,12 +30,13 @@ static int rpm_suspend(struct device *dev, int rpmflags);
 void update_pm_runtime_accounting(struct device *dev)
 {
 	unsigned long now = jiffies;
-	int delta;
+	unsigned long delta;
+	unsigned long max_num = ~0;
 
 	delta = now - dev->power.accounting_timestamp;
 
-	if (delta < 0)
-		delta = 0;
+	if (now < dev->power.accounting_timestamp)
+		delta = max_num - dev->power.accounting_timestamp + now;
 
 	dev->power.accounting_timestamp = now;
 
-- 
1.7.1.1

