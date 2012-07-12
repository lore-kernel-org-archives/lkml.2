Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162671Ab2GLXSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:18:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47532 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162610Ab2GLXEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:04:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Mason <chris.mason@fusionio.com>
Subject: [ 25/68] Btrfs: run delayed directory updates during log replay
Date: Thu, 12 Jul 2012 16:01:59 -0700
Message-Id: <20120712175037.675064141@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-log.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -691,6 +691,8 @@ static noinline int drop_one_dir_item(st
 	kfree(name);
 
 	iput(inode);
+
+	btrfs_run_delayed_items(trans, root);
 	return ret;
 }
 
@@ -896,6 +898,7 @@ again:
 				ret = btrfs_unlink_inode(trans, root, dir,
 							 inode, victim_name,
 							 victim_name_len);
+				btrfs_run_delayed_items(trans, root);
 			}
 			kfree(victim_name);
 			ptr = (unsigned long)(victim_ref + 1) + victim_name_len;
@@ -1476,6 +1479,9 @@ again:
 			ret = btrfs_unlink_inode(trans, root, dir, inode,
 						 name, name_len);
 			BUG_ON(ret);
+
+			btrfs_run_delayed_items(trans, root);
+
 			kfree(name);
 			iput(inode);
 


