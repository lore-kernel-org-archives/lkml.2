Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab1BBApF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:45:05 -0500
Received: from mga14.intel.com ([143.182.124.37]:3685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab1BBApB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960877"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: tiwai@suse.de, cjb@laptop.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [112/139] mmc: Fix re-probing with PM_POST_RESTORE notification
Message-Id: <20110202004511.008F83E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Takashi Iwai <tiwai@suse.de>

commit 274476f8fe0b6ac9bac542cc39de12c3dd0f43f6 upstream.

In the error-path where PM notifies PM_POST_RESTORE, the rescan-blockage
should be cleared as well.  Otherwise it'll be never re-probed.

Also, as a bonus, this fixes a bug in S4 with user-mode suspend in the
current code, as it sends PM_POST_RESTORE instead of
PM_POST_HIBERNATION wrongly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/mmc/core/core.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/mmc/core/core.c
===================================================================
--- linux-2.6.35.y.orig/drivers/mmc/core/core.c
+++ linux-2.6.35.y/drivers/mmc/core/core.c
@@ -1366,6 +1366,7 @@ int mmc_pm_notify(struct notifier_block 
 
 	case PM_POST_SUSPEND:
 	case PM_POST_HIBERNATION:
+	case PM_POST_RESTORE:
 
 		spin_lock_irqsave(&host->lock, flags);
 		host->rescan_disable = 0;
