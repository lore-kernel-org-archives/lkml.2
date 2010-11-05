Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab0KEDIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:08:51 -0400
Received: from mail.perches.com ([173.55.12.10]:4091 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab0KEDIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:47 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/49] drivers/mtd: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:40 -0700
Message-Id: <61af073f284d2169834120889a641cd11c370643.1288925424.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mtd/nand/nandsim.c |    3 +--
 drivers/mtd/ubi/vtbl.c     |    6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index a6a73aa..b3d241b 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -470,7 +470,7 @@ static int alloc_device(struct nandsim *ns)
 			err = -EINVAL;
 			goto err_close;
 		}
-		ns->pages_written = vmalloc(ns->geom.pgnum);
+		ns->pages_written = vzalloc(ns->geom.pgnum);
 		if (!ns->pages_written) {
 			NS_ERR("alloc_device: unable to allocate pages written array\n");
 			err = -ENOMEM;
@@ -483,7 +483,6 @@ static int alloc_device(struct nandsim *ns)
 			goto err_free;
 		}
 		ns->cfile = cfile;
-		memset(ns->pages_written, 0, ns->geom.pgnum);
 		return 0;
 	}
 
diff --git a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
index fcdb7f6..0b8141f 100644
--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -425,12 +425,11 @@ static struct ubi_vtbl_record *process_lvol(struct ubi_device *ubi,
 
 	/* Read both LEB 0 and LEB 1 into memory */
 	ubi_rb_for_each_entry(rb, seb, &sv->root, u.rb) {
-		leb[seb->lnum] = vmalloc(ubi->vtbl_size);
+		leb[seb->lnum] = vzalloc(ubi->vtbl_size);
 		if (!leb[seb->lnum]) {
 			err = -ENOMEM;
 			goto out_free;
 		}
-		memset(leb[seb->lnum], 0, ubi->vtbl_size);
 
 		err = ubi_io_read_data(ubi, leb[seb->lnum], seb->pnum, 0,
 				       ubi->vtbl_size);
@@ -516,10 +515,9 @@ static struct ubi_vtbl_record *create_empty_lvol(struct ubi_device *ubi,
 	int i;
 	struct ubi_vtbl_record *vtbl;
 
-	vtbl = vmalloc(ubi->vtbl_size);
+	vtbl = vzalloc(ubi->vtbl_size);
 	if (!vtbl)
 		return ERR_PTR(-ENOMEM);
-	memset(vtbl, 0, ubi->vtbl_size);
 
 	for (i = 0; i < ubi->vtbl_slots; i++)
 		memcpy(&vtbl[i], &empty_vtbl_record, UBI_VTBL_RECORD_SIZE);
-- 
1.7.3.1.g432b3.dirty

