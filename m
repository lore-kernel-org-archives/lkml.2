Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab1E3S40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 14:56:26 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:56621 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713Ab1E3S4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 14:56:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CRjgkbuqJPRPvhrCu9uYPg4DRQnNa7DTN7I1OGWwwriKVfj1sEFi9GH5xryAH/68dK
         tX4UeEV9QOHWw9/usmzytFG8nui+WuLVHjaaFXUY25SbYo1Pf3lF1Ki4E1RmWQodi2HH
         FsPlFuy+UIsRo/xY64CputdipFJfsZMnPmP5Q=
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@nokia.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Matthew L. Creech" <mlcreech@gmail.com>
Subject: [PATCH 3/3] UBIFS: fix-up free space earlier
Date: Mon, 30 May 2011 14:56:16 -0400
Message-Id: <546eb16b8aedc7708774ae66bffd6c1175331b49.1306780983.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1306780983.git.bengardiner@nanometrics.ca>
References: <cover.1306780983.git.bengardiner@nanometrics.ca>
In-Reply-To: <cover.1306780983.git.bengardiner@nanometrics.ca>
References: <cover.1306780983.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The free space fixup is currently initiated during mount after the call to
ubifs_write_master() which results in a write to PEBs; this has been observed
with the patch 'assert no fixup when writing a node' applied:

Move the free space fixup on mount to before the calls to
ubifs_recover_inl_heads() and ubifs_write_master(). This results in no
assertions with the previously mentioned patch applied.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics>
CC: Matthew L. Creech <mlcreech@gmail.com>

---
 fs/ubifs/super.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 89c8d33..531b9b7 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1285,6 +1285,12 @@ static int mount_ubifs(struct ubifs_info *c)
 	if (err)
 		goto out_lpt;
 
+	if (!c->ro_mount && c->space_fixup) {
+		err = ubifs_fixup_free_space(c);
+		if (err)
+			goto out_infos;
+	}
+
 	if ((c->mst_node->flags & cpu_to_le32(UBIFS_MST_DIRTY)) != 0) {
 		ubifs_msg("recovery needed");
 		c->need_recovery = 1;
@@ -1396,12 +1402,6 @@ static int mount_ubifs(struct ubifs_info *c)
 	} else
 		ubifs_assert(c->lst.taken_empty_lebs > 0);
 
-	if (!c->ro_mount && c->space_fixup) {
-		err = ubifs_fixup_free_space(c);
-		if (err)
-			goto out_infos;
-	}
-
 	err = dbg_check_filesystem(c);
 	if (err)
 		goto out_infos;
-- 
1.7.4.1

