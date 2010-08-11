Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578Ab0HLAgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:36:10 -0400
Received: from kroah.org ([198.145.64.141]:43415 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759054Ab0HKX6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:35 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:01 2010
Message-Id: <20100811235501.165594442@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Engelhardt <jengelh@medozas.de>,
        Chris Mason <chris.mason@oracle.com>, Jeff Mahoney <jeffm@suse.com>
Subject: [061/111] btrfs: fix missing last-entry in readdir(3)
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Engelhardt <jengelh@medozas.de>

commit 406266ab9ac8ed8b085c58aacd9e3161480dc5d5 upstream.

parent 49313cdac7b34c9f7ecbb1780cfc648b1c082cd7 (v2.6.32-1-g49313cd)
commit ff48c08e1c05c67e8348ab6f8a24de8034e0e34d
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Dec 9 22:57:36 2009 +0100

Btrfs: fix missing last-entry in readdir(3)

When one does a 32-bit readdir(3), the last entry of a directory is
missing. This is however not due to passing a large value to filldir,
but it seems to have to do with glibc doing telldir or something
quirky. In any case, this patch fixes it in practice.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/btrfs/inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3995,7 +3995,11 @@ skip:
 
 	/* Reached end of directory/root. Bump pos past the last item. */
 	if (key_type == BTRFS_DIR_INDEX_KEY)
-		filp->f_pos = INT_LIMIT(off_t);
+		/*
+		 * 32-bit glibc will use getdents64, but then strtol -
+		 * so the last number we can serve is this.
+		 */
+		filp->f_pos = 0x7fffffff;
 	else
 		filp->f_pos++;
 nopos:


