Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab2FHWQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 18:16:51 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:39871
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1759269Ab2FHWQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 18:16:49 -0400
Date: Sat, 9 Jun 2012 00:16:43 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: From:;
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [patch] UBIFS: add key state map data structure and accessors
Message-ID: <alpine.DEB.2.00.1206090016010.14953@eristoteles.iwoars.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the key state map to keymap, a structure that holds the state
of all keys in the KSA. The states are defined in an enum, and a get/set
accessor is added. These accessors are static only: the external interface
will simply be "mark used" or "mark deleted" and range checking, along with
locking the mutex for the state object, will be done there.

The memory is allocated in keymap_init() and keymap_free()
is added to deallocate the memory. Init is called when mounting is performed,
and free is called mounting failed or when unmounting. This was tested using
integck along with unit tests for get/set sanity.

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 fs/ubifs/keymap.c |  118 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ubifs/super.c  |    6 +++
 fs/ubifs/ubifs.h  |    1 +
 3 files changed, 122 insertions(+), 3 deletions(-)

diff --git a/fs/ubifs/keymap.c b/fs/ubifs/keymap.c
index 6f812c5..9fa04c3 100644
--- a/fs/ubifs/keymap.c
+++ b/fs/ubifs/keymap.c
@@ -28,14 +28,36 @@
 #include <linux/random.h>
 #include "ubifs.h"

+#define KEYMAP_STATES_PER_BYTE 4
+#define KEYMAP_STATES_PER_BYTE_SHIFT 2
+
+/**
+ * Defines the three possible states of a key:
+ * @KEYMAP_STATE_UNUSED: the key has never been assigned or used
+ * @KEYMAP_STATE_USED: the key has been assigned and is used for live data
+ * @KEYMAP_STATE_DELETED: the key has been assigned and is used for
+ *			  deleted data.
+ */
+enum {
+	KEYMAP_STATE_UNUSED  = 0,
+	KEYMAP_STATE_USED    = 1,
+	KEYMAP_STATE_DELETED = 2,
+};
+
 /**
  * struct ubifs_keymap - UBIFS key map.
  * @key_size: size of a key in bytes
  * @keys_per_leb: number of keys per KSA LEB
- * @ksa_size: number of LEBS in the KSA
+ * @ksa_lebs: number of LEBS in the KSA
  * @ksa_first: the first LEB belonging to the KSA
+ * @state: a double-array [ksa_lebs]x[keys_per_leb] that stores the
+ *	   state of the key at that position. The state consumes two bits so
+ *	   each byte contains four states. The first index is from 0 to the
+ *	   number of KSA LEBs - 1, and the second is from 0 to the number of
+ *	   keys per (KSA LEB - 1) >> 2
  * @unused: the number of unused keys in the system
  * @deleted: the number of deleted keys in the system.
+ * @state_mutex: this mutex must be locked when updating a key's state
  *
  * This manages the use of keys in UBIFS. There is only
  * instance of the keymap for the UBIFS main context. Its main purpose is to
@@ -45,13 +67,56 @@
 struct ubifs_keymap {
 	unsigned int key_size;
 	unsigned int keys_per_leb;
-	unsigned int ksa_size;
+	unsigned int ksa_lebs;
 	unsigned int ksa_first;
+	u8 **state;
 	long long unused;
 	long long deleted;
+	struct mutex state_mutex;
 };

 /**
+ * set_state - set the key state
+ * @km: the keymap
+ * @ksa_leb: the KSA eraseblock number
+ * @ksa_offset: the key's offset in the KSA eraseblock
+ * @value: the new state
+ *
+ * This function sets a key position's state. It assumes @km's @state_mutex is
+ * currently held.
+ */
+static void set_state(struct ubifs_keymap *km, int ksa_leb,
+		      int ksa_offset, int value)
+{
+	static const int minor_mask = (1 << KEYMAP_STATES_PER_BYTE_SHIFT) - 1;
+	int major, shift, mask, old;
+
+	major = ksa_offset >> KEYMAP_STATES_PER_BYTE_SHIFT;
+	shift = (ksa_offset & minor_mask) << 1;
+	mask  = minor_mask << shift;
+	old = km->state[ksa_leb][major];
+	km->state[ksa_leb][major] = old - (old & mask) + (value << shift);
+}
+
+/**
+ * get_state - get the key state
+ * @km: the keymap
+ * @ksa_leb: the KSA eraseblock number
+ * @ksa_offset: the key's offset in the KSA eraseblock
+ *
+ * This function returns key position's state.
+ */
+static int get_state(struct ubifs_keymap *km, int ksa_leb, int ksa_offset)
+{
+	static const int minor_mask = (1 << KEYMAP_STATES_PER_BYTE_SHIFT) - 1;
+	int major, shift;
+
+	major = ksa_offset >> KEYMAP_STATES_PER_BYTE_SHIFT;
+	shift = (ksa_offset & minor_mask) << 1;
+	return (km->state[ksa_leb][major] >> shift) & minor_mask;
+}
+
+/**
  * ksa_pos_decouple - convert a ksa_pos to ksa_leb and offset
  * @ksa_pos: the key's position in the KSA
  * @ksa_leb: gets the KSA LEB number for the key position
@@ -85,20 +150,67 @@ static long long ksa_pos_couple(int ksa_leb, int ksa_offs)
  * @c: the ubifs info context to put the keymap into
  *
  * This function allocates a keymap data structure and initializes its fields.
- * The ubifs_info context @c is passed as a parameter and its @km field is set
+ * It assumes that @c has already correctly loaded the superblock. The
+ * ubifs_info context @c is passed as a parameter and its @km field is set
  * to the keymap that is preprared by this function. If memory cannot be
  * allocated, it returns -ENOMEM. Otherwise it returns 0.
  */
 int keymap_init(struct ubifs_info *c)
 {
 	struct ubifs_keymap *km;
+	int i, len;

+	if (!c->use_ubifsec)
+		return 0;
 	c->km = km = kzalloc(sizeof(struct ubifs_keymap), GFP_NOFS);
 	if (!km)
 		return -ENOMEM;

 	km->key_size = UBIFS_CRYPTO_KEYSIZE;
 	km->keys_per_leb = c->leb_size / km->key_size;
+	ubifs_assert(km->keys_per_leb % KEYMAP_STATES_PER_BYTE == 0);
+
+	km->ksa_lebs = c->ksa_lebs;
+	km->ksa_first = c->ksa_first;
+	km->state = NULL;
+	km->unused = 0;
+	km->deleted = 0;
+	km->state = kmalloc(sizeof(u8 *) * km->ksa_lebs, GFP_NOFS);
+	if (!km->state)
+		return -ENOMEM;
+	len = (sizeof(u8) * km->keys_per_leb) >> KEYMAP_STATES_PER_BYTE_SHIFT;
+	for (i = 0; i < km->ksa_lebs; ++i) {
+		km->state[i] = kzalloc(len, GFP_NOFS);
+		if (!(km->state[i]))
+			return -ENOMEM;
+		km->unused += km->keys_per_leb;
+	}
+	mutex_init(&km->state_mutex);

 	return 0;
 }
+
+/**
+ * keymap_free - destruct and free memory used by a struct keymap
+ * @c: the ubifs info context that contanis the keymap
+ *
+ * This function frees the memory being used by the keymap.
+ */
+void keymap_free(struct ubifs_info *c)
+{
+	struct ubifs_keymap *km = c->km;
+
+	if (!c->use_ubifsec)
+		return;
+	ubifs_assert(km);
+
+	mutex_destroy(&km->state_mutex);
+	if (km->state) {
+		int i;
+		for (i = 0; i < km->ksa_lebs; ++i)
+			kfree(km->state[i]);
+		kfree(km->state);
+	}
+	kfree(km);
+	c->km = NULL;
+}
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 879ecf5..ed76644 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1244,6 +1244,10 @@ static int mount_ubifs(struct ubifs_info *c)
 	if (err)
 		goto out_free;

+	err = keymap_init(c);
+	if (err)
+		goto out_free;
+
 	/*
 	 * Make sure the compressor which is set as default in the superblock
 	 * or overridden by mount options is actually compiled in.
@@ -1525,6 +1529,7 @@ out_free:
 	kfree(c->bu.buf);
 	vfree(c->ileb_buf);
 	vfree(c->sbuf);
+	keymap_free(c);
 	kfree(c->bottom_up_buf);
 	ubifs_debugging_exit(c);
 	return err;
@@ -1564,6 +1569,7 @@ static void ubifs_umount(struct ubifs_info *c)
 	kfree(c->bu.buf);
 	vfree(c->ileb_buf);
 	vfree(c->sbuf);
+	keymap_free(c);
 	kfree(c->bottom_up_buf);
 	ubifs_debugging_exit(c);
 }
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 2b43107..7efab26 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1812,6 +1812,7 @@ int ubifs_decompress(void *buf, int len, void *out, int *out_len,

 /* keymap.c */
 int keymap_init(struct ubifs_info *c);
+void keymap_free(struct ubifs_info *c);

 #include "debug.h"
 #include "misc.h"
-- 
1.7.5.4

