Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965555Ab0GPMxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:53:09 -0400
Received: from smtp.nokia.com ([192.100.122.233]:54072 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965420Ab0GPMtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:49:23 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 13/16] writeback: restructure bdi forker loop a little
Date: Fri, 16 Jul 2010 15:45:09 +0300
Message-Id: <1279284312-2411-14-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 16 Jul 2010 12:49:16.0203 (UTC) FILETIME=[4CA2A7B0:01CB24E5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

This patch re-structures the loop which walks bdi a little. This
is really just a micro-step towards the coming change where the
forker thread will kill the bdi threads. Just a tiny preparation
which should simplify reviewing and make it easier to see what
I changed and catch mistakes by reviewing.

To put it differently, the final patch which moves the inactive bdi
threads exiting logic will be smaller if I do this little preparation.
Smaller patches are easier to review.

This patch also adds the 'bdi_cap_flush_forker(bdi)' condition to
the loop. The reason for this is that the forker thread can start
_before_ the BID_pending flag is set (see 'bdi_register()'), so
the WARN() statement will fire for the default bdi. I observed
this warning the system boots up.

This patch also amends comments a little.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 mm/backing-dev.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 0123d6f..18d7c22 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -340,24 +340,23 @@ static int bdi_forker_thread(void *ptr)
 		spin_lock_bh(&bdi_lock);
 		set_current_state(TASK_INTERRUPTIBLE);
 
-		/*
-		 * Check if any existing bdi's have dirty data without
-		 * a thread registered. If so, set that up.
-		 */
 		list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
-			if (!bdi_cap_writeback_dirty(bdi))
-				continue;
-			if (bdi->wb.task)
-				continue;
-			if (!bdi_has_dirty_io(bdi))
+			if (!bdi_cap_writeback_dirty(bdi) ||
+			     bdi_cap_flush_forker(bdi))
 				continue;
 
 			WARN(!test_bit(BDI_registered, &bdi->state),
 			     "bdi %p/%s is not registered!\n", bdi, bdi->name);
 
-			list_del_rcu(&bdi->bdi_list);
-			fork = true;
-			break;
+			/*
+			 * If the bdi has work to do, but the thread does not
+			 * exist - create it.
+			 */
+			if (!bdi->wb.task && bdi_has_dirty_io(bdi)) {
+				list_del_rcu(&bdi->bdi_list);
+				fork = true;
+				break;
+			}
 		}
 		spin_unlock_bh(&bdi_lock);
 
-- 
1.7.1.1

