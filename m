Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761811Ab0HFS2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:28:19 -0400
Received: from kroah.org ([198.145.64.141]:36017 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761644Ab0HFS2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:28:17 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 10:56:11 2010
Message-Id: <20100806175611.554738398@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 10:54:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>
Subject: [2/4] xfs: prevent swapext from operating on write-only files
In-Reply-To: <20100806182735.GA15732@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <dan.j.rosenberg@gmail.com>

commit 1817176a86352f65210139d4c794ad2d19fc6b63 upstream.

This patch prevents user "foo" from using the SWAPEXT ioctl to swap
a write-only file owned by user "bar" into a file owned by "foo" and
subsequently reading it.  It does so by checking that the file
descriptors passed to the ioctl are also opened for reading.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/xfs_dfrag.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -74,7 +74,9 @@ xfs_swapext(
 		goto out_free_sxp;
 	}
 
-	if (!(file->f_mode & FMODE_WRITE) || (file->f_flags & O_APPEND)) {
+	if (!(file->f_mode & FMODE_WRITE) ||
+	    !(file->f_mode & FMODE_READ) ||
+	    (file->f_flags & O_APPEND)) {
 		error = XFS_ERROR(EBADF);
 		goto out_put_file;
 	}
@@ -86,6 +88,7 @@ xfs_swapext(
 	}
 
 	if (!(target_file->f_mode & FMODE_WRITE) ||
+	    !(target_file->f_mode & FMODE_READ) ||
 	    (target_file->f_flags & O_APPEND)) {
 		error = XFS_ERROR(EBADF);
 		goto out_put_target_file;


