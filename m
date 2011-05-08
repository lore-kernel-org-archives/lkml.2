Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab1EHSz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:55:28 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:37610 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab1EHSzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:55:18 -0400
Date: Sun, 8 May 2011 20:44:32 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 12/14] HPFS: Fix some unaligned accesses
Message-ID: <alpine.DEB.2.00.1105082030370.7013@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some unaligned accesses

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

---
 fs/hpfs/ea.c      |   41 +++++++++++++++++++++--------------------
 fs/hpfs/hpfs.h    |    3 ++-
 fs/hpfs/hpfs_fn.h |   12 +++++++++---
 3 files changed, 32 insertions(+), 24 deletions(-)

Index: linux-2.6.39-rc5-fast/fs/hpfs/ea.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/ea.c	2011-05-05 01:02:58.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/ea.c	2011-05-05 01:03:00.000000000 +0200
@@ -24,7 +24,7 @@ void hpfs_ea_ext_remove(struct super_blo
 		}
 		if (hpfs_ea_read(s, a, ano, pos, 4, ex)) return;
 		if (ea->indirect) {
-			if (le16_to_cpu(ea->valuelen) != 8) {
+			if (ea_valuelen(ea) != 8) {
 				hpfs_error(s, "ea->indirect set while ea->valuelen!=8, %s %08x, pos %08x",
 					ano ? "anode" : "sectors", a, pos);
 				return;
@@ -33,7 +33,7 @@ void hpfs_ea_ext_remove(struct super_blo
 				return;
 			hpfs_ea_remove(s, ea_sec(ea), ea->anode, ea_len(ea));
 		}
-		pos += ea->namelen + le16_to_cpu(ea->valuelen) + 5;
+		pos += ea->namelen + ea_valuelen(ea) + 5;
 	}
 	if (!ano) hpfs_free_sectors(s, a, (len+511) >> 9);
 	else {
@@ -82,10 +82,10 @@ int hpfs_read_ea(struct super_block *s, 
 		if (!strcmp(ea->name, key)) {
 			if (ea->indirect)
 				goto indirect;
-			if (le16_to_cpu(ea->valuelen) >= size)
+			if (ea_valuelen(ea) >= size)
 				return -EINVAL;
-			memcpy(buf, ea_data(ea), le16_to_cpu(ea->valuelen));
-			buf[le16_to_cpu(ea->valuelen)] = 0;
+			memcpy(buf, ea_data(ea), ea_valuelen(ea));
+			buf[ea_valuelen(ea)] = 0;
 			return 0;
 		}
 	a = le32_to_cpu(fnode->ea_secno);
@@ -106,14 +106,14 @@ int hpfs_read_ea(struct super_block *s, 
 		if (!strcmp(ea->name, key)) {
 			if (ea->indirect)
 				goto indirect;
-			if (le16_to_cpu(ea->valuelen) >= size)
+			if (ea_valuelen(ea) >= size)
 				return -EINVAL;
-			if (hpfs_ea_read(s, a, ano, pos + 4 + ea->namelen + 1, le16_to_cpu(ea->valuelen), buf))
+			if (hpfs_ea_read(s, a, ano, pos + 4 + ea->namelen + 1, ea_valuelen(ea), buf))
 				return -EIO;
-			buf[le16_to_cpu(ea->valuelen)] = 0;
+			buf[ea_valuelen(ea)] = 0;
 			return 0;
 		}
-		pos += ea->namelen + le16_to_cpu(ea->valuelen) + 5;
+		pos += ea->namelen + ea_valuelen(ea) + 5;
 	}
 	return -ENOENT;
 indirect:
@@ -138,12 +138,12 @@ char *hpfs_get_ea(struct super_block *s,
 		if (!strcmp(ea->name, key)) {
 			if (ea->indirect)
 				return get_indirect_ea(s, ea->anode, ea_sec(ea), *size = ea_len(ea));
-			if (!(ret = kmalloc((*size = le16_to_cpu(ea->valuelen)) + 1, GFP_NOFS))) {
+			if (!(ret = kmalloc((*size = ea_valuelen(ea)) + 1, GFP_NOFS))) {
 				printk("HPFS: out of memory for EA\n");
 				return NULL;
 			}
-			memcpy(ret, ea_data(ea), le16_to_cpu(ea->valuelen));
-			ret[le16_to_cpu(ea->valuelen)] = 0;
+			memcpy(ret, ea_data(ea), ea_valuelen(ea));
+			ret[ea_valuelen(ea)] = 0;
 			return ret;
 		}
 	a = le32_to_cpu(fnode->ea_secno);
@@ -164,18 +164,18 @@ char *hpfs_get_ea(struct super_block *s,
 		if (!strcmp(ea->name, key)) {
 			if (ea->indirect)
 				return get_indirect_ea(s, ea->anode, ea_sec(ea), *size = ea_len(ea));
-			if (!(ret = kmalloc((*size = le16_to_cpu(ea->valuelen)) + 1, GFP_NOFS))) {
+			if (!(ret = kmalloc((*size = ea_valuelen(ea)) + 1, GFP_NOFS))) {
 				printk("HPFS: out of memory for EA\n");
 				return NULL;
 			}
-			if (hpfs_ea_read(s, a, ano, pos + 4 + ea->namelen + 1, le16_to_cpu(ea->valuelen), ret)) {
+			if (hpfs_ea_read(s, a, ano, pos + 4 + ea->namelen + 1, ea_valuelen(ea), ret)) {
 				kfree(ret);
 				return NULL;
 			}
-			ret[le16_to_cpu(ea->valuelen)] = 0;
+			ret[ea_valuelen(ea)] = 0;
 			return ret;
 		}
-		pos += ea->namelen + le16_to_cpu(ea->valuelen) + 5;
+		pos += ea->namelen + ea_valuelen(ea) + 5;
 	}
 	return NULL;
 }
@@ -202,7 +202,7 @@ void hpfs_set_ea(struct inode *inode, st
 			if (ea->indirect) {
 				if (ea_len(ea) == size)
 					set_indirect_ea(s, ea->anode, ea_sec(ea), data, size);
-			} else if (le16_to_cpu(ea->valuelen) == size) {
+			} else if (ea_valuelen(ea) == size) {
 				memcpy(ea_data(ea), data, size);
 			}
 			return;
@@ -228,12 +228,12 @@ void hpfs_set_ea(struct inode *inode, st
 					set_indirect_ea(s, ea->anode, ea_sec(ea), data, size);
 			}
 			else {
-				if (le16_to_cpu(ea->valuelen) == size)
+				if (ea_valuelen(ea) == size)
 					hpfs_ea_write(s, a, ano, pos + 4 + ea->namelen + 1, size, data);
 			}
 			return;
 		}
-		pos += ea->namelen + le16_to_cpu(ea->valuelen) + 5;
+		pos += ea->namelen + ea_valuelen(ea) + 5;
 	}
 	if (!le16_to_cpu(fnode->ea_offs)) {
 		/*if (le16_to_cpu(fnode->ea_size_s)) {
@@ -254,7 +254,8 @@ void hpfs_set_ea(struct inode *inode, st
 		ea = fnode_end_ea(fnode);
 		*(char *)ea = 0;
 		ea->namelen = strlen(key);
-		ea->valuelen = cpu_to_le16(size);
+		ea->valuelen_lo = size;
+		ea->valuelen_hi = size >> 8;
 		strcpy(ea->name, key);
 		memcpy(ea_data(ea), data, size);
 		fnode->ea_size_s = cpu_to_le16(le16_to_cpu(fnode->ea_size_s) + strlen(key) + size + 5);
Index: linux-2.6.39-rc5-fast/fs/hpfs/hpfs.h
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/hpfs.h	2011-05-05 01:02:57.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/hpfs.h	2011-05-05 01:03:00.000000000 +0200
@@ -546,7 +546,8 @@ struct extended_attribute
 					   where real value starts */
 #endif
   u8 namelen;				/* length of name, bytes */
-  u16 valuelen;				/* length of value, bytes */
+  u8 valuelen_lo;			/* length of value, bytes */
+  u8 valuelen_hi;			/* length of value, bytes */
   u8 name[0];
   /*
     u8 name[namelen];			ascii attrib name
Index: linux-2.6.39-rc5-fast/fs/hpfs/hpfs_fn.h
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/hpfs_fn.h	2011-05-05 01:02:58.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/hpfs_fn.h	2011-05-05 01:03:00.000000000 +0200
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
 #include <linux/slab.h>
+#include <asm/unaligned.h>
 
 #include "hpfs.h"
 
@@ -135,19 +136,24 @@ static inline struct extended_attribute 
 	return (struct extended_attribute *)((char *)fnode + le16_to_cpu(fnode->ea_offs) + le16_to_cpu(fnode->acl_size_s) + le16_to_cpu(fnode->ea_size_s));
 }
 
+static unsigned ea_valuelen(struct extended_attribute *ea)
+{
+	return ea->valuelen_lo + 256 * ea->valuelen_hi;
+}
+
 static inline struct extended_attribute *next_ea(struct extended_attribute *ea)
 {
-	return (struct extended_attribute *)((char *)ea + 5 + ea->namelen + le16_to_cpu(ea->valuelen));
+	return (struct extended_attribute *)((char *)ea + 5 + ea->namelen + ea_valuelen(ea));
 }
 
 static inline secno ea_sec(struct extended_attribute *ea)
 {
-	return le32_to_cpu(*((secno *)((char *)ea + 9 + ea->namelen)));
+	return le32_to_cpu(get_unaligned((secno *)((char *)ea + 9 + ea->namelen)));
 }
 
 static inline secno ea_len(struct extended_attribute *ea)
 {
-	return le32_to_cpu(*((secno *)((char *)ea + 5 + ea->namelen)));
+	return le32_to_cpu(get_unaligned((secno *)((char *)ea + 5 + ea->namelen)));
 }
 
 static inline char *ea_data(struct extended_attribute *ea)
