Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab2FGEUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:20:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932803Ab2FGEUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:20:36 -0400
Message-Id: <20120607040346.052545632@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:42 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Salman Qazi <sqazi@google.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 66/82] ext4: remove mb_groups before tearing down the buddy_cache
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/mballoc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2517,6 +2517,9 @@ int ext4_mb_release(struct super_block *
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct kmem_cache *cachep = get_groupinfo_cache(sb->s_blocksize_bits);
 
+	if (sbi->s_proc)
+		remove_proc_entry("mb_groups", sbi->s_proc);
+
 	if (sbi->s_group_info) {
 		for (i = 0; i < ngroups; i++) {
 			grinfo = ext4_get_group_info(sb, i);
@@ -2564,8 +2567,6 @@ int ext4_mb_release(struct super_block *
 	}
 
 	free_percpu(sbi->s_locality_groups);
-	if (sbi->s_proc)
-		remove_proc_entry("mb_groups", sbi->s_proc);
 
 	return 0;
 }


