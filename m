Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161713Ab2GLWjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:39:41 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:48634 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161700Ab2GLWjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:39:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Mason <chris.mason@fusionio.com>
Subject: [ 070/187] Btrfs: run delayed directory updates during log replay
Date: Thu, 12 Jul 2012 15:33:46 -0700
Message-Id: <20120712191528.890184546@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -690,6 +690,8 @@ static noinline int drop_one_dir_item(st
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
 


