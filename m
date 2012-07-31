Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab2GaE5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:57:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48786 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755639Ab2GaEu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:56 -0400
Message-Id: <20120731044317.184294372@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Kara <jack@suse.cz>
Subject: [ 37/73] udf: Improve table length check to avoid possible overflow
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 57b9655d01ef057a523e810d29c37ac09b80eead upstream.

When a partition table length is corrupted to be close to 1 << 32, the
check for its length may overflow on 32-bit systems and we will think
the length is valid. Later on the kernel can crash trying to read beyond
end of buffer. Fix the check to avoid possible overflow.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/udf/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 8a75838..dcbf987 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1340,7 +1340,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	BUG_ON(ident != TAG_IDENT_LVD);
 	lvd = (struct logicalVolDesc *)bh->b_data;
 	table_len = le32_to_cpu(lvd->mapTableLength);
-	if (sizeof(*lvd) + table_len > sb->s_blocksize) {
+	if (table_len > sb->s_blocksize - sizeof(*lvd)) {
 		udf_err(sb, "error loading logical volume descriptor: "
 			"Partition table too long (%u > %lu)\n", table_len,
 			sb->s_blocksize - sizeof(*lvd));


