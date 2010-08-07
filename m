Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762332Ab0HGJJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 05:09:34 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41604 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761582Ab0HGJJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 05:09:31 -0400
Date: Sat, 7 Aug 2010 11:09:29 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] drivers/mtd/ubi: Eliminate update of list_for_each_entry
 loop cursor
Message-ID: <Pine.LNX.4.64.1008071109140.5821@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

list_for_each_entry uses its first argument to move from one element to the
next, so modifying it can break the iteration.  The variable re1 is already
used within the loop as a temporary variable, and is not live here.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
iterator name list_for_each_entry;
expression x,E;
position p1,p2;
@@

list_for_each_entry@p1(x,...) { <... x =@p2 E ...> }

@@
expression x,E;
position r.p1,r.p2;
statement S;
@@

*x =@p2 E
...
list_for_each_entry@p1(x,...) S
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mtd/ubi/cdev.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index 4dfa6b9..3d2d1a6 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -798,18 +798,18 @@ static int rename_volumes(struct ubi_device *ubi,
 			goto out_free;
 		}
 
-		re = kzalloc(sizeof(struct ubi_rename_entry), GFP_KERNEL);
-		if (!re) {
+		re1 = kzalloc(sizeof(struct ubi_rename_entry), GFP_KERNEL);
+		if (!re1) {
 			err = -ENOMEM;
 			ubi_close_volume(desc);
 			goto out_free;
 		}
 
-		re->remove = 1;
-		re->desc = desc;
-		list_add(&re->list, &rename_list);
+		re1->remove = 1;
+		re1->desc = desc;
+		list_add(&re1->list, &rename_list);
 		dbg_msg("will remove volume %d, name \"%s\"",
-			re->desc->vol->vol_id, re->desc->vol->name);
+			re1->desc->vol->vol_id, re1->desc->vol->name);
 	}
 
 	mutex_lock(&ubi->device_mutex);
