Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab1DBPhl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 11:37:41 -0400
Received: from relay.parallels.com ([195.214.232.42]:57370 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab1DBPhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 11:37:40 -0400
Subject: [PATCH] block: fix request sorting at unplug
To: Jens Axboe <axboe@kernel.dk>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: <linux-kernel@vger.kernel.org>
Date: Sat, 2 Apr 2011 19:37:37 +0400
Message-ID: <20110402153737.15555.75762.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparison function for list_sort() must be anticommutative,
otherwise it is not sorting in ordinary meaning.

But fortunately list_sort() always check ((*cmp)(priv, a, b) <= 0)
it not distinguish negative and zero, so comparison function can
implement only less-or-equal instead of full three-way comparison.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 block/blk-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e0a0623..5e151d2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2665,7 +2665,7 @@ static int plug_rq_cmp(void *priv, struct list_head *a, struct list_head *b)
 	struct request *rqa = container_of(a, struct request, queuelist);
 	struct request *rqb = container_of(b, struct request, queuelist);
 
-	return !(rqa->q == rqb->q);
+	return !(rqa->q <= rqb->q);
 }
 
 static void flush_plug_list(struct blk_plug *plug)

