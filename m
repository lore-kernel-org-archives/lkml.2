Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab2JOUVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:21:44 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:47102 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab2JOUKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:12 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de, vgoyal@redhat.com, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH v4 16/24] pktcdvd: Use bio_reset() in disabled code to kill bi_idx usage
Date: Mon, 15 Oct 2012 13:08:50 -0700
Message-Id: <1350331769-14856-17-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the short term this'll help with code auditing, and if this code ever
gets used now it's converted :)

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jiri Kosina <jkosina@suse.cz>
---
 drivers/block/pktcdvd.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 783c96c..1119042 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -1156,16 +1156,15 @@ static int pkt_start_recovery(struct packet_data *pkt)
 	new_sector = new_block * (CD_FRAMESIZE >> 9);
 	pkt->sector = new_sector;
 
+	bio_reset(pkt->bio);
+	pkt->bio->bi_bdev = pd->bdev;
+	pkt->bio->bi_rw = REQ_WRITE;
 	pkt->bio->bi_sector = new_sector;
-	pkt->bio->bi_next = NULL;
-	pkt->bio->bi_flags = 1 << BIO_UPTODATE;
-	pkt->bio->bi_idx = 0;
-
-	BUG_ON(pkt->bio->bi_rw != REQ_WRITE);
-	BUG_ON(pkt->bio->bi_vcnt != pkt->frames);
-	BUG_ON(pkt->bio->bi_size != pkt->frames * CD_FRAMESIZE);
-	BUG_ON(pkt->bio->bi_end_io != pkt_end_io_packet_write);
-	BUG_ON(pkt->bio->bi_private != pkt);
+	pkt->bio->bi_size = pkt->frames * CD_FRAMESIZE;
+	pkt->bio->bi_vcnt = pkt->frames;
+
+	pkt->bio->bi_end_io = pkt_end_io_packet_write;
+	pkt->bio->bi_private = pkt;
 
 	drop_super(sb);
 	return 1;
-- 
1.7.12

