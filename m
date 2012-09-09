Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab2IIXWF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:22:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51537 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756435Ab2IIXRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:17 -0400
Message-Id: <20120909224156.176504872@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:29 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Theodore Tso <tytso@mit.edu>
Subject: [ 39/95] ext4: fix long mount times on very big file systems
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 0548bbb85337e532ca2ed697c3e9b227ff2ed4b4 upstream.

Commit 8aeb00ff85a: "ext4: fix overhead calculation used by
ext4_statfs()" introduced a O(n**2) calculation which makes very large
file systems take forever to mount.  Fix this with an optimization for
non-bigalloc file systems.  (For bigalloc file systems the overhead
needs to be set in the the superblock.)

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/super.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 56bcaec..5984989 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3120,6 +3120,10 @@ static int count_overhead(struct super_block *sb, ext4_group_t grp,
 	ext4_group_t		i, ngroups = ext4_get_groups_count(sb);
 	int			s, j, count = 0;
 
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_BIGALLOC))
+		return (ext4_bg_has_super(sb, grp) + ext4_bg_num_gdb(sb, grp) +
+			sbi->s_itb_per_group + 2);
+
 	first_block = le32_to_cpu(sbi->s_es->s_first_data_block) +
 		(grp * EXT4_BLOCKS_PER_GROUP(sb));
 	last_block = first_block + EXT4_BLOCKS_PER_GROUP(sb) - 1;


