Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab2EYHtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 03:49:21 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:43596
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751260Ab2EYHtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 03:49:19 -0400
Date: Fri, 25 May 2012 09:49:15 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBIFS: introduce struct ubifs_keymap
In-Reply-To: <1337769818.2483.202.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1205250947210.1340@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205211640320.3833@eristoteles.iwoars.net> <1337769818.2483.202.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces struct ubifs_keymap, the entity responsible for key
generation, distribution, and lifetime management for ubifs's secure deletion.
In addition to the struct's (partial) definition, it is added as a field to
ubifs_info. The alloc routines are provided. More fields and functions
will come in following patches.

This is tested using local unit tests for the functions: alloc,
and checking couple/decouple is sound. UBIFS integck is also run to ensure
UBIFS is not effected.


Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 fs/ubifs/Makefile |    2 +-
 fs/ubifs/keymap.c |  104 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ubifs/ubifs.h  |    6 +++
 3 files changed, 111 insertions(+), 1 deletions(-)
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
index 0000000..6f812c5
--- /dev/null
+++ b/fs/ubifs/keymap.c
@@ -0,0 +1,104 @@
+/*
+ * This file is part of UBIFS.
+ *
+ * Copyright (C) 2012 Joel Reardon
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
+ * Authors: Joel Reardon
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
+ * ksa_pos_decouple - convert a ksa_pos to ksa_leb and offset
+ * @ksa_pos: the key's position in the KSA
+ * @ksa_leb: gets the KSA LEB number for the key position
+ * @ksa_offs: gets the KSA LEB offset for the key position
+ *
+ * This function converts a 64-bit KSA position into the KSA LEB number and
+ * offset so it can be looked up.
+ */
+static void ksa_pos_decouple(const long long ksa_pos,
+			     int *ksa_leb, int *ksa_offs)
+{
+	*ksa_offs = 0xffffffff & ksa_pos;
+	*ksa_leb = 0xffffffff & (ksa_pos >> 32);
+}
+
+/**
+ * ksa_pos_couple - convert a ksa_leb and offset to ksa_pos
+ * @ksa_leb: gets the KSA LEB number for the key position
+ * @ksa_offs: gets the KSA LEB offset for the key position
+ *
+ * This function converts the LEB number and offset for a key into the 64-bit
+ * key position value.
+ */
+static long long ksa_pos_couple(int ksa_leb, int ksa_offs)
+{
+	return ((long long)ksa_leb << 32) + ksa_offs;
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
+	c->km = km = kzalloc(sizeof(struct ubifs_keymap), GFP_NOFS);
+	if (!km)
+		return -ENOMEM;
+
+	km->key_size = UBIFS_CRYPTO_KEYSIZE;
+	km->keys_per_leb = c->leb_size / km->key_size;
+
+	return 0;
+}
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 74f458c..6912f34 100644
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
@@ -1780,6 +1783,9 @@ void ubifs_compress(const void *in_buf, int in_len, void *out_buf, int *out_len,
 int ubifs_decompress(void *buf, int len, void *out, int *out_len,
 		     int compr_type, void *crypto_key);

+/* keymap.c */
+int keymap_init(struct ubifs_info *c);
+
 #include "debug.h"
 #include "misc.h"
 #include "key.h"
-- 
1.7.5.4


