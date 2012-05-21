Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab2EUOlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:41:17 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:44644
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752800Ab2EUOlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:41:16 -0400
Date: Mon, 21 May 2012 16:41:12 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] UBIFS: introduce struct ubifs_keymap
Message-ID: <alpine.DEB.2.00.1205211640320.3833@eristoteles.iwoars.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="776899908-607960530-1337611272=:3833"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--776899908-607960530-1337611272=:3833
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

This patch introduces struct ubifs_keymap, the entity responsible for key
generation, distribution, and lifetime management for ubifs's secure deletion.
In addition to the struct's (partial) definition, it is added as a field to
ubifs_info. The alloc/free routines are provided. More fields and functions
will come in following patches. As such, this introduces warnings about
defined but unused functions. (Since this goes in the joel branch, I suppose
thats okay for the time being and didn't add fake invocations.)

This is tested using local unit tests for the functions: alloc and deallocing,
checking the conversion of eb/off to pos and back is sound, and key generation
sets distinct keys for the keylength. UBIFS integck is also run to ensure
UBIFS is not effected.


Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 fs/ubifs/Makefile |    2 +-
 fs/ubifs/keymap.c |  140 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ubifs/ubifs.h  |   11 ++++
 3 files changed, 152 insertions(+), 1 deletions(-)
 create mode 100644 fs/ubifs/keymap.c

diff --git a/fs/ubifs/Makefile b/fs/ubifs/Makefile
index 2c6f0cb..881ce27 100644
--- a/fs/ubifs/Makefile
+++ b/fs/ubifs/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_UBIFS_FS) += ubifs.o

-ubifs-y += shrinker.o journal.o file.o dir.o super.o sb.o io.o
+ubifs-y += shrinker.o journal.o file.o dir.o super.o sb.o io.o keymap.o
 ubifs-y += tnc.o master.o scan.o replay.o log.o commit.o gc.o orphan.o
 ubifs-y += budget.o find.o tnc_commit.o compress.o lpt.o lprops.o
 ubifs-y += recovery.o ioctl.o lpt_commit.o tnc_misc.o xattr.o debug.o
diff --git a/fs/ubifs/keymap.c b/fs/ubifs/keymap.c
new file mode 100644
index 0000000..9ab9342
--- /dev/null
+++ b/fs/ubifs/keymap.c
@@ -0,0 +1,140 @@
+/*
+ * This file is part of UBIFS.
+ *
+ * Copyright (C) 2006-2008 Nokia Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ * Authors: Adrian Hunter
+ *	    Artem Bityutskiy (‚…‘¿√À…  ·“‘£Õ)
+ */
+
+/*
+ * The file implements the key storage, assignment, and deletion for UBIFS's
+ * secure deletion enhancement. For more information, read
+ * Documentation/filesystems/ubifsec.txt
+ */
+
+#include <linux/random.h>
+#include "ubifs.h"
+
+#define RETURN_VAL_IF(v, e) do { if ((e)) return (v); } while (0)
+#define RETURN_ON_ERR(e) do { if ((e)) return (e); } while (0)
+
+/**
+ * struct ubifs_keymap - UBIFS key map.
+ * @key_size: size of a key in bytes
+ * @keys_per_leb: number of keys per KSA LEB
+ * @ksa_size: number of LEBS in the KSA
+ * @ksa_first: the first LEB belonging to the KSA
+ * @unused: the number of unused keys in the system
+ * @deleted: the number of deleted keys in the system.
+ *
+ * This manages the use of keys in UBIFS. There is only
+ * instance of the keymap for the UBIFS main context. Its main purpose is to
+ * be aware of which LEBs belong to the KSA, how the KSA is divided into
+ * ranges, the state for each key, and mutexes to ensure thread safety.
+ */
+struct ubifs_keymap {
+	unsigned int key_size;
+	unsigned int keys_per_leb;
+	unsigned int ksa_size;
+	unsigned int ksa_first;
+	long long unused;
+	long long deleted;
+};
+
+/**
+ * pos_to_eb_offset - convert a ksa_pos to ksa_leb and offset
+ * @ksa_pos: the key's position in the KSA
+ * @ksa_leb: gets the KSA LEB number for the key position
+ * @ksa_offset: gets the KSA LEB offset for the key position
+ *
+ * This function converts a 64-bit KSA position into the KSA LEB number and
+ * offset so it can be looked up.
+ */
+static void pos_to_eb_offset(const long long ksa_pos,
+			     int *ksa_leb, int *ksa_offset)
+{
+	*ksa_offset = 0xffffffff & ksa_pos;
+	*ksa_leb = 0xffffffff & (ksa_pos >> 32);
+}
+
+/**
+ * eb_offset_to_pos - convert a ksa_leb and offset to ksa_pos
+ * @ksa_leb: gets the KSA LEB number for the key position
+ * @ksa_offset: gets the KSA LEB offset for the key position
+ *
+ * This function converts the LEB number and offset for a key into the 64-bit
+ * key position value.
+ */
+static long long eb_offset_to_pos(int ksa_leb, int ksa_offset)
+{
+	return (((long long) ksa_leb) << 32) + ksa_offset;
+}
+
+/**
+ * generate_key - generate a new encryption key
+ * @km: keymap structure to know the key size
+ * @to: key-size-sized buffer to hold the new key.
+ *
+ * This function generates a new random key and places it in the to field. The
+ * keymap stores the size of the key used as a field. We assume that
+ * get_random_bytes() will always yield cryptographically-suitable random
+ * data. If this ever changes, this will need to be updated.
+ */
+static void generate_key(struct ubifs_keymap *km, u8 *to)
+{
+	get_random_bytes(to, km->key_size);
+}
+
+/**
+ * keymap_init - construct and initialize a struct keymap
+ * @c: the ubifs info context to put the keymap into
+ *
+ * This function allocates a keymap data structure and initializes its fields.
+ * The ubifs_info context @c is passed as a parameter and its @km field is set
+ * to the keymap that is preprared by this function. If memory cannot be
+ * allocated, it returns -ENOMEM. Otherwise it returns 0.
+ */
+int keymap_init(struct ubifs_info *c)
+{
+	struct ubifs_keymap *km;
+
+	c->km = NULL;
+	km = kmalloc(sizeof(struct ubifs_keymap), GFP_NOFS);
+	RETURN_VAL_IF(-ENOMEM, !km);
+
+	km->key_size = UBIFS_CRYPTO_KEYSIZE;
+	km->keys_per_leb = c->leb_size / km->key_size;
+	km->ksa_size = 0;
+	km->ksa_first = 0;
+	km->unused = 0;
+	km->deleted = 0;
+
+	c->km = km;
+	return 0;
+}
+
+/**
+ * keymap_free - destruct and free memory used by a struct keymap
+ * @c: the ubifs info context that contanis the keymap
+ *
+ * This function frees the memory being used by the keymap.
+ */
+void keymap_free(struct ubifs_info *c)
+{
+	kfree(c->km);
+	c->km = NULL;
+}
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 74f458c..cef5ab2 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -978,6 +978,7 @@ struct ubifs_budg_info {
 };

 struct ubifs_debug_info;
+struct ubifs_keymap;

 /**
  * struct ubifs_info - UBIFS file-system description data structure
@@ -1224,6 +1225,7 @@ struct ubifs_debug_info;
  * @mount_opts: UBIFS-specific mount options
  *
  * @dbg: debugging-related information
+ * @keymap: cryptographic key store for secure deletion
  */
 struct ubifs_info {
 	struct super_block *vfs_sb;
@@ -1452,6 +1454,7 @@ struct ubifs_info {
 	struct ubifs_mount_opts mount_opts;

 	struct ubifs_debug_info *dbg;
+	struct ubifs_keymap *km;
 };

 extern struct list_head ubifs_infos;
@@ -1780,6 +1783,14 @@ void ubifs_compress(const void *in_buf, int in_len, void *out_buf, int *out_len,
 int ubifs_decompress(void *buf, int len, void *out, int *out_len,
 		     int compr_type, void *crypto_key);

+/* keymap.c */
+int keymap_init(struct ubifs_info *c);
+void keymap_free(struct ubifs_info *c);
+
+/* keymap.c */
+int keymap_init(struct ubifs_info *c);
+void keymap_free(struct ubifs_info *c);
+
 #include "debug.h"
 #include "misc.h"
 #include "key.h"
-- 
1.7.5.4


--776899908-607960530-1337611272=:3833--
