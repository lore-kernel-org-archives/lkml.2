Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab1AJR0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:26:17 -0500
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:48240 "HELO
	web31807.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751011Ab1AJR0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 12:26:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type;
  b=4cuvk1nEeCG+VMZnaFeyAwEgLP6MTBlXMier5fM+G0EKC6S64f9tPKYlllMwsrD/dZTKVUkWqLJ3HZnc5jVOn9d/UhzznZ8gnfJwI0MURCl5F2NQuJn5fUQ9PWBjS3i1P+BlxjvstKngelR5nHYv12jNGmKoAZEk9Vstox3eeyw=;
Message-ID: <1266.36669.qm@web31807.mail.mud.yahoo.com>
X-YMail-OSG: lrFfkcMVM1k2ODXThpz18v7HNJBKjbVncztOQFisRKJN0oI
 4BOLpkK94M3sDRxCPoVrTZbjuMW_8vGRTg3oFKc10oRYhEbf6SHf6fuKvy1A
 lAO5kHbAXYw78s8AMGKp._sTWYG1VedtO3GVHdwYzbqb64Ekhs0Dt_QilIzX
 .rej._p0XlgaUMnScL5m.1X_fA8w4JPSuQZ5jP20ivtNcKZaAvgAAo.TksmG
 TslMI2AbTHQ7GKjBnM8JE7_ihW0GyWsiih.sUJ6Q9RX_klrZP0gicoOO7G.O
 Zpz7yz326u6_ajTM1dUDZukkRQKyyrdoryiQpZyHWQ1aUYjXskzoZZLmQek1
 hvlo49rz_PlXlq6iA7p2kqlvJxngVIiofergVUDn19_lwH1iIhk33qXPAJYZ
 _d8gRv.fUrSXUjw--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.108.291010
Date: Mon, 10 Jan 2011 09:26:13 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: [PATCH] [BLOCK] Allow tag 0 to be generated
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jaxboe@fusionio.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 67869fb9fdfa04503b250d59e086c15f1698aea0
skipped tag 0 by virtue of setting last_tag to
0. This commit sets it to -1, in order to start
and loop over from 0, thus generating tags
[0,max_tag-1], instead of [1,max_tag-1].

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 For a reference to the original patch see here:
 git://github.com/ltuikov/linux-2.6.git

 block/blk-tag.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-tag.c b/block/blk-tag.c
index f792e98..744cea6 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -130,7 +130,7 @@ init_tag_map(struct request_queue *q, struct blk_queue_tag *tags, int depth)
        tags->max_depth = depth;
        tags->tag_index = tag_index;
        tags->tag_map = tag_map;
-       tags->last_tag = 0;
+       tags->last_tag = -1;
 
        return 0;
 fail:
@@ -340,7 +340,7 @@ EXPORT_SYMBOL(blk_queue_end_tag);
 int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 {
        struct blk_queue_tag *bqt = q->queue_tags;
-       unsigned max_depth;
+       int max_depth;
        int tag;
 
        if (unlikely((rq->cmd_flags & REQ_QUEUED))) {
@@ -361,14 +361,14 @@ int blk_queue_start_tag(struct request_queue *q, struct request *rq)
        max_depth = bqt->max_depth;
        if (!rq_is_sync(rq) && max_depth > 1) {
                max_depth -= 2;
-               if (!max_depth)
+               if (max_depth <= 0)
                        max_depth = 1;
                if (q->in_flight[BLK_RW_ASYNC] > max_depth)
                        return 1;
        }
 
        if (bqt->last_tag == bqt->max_depth-1)
-               bqt->last_tag = 0;
+               bqt->last_tag = -1;
 
        do {
                tag = find_next_zero_bit(bqt->tag_map,
-- 
1.7.2.2.165.gbc382

