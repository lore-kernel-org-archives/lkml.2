Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933946Ab2FGE1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:27:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933536Ab2FGEZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:25:50 -0400
Message-Id: <20120607041404.173100907@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:14:40 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tao Ma <boyu.mt@taobao.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 42/47] ext4: dont trash state flags in EXT4_IOC_SETFLAGS
In-Reply-To: <20120607041504.GA13819@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 79906964a187c405db72a3abc60eb9b50d804fbc upstream.

In commit 353eb83c we removed i_state_flags with 64-bit longs, But
when handling the EXT4_IOC_SETFLAGS ioctl, we replace i_flags
directly, which trashes the state flags which are stored in the high
32-bits of i_flags on 64-bit platforms.  So use the the
ext4_{set,clear}_inode_flags() functions which use atomic bit
manipulation functions instead.

Reported-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ioctl.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -35,7 +35,7 @@ long ext4_ioctl(struct file *filp, unsig
 		handle_t *handle = NULL;
 		int err, migrate = 0;
 		struct ext4_iloc iloc;
-		unsigned int oldflags;
+		unsigned int oldflags, mask, i;
 		unsigned int jflag;
 
 		if (!inode_owner_or_capable(inode))
@@ -112,8 +112,14 @@ long ext4_ioctl(struct file *filp, unsig
 		if (err)
 			goto flags_err;
 
-		flags = flags & EXT4_FL_USER_MODIFIABLE;
-		flags |= oldflags & ~EXT4_FL_USER_MODIFIABLE;
+		for (i = 0, mask = 1; i < 32; i++, mask <<= 1) {
+			if (!(mask & EXT4_FL_USER_MODIFIABLE))
+				continue;
+			if (mask & flags)
+				ext4_set_inode_flag(inode, i);
+			else
+				ext4_clear_inode_flag(inode, i);
+		}
 		ei->i_flags = flags;
 
 		ext4_set_inode_flags(inode);


