Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab1ILP1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 11:27:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59221 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab1ILP1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 11:27:11 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Pavel Ivanov <paivanof@gmail.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: [PATCH] hfsplus: Fix kfree of wrong vhdr pointers
Date: Mon, 12 Sep 2011 10:27:07 -0500
Message-Id: <1315841227-24535-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <CAG1a4rubbzvOE3KoGmc_9svS-UFX8gzuE=3TnVYfGAeXCJpLYw@mail.gmail.com>
References: <CAG1a4rubbzvOE3KoGmc_9svS-UFX8gzuE=3TnVYfGAeXCJpLYw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6596528 (hfsplus: ensure bio requests are not smaller than
the hardware sectors) changed the pointers used for volume header
allocations, but a couple of spots are still freeing the old
pointers. This patch fixes the problem.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Pavel Ivanov <paivanof@gmail.com>
Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: <stable@kernel.org>
---
 fs/hfsplus/super.c   |    4 ++--
 fs/hfsplus/wrapper.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index c106ca2..cadbb8c 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -525,8 +525,8 @@ out_close_cat_tree:
 out_close_ext_tree:
 	hfs_btree_close(sbi->ext_tree);
 out_free_vhdr:
-	kfree(sbi->s_vhdr);
-	kfree(sbi->s_backup_vhdr);
+	kfree(sbi->s_vhdr_buf);
+	kfree(sbi->s_backup_vhdr_buf);
 out_unload_nls:
 	unload_nls(sbi->nls);
 	unload_nls(nls);
diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 10e515a..7daf4b8 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -272,9 +272,9 @@ reread:
 	return 0;
 
 out_free_backup_vhdr:
-	kfree(sbi->s_backup_vhdr);
+	kfree(sbi->s_backup_vhdr_buf);
 out_free_vhdr:
-	kfree(sbi->s_vhdr);
+	kfree(sbi->s_vhdr_buf);
 out:
 	return error;
 }
-- 
1.7.4.1

