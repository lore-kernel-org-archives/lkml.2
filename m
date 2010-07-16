Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965513Ab0GPMtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:49:36 -0400
Received: from smtp.nokia.com ([192.100.122.230]:40005 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965399Ab0GPMtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:49:13 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 01/16] writeback: do not self-wakeup
Date: Fri, 16 Jul 2010 15:44:57 +0300
Message-Id: <1279284312-2411-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 16 Jul 2010 12:48:58.0117 (UTC) FILETIME=[41DAF350:01CB24E5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

The bdi forker thread wakes up itself via 'bdi_add_to_pending()'.
And the thread is the only user of 'bdi_add_to_pending()'. Thus,
we can safely zap the unneeded 'wake_up_process()' call.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 mm/backing-dev.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index ac78a33..ff5669a 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -421,12 +421,6 @@ static void bdi_add_to_pending(struct rcu_head *head)
 	spin_lock(&bdi_lock);
 	list_add_tail(&bdi->bdi_list, &bdi_pending_list);
 	spin_unlock(&bdi_lock);
-
-	/*
-	 * We are now on the pending list, wake up bdi_forker_task()
-	 * to finish the job and add us back to the active bdi_list
-	 */
-	wake_up_process(default_backing_dev_info.wb.task);
 }
 
 /*
-- 
1.7.1.1

