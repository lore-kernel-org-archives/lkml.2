Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab2AXDBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 22:01:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420Ab2AXCqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:46:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:30 2012
Message-Id: <20120124023930.859036287@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peng Tao <peng_tao@emc.com>,
        Benny Halevy <bhalevy@tonian.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [078/129] pnfsblock: dont spinlock when freeing block_dev
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1276
Lines: 40

From: Peng Tao <bergwolf@gmail.com>

commit 93a3844ee0f843b05a1df4b52e1a19ff26b98d24 upstream.

bl_free_block_dev() may sleep. We can not call it with spinlock held.
Besides, there is no need to take bm_lock as we are last user freeing bm_devlist.

Signed-off-by: Peng Tao <peng_tao@emc.com>
Signed-off-by: Benny Halevy <bhalevy@tonian.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/blocklayout/blocklayout.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -779,16 +779,13 @@ bl_cleanup_layoutcommit(struct nfs4_layo
 static void free_blk_mountid(struct block_mount_id *mid)
 {
 	if (mid) {
-		struct pnfs_block_dev *dev;
-		spin_lock(&mid->bm_lock);
-		while (!list_empty(&mid->bm_devlist)) {
-			dev = list_first_entry(&mid->bm_devlist,
-					       struct pnfs_block_dev,
-					       bm_node);
+		struct pnfs_block_dev *dev, *tmp;
+
+		/* No need to take bm_lock as we are last user freeing bm_devlist */
+		list_for_each_entry_safe(dev, tmp, &mid->bm_devlist, bm_node) {
 			list_del(&dev->bm_node);
 			bl_free_block_dev(dev);
 		}
-		spin_unlock(&mid->bm_lock);
 		kfree(mid);
 	}
 }


