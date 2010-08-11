Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160Ab0HKX6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:58:50 -0400
Received: from kroah.org ([198.145.64.141]:43390 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759023Ab0HKX6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:31 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:00 2010
Message-Id: <20100811235500.773919237@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>,
        Chris Mason <chris.mason@oracle.com>, Jeff Mahoney <jeffm@suse.com>
Subject: [057/111] Btrfs: deny sys_link across subvolumes.
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>

commit 4a8be425a8fb8fbb5d881eb55fa6634c3463b9c9 upstream.

I rebased Christian Parpart's patch to deny hard link across
subvolumes. Original patch modifies also btrfs_rename, but
I excluded it because we can move across subvolumes now and
it make no problem.
-----------------

Hard link across subvolumes should not allowed in Btrfs.
btrfs_link checks root of 'to' directory is same as root
of 'from' file. If not same, btrfs_link returns -EPERM.

Signed-off-by: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/btrfs/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4462,6 +4462,10 @@ static int btrfs_link(struct dentry *old
 	if (inode->i_nlink == 0)
 		return -ENOENT;
 
+	/* do not allow sys_link's with other subvols of the same device */
+	if (root->objectid != BTRFS_I(inode)->root->objectid)
+		return -EPERM;
+
 	/*
 	 * 1 item for inode ref
 	 * 2 items for dir items


