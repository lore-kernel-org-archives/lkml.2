Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0F2LKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 07:10:41 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52677 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab0F2LKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 07:10:39 -0400
To: Jens Axboe <axboe@kernel.dk>
CC: xiaosuo@gmail.com, tim.gardner@canonical.com,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <E1OTYfk-0008GY-PJ@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Tue, 29 Jun 2010 13:08:12 +0200)
Subject: [PATCH 2/3] splice: check f_mode for seekable file
References: <E1OTYfk-0008GY-PJ@pomaz-ex.szeredi.hu>
Message-Id: <E1OTYi4-0008IE-Aq@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 29 Jun 2010 13:10:36 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Changli Gao <xiaosuo@gmail.com>

check f_mode for seekable file

As a seekable file is allowed without a llseek function, so the old way isn't
work any more.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
----
 fs/splice.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)
Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2010-06-29 12:46:28.000000000 +0200
+++ linux-2.6/fs/splice.c	2010-06-29 12:46:30.000000000 +0200
@@ -1372,8 +1372,7 @@ static long do_splice(struct file *in, l
 		if (off_in)
 			return -ESPIPE;
 		if (off_out) {
-			if (!out->f_op || !out->f_op->llseek ||
-			    out->f_op->llseek == no_llseek)
+			if (!(out->f_mode & FMODE_PWRITE))
 				return -EINVAL;
 			if (copy_from_user(&offset, off_out, sizeof(loff_t)))
 				return -EFAULT;
@@ -1393,8 +1392,7 @@ static long do_splice(struct file *in, l
 		if (off_out)
 			return -ESPIPE;
 		if (off_in) {
-			if (!in->f_op || !in->f_op->llseek ||
-			    in->f_op->llseek == no_llseek)
+			if (!(in->f_mode & FMODE_PREAD))
 				return -EINVAL;
 			if (copy_from_user(&offset, off_in, sizeof(loff_t)))
 				return -EFAULT;
