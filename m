Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2I1E5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:57:50 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39417 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab2I1E5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:57:47 -0400
MIME-Version: 1.0
Date: Fri, 28 Sep 2012 12:57:46 +0800
Message-ID: <CAPgLHd8C3BSWdBJUCx=Goah_RaP9zHkCqNkX0z4g1pcRq8=EWQ@mail.gmail.com>
Subject: [PATCH] hpfs: convert to use leXX_add_cpu()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mikulas@artax.karlin.mff.cuni.cz
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Convert cpu_to_leXX(leXX_to_cpu(E1) + E2) to use leXX_add_cpu().

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/hpfs/dnode.c | 30 +++++++++++++++---------------
 fs/hpfs/anode.c | 6 +++---
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/hpfs/dnode.c b/fs/hpfs/dnode.c
index 3228c52..153f442 100644
--- a/fs/hpfs/dnode.c
+++ b/fs/hpfs/dnode.c
@@ -145,10 +145,10 @@ static void set_last_pointer(struct super_block *s, struct dnode *d, dnode_secno
 		}
 	}
 	if (ptr) {
-		d->first_free = cpu_to_le32(le32_to_cpu(d->first_free) + 4);
+		le32_add_cpu(&d->first_free, 4);
 		if (le32_to_cpu(d->first_free) > 2048) {
 			hpfs_error(s, "set_last_pointer: too long dnode %08x", le32_to_cpu(d->self));
-			d->first_free = cpu_to_le32(le32_to_cpu(d->first_free) - 4);
+			le32_add_cpu(&d->first_free, -4);
 			return;
 		}
 		de->length = cpu_to_le16(36);
@@ -184,7 +184,7 @@ struct hpfs_dirent *hpfs_add_de(struct super_block *s, struct dnode *d,
 	de->not_8x3 = hpfs_is_name_long(name, namelen);
 	de->namelen = namelen;
 	memcpy(de->name, name, namelen);
-	d->first_free = cpu_to_le32(le32_to_cpu(d->first_free) + d_size);
+	le32_add_cpu(&d->first_free, d_size);
 	return de;
 }
 
@@ -314,7 +314,7 @@ static int hpfs_add_to_dnode(struct inode *i, dnode_secno dno,
 	set_last_pointer(i->i_sb, ad, de->down ? de_down_pointer(de) : 0);
 	de = de_next_de(de);
 	memmove((char *)nd + 20, de, le32_to_cpu(nd->first_free) + (char *)nd - (char *)de);
-	nd->first_free = cpu_to_le32(le32_to_cpu(nd->first_free) - ((char *)de - (char *)nd - 20));
+	le32_add_cpu(&nd->first_free, -((char *)de - (char *)nd - 20));
 	memcpy(d, nd, le32_to_cpu(nd->first_free));
 	for_all_poss(i, hpfs_pos_del, (loff_t)dno << 4, pos);
 	fix_up_ptrs(i->i_sb, ad);
@@ -474,8 +474,8 @@ static secno move_to_top(struct inode *i, dnode_secno from, dnode_secno to)
 			hpfs_brelse4(&qbh);
 			return 0;
 		}
-		dnode->first_free = cpu_to_le32(le32_to_cpu(dnode->first_free) - 4);
-		de->length = cpu_to_le16(le16_to_cpu(de->length) - 4);
+		le32_add_cpu(&dnode->first_free, -4);
+		le16_add_cpu(&de->length, -4);
 		de->down = 0;
 		hpfs_mark_4buffers_dirty(&qbh);
 		dno = up;
@@ -570,8 +570,8 @@ static void delete_empty_dnode(struct inode *i, dnode_secno dno)
 		for_all_poss(i, hpfs_pos_subst, ((loff_t)dno << 4) | 1, ((loff_t)up << 4) | p);
 		if (!down) {
 			de->down = 0;
-			de->length = cpu_to_le16(le16_to_cpu(de->length) - 4);
-			dnode->first_free = cpu_to_le32(le32_to_cpu(dnode->first_free) - 4);
+			le16_add_cpu(&de->length, -4);
+			le32_add_cpu(&dnode->first_free, -4);
 			memmove(de_next_de(de), (char *)de_next_de(de) + 4,
 				(char *)dnode + le32_to_cpu(dnode->first_free) - (char *)de_next_de(de));
 		} else {
@@ -647,14 +647,14 @@ static void delete_empty_dnode(struct inode *i, dnode_secno dno)
 					printk("HPFS: warning: unbalanced dnode tree, see hpfs.txt 4 more info\n");
 					printk("HPFS: warning: goin'on\n");
 				}
-				del->length = cpu_to_le16(le16_to_cpu(del->length) + 4);
+				le16_add_cpu(&del->length, 4);
 				del->down = 1;
-				d1->first_free = cpu_to_le32(le32_to_cpu(d1->first_free) + 4);
+				le32_add_cpu(&d1->first_free, 4);
 			}
 			if (dlp && !down) {
-				del->length = cpu_to_le16(le16_to_cpu(del->length) - 4);
+				le16_add_cpu(&del->length, -4);
 				del->down = 0;
-				d1->first_free = cpu_to_le32(le32_to_cpu(d1->first_free) - 4);
+				le32_add_cpu(&d1->first_free, -4);
 			} else if (down)
 				*(__le32 *) ((void *) del + le16_to_cpu(del->length) - 4) = cpu_to_le32(down);
 		} else goto endm;
@@ -668,9 +668,9 @@ static void delete_empty_dnode(struct inode *i, dnode_secno dno)
 		memcpy(de_cp, de_prev, le16_to_cpu(de_prev->length));
 		hpfs_delete_de(i->i_sb, dnode, de_prev);
 		if (!de_prev->down) {
-			de_prev->length = cpu_to_le16(le16_to_cpu(de_prev->length) + 4);
+			le16_add_cpu(&de_prev->length, 4);
 			de_prev->down = 1;
-			dnode->first_free = cpu_to_le32(le32_to_cpu(dnode->first_free) + 4);
+			le32_add_cpu(&dnode->first_free, 4);
 		}
 		*(__le32 *) ((void *) de_prev + le16_to_cpu(de_prev->length) - 4) = cpu_to_le32(ndown);
 		hpfs_mark_4buffers_dirty(&qbh);

diff --git a/fs/hpfs/anode.c b/fs/hpfs/anode.c
index 4bae4a4..2d5b254 100644
--- a/fs/hpfs/anode.c
+++ b/fs/hpfs/anode.c
@@ -102,7 +102,7 @@ secno hpfs_add_sector_to_btree(struct super_block *s, secno node, int fnod, unsi
 			return -1;
 		}
 		if (hpfs_alloc_if_possible(s, se = le32_to_cpu(btree->u.external[n].disk_secno) + le32_to_cpu(btree->u.external[n].length))) {
-			btree->u.external[n].length = cpu_to_le32(le32_to_cpu(btree->u.external[n].length) + 1);
+			le32_add_cpu(&btree->u.external[n].length, 1);
 			mark_buffer_dirty(bh);
 			brelse(bh);
 			return se;
@@ -153,7 +153,7 @@ secno hpfs_add_sector_to_btree(struct super_block *s, secno node, int fnod, unsi
 		btree = &anode->btree;
 	}
 	btree->n_free_nodes--; n = btree->n_used_nodes++;
-	btree->first_free = cpu_to_le16(le16_to_cpu(btree->first_free) + 12);
+	le16_add_cpu(&btree->first_free, 12);
 	btree->u.external[n].disk_secno = cpu_to_le32(se);
 	btree->u.external[n].file_secno = cpu_to_le32(fs);
 	btree->u.external[n].length = cpu_to_le32(1);
@@ -174,7 +174,7 @@ secno hpfs_add_sector_to_btree(struct super_block *s, secno node, int fnod, unsi
 		}
 		if (btree->n_free_nodes) {
 			btree->n_free_nodes--; n = btree->n_used_nodes++;
-			btree->first_free = cpu_to_le16(le16_to_cpu(btree->first_free) + 8);
+			le16_add_cpu(&btree->first_free, 8);
 			btree->u.internal[n].file_secno = cpu_to_le32(-1);
 			btree->u.internal[n].down = cpu_to_le32(na);
 			btree->u.internal[n-1].file_secno = cpu_to_le32(fs);


