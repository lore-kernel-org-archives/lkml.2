Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab1DYUsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:48:20 -0400
Received: from 1wt.eu ([62.212.114.60]:34222 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756954Ab1DYUYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:37 -0400
Message-Id: <20110425200237.555651538@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:17 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Amir Goldstein <amir73il@users.sf.net>, Jan Kara <jack@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 105/173] ext3: skip orphan cleanup on rocompat fs
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit ce654b37f87980d95f339080e4c3bdb2370bdf22 upstream.

Orphan cleanup is currently executed even if the file system has some
number of unknown ROCOMPAT features, which deletes inodes and frees
blocks, which could be very bad for some RO_COMPAT features.

This patch skips the orphan cleanup if it contains readonly compatible
features not known by this ext3 implementation, which would prevent
the fs from being mounted (or remounted) readwrite.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext3/super.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1404,6 +1404,13 @@ static void ext3_orphan_cleanup (struct
 		return;
 	}
 
+	/* Check if feature set allows readwrite operations */
+	if (EXT3_HAS_RO_COMPAT_FEATURE(sb, ~EXT3_FEATURE_RO_COMPAT_SUPP)) {
+		printk(KERN_INFO "EXT3-fs: %s: Skipping orphan cleanup due to "
+			 "unknown ROCOMPAT features\n", sb->s_id);
+		return;
+	}
+
 	if (EXT3_SB(sb)->s_mount_state & EXT3_ERROR_FS) {
 		if (es->s_last_orphan)
 			jbd_debug(1, "Errors on filesystem, "


