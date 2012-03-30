Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936578Ab2C3WnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:43:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55577 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935215Ab2C3VHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:07:36 -0400
Message-Id: <20120330195734.491949938@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:58:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@ZenIV.linux.org.uk>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [ 086/108] udf: Fix deadlock in udf_release_file()
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit a0391a3ae91d301c0e59368531a4de5f0b122bcf upstream.

udf_release_file() can be called from munmap() path with mmap_sem held.  Thus
we cannot take i_mutex there because that ranks above mmap_sem. Luckily,
i_mutex is not needed in udf_release_file() anymore since protection by
i_data_sem is enough to protect from races with write and truncate.

Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/udf/file.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -201,12 +201,10 @@ out:
 static int udf_release_file(struct inode *inode, struct file *filp)
 {
 	if (filp->f_mode & FMODE_WRITE) {
-		mutex_lock(&inode->i_mutex);
 		down_write(&UDF_I(inode)->i_data_sem);
 		udf_discard_prealloc(inode);
 		udf_truncate_tail_extent(inode);
 		up_write(&UDF_I(inode)->i_data_sem);
-		mutex_unlock(&inode->i_mutex);
 	}
 	return 0;
 }


