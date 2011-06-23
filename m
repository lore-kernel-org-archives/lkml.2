Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab1FWRi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:38:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:35748 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933887Ab1FWRiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Amir Goldstein <amir73il@users.sf.net>, Jan Kara <jack@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 221/247] ext3: skip orphan cleanup on rocompat fs
Date: Thu, 23 Jun 2011 13:34:49 -0400
Message-Id: <1308850515-15242-162-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit ce654b37f87980d95f339080e4c3bdb2370bdf22 upstream.

Orphan cleanup is currently executed even if the file system has some
number of unknown ROCOMPAT features, which deletes inodes and frees
blocks, which could be very bad for some RO_COMPAT features.

This patch skips the orphan cleanup if it contains readonly compatible
features not known by this ext3 implementation, which would prevent
the fs from being mounted (or remounted) readwrite.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext3/super.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 1bee604..3614e52 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1441,6 +1441,13 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 		return;
 	}
 
+	/* Check if feature set allows readwrite operations */
+	if (EXT3_HAS_RO_COMPAT_FEATURE(sb, ~EXT3_FEATURE_RO_COMPAT_SUPP)) {
+		ext3_msg(sb, KERN_INFO, "Skipping orphan cleanup due to "
+			 "unknown ROCOMPAT features");
+		return;
+	}
+
 	if (EXT3_SB(sb)->s_mount_state & EXT3_ERROR_FS) {
 		if (es->s_last_orphan)
 			jbd_debug(1, "Errors on filesystem, "
-- 
1.7.4.4

