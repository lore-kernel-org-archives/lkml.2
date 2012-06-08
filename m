Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab2FHFPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:15:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43267 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761250Ab2FHFH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:27 -0400
Message-Id: <20120608041846.878941960@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:25 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Salman Qazi <sqazi@google.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 45/82] ext4: remove mb_groups before tearing down the buddy_cache
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salman Qazi <sqazi@google.com>

commit 95599968d19db175829fb580baa6b68939b320fb upstream.

We can't have references held on pages in the s_buddy_cache while we are
trying to truncate its pages and put the inode.  All the pages must be
gone before we reach clear_inode.  This can only be gauranteed if we
can prevent new users from grabbing references to s_buddy_cache's pages.

The original bug can be reproduced and the bug fix can be verified by:

while true; do mount -t ext4 /dev/ram0 /export/hda3/ram0; \
	umount /export/hda3/ram0; done &

while true; do cat /proc/fs/ext4/ram0/mb_groups; done

Signed-off-by: Salman Qazi <sqazi@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/mballoc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 3d9277c..1cd6994 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2517,6 +2517,9 @@ int ext4_mb_release(struct super_block *sb)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct kmem_cache *cachep = get_groupinfo_cache(sb->s_blocksize_bits);
 
+	if (sbi->s_proc)
+		remove_proc_entry("mb_groups", sbi->s_proc);
+
 	if (sbi->s_group_info) {
 		for (i = 0; i < ngroups; i++) {
 			grinfo = ext4_get_group_info(sb, i);
@@ -2564,8 +2567,6 @@ int ext4_mb_release(struct super_block *sb)
 	}
 
 	free_percpu(sbi->s_locality_groups);
-	if (sbi->s_proc)
-		remove_proc_entry("mb_groups", sbi->s_proc);
 
 	return 0;
 }


