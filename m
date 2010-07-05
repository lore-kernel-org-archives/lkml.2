Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab0GEMTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 08:19:00 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49122 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212Ab0GEMSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 08:18:51 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCHv6 6/9] sysv: do not mark superblock dirty on remount
Date: Mon,  5 Jul 2010 15:15:04 +0300
Message-Id: <1278332107-11443-7-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1278332107-11443-1-git-send-email-dedekind1@gmail.com>
References: <1278332107-11443-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 05 Jul 2010 12:18:44.0046 (UTC) FILETIME=[360A6EE0:01CB1C3C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

No need to mark the superblock as dirty in sysv_remount, synchronize
it instead (only if mounting R/O).

I did not find any docs about this file-system, and I have no possibility
to test my changes. Thus, this is untested. I see other issues in sysv,
e.g., why sysv_sync_fs writes only in the FSTYPE_SYSV4 case? However,
it marks its SB bh's dirty for all types, and does not wait for them
ever. With zero docs I'm unable to fix this.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/sysv/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index d4a5380..661bab5 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -71,8 +71,8 @@ static int sysv_remount(struct super_block *sb, int *flags, char *data)
 	lock_super(sb);
 	if (sbi->s_forced_ro)
 		*flags |= MS_RDONLY;
-	if (!(*flags & MS_RDONLY))
-		sb->s_dirt = 1;
+	if (*flags & MS_RDONLY)
+		sysv_write_super(sb);
 	unlock_super(sb);
 	return 0;
 }
-- 
1.7.0.1

