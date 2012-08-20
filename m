Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab2HTD6m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 23:58:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54493 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab2HTD6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:58:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 18/32] ext4: fix long mount times on very big file systems
Date: Sun, 19 Aug 2012 20:57:14 -0700
Message-Id: <20120820035650.382535526@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035647.862247088@linuxfoundation.org>
References: <20120820035647.862247088@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 0548bbb85337e532ca2ed697c3e9b227ff2ed4b4 upstream.

Commit 8aeb00ff85a: "ext4: fix overhead calculation used by
ext4_statfs()" introduced a O(n**2) calculation which makes very large
file systems take forever to mount.  Fix this with an optimization for
non-bigalloc file systems.  (For bigalloc file systems the overhead
needs to be set in the the superblock.)

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2969,6 +2969,10 @@ static int count_overhead(struct super_b
 	ext4_group_t		i, ngroups = ext4_get_groups_count(sb);
 	int			s, j, count = 0;
 
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_BIGALLOC))
+		return (ext4_bg_has_super(sb, grp) + ext4_bg_num_gdb(sb, grp) +
+			sbi->s_itb_per_group + 2);
+
 	first_block = le32_to_cpu(sbi->s_es->s_first_data_block) +
 		(grp * EXT4_BLOCKS_PER_GROUP(sb));
 	last_block = first_block + EXT4_BLOCKS_PER_GROUP(sb) - 1;


