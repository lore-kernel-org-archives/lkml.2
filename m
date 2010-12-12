Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0LLXpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44557 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab0LLXo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:44:59 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: jaxboe@fusionio.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [3/223] block: limit vec count in bio_kmalloc() and bio_alloc_map_data()
Message-Id: <20101212234457.D8BABB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:44:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jens Axboe <jaxboe@fusionio.com>

commit f3f63c1c28bc861a931fac283b5bc3585efb8967 upstream.

Reported-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/bio.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux/fs/bio.c
===================================================================
--- linux.orig/fs/bio.c
+++ linux/fs/bio.c
@@ -370,6 +370,9 @@ struct bio *bio_kmalloc(gfp_t gfp_mask,
 {
 	struct bio *bio;
 
+	if (nr_iovecs > UIO_MAXIOV)
+		return NULL;
+
 	bio = kmalloc(sizeof(struct bio) + nr_iovecs * sizeof(struct bio_vec),
 		      gfp_mask);
 	if (unlikely(!bio))
@@ -697,8 +700,12 @@ static void bio_free_map_data(struct bio
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
 
