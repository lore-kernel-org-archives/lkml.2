Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab2AXCqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:46:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab2AXCqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:46:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:30 2012
Message-Id: <20120124023930.763547655@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peng Tao <peng_tao@emc.com>,
        Benny Halevy <bhalevy@tonian.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [077/129] pnfsblock: acquire im_lock in _preload_range
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1825
Lines: 58

From: Peng Tao <bergwolf@gmail.com>

commit 39e567ae36fe03c2b446e1b83ee3d39bea08f90b upstream.

When calling _add_entry, we should take the im_lock to protect
agains other modifiers.

Signed-off-by: Peng Tao <peng_tao@emc.com>
Signed-off-by: Benny Halevy <bhalevy@tonian.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/blocklayout/extents.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/nfs/blocklayout/extents.c
+++ b/fs/nfs/blocklayout/extents.c
@@ -139,11 +139,13 @@ static int _set_range(struct my_tree *tr
 }
 
 /* Ensure that future operations on given range of tree will not malloc */
-static int _preload_range(struct my_tree *tree, u64 offset, u64 length)
+static int _preload_range(struct pnfs_inval_markings *marks,
+		u64 offset, u64 length)
 {
 	u64 start, end, s;
 	int count, i, used = 0, status = -ENOMEM;
 	struct pnfs_inval_tracking **storage;
+	struct my_tree  *tree = &marks->im_tree;
 
 	dprintk("%s(%llu, %llu) enter\n", __func__, offset, length);
 	start = normalize(offset, tree->mtt_step_size);
@@ -161,12 +163,11 @@ static int _preload_range(struct my_tree
 			goto out_cleanup;
 	}
 
-	/* Now need lock - HOW??? */
-
+	spin_lock(&marks->im_lock);
 	for (s = start; s < end; s += tree->mtt_step_size)
 		used += _add_entry(tree, s, INTERNAL_EXISTS, storage[used]);
+	spin_unlock(&marks->im_lock);
 
-	/* Unlock - HOW??? */
 	status = 0;
 
  out_cleanup:
@@ -286,7 +287,7 @@ int bl_mark_sectors_init(struct pnfs_inv
 
 	start = normalize(offset, marks->im_block_size);
 	end = normalize_up(offset + length, marks->im_block_size);
-	if (_preload_range(&marks->im_tree, start, end - start))
+	if (_preload_range(marks, start, end - start))
 		goto outerr;
 
 	spin_lock(&marks->im_lock);


