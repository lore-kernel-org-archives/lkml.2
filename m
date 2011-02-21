Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab1BUXnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 18:43:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab1BUXnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 18:43:02 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: oleg@redhat.com, paulmck@linux.vnet.ibm.com, vgoyal@redhat.com
Subject: [PATCH 1/2] blk-throttle: process limit change only through one function
Date: Mon, 21 Feb 2011 18:42:49 -0500
Message-Id: <1298331770-20079-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1298331770-20079-1-git-send-email-vgoyal@redhat.com>
References: <1298331770-20079-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o With the help of cgroup interface one can go and upate the bps/iops limits
  of existing group. Once the limits are udpated, a thread is woken up to
  see if some blocked group needs recalculation based on new limits and needs
  to be requeued.

o There was also a piece of code where I was checking for group limit update
  when a fresh bio comes in. This patch gets rid of that piece of code and
  keeps processing the limit change at one place throtl_process_limit_change().
  It just keeps the code simple and easy to understand.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index a89043a..67bd250 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1006,14 +1006,8 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 		/*
 		 * There is already another bio queued in same dir. No
 		 * need to update dispatch time.
-		 * Still update the disptime if rate limits on this group
-		 * were changed.
 		 */
-		if (!tg->limits_changed)
-			update_disptime = false;
-		else
-			tg->limits_changed = false;
-
+		update_disptime = false;
 		goto queue_bio;
 	}
 
-- 
1.7.1

