Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361Ab0HLAdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:33:40 -0400
Received: from kroah.org ([198.145.64.141]:43536 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758782Ab0HKX6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:54 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:02 2010
Message-Id: <20100811235502.610603500@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yan Zheng <zheng.yan@oracle.com>, Chris Mason <chris.mason@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [077/111] Btrfs: Fix oopsen when dropping empty tree.
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yan, Zheng <zheng.yan@oracle.com>

commit 7a7965f83e89f0be506a96769938a721e4e5ae50 upstream.

When dropping a empty tree, walk_down_tree() skips checking
extent information for the tree root. This will triggers a
BUG_ON in walk_up_proc().

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/extent-tree.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5402,10 +5402,6 @@ static noinline int walk_down_tree(struc
 	int ret;
 
 	while (level >= 0) {
-		if (path->slots[level] >=
-		    btrfs_header_nritems(path->nodes[level]))
-			break;
-
 		ret = walk_down_proc(trans, root, path, wc, lookup_info);
 		if (ret > 0)
 			break;
@@ -5413,6 +5409,10 @@ static noinline int walk_down_tree(struc
 		if (level == 0)
 			break;
 
+		if (path->slots[level] >=
+		    btrfs_header_nritems(path->nodes[level]))
+			break;
+
 		ret = do_walk_down(trans, root, path, wc, &lookup_info);
 		if (ret > 0) {
 			path->slots[level]++;


