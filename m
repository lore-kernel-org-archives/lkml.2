Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab0IXQoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:44:21 -0400
Received: from kroah.org ([198.145.64.141]:37173 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933002Ab0IXQfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:13 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:46 2010
Message-Id: <20100924163346.447354449@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:31:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>, Jens Axboe <jaxboe@fusionio.com>
Subject: [27/68] char: Mark /dev/zero and /dev/kmem as not capable of writeback
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

commit 371d217ee1ff8b418b8f73fb2a34990f951ec2d4 upstream.

These devices don't do any writeback but their device inodes still can get
dirty so mark bdi appropriately so that bdi code does the right thing and files
inodes to lists of bdi carrying the device inodes.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/mem.c |    3 ++-
 fs/char_dev.c      |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -822,10 +822,11 @@ static const struct file_operations zero
 /*
  * capabilities for /dev/zero
  * - permits private mappings, "copies" are taken of the source of zeros
+ * - no writeback happens
  */
 static struct backing_dev_info zero_bdi = {
 	.name		= "char/mem",
-	.capabilities	= BDI_CAP_MAP_COPY,
+	.capabilities	= BDI_CAP_MAP_COPY | BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 
 static const struct file_operations full_fops = {
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -39,7 +39,9 @@ struct backing_dev_info directly_mappabl
 #endif
 		/* permit direct mmap, for read, write or exec */
 		BDI_CAP_MAP_DIRECT |
-		BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP),
+		BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP |
+		/* no writeback happens */
+		BDI_CAP_NO_ACCT_AND_WRITEBACK),
 };
 
 static struct kobj_map *cdev_map;


