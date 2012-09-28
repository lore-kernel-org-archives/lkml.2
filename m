Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824Ab2I1Ua3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:30:29 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43081 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964981Ab2I1UaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:30:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ivan Vasilyev <ivan.vasilyev@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [ 164/218] md/raid10: fix problem with on-stack allocation of r10bio structure.
Date: Fri, 28 Sep 2012 13:16:21 -0700
Message-Id: <20120928201520.361265116@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit e0ee778528bbaad28a5c69d2e219269a3a096607 upstream.

A 'struct r10bio' has an array of per-copy information at the end.
This array is declared with size [0] and r10bio_pool_alloc allocates
enough extra space to store the per-copy information depending on the
number of copies needed.

So declaring a 'struct r10bio on the stack isn't going to work.  It
won't allocate enough space, and memory corruption will ensue.

So in the two places where this is done, declare a sufficiently large
structure and use that instead.

The two call-sites of this bug were introduced in 3.4 and 3.5
so this is suitable for both those kernels.  The patch will have to
be modified for 3.4 as it only has one bug.

Reported-by: Ivan Vasilyev <ivan.vasilyev@gmail.com>
Tested-by: Ivan Vasilyev <ivan.vasilyev@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/md/raid10.c |   16 ++++++++++------
 drivers/md/raid10.h |    2 +-
 2 files changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -612,20 +612,24 @@ static int raid10_mergeable_bvec(struct
 		max = biovec->bv_len;
 
 	if (mddev->merge_check_needed) {
-		struct r10bio r10_bio;
+		struct {
+			struct r10bio r10_bio;
+			struct r10dev devs[conf->copies];
+		} on_stack;
+		struct r10bio *r10_bio = &on_stack.r10_bio;
 		int s;
-		r10_bio.sector = sector;
-		raid10_find_phys(conf, &r10_bio);
+		r10_bio->sector = sector;
+		raid10_find_phys(conf, r10_bio);
 		rcu_read_lock();
 		for (s = 0; s < conf->copies; s++) {
-			int disk = r10_bio.devs[s].devnum;
+			int disk = r10_bio->devs[s].devnum;
 			struct md_rdev *rdev = rcu_dereference(
 				conf->mirrors[disk].rdev);
 			if (rdev && !test_bit(Faulty, &rdev->flags)) {
 				struct request_queue *q =
 					bdev_get_queue(rdev->bdev);
 				if (q->merge_bvec_fn) {
-					bvm->bi_sector = r10_bio.devs[s].addr
+					bvm->bi_sector = r10_bio->devs[s].addr
 						+ rdev->data_offset;
 					bvm->bi_bdev = rdev->bdev;
 					max = min(max, q->merge_bvec_fn(
@@ -637,7 +641,7 @@ static int raid10_mergeable_bvec(struct
 				struct request_queue *q =
 					bdev_get_queue(rdev->bdev);
 				if (q->merge_bvec_fn) {
-					bvm->bi_sector = r10_bio.devs[s].addr
+					bvm->bi_sector = r10_bio->devs[s].addr
 						+ rdev->data_offset;
 					bvm->bi_bdev = rdev->bdev;
 					max = min(max, q->merge_bvec_fn(
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -104,7 +104,7 @@ struct r10bio {
 	 * We choose the number when they are allocated.
 	 * We sometimes need an extra bio to write to the replacement.
 	 */
-	struct {
+	struct r10dev {
 		struct bio	*bio;
 		union {
 			struct bio	*repl_bio; /* used for resync and


