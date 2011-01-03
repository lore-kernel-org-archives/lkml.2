Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab1ACNwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:52:41 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60593 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab1ACNus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=C6McI2Lax3I6Vmin1YWEVjOwyNELoc9fwj+NFm3e8mEHZuMi7zVYnkTFBi5JR/Z7VC
         2RDjLRl94fwRi2vnrvGKPlsEjO0sPa+lV+SboE7ss9snzKmCYeKAHWpChbSBDZh+PBTs
         H7HraPzARpao32Cj9bL86XHI7FsCbE6iOqiac=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, reiserfs-devel@vger.kernel.org
Subject: [PATCH 27/32] reiserfs: make commit_wq use the default concurrency level
Date: Mon,  3 Jan 2011 14:49:50 +0100
Message-Id: <1294062595-30097-28-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The maximum number of concurrent work items queued on commit_wq is
bound by the number of active journals.  Convert to alloc_workqueue()
and use the default concurrency level so that they can be processed in
parallel.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: reiserfs-devel@vger.kernel.org
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 fs/reiserfs/journal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index d31bce1..ee311c0 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2883,7 +2883,7 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 	reiserfs_mounted_fs_count++;
 	if (reiserfs_mounted_fs_count <= 1) {
 		reiserfs_write_unlock(sb);
-		commit_wq = create_workqueue("reiserfs");
+		commit_wq = alloc_workqueue("reiserfs", WQ_MEM_RECLAIM, 0);
 		reiserfs_write_lock(sb);
 	}
 
-- 
1.7.1

