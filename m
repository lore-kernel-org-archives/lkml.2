Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab0K0W5Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 17:57:16 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46384 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab0K0W5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 17:57:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JXhyPcytG6qGNrubjWZYkBYMxvFmTDbc0Ti20C3cGcu3nuXCZBepbekbNH/XOslDYp
         Sz4M8ir7TXJtMiBy40OWuUgAd6gnZR9RidUiHk0/+bfsciPoq6Ahh3Uw+0SNtDDKCtm9
         VexkE95t1T0ZSkrRog0VbgCZ1n98D+ZzeViac=
Date: Sat, 27 Nov 2010 16:57:06 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sage Weil <sage@newdream.net>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] vfs: introduce FS_IOC_SYNCFS to sync a single super
Message-ID: <20101127225706.GA28927@burratino>
References: <Pine.LNX.4.64.1008090711040.17515@cobra.newdream.net>
 <201008092055.07248.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008092055.07248.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:

> You need to add this to the compat_ioctl handling as well, otherwise
> it won't work when you run a 32 bit process in a 64 bit kernel.
> 
> Adding it to the ioctl_pointer[] array is probably the easiest way.

Here's a patch for squashing (plus another tweak: renumbering the
ioctl to avoid a conflict with EXT4_IOC_ALLOC_DA_BLKS).

-- 8< --
Subject: FS_IOC_SYNCFS: finishing touches

This ioctl has the same ABI for 32-bit and 64-bit use; record
that in compat_ioctl.c.

Change ioctl number from _IO('f', 12) to _IO('f', 16) since the
former is taken by EXT4_IOC_ALLOC_DA_BLKS.

Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 Documentation/ioctl/ioctl-number.txt |    2 +-
 fs/compat_ioctl.c                    |    1 +
 fs/ext4/ext4.h                       |    1 +
 include/linux/fs.h                   |    3 ++-
 4 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 63ffd78..3644ba9 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -212,7 +212,7 @@ Code  Seq#(hex)	Include File		Comments
 'f'	00-1F	linux/ext3_fs.h		conflict!
 'f'	00-0F	fs/jfs/jfs_dinode.h	conflict!
 'f'	00-0F	fs/ext4/ext4.h		conflict!
-'f'	00-0F	linux/fs.h		conflict!
+'f'	00-1F	linux/fs.h		conflict!
 'f'	00-0F	fs/ocfs2/ocfs2_fs.h	conflict!
 'g'	00-0F	linux/usb/gadgetfs.h
 'g'	20-2F	linux/usb/g_printer.h
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index a60579b..0989acf 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -876,6 +876,7 @@ COMPATIBLE_IOCTL(FIOASYNC)
 COMPATIBLE_IOCTL(FIONBIO)
 COMPATIBLE_IOCTL(FIONREAD)  /* This is also TIOCINQ */
 COMPATIBLE_IOCTL(FS_IOC_FIEMAP)
+COMPATIBLE_IOCTL(FS_IOC_SYNCFS)
 /* 0x00 */
 COMPATIBLE_IOCTL(FIBMAP)
 COMPATIBLE_IOCTL(FIGETBSZ)
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6a5edea..178d70b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -541,6 +541,7 @@ struct ext4_new_group_data {
  /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
 #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
 #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
+ /* note ioctls 16- reserved for filesystem-independent ioctls */
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 525ecdd..24c6d42 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -331,7 +331,8 @@ struct inodes_stat_t {
 #define	FS_IOC_GETVERSION		_IOR('v', 1, long)
 #define	FS_IOC_SETVERSION		_IOW('v', 2, long)
 #define FS_IOC_FIEMAP			_IOWR('f', 11, struct fiemap)
-#define FS_IOC_SYNCFS                   _IO('f', 12)
+ /* 12-15 are for filesystem-specific ioctls */
+#define FS_IOC_SYNCFS			_IO('f', 16)
 #define FS_IOC32_GETFLAGS		_IOR('f', 1, int)
 #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
 #define FS_IOC32_GETVERSION		_IOR('v', 1, int)
-- 
1.7.2.3

