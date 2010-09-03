Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab0ICKl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:41:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:35615 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021Ab0ICKbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:31:05 -0400
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
Subject: [PATCH 18/41] block/loop: implement REQ_FLUSH/FUA support
Date: Fri,  3 Sep 2010 12:29:33 +0200
Message-Id: <1283509796-1510-19-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 10:30:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deprecate REQ_HARDBARRIER and implement REQ_FLUSH/FUA instead.  Also,
instead of checking file->f_op->fsync() directly, look at the value of
vfs_fsync() and ignore -EINVAL return.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/loop.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 953d1e1..5d27bc6 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -477,17 +477,17 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 	pos = ((loff_t) bio->bi_sector << 9) + lo->lo_offset;
 
 	if (bio_rw(bio) == WRITE) {
-		bool barrier = (bio->bi_rw & REQ_HARDBARRIER);
 		struct file *file = lo->lo_backing_file;
 
-		if (barrier) {
-			if (unlikely(!file->f_op->fsync)) {
-				ret = -EOPNOTSUPP;
-				goto out;
-			}
+		/* REQ_HARDBARRIER is deprecated */
+		if (bio->bi_rw & REQ_HARDBARRIER) {
+			ret = -EOPNOTSUPP;
+			goto out;
+		}
 
+		if (bio->bi_rw & REQ_FLUSH) {
 			ret = vfs_fsync(file, 0);
-			if (unlikely(ret)) {
+			if (unlikely(ret && ret != -EINVAL)) {
 				ret = -EIO;
 				goto out;
 			}
@@ -495,9 +495,9 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 
 		ret = lo_send(lo, bio, pos);
 
-		if (barrier && !ret) {
+		if ((bio->bi_rw & REQ_FUA) && !ret) {
 			ret = vfs_fsync(file, 0);
-			if (unlikely(ret))
+			if (unlikely(ret && ret != -EINVAL))
 				ret = -EIO;
 		}
 	} else
-- 
1.7.1

