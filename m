Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab1E3S4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 14:56:25 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:38182 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174Ab1E3S4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 14:56:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QihhUj0eDIrZupfqm5nPk7QE23HbVqXkKisqyycXue5bLReSGXaSQlWeftBLWq4vgs
         7IIXB9+KvdPLrhUxsKO6zAiFVUPmodn0I5cwfI6d4Vjo+KptP565sR6E1FIMBShfOJSU
         4qqbm1V+Xox+9IuD4wlLtYgnKrKdLUIyZeObA=
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@nokia.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Matthew L. Creech" <mlcreech@gmail.com>
Subject: [PATCH 2/3] UBIFS: intialize the LPT earlier
Date: Mon, 30 May 2011 14:56:15 -0400
Message-Id: <e0fb2d40ab7314049654d85b86a4c27e9a1801ef.1306780983.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1306780983.git.bengardiner@nanometrics.ca>
References: <cover.1306780983.git.bengardiner@nanometrics.ca>
In-Reply-To: <cover.1306780983.git.bengardiner@nanometrics.ca>
References: <cover.1306780983.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current mount_ubifs() implementation does not initialize the LPT until the
check for recovery is completed and the dirty flag is written.

Move the LPT initializtion to before the check for recovery and dirty flag in
preparation for the next patch which will move the free-space-fixup check to
directly after this allocation.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>

---
 fs/ubifs/super.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 6db0bdaa..89c8d33 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1281,13 +1281,17 @@ static int mount_ubifs(struct ubifs_info *c)
 
 	init_constants_master(c);
 
+	err = ubifs_lpt_init(c, 1, !c->ro_mount);
+	if (err)
+		goto out_lpt;
+
 	if ((c->mst_node->flags & cpu_to_le32(UBIFS_MST_DIRTY)) != 0) {
 		ubifs_msg("recovery needed");
 		c->need_recovery = 1;
 		if (!c->ro_mount) {
 			err = ubifs_recover_inl_heads(c, c->sbuf);
 			if (err)
-				goto out_master;
+				goto out_lpt;
 		}
 	} else if (!c->ro_mount) {
 		/*
@@ -1297,13 +1301,9 @@ static int mount_ubifs(struct ubifs_info *c)
 		c->mst_node->flags |= cpu_to_le32(UBIFS_MST_DIRTY);
 		err = ubifs_write_master(c);
 		if (err)
-			goto out_master;
+			goto out_lpt;
 	}
 
-	err = ubifs_lpt_init(c, 1, !c->ro_mount);
-	if (err)
-		goto out_lpt;
-
 	err = dbg_check_idx_size(c, c->bi.old_idx_sz);
 	if (err)
 		goto out_lpt;
-- 
1.7.4.1

