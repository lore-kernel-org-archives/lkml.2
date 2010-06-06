Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078Ab0FFOx7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 10:53:59 -0400
Received: from smtp.nokia.com ([192.100.122.233]:50228 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934053Ab0FFOxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 10:53:52 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCHv5 16/16] HFSPLUS: wait for synchronization
Date: Sun,  6 Jun 2010 17:50:29 +0300
Message-Id: <1275835829-1478-17-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 06 Jun 2010 14:53:41.0286 (UTC) FILETIME=[0DA5EC60:01CB0588]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

HFS does not ever wait for superblock synchronization in
->put_super(), ->write_super, and ->sync_fs().

However, it should wait for synchronization in ->put_super() because
it is about to be unmounted, in ->write_super() because this is
periodic SB synchronization berformed from a separate kernel thread,
and in ->sync_fs() it should respect the 'wait' flag. This patch fixes
this.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/hfsplus/super.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index a90fc67..15cadf6 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -170,6 +170,8 @@ static int hfsplus_sync_fs(struct super_block *sb, int wait)
 	vhdr->file_count = cpu_to_be32(HFSPLUS_SB(sb).file_count);
 
 	mark_buffer_dirty(HFSPLUS_SB(sb).s_vhbh);
+	if (wait)
+		sync_dirty_buffer(HFSPLUS_SB(sb).s_vhbh);
 	if (HFSPLUS_SB(sb).flags & HFSPLUS_SB_WRITEBACKUP) {
 		if (HFSPLUS_SB(sb).sect_count) {
 			struct buffer_head *bh;
@@ -186,6 +188,7 @@ static int hfsplus_sync_fs(struct super_block *sb, int wait)
 				if (be16_to_cpu(vhdr->signature) == HFSPLUS_VOLHEAD_SIG) {
 					memcpy(vhdr, HFSPLUS_SB(sb).s_vhdr, sizeof(*vhdr));
 					mark_buffer_dirty(bh);
+					sync_dirty_buffer(bh);
 					brelse(bh);
 				} else
 					printk(KERN_WARNING "hfs: backup not found!\n");
-- 
1.7.0.1

