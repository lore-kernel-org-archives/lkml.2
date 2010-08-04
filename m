Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281Ab0HDVTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:19:43 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:57595 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759103Ab0HDVTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:19:00 -0400
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCHv3 10/16] pps: use BUG_ON for kernel API safety checks
Date: Thu,  5 Aug 2010 01:06:47 +0400
Message-Id: <08fcb3aee15a9e2c4910e2aeecafe1cceacd7827.1280952801.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way less overhead is involved when running production kernel.
If you want to debug a pps client module please define DEBUG to enable
the checks.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/kapi.c |   33 ++++++++++-----------------------
 1 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index 8c557c4..220ab08 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -80,25 +80,14 @@ struct pps_device *pps_register_source(struct pps_source_info *info,
 	int err;
 
 	/* Sanity checks */
-	if ((info->mode & default_params) != default_params) {
-		pr_err("pps: %s: unsupported default parameters\n",
-					info->name);
-		err = -EINVAL;
-		goto pps_register_source_exit;
-	}
-	if ((info->mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)) != 0 &&
-			info->echo == NULL) {
-		pr_err("pps: %s: echo function is not defined\n",
-					info->name);
-		err = -EINVAL;
-		goto pps_register_source_exit;
-	}
-	if ((info->mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0) {
-		pr_err("pps: %s: unspecified time format\n",
-					info->name);
-		err = -EINVAL;
-		goto pps_register_source_exit;
-	}
+
+	/* default_params should be supported */
+	BUG_ON((info->mode & default_params) != default_params);
+	/* echo function should be defined if we are asked to call it */
+	BUG_ON((info->mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)) != 0 &&
+			info->echo == NULL);
+	/* time format should be specified */
+	BUG_ON((info->mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0);
 
 	/* Allocate memory for the new PPS source struct */
 	pps = kzalloc(sizeof(struct pps_device), GFP_KERNEL);
@@ -175,10 +164,8 @@ void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
 	int captured = 0;
 	struct pps_ktime ts_real;
 
-	if ((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0) {
-		dev_err(pps->dev, "unknown event (%x)\n", event);
-		return;
-	}
+	/* check event type */
+	BUG_ON((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0);
 
 	dev_dbg(pps->dev, "PPS event at %ld.%09ld\n",
 			ts->ts_real.tv_sec, ts->ts_real.tv_nsec);
-- 
1.7.1

