Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab2DKPiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:38:09 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:47043
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1755566Ab2DKPiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:38:08 -0400
Date: Wed, 11 Apr 2012 17:38:01 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UBIFS: use ubi's new ubi_leb_change sync parameter
In-Reply-To: <alpine.DEB.2.00.1204111514120.10181@eristoteles.iwoars.net>
Message-ID: <alpine.DEB.2.00.1204111735530.12033@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1203291653210.912@eristoteles.iwoars.net>    <4F748CD6.4080704@parrot.com>    <alpine.DEB.2.00.1203301413080.10066@eristoteles.iwoars.net>   <1333110503.5440.24.camel@sauron.fi.intel.com>   <alpine.DEB.2.00.1203301433270.10066@eristoteles.iwoars.net>
  <1333111321.5440.29.camel@sauron.fi.intel.com>  <alpine.DEB.2.00.1203301709080.10066@eristoteles.iwoars.net> <1334147205.13842.8.camel@sauron.fi.intel.com> <alpine.DEB.2.00.1204111514120.10181@eristoteles.iwoars.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes UBIFS to use the new sync parameter for ubi's ubi_leb_change
function. In the previous post, one of the calls had sync = 1, this is
fixed. This, along with the ubi patch that introduces the new
parameter, was tested using integck for both sync=0 and sync=1 in the
tnc_commit's call to leb_change and the underlying free'd PEB was
inspected through debug statements to ensure that it was later reallocated
for new data.

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 fs/ubifs/debug.c      |    4 ++--
 fs/ubifs/debug.h      |    2 +-
 fs/ubifs/io.c         |    6 +++---
 fs/ubifs/log.c        |    5 +++--
 fs/ubifs/lpt.c        |   10 +++++-----
 fs/ubifs/orphan.c     |    2 +-
 fs/ubifs/recovery.c   |   12 ++++++------
 fs/ubifs/sb.c         |    4 ++--
 fs/ubifs/tnc_commit.c |    2 +-
 fs/ubifs/ubifs.h      |    2 +-
 10 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index 1934084..46eea79 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -2697,7 +2697,7 @@ int dbg_leb_write(struct ubifs_info *c, int lnum, const void *buf,
 }

 int dbg_leb_change(struct ubifs_info *c, int lnum, const void *buf,
-		   int len, int dtype)
+		   int len, int dtype, int sync)
 {
 	int err;

@@ -2705,7 +2705,7 @@ int dbg_leb_change(struct ubifs_info *c, int lnum, const void *buf,
 		return -EROFS;
 	if (power_cut_emulated(c, lnum, 1))
 		return -EROFS;
-	err = ubi_leb_change(c->ubi, lnum, buf, len, dtype);
+	err = ubi_leb_change(c->ubi, lnum, buf, len, dtype, sync);
 	if (err)
 		return err;
 	if (power_cut_emulated(c, lnum, 1))
diff --git a/fs/ubifs/debug.h b/fs/ubifs/debug.h
index 9f71765..9cee4cc 100644
--- a/fs/ubifs/debug.h
+++ b/fs/ubifs/debug.h
@@ -309,7 +309,7 @@ int dbg_check_nondata_nodes_order(struct ubifs_info *c, struct list_head *head);
 int dbg_leb_write(struct ubifs_info *c, int lnum, const void *buf, int offs,
 		  int len, int dtype);
 int dbg_leb_change(struct ubifs_info *c, int lnum, const void *buf, int len,
-		   int dtype);
+		   int dtype, int sync);
 int dbg_leb_unmap(struct ubifs_info *c, int lnum);
 int dbg_leb_map(struct ubifs_info *c, int lnum, int dtype);

diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
index 103532e..5203787 100644
--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -136,7 +136,7 @@ int ubifs_leb_write(struct ubifs_info *c, int lnum, const void *buf, int offs,
 }

 int ubifs_leb_change(struct ubifs_info *c, int lnum, const void *buf, int len,
-		     int dtype)
+		     int dtype, int sync)
 {
 	int err;

@@ -144,9 +144,9 @@ int ubifs_leb_change(struct ubifs_info *c, int lnum, const void *buf, int len,
 	if (c->ro_error)
 		return -EROFS;
 	if (!dbg_is_tst_rcvry(c))
-		err = ubi_leb_change(c->ubi, lnum, buf, len, dtype);
+		err = ubi_leb_change(c->ubi, lnum, buf, len, dtype, sync);
 	else
-		err = dbg_leb_change(c, lnum, buf, len, dtype);
+		err = dbg_leb_change(c, lnum, buf, len, dtype, sync);
 	if (err) {
 		ubifs_err("changing %d bytes in LEB %d failed, error %d",
 			  len, lnum, err);
diff --git a/fs/ubifs/log.c b/fs/ubifs/log.c
index f9fd068..a3d4660 100644
--- a/fs/ubifs/log.c
+++ b/fs/ubifs/log.c
@@ -623,7 +623,7 @@ static int add_node(struct ubifs_info *c, void *buf, int *lnum, int *offs,
 		int sz = ALIGN(*offs, c->min_io_size), err;

 		ubifs_pad(c, buf + *offs, sz - *offs);
-		err = ubifs_leb_change(c, *lnum, buf, sz, UBI_SHORTTERM);
+		err = ubifs_leb_change(c, *lnum, buf, sz, UBI_SHORTTERM, 0);
 		if (err)
 			return err;
 		*lnum = ubifs_next_log_lnum(c, *lnum);
@@ -702,7 +702,8 @@ int ubifs_consolidate_log(struct ubifs_info *c)
 		int sz = ALIGN(offs, c->min_io_size);

 		ubifs_pad(c, buf + offs, sz - offs);
-		err = ubifs_leb_change(c, write_lnum, buf, sz, UBI_SHORTTERM);
+		err = ubifs_leb_change(c, write_lnum, buf,
+				       sz, UBI_SHORTTERM, 0);
 		if (err)
 			goto out_free;
 		offs = ALIGN(offs, c->min_io_size);
diff --git a/fs/ubifs/lpt.c b/fs/ubifs/lpt.c
index 66d59d0..c974211 100644
--- a/fs/ubifs/lpt.c
+++ b/fs/ubifs/lpt.c
@@ -702,7 +702,7 @@ int ubifs_create_dflt_lpt(struct ubifs_info *c, int *main_lebs, int lpt_first,
 			set_ltab(c, lnum, c->leb_size - alen, alen - len);
 			memset(p, 0xff, alen - len);
 			err = ubifs_leb_change(c, lnum++, buf, alen,
-					       UBI_SHORTTERM);
+					       UBI_SHORTTERM, 0);
 			if (err)
 				goto out;
 			p = buf;
@@ -733,7 +733,7 @@ int ubifs_create_dflt_lpt(struct ubifs_info *c, int *main_lebs, int lpt_first,
 					    alen - len);
 				memset(p, 0xff, alen - len);
 				err = ubifs_leb_change(c, lnum++, buf, alen,
-						       UBI_SHORTTERM);
+						       UBI_SHORTTERM, 0);
 				if (err)
 					goto out;
 				p = buf;
@@ -781,7 +781,7 @@ int ubifs_create_dflt_lpt(struct ubifs_info *c, int *main_lebs, int lpt_first,
 			set_ltab(c, lnum, c->leb_size - alen, alen - len);
 			memset(p, 0xff, alen - len);
 			err = ubifs_leb_change(c, lnum++, buf, alen,
-					       UBI_SHORTTERM);
+					       UBI_SHORTTERM, 0);
 			if (err)
 				goto out;
 			p = buf;
@@ -806,7 +806,7 @@ int ubifs_create_dflt_lpt(struct ubifs_info *c, int *main_lebs, int lpt_first,
 		alen = ALIGN(len, c->min_io_size);
 		set_ltab(c, lnum, c->leb_size - alen, alen - len);
 		memset(p, 0xff, alen - len);
-		err = ubifs_leb_change(c, lnum++, buf, alen, UBI_SHORTTERM);
+		err = ubifs_leb_change(c, lnum++, buf, alen, UBI_SHORTTERM, 0);
 		if (err)
 			goto out;
 		p = buf;
@@ -826,7 +826,7 @@ int ubifs_create_dflt_lpt(struct ubifs_info *c, int *main_lebs, int lpt_first,

 	/* Write remaining buffer */
 	memset(p, 0xff, alen - len);
-	err = ubifs_leb_change(c, lnum, buf, alen, UBI_SHORTTERM);
+	err = ubifs_leb_change(c, lnum, buf, alen, UBI_SHORTTERM, 0);
 	if (err)
 		goto out;

diff --git a/fs/ubifs/orphan.c b/fs/ubifs/orphan.c
index c542c73..a0ec4ed 100644
--- a/fs/ubifs/orphan.c
+++ b/fs/ubifs/orphan.c
@@ -249,7 +249,7 @@ static int do_write_orph_node(struct ubifs_info *c, int len, int atomic)
 		ubifs_prepare_node(c, c->orph_buf, len, 1);
 		len = ALIGN(len, c->min_io_size);
 		err = ubifs_leb_change(c, c->ohead_lnum, c->orph_buf, len,
-				       UBI_SHORTTERM);
+				       UBI_SHORTTERM, 0);
 	} else {
 		if (c->ohead_offs == 0) {
 			/* Ensure LEB has been unmapped */
diff --git a/fs/ubifs/recovery.c b/fs/ubifs/recovery.c
index 2a935b3..0531112 100644
--- a/fs/ubifs/recovery.c
+++ b/fs/ubifs/recovery.c
@@ -213,10 +213,10 @@ static int write_rcvrd_mst_node(struct ubifs_info *c,
 	mst->flags |= cpu_to_le32(UBIFS_MST_RCVRY);

 	ubifs_prepare_node(c, mst, UBIFS_MST_NODE_SZ, 1);
-	err = ubifs_leb_change(c, lnum, mst, sz, UBI_SHORTTERM);
+	err = ubifs_leb_change(c, lnum, mst, sz, UBI_SHORTTERM, 0);
 	if (err)
 		goto out;
-	err = ubifs_leb_change(c, lnum + 1, mst, sz, UBI_SHORTTERM);
+	err = ubifs_leb_change(c, lnum + 1, mst, sz, UBI_SHORTTERM, 0);
 	if (err)
 		goto out;
 out:
@@ -556,7 +556,7 @@ static int fix_unclean_leb(struct ubifs_info *c, struct ubifs_scan_leb *sleb,
 				}
 			}
 			err = ubifs_leb_change(c, lnum, sleb->buf, len,
-					       UBI_UNKNOWN);
+					       UBI_UNKNOWN, 0);
 			if (err)
 				return err;
 		}
@@ -941,7 +941,7 @@ static int recover_head(struct ubifs_info *c, int lnum, int offs, void *sbuf)
 		err = ubifs_leb_read(c, lnum, sbuf, 0, offs, 1);
 		if (err)
 			return err;
-		return ubifs_leb_change(c, lnum, sbuf, offs, UBI_UNKNOWN);
+		return ubifs_leb_change(c, lnum, sbuf, offs, UBI_UNKNOWN, 0);
 	}

 	return 0;
@@ -1071,7 +1071,7 @@ static int clean_an_unclean_leb(struct ubifs_info *c,
 	}

 	/* Write back the LEB atomically */
-	err = ubifs_leb_change(c, lnum, sbuf, len, UBI_UNKNOWN);
+	err = ubifs_leb_change(c, lnum, sbuf, len, UBI_UNKNOWN, 0);
 	if (err)
 		return err;

@@ -1472,7 +1472,7 @@ static int fix_size_in_place(struct ubifs_info *c, struct size_entry *e)
 		len -= 1;
 	len = ALIGN(len + 1, c->min_io_size);
 	/* Atomically write the fixed LEB back again */
-	err = ubifs_leb_change(c, lnum, c->sbuf, len, UBI_UNKNOWN);
+	err = ubifs_leb_change(c, lnum, c->sbuf, len, UBI_UNKNOWN, 0);
 	if (err)
 		goto out;
 	dbg_rcvry("inode %lu at %d:%d size %lld -> %lld",
diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
index 3fc9071..29de5bb 100644
--- a/fs/ubifs/sb.c
+++ b/fs/ubifs/sb.c
@@ -518,7 +518,7 @@ int ubifs_write_sb_node(struct ubifs_info *c, struct ubifs_sb_node *sup)
 	int len = ALIGN(UBIFS_SB_NODE_SZ, c->min_io_size);

 	ubifs_prepare_node(c, sup, UBIFS_SB_NODE_SZ, 1);
-	return ubifs_leb_change(c, UBIFS_SB_LNUM, sup, len, UBI_LONGTERM);
+	return ubifs_leb_change(c, UBIFS_SB_LNUM, sup, len, UBI_LONGTERM, 0);
 }

 /**
@@ -691,7 +691,7 @@ static int fixup_leb(struct ubifs_info *c, int lnum, int len)
 	if (err)
 		return err;

-	return ubifs_leb_change(c, lnum, c->sbuf, len, UBI_UNKNOWN);
+	return ubifs_leb_change(c, lnum, c->sbuf, len, UBI_UNKNOWN, 0);
 }

 /**
diff --git a/fs/ubifs/tnc_commit.c b/fs/ubifs/tnc_commit.c
index 4c15f07..485a283 100644
--- a/fs/ubifs/tnc_commit.c
+++ b/fs/ubifs/tnc_commit.c
@@ -323,7 +323,7 @@ static int layout_leb_in_gaps(struct ubifs_info *c, int *p)
 	if (err)
 		return err;
 	err = ubifs_leb_change(c, lnum, c->ileb_buf, c->ileb_len,
-			       UBI_SHORTTERM);
+			       UBI_SHORTTERM, 0);
 	if (err)
 		return err;
 	dbg_gc("LEB %d wrote %d index nodes", lnum, tot_written);
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 3ed12be..3aaeb45 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1470,7 +1470,7 @@ int ubifs_leb_read(const struct ubifs_info *c, int lnum, void *buf, int offs,
 int ubifs_leb_write(struct ubifs_info *c, int lnum, const void *buf, int offs,
 		    int len, int dtype);
 int ubifs_leb_change(struct ubifs_info *c, int lnum, const void *buf, int len,
-		     int dtype);
+		     int dtype, int sync);
 int ubifs_leb_unmap(struct ubifs_info *c, int lnum);
 int ubifs_leb_map(struct ubifs_info *c, int lnum, int dtype);
 int ubifs_is_mapped(const struct ubifs_info *c, int lnum);
-- 
1.7.5.4


