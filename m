Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab1DNRpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:45:35 -0400
Received: from mail.windriver.com ([147.11.1.11]:37320 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab1DNRpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:30 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 016/209] block: limit vec count in bio_kmalloc() and bio_alloc_map_data()
Date: Thu, 14 Apr 2011 13:40:46 -0400
Message-Id: <1302803039-9400-17-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jaxboe@fusionio.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit f3f63c1c28bc861a931fac283b5bc3585efb8967 upstream.

Reported-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/bio.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index e7bf6ca..75ea4c3 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -370,6 +370,9 @@ struct bio *bio_kmalloc(gfp_t gfp_mask, int nr_iovecs)
 {
 	struct bio *bio;
 
+	if (nr_iovecs > UIO_MAXIOV)
+		return NULL;
+
 	bio = kmalloc(sizeof(struct bio) + nr_iovecs * sizeof(struct bio_vec),
 		      gfp_mask);
 	if (unlikely(!bio))
@@ -697,8 +700,12 @@ static void bio_free_map_data(struct bio_map_data *bmd)
 static struct bio_map_data *bio_alloc_map_data(int nr_segs, int iov_count,
 					       gfp_t gfp_mask)
 {
-	struct bio_map_data *bmd = kmalloc(sizeof(*bmd), gfp_mask);
+	struct bio_map_data *bmd;
+
+	if (iov_count > UIO_MAXIOV)
+		return NULL;
 
+	bmd = kmalloc(sizeof(*bmd), gfp_mask);
 	if (!bmd)
 		return NULL;
 
-- 
1.7.4.4

