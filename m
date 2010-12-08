Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0LHCVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:21:22 -0500
Received: from kroah.org ([198.145.64.141]:45816 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab0LHAq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:28 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:24 2010
Message-Id: <20101208004424.609071456@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [002/127] block: limit vec count in bio_kmalloc() and bio_alloc_map_data()
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jens Axboe <jaxboe@fusionio.com>

commit f3f63c1c28bc861a931fac283b5bc3585efb8967 upstream.

Reported-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/bio.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/bio.c
+++ b/fs/bio.c
@@ -371,6 +371,9 @@ struct bio *bio_kmalloc(gfp_t gfp_mask,
 {
 	struct bio *bio;
 
+	if (nr_iovecs > UIO_MAXIOV)
+		return NULL;
+
 	bio = kmalloc(sizeof(struct bio) + nr_iovecs * sizeof(struct bio_vec),
 		      gfp_mask);
 	if (unlikely(!bio))
@@ -701,8 +704,12 @@ static void bio_free_map_data(struct bio
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
 


