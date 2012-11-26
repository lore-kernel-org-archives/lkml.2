Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812Ab2KZRMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:12:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48001 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab2KZRMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:12:46 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lukas Czerner <lczerner@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 206/270] ext4: Avoid underflow in ext4_trim_fs()
Date: Mon, 26 Nov 2012 14:58:16 -0200
Message-Id: <1353949160-26803-207-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Czerner <lczerner@redhat.com>

commit 5de35e8d5c02d271c20e18337e01bc20e6ef472e upstream.

Currently if len argument in ext4_trim_fs() is smaller than one block,
the 'end' variable underflow. Avoid that by returning EINVAL if len is
smaller than file system block.

Also remove useless unlikely().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ext4/mballoc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 70f97a5..af848bb 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4983,8 +4983,9 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	end = start + (range->len >> sb->s_blocksize_bits) - 1;
 	minlen = range->minlen >> sb->s_blocksize_bits;
 
-	if (unlikely(minlen > EXT4_CLUSTERS_PER_GROUP(sb)) ||
-	    unlikely(start >= max_blks))
+	if (minlen > EXT4_CLUSTERS_PER_GROUP(sb) ||
+	    start >= max_blks ||
+	    range->len < sb->s_blocksize)
 		return -EINVAL;
 	if (end >= max_blks)
 		end = max_blks - 1;
-- 
1.7.9.5

