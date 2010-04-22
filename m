Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab0DVUI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:08:58 -0400
Received: from kroah.org ([198.145.64.141]:60097 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758160Ab0DVUCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:02:01 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:18 2010
Message-Id: <20100422195418.095264403@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:55:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Sandeen <sandeen@redhat.com>, maximilian attems <max@stro.at>
Subject: [127/139] ext4: fix async i/o writes beyond 4GB to a sparse file
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit a1de02dccf906faba2ee2d99cac56799bda3b96a upstream.

The "offset" member in ext4_io_end holds bytes, not blocks, so
ext4_lblk_t is wrong - and too small (u32).

This caused the async i/o writes to sparse files beyond 4GB to fail
when they wrapped around to 0.

Also fix up the type of arguments to ext4_convert_unwritten_extents(),
it gets ssize_t from ext4_end_aio_dio_nolock() and
ext4_ext_direct_IO().

Reported-by: Giel de Nijs <giel@vectorwise.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/ext4.h    |    6 +++---
 fs/ext4/extents.c |    2 +-
 fs/ext4/inode.c   |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -139,8 +139,8 @@ typedef struct ext4_io_end {
 	struct inode		*inode;		/* file being written to */
 	unsigned int		flag;		/* unwritten or not */
 	int			error;		/* I/O error code */
-	ext4_lblk_t		offset;		/* offset in the file */
-	size_t			size;		/* size of the extent */
+	loff_t			offset;		/* offset in the file */
+	ssize_t			size;		/* size of the extent */
 	struct work_struct	work;		/* data work queue */
 } ext4_io_end_t;
 
@@ -1744,7 +1744,7 @@ extern void ext4_ext_release(struct supe
 extern long ext4_fallocate(struct inode *inode, int mode, loff_t offset,
 			  loff_t len);
 extern int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
-			  loff_t len);
+			  ssize_t len);
 extern int ext4_get_blocks(handle_t *handle, struct inode *inode,
 			   sector_t block, unsigned int max_blocks,
 			   struct buffer_head *bh, int flags);
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3603,7 +3603,7 @@ retry:
  * Returns 0 on success.
  */
 int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
-				    loff_t len)
+				    ssize_t len)
 {
 	handle_t *handle;
 	ext4_lblk_t block;
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3551,7 +3551,7 @@ static int ext4_end_aio_dio_nolock(ext4_
 {
 	struct inode *inode = io->inode;
 	loff_t offset = io->offset;
-	size_t size = io->size;
+	ssize_t size = io->size;
 	int ret = 0;
 
 	ext4_debug("end_aio_dio_onlock: io 0x%p from inode %lu,list->next 0x%p,"


