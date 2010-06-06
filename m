Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab0FFOxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 10:53:49 -0400
Received: from smtp.nokia.com ([192.100.105.134]:18235 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934025Ab0FFOxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 10:53:38 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCHv5 10/16] exofs: fix race condition in marking SB dirty
Date: Sun,  6 Jun 2010 17:50:23 +0300
Message-Id: <1275835829-1478-11-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 06 Jun 2010 14:53:29.0637 (UTC) FILETIME=[06B46D50:01CB0588]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

When synchronizing the superblock, exofs first initiates the SB write
(a) and then marks the superblock as clean (b). However, meanwhile
(between (a) and (b)) someone else can modify the superblock and
mark it as dirty. This would be a race condition, and the result
would be that we'd end up with a modified superblock which would
nevertheless be marked as clean (because of (b)). This means that
'sync_supers()' would never call our '->write_super()', at least
not until yet another SB change happens.

This patch fixes this race condition by marking the superblock as
clean before initiating the write operation.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 74ccbdc..0b432b9 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -219,6 +219,7 @@ int exofs_sync_fs(struct super_block *sb, int wait)
 	 *       the fscb->s_dev_table_oid member. There is no read-modify-write
 	 *       here.
 	 */
+	sb_mark_clean(sb);
 	ios->length = offsetof(struct exofs_fscb, s_dev_table_oid);
 	memset(fscb, 0, ios->length);
 	fscb->s_nextid = cpu_to_le64(sbi->s_nextid);
@@ -237,7 +238,6 @@ int exofs_sync_fs(struct super_block *sb, int wait)
 		EXOFS_ERR("%s: exofs_sbi_write failed.\n", __func__);
 		goto out;
 	}
-	sb_mark_clean(sb);
 
 out:
 	EXOFS_DBGMSG("s_nextid=0x%llx ret=%d\n", _LLU(sbi->s_nextid), ret);
-- 
1.7.0.1

