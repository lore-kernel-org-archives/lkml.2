Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab0LHPYC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:24:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47594 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680Ab0LHPYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:24:00 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Chris Ball <cjb@laptop.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Oliver Neukum <oneukum@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: Fix re-probing after hibernation
Date: Wed,  8 Dec 2010 16:23:59 +0100
Message-Id: <1291821839-15088-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 4c2ef25fe0b847d2ae818f74758ddb0be1c27d8e
  mmc: fix all hangs related to mmc/sd card insert/removal during
  suspend/resume
introduced a bug where the device probing no longer works after
hibernation.  This was because the pm notifier expects
PM_POST_HIBERNATION call while the system sends PM_POST_RESTORE
instead, thus disable_rescan is kept as 1.

Cc: <stable@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/mmc/core/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 31ae07a..30094f6 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1772,7 +1772,7 @@ int mmc_pm_notify(struct notifier_block *notify_block,
 		break;
 
 	case PM_POST_SUSPEND:
-	case PM_POST_HIBERNATION:
+	case PM_POST_RESTORE:
 
 		spin_lock_irqsave(&host->lock, flags);
 		host->rescan_disable = 0;
-- 
1.7.3.1

