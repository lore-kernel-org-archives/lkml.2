Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1KLRC1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 12:02:27 -0500
Received: from www17.your-server.de ([213.133.104.17]:42117 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab1KLRC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 12:02:26 -0500
Message-ID: <1321117345.1624.6.camel@localhost.localdomain>
Subject: [PATCH] ocfs2: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Date: Sat, 12 Nov 2011 18:02:25 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kmemdup rather than duplicating its implementation

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c 2011-11-07 19:38:23.787162856 +0100
+++ b/fs/ocfs2/localalloc.c 2011-11-08 10:34:40.993095086 +0100
@@ -434,12 +434,11 @@ void ocfs2_shutdown_local_alloc(struct o
 	bh = osb->local_alloc_bh;
 	alloc = (struct ocfs2_dinode *) bh->b_data;
 
-	alloc_copy = kmalloc(bh->b_size, GFP_NOFS);
+	alloc_copy = kmemdup(alloc, bh->b_size, GFP_NOFS);
 	if (!alloc_copy) {
 		status = -ENOMEM;
 		goto out_commit;
 	}
-	memcpy(alloc_copy, alloc, bh->b_size);
 
 	status = ocfs2_journal_access_di(handle, INODE_CACHE(local_alloc_inode),
 					 bh, OCFS2_JOURNAL_ACCESS_WRITE);
@@ -1249,13 +1248,12 @@ static int ocfs2_local_alloc_slide_windo
 	 * local alloc shutdown won't try to double free main bitmap
 	 * bits. Make a copy so the sync function knows which bits to
 	 * free. */
-	alloc_copy = kmalloc(osb->local_alloc_bh->b_size, GFP_NOFS);
+	alloc_copy = kmemdup(alloc, osb->local_alloc_bh->b_size, GFP_NOFS);
 	if (!alloc_copy) {
 		status = -ENOMEM;
 		mlog_errno(status);
 		goto bail;
 	}
-	memcpy(alloc_copy, alloc, osb->local_alloc_bh->b_size);
 
 	status = ocfs2_journal_access_di(handle,
 					 INODE_CACHE(local_alloc_inode),



