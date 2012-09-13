Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab2IMDlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 23:41:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42399 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab2IMDk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 23:40:59 -0400
From: joseph.glanville@orionvm.com.au
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        NeilBrown <neilb@suse.de>, Kent Overstreet <koverstreet@google.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Joseph Glanville <joseph.glanville@orionvm.com.au>
Subject: [PATCH] block: Document lack of ordering of submit_bio/generic_make_request
Date: Thu, 13 Sep 2012 13:40:30 +1000
Message-Id: <1347507630-10215-1-git-send-email-joseph.glanville@orionvm.com.au>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Glanville <joseph.glanville@orionvm.com.au>

It is worth noting here that the block layer makes no attempt
to preserve the order of requests and that upper layers like
journaling filesystems that require such ordering need to do so
explicity.

Signed-off-by: Joseph Glanville <joseph.glanville@orionvm.com.au>
---
 block/blk-core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b4dbdf..14b8be6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1749,6 +1749,11 @@ end_io:
  * bio happens to be merged with someone else, and may resubmit the bio to
  * a lower device by calling into generic_make_request recursively, which
  * means the bio should NOT be touched after the call to ->make_request_fn.
+ *
+ * Ordering is not guaranteed, callers of generic_make_request()
+ * that require ordering should ensure dependencies are first drained
+ * before submission of dependent bios.
+ *
  */
 void generic_make_request(struct bio *bio)
 {
@@ -1808,6 +1813,7 @@ EXPORT_SYMBOL(generic_make_request);
  * submit_bio() is very similar in purpose to generic_make_request(), and
  * uses that function to do most of the work. Both are fairly rough
  * interfaces; @bio must be presetup and ready for I/O.
+ * Note: submit_bio() doesn't ensure ordering, see generic_make_request()
  *
  */
 void submit_bio(int rw, struct bio *bio)
-- 
1.7.12

