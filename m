Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab2HNWiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 18:38:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab2HNWiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 18:38:14 -0400
From: Nikola Pajkovsky <npajkovs@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Nikola Pajkovsky <npajkovs@redhat.com>
Subject: [PATCH] udf: fix retun value on error path in udf_load_logicalvol
Date: Wed, 15 Aug 2012 00:38:08 +0200
Message-Id: <c50410075da9d2f4cd7ebb42fadf11a67dcfa175.1344983600.git.npajkovs@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case we detect a problem and bail out, we fail to set "ret" to a
nonzero value, and udf_load_logicalvol will mistakenly report success.

Signed-off-by: Nikola Pajkovsky <npajkovs@redhat.com>
---
 fs/udf/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index dcbf987..c96bd77 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1344,6 +1344,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 		udf_err(sb, "error loading logical volume descriptor: "
 			"Partition table too long (%u > %lu)\n", table_len,
 			sb->s_blocksize - sizeof(*lvd));
+		ret = 1;
 		goto out_bh;
 	}
 
@@ -1388,8 +1389,10 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
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
1.7.10.2

