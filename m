Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab0KNUIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 15:08:48 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37539 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab0KNUIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 15:08:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=E5XGinkGis457eLti7L669p99YlyDNBgNqlnkjs6ljnEjeM3yoaumWvu1LxZvK0lpG
         tAgCTBVhd+TkCwsuS4PoFVGU45O/f2hIU1x1OmHuJv/X4kt/fcnyiwbz3uudQkqC7MfT
         v+P+7D3l/uiRFfei+Ju6cV5WaZ8Z02ruaPdaM=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs: jffs2: fix error value sign
Date: Sun, 14 Nov 2010 23:08:39 +0300
Message-Id: <1289765320-6071-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_verify_xattr_datum(), do_load_xattr_datum(), load_xattr_datum()
and verify_xattr_ref() should return negative value on error.
Sometimes they return EIO that is positive.  Change this to -EIO.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 This driver is not compilable, so the patch is not tested.

 fs/jffs2/xattr.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/jffs2/xattr.c b/fs/jffs2/xattr.c
index 9b572ca..4f9cc04 100644
--- a/fs/jffs2/xattr.c
+++ b/fs/jffs2/xattr.c
@@ -151,7 +151,7 @@ static int do_verify_xattr_datum(struct jffs2_sb_info *c, struct jffs2_xattr_dat
 		JFFS2_ERROR("node CRC failed at %#08x, read=%#08x, calc=%#08x\n",
 			    offset, je32_to_cpu(rx.hdr_crc), crc);
 		xd->flags |= JFFS2_XFLAGS_INVALID;
-		return EIO;
+		return -EIO;
 	}
 	totlen = PAD(sizeof(rx) + rx.name_len + 1 + je16_to_cpu(rx.value_len));
 	if (je16_to_cpu(rx.magic) != JFFS2_MAGIC_BITMASK
@@ -167,7 +167,7 @@ static int do_verify_xattr_datum(struct jffs2_sb_info *c, struct jffs2_xattr_dat
 			    je32_to_cpu(rx.xid), xd->xid,
 			    je32_to_cpu(rx.version), xd->version);
 		xd->flags |= JFFS2_XFLAGS_INVALID;
-		return EIO;
+		return -EIO;
 	}
 	xd->xprefix = rx.xprefix;
 	xd->name_len = rx.name_len;
@@ -230,7 +230,7 @@ static int do_load_xattr_datum(struct jffs2_sb_info *c, struct jffs2_xattr_datum
 			      ref_offset(xd->node), xd->data_crc, crc);
 		kfree(data);
 		xd->flags |= JFFS2_XFLAGS_INVALID;
-		return EIO;
+		return -EIO;
 	}
 
 	xd->flags |= JFFS2_XFLAGS_HOT;
@@ -268,7 +268,7 @@ static int load_xattr_datum(struct jffs2_sb_info *c, struct jffs2_xattr_datum *x
 	if (xd->xname)
 		return 0;
 	if (xd->flags & JFFS2_XFLAGS_INVALID)
-		return EIO;
+		return -EIO;
 	if (unlikely(is_xattr_datum_unchecked(c, xd)))
 		rc = do_verify_xattr_datum(c, xd);
 	if (!rc)
@@ -460,7 +460,7 @@ static int verify_xattr_ref(struct jffs2_sb_info *c, struct jffs2_xattr_ref *ref
 	if (crc != je32_to_cpu(rr.node_crc)) {
 		JFFS2_ERROR("node CRC failed at %#08x, read=%#08x, calc=%#08x\n",
 			    offset, je32_to_cpu(rr.node_crc), crc);
-		return EIO;
+		return -EIO;
 	}
 	if (je16_to_cpu(rr.magic) != JFFS2_MAGIC_BITMASK
 	    || je16_to_cpu(rr.nodetype) != JFFS2_NODETYPE_XREF
@@ -470,7 +470,7 @@ static int verify_xattr_ref(struct jffs2_sb_info *c, struct jffs2_xattr_ref *ref
 			    offset, je16_to_cpu(rr.magic), JFFS2_MAGIC_BITMASK,
 			    je16_to_cpu(rr.nodetype), JFFS2_NODETYPE_XREF,
 			    je32_to_cpu(rr.totlen), PAD(sizeof(rr)));
-		return EIO;
+		return -EIO;
 	}
 	ref->ino = je32_to_cpu(rr.ino);
 	ref->xid = je32_to_cpu(rr.xid);
-- 
1.7.0.4

