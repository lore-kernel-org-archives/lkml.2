Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab0GYLaP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 07:30:15 -0400
Received: from smtp.nokia.com ([192.100.122.230]:18913 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab0GYLaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 07:30:06 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCHv6 03/15] writeback: do not lose wake-ups in the forker thread - 1
Date: Sun, 25 Jul 2010 14:29:13 +0300
Message-Id: <1280057365-10297-4-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1280057365-10297-1-git-send-email-dedekind1@gmail.com>
References: <1280057365-10297-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 25 Jul 2010 11:29:26.0875 (UTC) FILETIME=[A3B0F2B0:01CB2BEC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Currently the forker thread can lose wake-ups which may lead to unnecessary
delays in processing bdi works. E.g., consider the following scenario.

1. 'bdi_forker_thread()' walks the 'bdi_list', finds out there is nothing to
   do, and is about to finish the loop.
2. A bdi thread decides to exit because it was inactive for long time.
3. 'bdi_queue_work()' adds a work to the bdi which just exited, so it wakes up
   the forker thread.
4. but 'bdi_forker_thread()' executes 'set_current_state(TASK_INTERRUPTIBLE)'
   and goes sleep. We lose a wake-up.

Losing the wake-up is not fatal, but this means that the bdi work processing
will be delayed by up to 5 sec. This race is theoretical, I never hit it, but
it is worth fixing.

The fix is to execute 'set_current_state(TASK_INTERRUPTIBLE)' _before_ walking
'bdi_list', not after.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mm/backing-dev.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 327e36d..b1dc2d4 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -342,6 +342,7 @@ static int bdi_forker_thread(void *ptr)
 			wb_do_writeback(me, 0);
 
 		spin_lock_bh(&bdi_lock);
+		set_current_state(TASK_INTERRUPTIBLE);
 
 		/*
 		 * Check if any existing bdi's have dirty data without
@@ -357,8 +358,6 @@ static int bdi_forker_thread(void *ptr)
 			bdi_add_default_flusher_thread(bdi);
 		}
 
-		set_current_state(TASK_INTERRUPTIBLE);
-
 		if (list_empty(&bdi_pending_list)) {
 			unsigned long wait;
 
-- 
1.7.1.1

