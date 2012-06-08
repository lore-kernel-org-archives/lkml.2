Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761998Ab2FHFWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:22:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43293 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761304Ab2FHFHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:20 -0400
Message-Id: <20120608041845.812526813@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:17 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Sandeen <sandeen@redhat.com>,
        Andreas Dilger <adilger@whamcloud.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 37/82] ext4: force ro mount if ext4_setup_super() fails
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit 7e84b6216467b84cd332c8e567bf5aa113fd2f38 upstream.

If ext4_setup_super() fails i.e. due to a too-high revision,
the error is logged in dmesg but the fs is not mounted RO as
indicated.

Tested by:

# mkfs.ext4 -r 4 /dev/sdb6
# mount /dev/sdb6 /mnt/test
# dmesg | grep "too high"
[164919.759248] EXT4-fs (sdb6): revision level too high, forcing read-only mode
# grep sdb6 /proc/mounts
/dev/sdb6 /mnt/test2 ext4 rw,seclabel,relatime,data=ordered 0 0

Reviewed-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8dfb42e..d9466a5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3732,7 +3732,8 @@ no_journal:
 		goto failed_mount4;
 	}
 
-	ext4_setup_super(sb, es, sb->s_flags & MS_RDONLY);
+	if (ext4_setup_super(sb, es, sb->s_flags & MS_RDONLY))
+		sb->s_flags |= MS_RDONLY;
 
 	/* determine the minimum size of new large inodes, if present */
 	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE) {


