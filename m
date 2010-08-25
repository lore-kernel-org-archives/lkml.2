Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0HYP5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 11:57:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:52924 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab0HYPyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 11:54:12 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        jeremy@goop.org, snitzer@redhat.com, k-ueda@ct.jp.nec.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/30] block/loop: implement REQ_FLUSH/FUA support
Date: Wed, 25 Aug 2010 17:47:31 +0200
Message-Id: <1282751267-3530-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 Aug 2010 15:53:22 +0000 (UTC)
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

