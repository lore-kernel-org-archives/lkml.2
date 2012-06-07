Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab2FGEUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:20:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932807Ab2FGEUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:20:08 -0400
Message-Id: <20120607040345.089064266@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:36 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andreas Dilger <adilger@whamcloud.com>,
        Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 60/82] ext4: force ro mount if ext4_setup_super() fails
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3592,7 +3592,8 @@ no_journal:
 		goto failed_mount4;
 	}
 
-	ext4_setup_super(sb, es, sb->s_flags & MS_RDONLY);
+	if (ext4_setup_super(sb, es, sb->s_flags & MS_RDONLY))
+		sb->s_flags |= MS_RDONLY;
 
 	/* determine the minimum size of new large inodes, if present */
 	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE) {


