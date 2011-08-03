Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1HCQAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 12:00:09 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51519 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab1HCQAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 12:00:06 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] md: use REQ_NOIDLE flag in md_super_write()
Date: Thu,  4 Aug 2011 00:57:57 +0900
Message-Id: <1312387077-26617-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Queue idling is used for the anticipation of immediate
sequencial I/O's but md_super_write() is a kind of one-
shot operation, coupled with md_super_wait(), so the
idling in this case will be just a waste of time.

Specifying REQ_NOIDLE prevents it. Instead of adding
the flag to submit_bio() directly, use pre-defined
macro WRITE_FLUSH_FUA.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/md.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d97a62534798..8650e9a0ce7c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -848,7 +848,7 @@ void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
 	bio->bi_end_io = super_written;
 
 	atomic_inc(&mddev->pending_writes);
-	submit_bio(REQ_WRITE | REQ_SYNC | REQ_FLUSH | REQ_FUA, bio);
+	submit_bio(WRITE_FLUSH_FUA, bio);
 }
 
 void md_super_wait(mddev_t *mddev)
-- 
1.7.6

