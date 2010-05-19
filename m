Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab0ESU1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 16:27:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085Ab0ESU10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 16:27:26 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org
Subject: [PATCH 3/6] direct-io: do not merge logically non-contiguous requests
Date: Wed, 19 May 2010 16:24:51 -0400
Message-Id: <1274300694-8976-3-git-send-email-josef@redhat.com>
In-Reply-To: <1274300694-8976-1-git-send-email-josef@redhat.com>
References: <1274300694-8976-1-git-send-email-josef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btrfs cannot handle having logically non-contiguous requests submitted.  For
example if you have

Logical:  [0-4095][HOLE][8192-12287]
Physical: [0-4095]      [4096-8191]

Normally the DIO code would put these into the same BIO's.  The problem is we
need to know exactly what offset is associated with what BIO so we can do our
checksumming and unlocking properly, so putting them in the same BIO doesn't
work.  So add another check where we submit the current BIO if the physical
blocks are not contigous OR the logical blocks are not contiguous.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/direct-io.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 21ec032..03a3ed4 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -623,10 +623,15 @@ static int dio_send_cur_page(struct dio *dio)
 	int ret = 0;
 
 	if (dio->bio) {
+		loff_t cur_offset = dio->block_in_file << dio->blkbits;
+		loff_t bio_next_offset = dio->logical_offset_in_bio +
+			dio->bio->bi_size;
+
 		/*
 		 * See whether this new request is contiguous with the old
 		 */
-		if (dio->final_block_in_bio != dio->cur_page_block)
+		if (dio->final_block_in_bio != dio->cur_page_block ||
+		    cur_offset != bio_next_offset)
 			dio_bio_submit(dio);
 		/*
 		 * Submit now if the underlying fs is about to perform a
-- 
1.6.6.1

