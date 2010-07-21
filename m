Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab0GUJcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 05:32:32 -0400
Received: from smtp.nokia.com ([192.100.122.230]:52633 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab0GUJc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 05:32:26 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 04/11] writeback: do not lose wake-ups in the forker thread - 2
Date: Wed, 21 Jul 2010 12:31:39 +0300
Message-Id: <1279704706-1267-5-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
References: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 21 Jul 2010 09:31:47.0798 (UTC) FILETIME=[8A804760:01CB28B7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Currently, if someone submits jobs for the default bdi, we can lose wake-up
events. E.g., this can happen if 'bdi_queue_work()' is called when
'bdi_forker_thread()' is executing code after 'wb_do_writeback(me, 0)', but
before 'set_current_state(TASK_INTERRUPTIBLE)'.

This situation is unlikely, and the result is not very severe - we'll just
delay the execution of the work, but this is still not very nice.

This patch fixes the issue by checking whether the default bdi has works before
the forker thread goes sleep.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 mm/backing-dev.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 0ea5e4c..ae44417 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -358,6 +358,10 @@ static int bdi_forker_thread(void *ptr)
 			bdi_add_default_flusher_thread(bdi);
 		}
 
+		/* Keep working if default bdi still has things to do */
+		if (!list_empty(&me->bdi->work_list))
+			__set_current_state(TASK_RUNNING);
+
 		if (list_empty(&bdi_pending_list)) {
 			unsigned long wait;
 
-- 
1.7.1.1

