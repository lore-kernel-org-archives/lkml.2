Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab0KCQyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 12:54:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45636 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab0KCQys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 12:54:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kka2ibJYI460XalLTeV1e6l3EX5pNPjxucxX9g7S2ZfhSwsbUaFz/QNKlhnxGykzlP
         7jczmXQaWPPZyXLBm+OmO++p7LUK3BF4tcJQob0ji/QDdu3zD22gQRTv4/dcct5rSNk7
         7hpecN6+p3qbrjXJtW+8PgK59FDngKWeWYhTY=
From: cdhmanning@gmail.com
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 7/9] Add yaffs tag access code
Date: Thu,  4 Nov 2010 05:53:22 +1300
Message-Id: <1288803204-3849-8-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com>
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Manning <cdhmanning@gmail.com>

Adding yaffs2 file system.

Signed-off-by: Charles Manning <cdhmanning@gmail.com>
---
 fs/yaffs2/yaffs_packedtags1.c  |   53 +++++
 fs/yaffs2/yaffs_packedtags1.h  |   39 ++++
 fs/yaffs2/yaffs_packedtags2.c  |  197 +++++++++++++++++
 fs/yaffs2/yaffs_packedtags2.h  |   47 ++++
 fs/yaffs2/yaffs_tagscompat.c   |  454 ++++++++++++++++++++++++++++++++++++++++
 fs/yaffs2/yaffs_tagscompat.h   |   36 ++++
 fs/yaffs2/yaffs_tagsvalidity.c |   27 +++
 fs/yaffs2/yaffs_tagsvalidity.h |   23 ++
 8 files changed, 876 insertions(+), 0 deletions(-)
 create mode 100644 fs/yaffs2/yaffs_packedtags1.c
 create mode 100644 fs/yaffs2/yaffs_packedtags1.h
 create mode 100644 fs/yaffs2/yaffs_packedtags2.c
 create mode 100644 fs/yaffs2/yaffs_packedtags2.h
 create mode 100644 fs/yaffs2/yaffs_tagscompat.c
 create mode 100644 fs/yaffs2/yaffs_tagscompat.h
 create mode 100644 fs/yaffs2/yaffs_tagsvalidity.c
 create mode 100644 fs/yaffs2/yaffs_tagsvalidity.h

diff --git a/fs/yaffs2/yaffs_packedtags1.c b/fs/yaffs2/yaffs_packedtags1.c
new file mode 100644
index 0000000..a77f095
--- /dev/null
+++ b/fs/yaffs2/yaffs_packedtags1.c
@@ -0,0 +1,53 @@
+/*
+ * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "yaffs_packedtags1.h"
+#include "yportenv.h"
+
+void yaffs_pack_tags1(struct yaffs_packed_tags1 *pt,
+		      const struct yaffs_ext_tags *t)
+{
+	pt->chunk_id = t->chunk_id;
+	pt->serial_number = t->serial_number;
+	pt->n_bytes = t->n_bytes;
+	pt->obj_id = t->obj_id;
+	pt->ecc = 0;
+	pt->deleted = (t->is_deleted) ? 0 : 1;
+	pt->unused_stuff = 0;
+	pt->should_be_ff = 0xFFFFFFFF;
+
+}
+
+void yaffs_unpack_tags1(struct yaffs_ext_tags *t,
+			const struct yaffs_packed_tags1 *pt)
+{
+	static const u8 all_ff[] =
+	    { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+		0xff
+	};
+
+	if (memcmp(all_ff, pt, sizeof(struct yaffs_packed_tags1))) {
+		t->block_bad = 0;
+		if (pt->should_be_ff != 0xFFFFFFFF)
+			t->block_bad = 1;
+		t->chunk_used = 1;
+		t->obj_id = pt->obj_id;
+		t->chunk_id = pt->chunk_id;
+		t->n_bytes = pt->n_bytes;
+		t->ecc_result = YAFFS_ECC_RESULT_NO_ERROR;
+		t->is_deleted = (pt->deleted) ? 0 : 1;
+		t->serial_number = pt->serial_number;
+	} else {
+		memset(t, 0, sizeof(struct yaffs_ext_tags));
+	}
+}
diff --git a/fs/yaffs2/yaffs_packedtags1.h b/fs/yaffs2/yaffs_packedtags1.h
new file mode 100644
index 0000000..d6861ff
--- /dev/null
+++ b/fs/yaffs2/yaffs_packedtags1.h
@@ -0,0 +1,39 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License version 2.1 as
+ * published by the Free Software Foundation.
+ *
+ * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
+ */
+
+/* This is used to pack YAFFS1 tags, not YAFFS2 tags. */
+
+#ifndef __YAFFS_PACKEDTAGS1_H__
+#define __YAFFS_PACKEDTAGS1_H__
+
+#include "yaffs_guts.h"
+
+struct yaffs_packed_tags1 {
+	unsigned chunk_id:20;
+	unsigned serial_number:2;
+	unsigned n_bytes:10;
+	unsigned obj_id:18;
+	unsigned ecc:12;
+	unsigned deleted:1;
+	unsigned unused_stuff:1;
+	unsigned should_be_ff;
+
+};
+
+void yaffs_pack_tags1(struct yaffs_packed_tags1 *pt,
+		      const struct yaffs_ext_tags *t);
+void yaffs_unpack_tags1(struct yaffs_ext_tags *t,
+			const struct yaffs_packed_tags1 *pt);
+#endif
diff --git a/fs/yaffs2/yaffs_packedtags2.c b/fs/yaffs2/yaffs_packedtags2.c
new file mode 100644
index 0000000..6c12aed
--- /dev/null
+++ b/fs/yaffs2/yaffs_packedtags2.c
@@ -0,0 +1,197 @@
+/*
+ * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "yaffs_packedtags2.h"
+#include "yportenv.h"
+#include "yaffs_trace.h"
+#include "yaffs_tagsvalidity.h"
+
+/* This code packs a set of extended tags into a binary structure for
+ * NAND storage
+ */
+
+/* Some of the information is "extra" struff which can be packed in to
+ * speed scanning
+ * This is defined by having the EXTRA_HEADER_INFO_FLAG set.
+ */
+
+/* Extra flags applied to chunk_id */
+
+#define EXTRA_HEADER_INFO_FLAG	0x80000000
+#define EXTRA_SHRINK_FLAG	0x40000000
+#define EXTRA_SHADOWS_FLAG	0x20000000
+#define EXTRA_SPARE_FLAGS	0x10000000
+
+#define ALL_EXTRA_FLAGS		0xF0000000
+
+/* Also, the top 4 bits of the object Id are set to the object type. */
+#define EXTRA_OBJECT_TYPE_SHIFT (28)
+#define EXTRA_OBJECT_TYPE_MASK  ((0x0F) << EXTRA_OBJECT_TYPE_SHIFT)
+
+static void yaffs_dump_packed_tags2_tags_only(const struct
+					      yaffs_packed_tags2_tags_only *ptt)
+{
+	T(YAFFS_TRACE_MTD,
+	  (TSTR("packed tags obj %d chunk %d byte %d seq %d" TENDSTR),
+	   ptt->obj_id, ptt->chunk_id, ptt->n_bytes, ptt->seq_number));
+}
+
+static void yaffs_dump_packed_tags2(const struct yaffs_packed_tags2 *pt)
+{
+	yaffs_dump_packed_tags2_tags_only(&pt->t);
+}
+
+static void yaffs_dump_tags2(const struct yaffs_ext_tags *t)
+{
+	T(YAFFS_TRACE_MTD,
+	  (TSTR
+	   ("ext.tags eccres %d blkbad %d chused %d obj %d chunk%d byte %d del %d ser %d seq %d"
+	    TENDSTR), t->ecc_result, t->block_bad, t->chunk_used, t->obj_id,
+	   t->chunk_id, t->n_bytes, t->is_deleted, t->serial_number,
+	   t->seq_number));
+
+}
+
+void yaffs_pack_tags2_tags_only(struct yaffs_packed_tags2_tags_only *ptt,
+				const struct yaffs_ext_tags *t)
+{
+	ptt->chunk_id = t->chunk_id;
+	ptt->seq_number = t->seq_number;
+	ptt->n_bytes = t->n_bytes;
+	ptt->obj_id = t->obj_id;
+
+	if (t->chunk_id == 0 && t->extra_available) {
+		/* Store the extra header info instead */
+		/* We save the parent object in the chunk_id */
+		ptt->chunk_id = EXTRA_HEADER_INFO_FLAG | t->extra_parent_id;
+		if (t->extra_is_shrink)
+			ptt->chunk_id |= EXTRA_SHRINK_FLAG;
+		if (t->extra_shadows)
+			ptt->chunk_id |= EXTRA_SHADOWS_FLAG;
+
+		ptt->obj_id &= ~EXTRA_OBJECT_TYPE_MASK;
+		ptt->obj_id |= (t->extra_obj_type << EXTRA_OBJECT_TYPE_SHIFT);
+
+		if (t->extra_obj_type == YAFFS_OBJECT_TYPE_HARDLINK)
+			ptt->n_bytes = t->extra_equiv_id;
+		else if (t->extra_obj_type == YAFFS_OBJECT_TYPE_FILE)
+			ptt->n_bytes = t->extra_length;
+		else
+			ptt->n_bytes = 0;
+	}
+
+	yaffs_dump_packed_tags2_tags_only(ptt);
+	yaffs_dump_tags2(t);
+}
+
+void yaffs_pack_tags2(struct yaffs_packed_tags2 *pt,
+		      const struct yaffs_ext_tags *t, int tags_ecc)
+{
+	yaffs_pack_tags2_tags_only(&pt->t, t);
+
+	if (tags_ecc)
+		yaffs_ecc_calc_other((unsigned char *)&pt->t,
+				     sizeof(struct
+					    yaffs_packed_tags2_tags_only),
+				     &pt->ecc);
+}
+
+void yaffs_unpack_tags2_tags_only(struct yaffs_ext_tags *t,
+				  struct yaffs_packed_tags2_tags_only *ptt)
+{
+
+	memset(t, 0, sizeof(struct yaffs_ext_tags));
+
+	yaffs_init_tags(t);
+
+	if (ptt->seq_number != 0xFFFFFFFF) {
+		t->block_bad = 0;
+		t->chunk_used = 1;
+		t->obj_id = ptt->obj_id;
+		t->chunk_id = ptt->chunk_id;
+		t->n_bytes = ptt->n_bytes;
+		t->is_deleted = 0;
+		t->serial_number = 0;
+		t->seq_number = ptt->seq_number;
+
+		/* Do extra header info stuff */
+
+		if (ptt->chunk_id & EXTRA_HEADER_INFO_FLAG) {
+			t->chunk_id = 0;
+			t->n_bytes = 0;
+
+			t->extra_available = 1;
+			t->extra_parent_id =
+			    ptt->chunk_id & (~(ALL_EXTRA_FLAGS));
+			t->extra_is_shrink =
+			    (ptt->chunk_id & EXTRA_SHRINK_FLAG) ? 1 : 0;
+			t->extra_shadows =
+			    (ptt->chunk_id & EXTRA_SHADOWS_FLAG) ? 1 : 0;
+			t->extra_obj_type =
+			    ptt->obj_id >> EXTRA_OBJECT_TYPE_SHIFT;
+			t->obj_id &= ~EXTRA_OBJECT_TYPE_MASK;
+
+			if (t->extra_obj_type == YAFFS_OBJECT_TYPE_HARDLINK)
+				t->extra_equiv_id = ptt->n_bytes;
+			else
+				t->extra_length = ptt->n_bytes;
+		}
+	}
+
+	yaffs_dump_packed_tags2_tags_only(ptt);
+	yaffs_dump_tags2(t);
+
+}
+
+void yaffs_unpack_tags2(struct yaffs_ext_tags *t, struct yaffs_packed_tags2 *pt,
+			int tags_ecc)
+{
+
+	enum yaffs_ecc_result ecc_result = YAFFS_ECC_RESULT_NO_ERROR;
+
+	if (pt->t.seq_number != 0xFFFFFFFF && tags_ecc) {
+		/* Chunk is in use and we need to do ECC */
+
+		struct yaffs_ecc_other ecc;
+		int result;
+		yaffs_ecc_calc_other((unsigned char *)&pt->t,
+				     sizeof(struct
+					    yaffs_packed_tags2_tags_only),
+				     &ecc);
+		result =
+		    yaffs_ecc_correct_other((unsigned char *)&pt->t,
+					    sizeof(struct
+						   yaffs_packed_tags2_tags_only),
+					    &pt->ecc, &ecc);
+		switch (result) {
+		case 0:
+			ecc_result = YAFFS_ECC_RESULT_NO_ERROR;
+			break;
+		case 1:
+			ecc_result = YAFFS_ECC_RESULT_FIXED;
+			break;
+		case -1:
+			ecc_result = YAFFS_ECC_RESULT_UNFIXED;
+			break;
+		default:
+			ecc_result = YAFFS_ECC_RESULT_UNKNOWN;
+		}
+	}
+
+	yaffs_unpack_tags2_tags_only(t, &pt->t);
+
+	t->ecc_result = ecc_result;
+
+	yaffs_dump_packed_tags2(pt);
+	yaffs_dump_tags2(t);
+}
diff --git a/fs/yaffs2/yaffs_packedtags2.h b/fs/yaffs2/yaffs_packedtags2.h
new file mode 100644
index 0000000..f329669
--- /dev/null
+++ b/fs/yaffs2/yaffs_packedtags2.h
@@ -0,0 +1,47 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License version 2.1 as
+ * published by the Free Software Foundation.
+ *
+ * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
+ */
+
+/* This is used to pack YAFFS2 tags, not YAFFS1tags. */
+
+#ifndef __YAFFS_PACKEDTAGS2_H__
+#define __YAFFS_PACKEDTAGS2_H__
+
+#include "yaffs_guts.h"
+#include "yaffs_ecc.h"
+
+struct yaffs_packed_tags2_tags_only {
+	unsigned seq_number;
+	unsigned obj_id;
+	unsigned chunk_id;
+	unsigned n_bytes;
+};
+
+struct yaffs_packed_tags2 {
+	struct yaffs_packed_tags2_tags_only t;
+	struct yaffs_ecc_other ecc;
+};
+
+/* Full packed tags with ECC, used for oob tags */
+void yaffs_pack_tags2(struct yaffs_packed_tags2 *pt,
+		      const struct yaffs_ext_tags *t, int tags_ecc);
+void yaffs_unpack_tags2(struct yaffs_ext_tags *t, struct yaffs_packed_tags2 *pt,
+			int tags_ecc);
+
+/* Only the tags part (no ECC for use with inband tags */
+void yaffs_pack_tags2_tags_only(struct yaffs_packed_tags2_tags_only *pt,
+				const struct yaffs_ext_tags *t);
+void yaffs_unpack_tags2_tags_only(struct yaffs_ext_tags *t,
+				  struct yaffs_packed_tags2_tags_only *pt);
+#endif
diff --git a/fs/yaffs2/yaffs_tagscompat.c b/fs/yaffs2/yaffs_tagscompat.c
new file mode 100644
index 0000000..3a9a157
--- /dev/null
+++ b/fs/yaffs2/yaffs_tagscompat.c
@@ -0,0 +1,454 @@
+/*
+ * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "yaffs_guts.h"
+#include "yaffs_tagscompat.h"
+#include "yaffs_ecc.h"
+#include "yaffs_getblockinfo.h"
+#include "yaffs_trace.h"
+
+static void yaffs_handle_rd_data_error(struct yaffs_dev *dev, int nand_chunk);
+
+static const char yaffs_count_bits_table[256] = {
+	0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4,
+	1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
+	1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
+	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
+	1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
+	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
+	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
+	3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
+	1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
+	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
+	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
+	3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
+	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
+	3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
+	3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
+	4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8
+};
+
+int yaffs_count_bits(u8 x)
+{
+	int ret_val;
+	ret_val = yaffs_count_bits_table[x];
+	return ret_val;
+}
+
+/********** Tags ECC calculations  *********/
+
+void yaffs_calc_ecc(const u8 * data, struct yaffs_spare *spare)
+{
+	yaffs_ecc_cacl(data, spare->ecc1);
+	yaffs_ecc_cacl(&data[256], spare->ecc2);
+}
+
+void yaffs_calc_tags_ecc(struct yaffs_tags *tags)
+{
+	/* Calculate an ecc */
+
+	unsigned char *b = ((union yaffs_tags_union *)tags)->as_bytes;
+	unsigned i, j;
+	unsigned ecc = 0;
+	unsigned bit = 0;
+
+	tags->ecc = 0;
+
+	for (i = 0; i < 8; i++) {
+		for (j = 1; j & 0xff; j <<= 1) {
+			bit++;
+			if (b[i] & j)
+				ecc ^= bit;
+		}
+	}
+
+	tags->ecc = ecc;
+
+}
+
+int yaffs_check_tags_ecc(struct yaffs_tags *tags)
+{
+	unsigned ecc = tags->ecc;
+
+	yaffs_calc_tags_ecc(tags);
+
+	ecc ^= tags->ecc;
+
+	if (ecc && ecc <= 64) {
+		/* TODO: Handle the failure better. Retire? */
+		unsigned char *b = ((union yaffs_tags_union *)tags)->as_bytes;
+
+		ecc--;
+
+		b[ecc / 8] ^= (1 << (ecc & 7));
+
+		/* Now recvalc the ecc */
+		yaffs_calc_tags_ecc(tags);
+
+		return 1;	/* recovered error */
+	} else if (ecc) {
+		/* Wierd ecc failure value */
+		/* TODO Need to do somethiong here */
+		return -1;	/* unrecovered error */
+	}
+
+	return 0;
+}
+
+/********** Tags **********/
+
+static void yaffs_load_tags_to_spare(struct yaffs_spare *spare_ptr,
+				     struct yaffs_tags *tags_ptr)
+{
+	union yaffs_tags_union *tu = (union yaffs_tags_union *)tags_ptr;
+
+	yaffs_calc_tags_ecc(tags_ptr);
+
+	spare_ptr->tb0 = tu->as_bytes[0];
+	spare_ptr->tb1 = tu->as_bytes[1];
+	spare_ptr->tb2 = tu->as_bytes[2];
+	spare_ptr->tb3 = tu->as_bytes[3];
+	spare_ptr->tb4 = tu->as_bytes[4];
+	spare_ptr->tb5 = tu->as_bytes[5];
+	spare_ptr->tb6 = tu->as_bytes[6];
+	spare_ptr->tb7 = tu->as_bytes[7];
+}
+
+static void yaffs_get_tags_from_spare(struct yaffs_dev *dev,
+				      struct yaffs_spare *spare_ptr,
+				      struct yaffs_tags *tags_ptr)
+{
+	union yaffs_tags_union *tu = (union yaffs_tags_union *)tags_ptr;
+	int result;
+
+	tu->as_bytes[0] = spare_ptr->tb0;
+	tu->as_bytes[1] = spare_ptr->tb1;
+	tu->as_bytes[2] = spare_ptr->tb2;
+	tu->as_bytes[3] = spare_ptr->tb3;
+	tu->as_bytes[4] = spare_ptr->tb4;
+	tu->as_bytes[5] = spare_ptr->tb5;
+	tu->as_bytes[6] = spare_ptr->tb6;
+	tu->as_bytes[7] = spare_ptr->tb7;
+
+	result = yaffs_check_tags_ecc(tags_ptr);
+	if (result > 0)
+		dev->n_tags_ecc_fixed++;
+	else if (result < 0)
+		dev->n_tags_ecc_unfixed++;
+}
+
+static void yaffs_spare_init(struct yaffs_spare *spare)
+{
+	memset(spare, 0xFF, sizeof(struct yaffs_spare));
+}
+
+static int yaffs_wr_nand(struct yaffs_dev *dev,
+			 int nand_chunk, const u8 * data,
+			 struct yaffs_spare *spare)
+{
+	if (nand_chunk < dev->param.start_block * dev->param.chunks_per_block) {
+		T(YAFFS_TRACE_ERROR,
+		  (TSTR("**>> yaffs chunk %d is not valid" TENDSTR),
+		   nand_chunk));
+		return YAFFS_FAIL;
+	}
+
+	return dev->param.write_chunk_fn(dev, nand_chunk, data, spare);
+}
+
+static int yaffs_rd_chunk_nand(struct yaffs_dev *dev,
+			       int nand_chunk,
+			       u8 * data,
+			       struct yaffs_spare *spare,
+			       enum yaffs_ecc_result *ecc_result,
+			       int correct_errors)
+{
+	int ret_val;
+	struct yaffs_spare local_spare;
+
+	if (!spare && data) {
+		/* If we don't have a real spare, then we use a local one. */
+		/* Need this for the calculation of the ecc */
+		spare = &local_spare;
+	}
+
+	if (!dev->param.use_nand_ecc) {
+		ret_val =
+		    dev->param.read_chunk_fn(dev, nand_chunk, data, spare);
+		if (data && correct_errors) {
+			/* Do ECC correction */
+			/* Todo handle any errors */
+			int ecc_result1, ecc_result2;
+			u8 calc_ecc[3];
+
+			yaffs_ecc_cacl(data, calc_ecc);
+			ecc_result1 =
+			    yaffs_ecc_correct(data, spare->ecc1, calc_ecc);
+			yaffs_ecc_cacl(&data[256], calc_ecc);
+			ecc_result2 =
+			    yaffs_ecc_correct(&data[256], spare->ecc2,
+					      calc_ecc);
+
+			if (ecc_result1 > 0) {
+				T(YAFFS_TRACE_ERROR,
+				  (TSTR
+				   ("**>>yaffs ecc error fix performed on chunk %d:0"
+				    TENDSTR), nand_chunk));
+				dev->n_ecc_fixed++;
+			} else if (ecc_result1 < 0) {
+				T(YAFFS_TRACE_ERROR,
+				  (TSTR
+				   ("**>>yaffs ecc error unfixed on chunk %d:0"
+				    TENDSTR), nand_chunk));
+				dev->n_ecc_unfixed++;
+			}
+
+			if (ecc_result2 > 0) {
+				T(YAFFS_TRACE_ERROR,
+				  (TSTR
+				   ("**>>yaffs ecc error fix performed on chunk %d:1"
+				    TENDSTR), nand_chunk));
+				dev->n_ecc_fixed++;
+			} else if (ecc_result2 < 0) {
+				T(YAFFS_TRACE_ERROR,
+				  (TSTR
+				   ("**>>yaffs ecc error unfixed on chunk %d:1"
+				    TENDSTR), nand_chunk));
+				dev->n_ecc_unfixed++;
+			}
+
+			if (ecc_result1 || ecc_result2) {
+				/* We had a data problem on this page */
+				yaffs_handle_rd_data_error(dev, nand_chunk);
+			}
+
+			if (ecc_result1 < 0 || ecc_result2 < 0)
+				*ecc_result = YAFFS_ECC_RESULT_UNFIXED;
+			else if (ecc_result1 > 0 || ecc_result2 > 0)
+				*ecc_result = YAFFS_ECC_RESULT_FIXED;
+			else
+				*ecc_result = YAFFS_ECC_RESULT_NO_ERROR;
+		}
+	} else {
+		/* Must allocate enough memory for spare+2*sizeof(int) */
+		/* for ecc results from device. */
+		struct yaffs_nand_spare nspare;
+
+		memset(&nspare, 0, sizeof(nspare));
+
+		ret_val = dev->param.read_chunk_fn(dev, nand_chunk, data,
+						   (struct yaffs_spare *)
+						   &nspare);
+		memcpy(spare, &nspare, sizeof(struct yaffs_spare));
+		if (data && correct_errors) {
+			if (nspare.eccres1 > 0) {
+				T(YAFFS_TRACE_ERROR,
+				  (TSTR
+				   ("**>>mtd ecc error fix performed on chunk %d:0"
+				    TENDSTR), nand_chunk));
+			} else if (nspare.eccres1 < 0) {
+				T(YAFFS_TRACE_ERROR,
+				  (TSTR
+				   ("**>>mtd ecc error unfixed on chunk %d:0"
+				    TENDSTR), nand_chunk));
+			}
+
+			if (nspare.eccres2 > 0) {
+				T(YAFFS_TRACE_ERROR,
+				  (TSTR
+				   ("**>>mtd ecc error fix performed on chunk %d:1"
+				    TENDSTR), nand_chunk));
+			} else if (nspare.eccres2 < 0) {
+				T(YAFFS_TRACE_ERROR,
+				  (TSTR
+				   ("**>>mtd ecc error unfixed on chunk %d:1"
+				    TENDSTR), nand_chunk));
+			}
+
+			if (nspare.eccres1 || nspare.eccres2) {
+				/* We had a data problem on this page */
+				yaffs_handle_rd_data_error(dev, nand_chunk);
+			}
+
+			if (nspare.eccres1 < 0 || nspare.eccres2 < 0)
+				*ecc_result = YAFFS_ECC_RESULT_UNFIXED;
+			else if (nspare.eccres1 > 0 || nspare.eccres2 > 0)
+				*ecc_result = YAFFS_ECC_RESULT_FIXED;
+			else
+				*ecc_result = YAFFS_ECC_RESULT_NO_ERROR;
+
+		}
+	}
+	return ret_val;
+}
+
+/*
+ * Functions for robustisizing
+ */
+
+static void yaffs_handle_rd_data_error(struct yaffs_dev *dev, int nand_chunk)
+{
+	int flash_block = nand_chunk / dev->param.chunks_per_block;
+
+	/* Mark the block for retirement */
+	yaffs_get_block_info(dev,
+			     flash_block + dev->block_offset)->needs_retiring =
+	    1;
+	T(YAFFS_TRACE_ERROR | YAFFS_TRACE_BAD_BLOCKS,
+	  (TSTR("**>>Block %d marked for retirement" TENDSTR), flash_block));
+
+	/* TODO:
+	 * Just do a garbage collection on the affected block
+	 * then retire the block
+	 * NB recursion
+	 */
+}
+
+int yaffs_tags_compat_wr(struct yaffs_dev *dev,
+			 int nand_chunk,
+			 const u8 * data, const struct yaffs_ext_tags *ext_tags)
+{
+	struct yaffs_spare spare;
+	struct yaffs_tags tags;
+
+	yaffs_spare_init(&spare);
+
+	if (ext_tags->is_deleted)
+		spare.page_status = 0;
+	else {
+		tags.obj_id = ext_tags->obj_id;
+		tags.chunk_id = ext_tags->chunk_id;
+
+		tags.n_bytes_lsb = ext_tags->n_bytes & 0x3ff;
+
+		if (dev->data_bytes_per_chunk >= 1024)
+			tags.n_bytes_msb = (ext_tags->n_bytes >> 10) & 3;
+		else
+			tags.n_bytes_msb = 3;
+
+		tags.serial_number = ext_tags->serial_number;
+
+		if (!dev->param.use_nand_ecc && data)
+			yaffs_calc_ecc(data, &spare);
+
+		yaffs_load_tags_to_spare(&spare, &tags);
+
+	}
+
+	return yaffs_wr_nand(dev, nand_chunk, data, &spare);
+}
+
+int yaffs_tags_compat_rd(struct yaffs_dev *dev,
+			 int nand_chunk,
+			 u8 * data, struct yaffs_ext_tags *ext_tags)
+{
+
+	struct yaffs_spare spare;
+	struct yaffs_tags tags;
+	enum yaffs_ecc_result ecc_result = YAFFS_ECC_RESULT_UNKNOWN;
+
+	static struct yaffs_spare spare_ff;
+	static int init;
+
+	if (!init) {
+		memset(&spare_ff, 0xFF, sizeof(spare_ff));
+		init = 1;
+	}
+
+	if (yaffs_rd_chunk_nand(dev, nand_chunk, data, &spare, &ecc_result, 1)) {
+		/* ext_tags may be NULL */
+		if (ext_tags) {
+
+			int deleted =
+			    (yaffs_count_bits(spare.page_status) < 7) ? 1 : 0;
+
+			ext_tags->is_deleted = deleted;
+			ext_tags->ecc_result = ecc_result;
+			ext_tags->block_bad = 0;	/* We're reading it */
+			/* therefore it is not a bad block */
+			ext_tags->chunk_used =
+			    (memcmp(&spare_ff, &spare, sizeof(spare_ff)) !=
+			     0) ? 1 : 0;
+
+			if (ext_tags->chunk_used) {
+				yaffs_get_tags_from_spare(dev, &spare, &tags);
+
+				ext_tags->obj_id = tags.obj_id;
+				ext_tags->chunk_id = tags.chunk_id;
+				ext_tags->n_bytes = tags.n_bytes_lsb;
+
+				if (dev->data_bytes_per_chunk >= 1024)
+					ext_tags->n_bytes |=
+					    (((unsigned)tags.
+					      n_bytes_msb) << 10);
+
+				ext_tags->serial_number = tags.serial_number;
+			}
+		}
+
+		return YAFFS_OK;
+	} else {
+		return YAFFS_FAIL;
+	}
+}
+
+int yaffs_tags_compat_mark_bad(struct yaffs_dev *dev, int flash_block)
+{
+
+	struct yaffs_spare spare;
+
+	memset(&spare, 0xff, sizeof(struct yaffs_spare));
+
+	spare.block_status = 'Y';
+
+	yaffs_wr_nand(dev, flash_block * dev->param.chunks_per_block, NULL,
+		      &spare);
+	yaffs_wr_nand(dev, flash_block * dev->param.chunks_per_block + 1,
+		      NULL, &spare);
+
+	return YAFFS_OK;
+
+}
+
+int yaffs_tags_compat_query_block(struct yaffs_dev *dev,
+				  int block_no,
+				  enum yaffs_block_state *state,
+				  u32 * seq_number)
+{
+
+	struct yaffs_spare spare0, spare1;
+	static struct yaffs_spare spare_ff;
+	static int init;
+	enum yaffs_ecc_result dummy;
+
+	if (!init) {
+		memset(&spare_ff, 0xFF, sizeof(spare_ff));
+		init = 1;
+	}
+
+	*seq_number = 0;
+
+	yaffs_rd_chunk_nand(dev, block_no * dev->param.chunks_per_block, NULL,
+			    &spare0, &dummy, 1);
+	yaffs_rd_chunk_nand(dev, block_no * dev->param.chunks_per_block + 1,
+			    NULL, &spare1, &dummy, 1);
+
+	if (yaffs_count_bits(spare0.block_status & spare1.block_status) < 7)
+		*state = YAFFS_BLOCK_STATE_DEAD;
+	else if (memcmp(&spare_ff, &spare0, sizeof(spare_ff)) == 0)
+		*state = YAFFS_BLOCK_STATE_EMPTY;
+	else
+		*state = YAFFS_BLOCK_STATE_NEEDS_SCANNING;
+
+	return YAFFS_OK;
+}
diff --git a/fs/yaffs2/yaffs_tagscompat.h b/fs/yaffs2/yaffs_tagscompat.h
new file mode 100644
index 0000000..8cd35dc
--- /dev/null
+++ b/fs/yaffs2/yaffs_tagscompat.h
@@ -0,0 +1,36 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License version 2.1 as
+ * published by the Free Software Foundation.
+ *
+ * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
+ */
+
+#ifndef __YAFFS_TAGSCOMPAT_H__
+#define __YAFFS_TAGSCOMPAT_H__
+
+#include "yaffs_guts.h"
+int yaffs_tags_compat_wr(struct yaffs_dev *dev,
+			 int nand_chunk,
+			 const u8 * data, const struct yaffs_ext_tags *tags);
+int yaffs_tags_compat_rd(struct yaffs_dev *dev,
+			 int nand_chunk,
+			 u8 * data, struct yaffs_ext_tags *tags);
+int yaffs_tags_compat_mark_bad(struct yaffs_dev *dev, int block_no);
+int yaffs_tags_compat_query_block(struct yaffs_dev *dev,
+				  int block_no,
+				  enum yaffs_block_state *state,
+				  u32 * seq_number);
+
+void yaffs_calc_tags_ecc(struct yaffs_tags *tags);
+int yaffs_check_tags_ecc(struct yaffs_tags *tags);
+int yaffs_count_bits(u8 byte);
+
+#endif
diff --git a/fs/yaffs2/yaffs_tagsvalidity.c b/fs/yaffs2/yaffs_tagsvalidity.c
new file mode 100644
index 0000000..4358d79
--- /dev/null
+++ b/fs/yaffs2/yaffs_tagsvalidity.c
@@ -0,0 +1,27 @@
+/*
+ * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "yaffs_tagsvalidity.h"
+
+void yaffs_init_tags(struct yaffs_ext_tags *tags)
+{
+	memset(tags, 0, sizeof(struct yaffs_ext_tags));
+	tags->validity0 = 0xAAAAAAAA;
+	tags->validity1 = 0x55555555;
+}
+
+int yaffs_validate_tags(struct yaffs_ext_tags *tags)
+{
+	return (tags->validity0 == 0xAAAAAAAA && tags->validity1 == 0x55555555);
+
+}
diff --git a/fs/yaffs2/yaffs_tagsvalidity.h b/fs/yaffs2/yaffs_tagsvalidity.h
new file mode 100644
index 0000000..36a021f
--- /dev/null
+++ b/fs/yaffs2/yaffs_tagsvalidity.h
@@ -0,0 +1,23 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License version 2.1 as
+ * published by the Free Software Foundation.
+ *
+ * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
+ */
+
+#ifndef __YAFFS_TAGS_VALIDITY_H__
+#define __YAFFS_TAGS_VALIDITY_H__
+
+#include "yaffs_guts.h"
+
+void yaffs_init_tags(struct yaffs_ext_tags *tags);
+int yaffs_validate_tags(struct yaffs_ext_tags *tags);
+#endif
-- 
1.7.1

