Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab0GVN6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 09:58:16 -0400
Received: from smtp.nokia.com ([192.100.105.134]:52145 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab0GVN5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 09:57:07 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv3 09/14] writeback: restructure bdi forker loop a little
Date: Thu, 22 Jul 2010 16:56:23 +0300
Message-Id: <1279806988-14100-10-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279806988-14100-1-git-send-email-dedekind1@gmail.com>
References: <1279806988-14100-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 22 Jul 2010 13:56:36.0707 (UTC) FILETIME=[B3712330:01CB29A5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

This patch re-structures the loop which walks bdi a little. This is just a
micro-step towards the coming change where the forker thread will kill the bdi
threads. It should simplify reviewing the following changes, which would
otherwise be larger.

This patch also adds the 'bdi_cap_flush_forker(bdi)' condition check to the
loop. The reason for this is that the forker thread can start _before_ the
'BDI_registered' flag is set (see 'bdi_register()'), so the WARN() statement
will fire for the default bdi. I observed this warning at boot-up.

This patch also amends comments a little.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mm/backing-dev.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 672c17b..b788b8e 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -348,25 +348,31 @@ static int bdi_forker_thread(void *ptr)
 		 * a thread registered. If so, set that up.
 		 */
 		list_for_each_entry(bdi, &bdi_list, bdi_list) {
-			if (!bdi_cap_writeback_dirty(bdi))
-				continue;
-			if (bdi->wb.task)
-				continue;
-			if (list_empty(&bdi->work_list) &&
-			    !bdi_has_dirty_io(bdi))
+			bool have_dirty_io;
+
+			if (!bdi_cap_writeback_dirty(bdi) ||
+			     bdi_cap_flush_forker(bdi))
 				continue;
 
 			WARN(!test_bit(BDI_registered, &bdi->state),
 			     "bdi %p/%s is not registered!\n", bdi, bdi->name);
 
-			fork = true;
+			have_dirty_io = !list_empty(&bdi->work_list) ||
+					wb_has_dirty_io(&bdi->wb);
 
 			/*
-			 * Set the pending bit - if someone will try to
-			 * unregister this bdi - it'll wait on this bit.
+			 * If the bdi has work to do, but the thread does not
+			 * exist - create it.
 			 */
-			set_bit(BDI_pending, &bdi->state);
-			break;
+			if (!bdi->wb.task && have_dirty_io) {
+				/*
+				 * Set the pending bit - if someone will try to
+				 * unregister this bdi - it'll wait on this bit.
+				 */
+				set_bit(BDI_pending, &bdi->state);
+				fork = true;
+				break;
+			}
 		}
 		spin_unlock_bh(&bdi_lock);
 
-- 
1.7.1.1

