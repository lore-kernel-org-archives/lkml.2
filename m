Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab2GIOpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:45:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38212 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754396Ab2GIOiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:11 -0400
Message-Id: <20120709143122.535842602@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Mason <chris.mason@fusionio.com>
Subject: [ 41/48] Btrfs: run delayed directory updates during log replay
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <chris.mason@fusionio.com>

commit b6305567e7d31b0bec1b8cb9ec0cadd7f7086f5f upstream.

While we are resolving directory modifications in the
tree log, we are triggering delayed metadata updates to
the filesystem btrees.

This commit forces the delayed updates to run so the
replay code can find any modifications done.  It stops
us from crashing because the directory deleltion replay
expects items to be removed immediately from the tree.

Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/tree-log.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 2017d0f..8abeae4 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -690,6 +690,8 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 	kfree(name);
 
 	iput(inode);
+
+	btrfs_run_delayed_items(trans, root);
 	return ret;
 }
 
@@ -895,6 +897,7 @@ again:
 				ret = btrfs_unlink_inode(trans, root, dir,
 							 inode, victim_name,
 							 victim_name_len);
+				btrfs_run_delayed_items(trans, root);
 			}
 			kfree(victim_name);
 			ptr = (unsigned long)(victim_ref + 1) + victim_name_len;
@@ -1475,6 +1478,9 @@ again:
 			ret = btrfs_unlink_inode(trans, root, dir, inode,
 						 name, name_len);
 			BUG_ON(ret);
+
+			btrfs_run_delayed_items(trans, root);
+
 			kfree(name);
 			iput(inode);
 


