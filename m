Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab0FWD0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 23:26:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49203 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab0FWD0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 23:26:17 -0400
From: Tao Ma <tao.ma@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tao Ma <tao.ma@oracle.com>,
       Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] block: Don't count_vm_events for discard bio in submit_bio.
Date: Wed, 23 Jun 2010 11:24:51 +0800
Message-Id: <1277263491-4068-1-git-send-email-tao.ma@oracle.com>
X-Mailer: git-send-email 1.7.0.4
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4C217ECF.0170:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In submit_bio, we count vm events by check READ/WRITE.
But actually DISCARD_NOBARRIER also has the WRITE flag set.
It looks as if in blkdev_issue_discard, we also add a
page as the payload and the bio_has_data check isn't enough.
So add another check for discard bio.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 block/blk-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f84cce4..a725602 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1586,7 +1586,7 @@ void submit_bio(int rw, struct bio *bio)
 	 * If it's a regular read/write or a barrier with data attached,
 	 * go through the normal accounting stuff before submission.
 	 */
-	if (bio_has_data(bio)) {
+	if (bio_has_data(bio) && !(rw & BIO_RW_DISCARD)) {
 		if (rw & WRITE) {
 			count_vm_events(PGPGOUT, count);
 		} else {
-- 
1.5.5

