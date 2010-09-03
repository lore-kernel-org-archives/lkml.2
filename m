Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab0ICKmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:42:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:35603 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800Ab0ICKbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:31:04 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com, mpatocka@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/41] block: filter flush bio's in __generic_make_request()
Date: Fri,  3 Sep 2010 12:29:26 +0200
Message-Id: <1283509796-1510-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 10:30:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a number of make_request based drivers which don't support
cache flushes.  Filter out flush bio's in __generic_make_request() so
that they don't have to worry about them.  All FLUSH/FUA requests with
data are converted to regular IO requests and empty ones are completed
immediately.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 18455c4..495bdc4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1509,6 +1509,19 @@ static inline void __generic_make_request(struct bio *bio)
 		if (bio_check_eod(bio, nr_sectors))
 			goto end_io;
 
+		/*
+		 * Filter flush bio's early so that make_request based
+		 * drivers without flush support don't have to worry
+		 * about them.
+		 */
+		if ((bio->bi_rw & (REQ_FLUSH | REQ_FUA)) && !q->flush_flags) {
+			bio->bi_rw &= ~(REQ_FLUSH | REQ_FUA);
+			if (!nr_sectors) {
+				err = 0;
+				goto end_io;
+			}
+		}
+
 		if ((bio->bi_rw & REQ_DISCARD) &&
 		    (!blk_queue_discard(q) ||
 		     ((bio->bi_rw & REQ_SECURE) &&
-- 
1.7.1

