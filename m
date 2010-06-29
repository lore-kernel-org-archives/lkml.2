Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab0F2LNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 07:13:10 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52683 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab0F2LNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 07:13:08 -0400
To: Jens Axboe <axboe@kernel.dk>
CC: xiaosuo@gmail.com, tim.gardner@canonical.com,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <E1OTYfk-0008GY-PJ@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Tue, 29 Jun 2010 13:08:12 +0200)
Subject: [PATCH 3/3] splice: fix misuse of SPLICE_F_NONBLOCK
References: <E1OTYfk-0008GY-PJ@pomaz-ex.szeredi.hu>
Message-Id: <E1OTYkT-0008Io-0s@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 29 Jun 2010 13:13:05 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

SPLICE_F_NONBLOCK is clearly documented to only affect blocking on the
destination pipe and not on the source file.

In __generic_file_splice_read(), however, it returns EAGAIN if the
page is currently being read.

This makes it impossible to write an application that only wants
failure if the pipe buffer is full.  For example if the same process
is handling both ends of a pipe and isn't otherwise able to determine
whether a splice to the pipe will fit or not.

We could make the read non-blocking on O_NONBLOCK or some other splice
flag, but for now this is the simplest fix.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/splice.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2010-06-29 12:46:30.000000000 +0200
+++ linux-2.6/fs/splice.c	2010-06-29 12:46:32.000000000 +0200
@@ -399,17 +399,7 @@ __generic_file_splice_read(struct file *
 		 * If the page isn't uptodate, we may need to start io on it
 		 */
 		if (!PageUptodate(page)) {
-			/*
-			 * If in nonblock mode then dont block on waiting
-			 * for an in-flight io page
-			 */
-			if (flags & SPLICE_F_NONBLOCK) {
-				if (!trylock_page(page)) {
-					error = -EAGAIN;
-					break;
-				}
-			} else
-				lock_page(page);
+			lock_page(page);
 
 			/*
 			 * Page was truncated, or invalidated by the
