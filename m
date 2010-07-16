Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965536Ab0GPMtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:49:41 -0400
Received: from smtp.nokia.com ([192.100.122.233]:54048 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965405Ab0GPMtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:49:13 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 07/16] writeback: do not lose wake-ups in the forker thread
Date: Fri, 16 Jul 2010 15:45:03 +0300
Message-Id: <1279284312-2411-8-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 16 Jul 2010 12:49:07.0234 (UTC) FILETIME=[474A1820:01CB24E5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Currently the forker thread can lose wakeups which may lead to
unnecessary delays in processing bdi works. E.g., consider the
following scenario.

1. 'bdi_forker_thread()' walks the 'bdi_list', finds out there
   is nothing to do, and is about to finish the loop.
2. A bdi thread decides to exit because it was inactive for long
   time.
3. 'bdi_queue_work()' adds a work to the bdi which just exited,
   so it wakes up 'bdi_forker_thread()'.
4. 'bdi_forker_thread()' executes
   'set_current_state(TASK_INTERRUPTIBLE)' and goes sleep. We
   loose a wake-up.

This situation is theoretica, I never hit it, but it is worth
fixing. The fix is to execute
'set_current_state(TASK_INTERRUPTIBLE)' before walking 'bdi_list'.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 mm/backing-dev.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 03a3d82..14fe1bb 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -343,6 +343,7 @@ static int bdi_forker_thread(void *ptr)
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

