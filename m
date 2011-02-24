Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab1BXOuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 09:50:11 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37861 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab1BXOuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 09:50:08 -0500
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
CC: rjw@sisk.pl, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: fix refcounting in swapon
Message-Id: <E1PscVt-0004ad-W9@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Feb 2011 15:49:53 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Grab a reference to bdev before calling blkdev_get(), which expects
the refcount to be already incremented and either returns success or
decrements the refcount and returns an error.

The bug was introduced by e525fd89 (block: make blkdev_get/put()
handle exclusive access), which didn't take into account this behavior
of blkdev_get().

CC: Tejun Heo <tj@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux.git/mm/swapfile.c
===================================================================
--- linux.git.orig/mm/swapfile.c	2011-02-24 15:29:26.000000000 +0100
+++ linux.git/mm/swapfile.c	2011-02-24 15:32:31.000000000 +0100
@@ -1940,7 +1940,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	error = -EINVAL;
 	if (S_ISBLK(inode->i_mode)) {
-		bdev = I_BDEV(inode);
+		bdev = bdgrab(I_BDEV(inode));
 		error = blkdev_get(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL,
 				   sys_swapon);
 		if (error < 0) {
