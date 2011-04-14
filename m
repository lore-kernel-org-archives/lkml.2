Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933758Ab1DNSCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:02:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:42384 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965073Ab1DNR7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:59:12 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Xiaotian Feng <dfeng@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 205/209] block: check for proper length of iov entries earlier in blk_rq_map_user_iov()
Date: Thu, 14 Apr 2011 13:56:03 -0400
Message-Id: <1302803767-9715-92-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaotian Feng <dfeng@redhat.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 5478755616ae2ef1ce144dded589b62b2a50d575 upstream.

commit 9284bcf checks for proper length of iov entries in
blk_rq_map_user_iov(). But if the map is unaligned, kernel
will break out the loop without checking for the proper length.
So we need to check the proper length before the unalign check.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 block/blk-map.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 30a7e51..749effa 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -201,12 +201,13 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	for (i = 0; i < iov_count; i++) {
 		unsigned long uaddr = (unsigned long)iov[i].iov_base;
 
+		if (!iov[i].iov_len)
+			return -EINVAL;
+
 		if (uaddr & queue_dma_alignment(q)) {
 			unaligned = 1;
 			break;
 		}
-		if (!iov[i].iov_len)
-			return -EINVAL;
 	}
 
 	if (unaligned || (q->dma_pad_mask & len) || map_data)
-- 
1.7.4.4

