Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab2KZQ74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:59:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46987 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab2KZQ7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:59:48 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nikola Pajkovsky <npajkovs@redhat.com>, Jan Kara <jack@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 001/270] udf: fix retun value on error path in udf_load_logicalvol
Date: Mon, 26 Nov 2012 14:54:51 -0200
Message-Id: <1353949160-26803-2-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikola Pajkovsky <npajkovs@redhat.com>

commit 68766a2edcd5cd744262a70a2f67a320ac944760 upstream.

In case we detect a problem and bail out, we fail to set "ret" to a
nonzero value, and udf_load_logicalvol will mistakenly report success.

Signed-off-by: Nikola Pajkovsky <npajkovs@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/udf/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index e660ffd..4988a8a 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1287,6 +1287,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 		udf_err(sb, "error loading logical volume descriptor: "
 			"Partition table too long (%u > %lu)\n", table_len,
 			sb->s_blocksize - sizeof(*lvd));
+		ret = 1;
 		goto out_bh;
 	}
 
@@ -1331,8 +1332,10 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 						UDF_ID_SPARABLE,
 						strlen(UDF_ID_SPARABLE))) {
 				if (udf_load_sparable_map(sb, map,
-				    (struct sparablePartitionMap *)gpm) < 0)
+				    (struct sparablePartitionMap *)gpm) < 0) {
+					ret = 1;
 					goto out_bh;
+				}
 			} else if (!strncmp(upm2->partIdent.ident,
 						UDF_ID_METADATA,
 						strlen(UDF_ID_METADATA))) {
-- 
1.7.9.5

