Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab1GZO10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:27:26 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56427 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1GZO1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:27:19 -0400
Date: Tue, 26 Jul 2011 17:25:20 +0300
From: Dan Carpenter <error27@gmail.com>
To: josef@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [patch] fs: add missing unlock in default_llseek()
Message-ID: <20110726142520.GG3824@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A recent change in linux-next, 982d816581 "fs: add SEEK_HOLE and
SEEK_DATA flags" added some direct returns on error, but it should
have been a goto out.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/read_write.c b/fs/read_write.c
index 5907b49..179f1c3 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -166,8 +166,10 @@ loff_t default_llseek(struct file *file, loff_t offset, int origin)
 			 * long as offset isn't at the end of the file then the
 			 * offset is data.
 			 */
-			if (offset >= inode->i_size)
-				return -ENXIO;
+			if (offset >= inode->i_size) {
+				retval = -ENXIO;
+				goto out;
+			}
 			break;
 		case SEEK_HOLE:
 			/*
@@ -175,8 +177,10 @@ loff_t default_llseek(struct file *file, loff_t offset, int origin)
 			 * as long as offset isn't i_size or larger, return
 			 * i_size.
 			 */
-			if (offset >= inode->i_size)
-				return -ENXIO;
+			if (offset >= inode->i_size) {
+				retval = -ENXIO;
+				goto out;
+			}
 			offset = inode->i_size;
 			break;
 	}
