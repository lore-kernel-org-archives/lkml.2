Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464Ab0HXXrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:47:49 -0400
Received: from kroah.org ([198.145.64.141]:52068 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370Ab0HXWxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:53:33 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:25:23 2010
Message-Id: <20100824222523.266066196@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:24:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tao Ma <tao.ma@oracle.com>, Joel Becker <joel.becker@oracle.com>
Subject: [10/59] ocfs2: Count more refcount records in file system fragmentation.
In-Reply-To: <20100824224625.GA5449@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tao Ma <tao.ma@oracle.com>

commit 8a2e70c40ff58f82dde67770e6623ca45f0cb0c8 upstream.

The refcount record calculation in ocfs2_calc_refcount_meta_credits
is too optimistic that we can always allocate contiguous clusters
and handle an already existed refcount rec as a whole. Actually
because of file system fragmentation, we may have the chance to split
a refcount record into 3 parts during the transaction. So consider
the worst case in record calculation.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/refcounttree.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2454,16 +2454,26 @@ static int ocfs2_calc_refcount_meta_cred
 		len = min((u64)cpos + clusters, le64_to_cpu(rec.r_cpos) +
 			  le32_to_cpu(rec.r_clusters)) - cpos;
 		/*
-		 * If the refcount rec already exist, cool. We just need
-		 * to check whether there is a split. Otherwise we just need
-		 * to increase the refcount.
-		 * If we will insert one, increases recs_add.
-		 *
 		 * We record all the records which will be inserted to the
 		 * same refcount block, so that we can tell exactly whether
 		 * we need a new refcount block or not.
+		 *
+		 * If we will insert a new one, this is easy and only happens
+		 * during adding refcounted flag to the extent, so we don't
+		 * have a chance of spliting. We just need one record.
+		 *
+		 * If the refcount rec already exists, that would be a little
+		 * complicated. we may have to:
+		 * 1) split at the beginning if the start pos isn't aligned.
+		 *    we need 1 more record in this case.
+		 * 2) split int the end if the end pos isn't aligned.
+		 *    we need 1 more record in this case.
+		 * 3) split in the middle because of file system fragmentation.
+		 *    we need 2 more records in this case(we can't detect this
+		 *    beforehand, so always think of the worst case).
 		 */
 		if (rec.r_refcount) {
+			recs_add += 2;
 			/* Check whether we need a split at the beginning. */
 			if (cpos == start_cpos &&
 			    cpos != le64_to_cpu(rec.r_cpos))


