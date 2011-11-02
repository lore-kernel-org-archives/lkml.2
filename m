Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934474Ab1KCBkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:40:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934367Ab1KCBkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:40:47 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:44 2011
Message-Id: <20111102222744.404026276@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Xiaotian Feng <dfeng@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [051/101] block: check for proper length of iov entries earlier in blk_rq_map_user_iov()
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Xiaotian Feng <dfeng@redhat.com>

commit 5478755616ae2ef1ce144dded589b62b2a50d575 upstream.

commit 9284bcf checks for proper length of iov entries in
blk_rq_map_user_iov(). But if the map is unaligned, kernel
will break out the loop without checking for the proper length.
So we need to check the proper length before the unalign check.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-map.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -201,12 +201,13 @@ int blk_rq_map_user_iov(struct request_q
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


