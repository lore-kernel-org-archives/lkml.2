Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685Ab0HLAff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:35:35 -0400
Received: from kroah.org ([198.145.64.141]:43430 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759061Ab0HKX6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:38 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:01 2010
Message-Id: <20100811235501.341781170@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>, Jeff Mahoney <jeffm@suse.com>
Subject: [063/111] Btrfs, fix memory leaks in error paths
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 2423fdfb96e3f9ff3baeb6c4c78d74145547891d upstream.

Stanse found 2 memory leaks in relocate_block_group and
__btrfs_map_block. cluster and multi are not freed/assigned on all
paths. Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/btrfs/relocation.c |    4 +++-
 fs/btrfs/volumes.c    |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3281,8 +3281,10 @@ static noinline_for_stack int relocate_b
 		return -ENOMEM;
 
 	path = btrfs_alloc_path();
-	if (!path)
+	if (!path) {
+		kfree(cluster);
 		return -ENOMEM;
+	}
 
 	rc->extents_found = 0;
 	rc->extents_skipped = 0;
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2649,8 +2649,10 @@ again:
 	em = lookup_extent_mapping(em_tree, logical, *length);
 	read_unlock(&em_tree->lock);
 
-	if (!em && unplug_page)
+	if (!em && unplug_page) {
+		kfree(multi);
 		return 0;
+	}
 
 	if (!em) {
 		printk(KERN_CRIT "unable to find logical %llu len %llu\n",


