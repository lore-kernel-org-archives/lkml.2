Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2BVUzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 15:55:43 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:60808 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865Ab2BVUzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 15:55:41 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: jack_wang@usish.com, dan.j.williams@intel.com
Cc: kernel-janitors@vger.kernel.org, lindar_liu@usish.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/scsi/pm8001/pm8001_sas.c: move timer start
Date: Wed, 22 Feb 2012 21:55:33 +0100
Message-Id: <1329944133-28433-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Move the add_timer below some instructions that do not seem to require a
timer and that in one case can fail, thus avoiding the need for a
corresponding del_timer.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
I don't fully understand the code, and have not tested the change.  Think
of this patch as more of a question as to whether this is the right thing
to do.

 drivers/scsi/pm8001/pm8001_sas.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 6b5b4a2..72cbe6d 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -775,8 +775,6 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 		task->slow_task->timer.data = (unsigned long)task;
 		task->slow_task->timer.function = pm8001_tmf_timedout;
 		task->slow_task->timer.expires = jiffies + PM8001_TASK_TIMEOUT * HZ;
-		add_timer(&task->slow_task->timer);
-
 		res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
 		if (res)
 			return res;
@@ -785,6 +783,8 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 		ccb->ccb_tag = ccb_tag;
 		ccb->task = task;
 
+		add_timer(&task->slow_task->timer);
+
 		res = PM8001_CHIP_DISP->task_abort(pm8001_ha,
 			pm8001_dev, flag, task_tag, ccb_tag);
 

