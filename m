Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab1HYHJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 03:09:30 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:38085 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753013Ab1HYHJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 03:09:29 -0400
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH] block: Don't check QUEUE_FLAG_SAME_COMP in __blk_complete_request.
Date: Thu, 25 Aug 2011 15:09:17 +0800
Message-Id: <1314256157-4356-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In __blk_complete_request, we check both QUEUE_FLAG_SAME_COMP and req->cpu
to decide whether we should use req->cpu. Actually the user can also
select the complete cpu by either setting BIO_CPU_AFFINE or by calling
bio_set_completion_cpu. Current solution makes these 2 ways don't work
any more. So we'd better just check req->cpu.

Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 block/blk-softirq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 58340d0..1366a89 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -115,7 +115,7 @@ void __blk_complete_request(struct request *req)
 	/*
 	 * Select completion CPU
 	 */
-	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) && req->cpu != -1) {
+	if (req->cpu != -1) {
 		ccpu = req->cpu;
 		if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags)) {
 			ccpu = blk_cpu_to_group(ccpu);
-- 
1.7.1

