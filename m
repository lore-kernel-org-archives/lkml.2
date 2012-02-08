Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab2BHXrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 18:47:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37553 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853Ab2BHXrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 18:47:06 -0500
Date: Thu, 9 Feb 2012 00:47:03 +0100
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        mpatocka@redhat.com, sandeen@sandeen.net
Subject: Re: [PATCH 1/2] vfs: Provide function to get superblock and wait
 for it to thaw
Message-ID: <20120208234703.GG1696@quack.suse.cz>
References: <1328654267-18855-1-git-send-email-jack@suse.cz>
 <1328654267-18855-2-git-send-email-jack@suse.cz>
 <20120208232049.GC7479@dastard>
 <20120208232705.GF1696@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
In-Reply-To: <20120208232705.GF1696@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 09-02-12 00:27:05, Jan Kara wrote:
> On Thu 09-02-12 10:20:49, Dave Chinner wrote:
> > On Tue, Feb 07, 2012 at 11:37:46PM +0100, Jan Kara wrote:
> > > In quota code we need to find a superblock corresponding to a device and wait
> > > for superblock to be unfrozen. However this waiting has to happen without
> > > s_umount semaphore because that is required for superblock to thaw. So provide
> > > a function in VFS for this to keep dances with s_umount where they belong.
> > > 
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > ---
> > >  fs/super.c         |   47 +++++++++++++++++++++++++++++++++++------------
> > >  include/linux/fs.h |    1 +
> > >  2 files changed, 36 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/fs/super.c b/fs/super.c
> > > index 6015c02..e320239 100644
> > > --- a/fs/super.c
> > > +++ b/fs/super.c
> > > @@ -593,15 +593,7 @@ void iterate_supers_type(struct file_system_type *type,
> > >  
> > >  EXPORT_SYMBOL(iterate_supers_type);
> > >  
> > > -/**
> > > - *	get_super - get the superblock of a device
> > > - *	@bdev: device to get the superblock for
> > > - *	
> > > - *	Scans the superblock list and finds the superblock of the file system
> > > - *	mounted on the device given. %NULL is returned if no match is found.
> > > - */
> > > -
> > > -struct super_block *get_super(struct block_device *bdev)
> > > +static struct super_block *__get_super(struct block_device *bdev, bool thawed)
> > >  {
> > >  	struct super_block *sb;
> > >  
> > > @@ -618,9 +610,13 @@ rescan:
> > >  			spin_unlock(&sb_lock);
> > >  			down_read(&sb->s_umount);
> > >  			/* still alive? */
> > > -			if (sb->s_root && (sb->s_flags & MS_BORN))
> > > -				return sb;
> > > -			up_read(&sb->s_umount);
> > > +			if (sb->s_root && (sb->s_flags & MS_BORN)) {
> > > +				if (sb->s_frozen == SB_UNFROZEN)
> > > +					return sb;
> > > +				up_read(&sb->s_umount);
> > > +				vfs_check_frozen(sb, SB_FREEZE_WRITE);
> > > +			} else
> > > +				up_read(&sb->s_umount);
> > >  			/* nope, got unmounted */
> > >  			spin_lock(&sb_lock);
> > >  			__put_super(sb);
> > > @@ -631,9 +627,36 @@ rescan:
> > >  	return NULL;
> > >  }
> > 
> > The thawed parameter appears to be unused and the waiting for frozen
> > filesystems appears to happen for all callers. Is this intentional?
>   Ah, sorry. Obviously that's a bug. Thanks for spotting it. I'll fix it
> up.
  Attached is a fixed version.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--vGgW1X5XWziG23Ko
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-vfs-Provide-function-to-get-superblock-and-wait-for-.patch"

>From 5dce7adb0c281612a14fa3dd8c8d5ef3f5eb3666 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 7 Feb 2012 22:59:06 +0100
Subject: [PATCH 1/2] vfs: Provide function to get superblock and wait for it to thaw

In quota code we need to find a superblock corresponding to a device and wait
for superblock to be unfrozen. However this waiting has to happen without
s_umount semaphore because that is required for superblock to thaw. So provide
a function in VFS for this to keep dances with s_umount where they belong.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/super.c         |   47 +++++++++++++++++++++++++++++++++++------------
 include/linux/fs.h |    1 +
 2 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 6015c02..e15aaa9 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -593,15 +593,7 @@ void iterate_supers_type(struct file_system_type *type,
 
 EXPORT_SYMBOL(iterate_supers_type);
 
-/**
- *	get_super - get the superblock of a device
- *	@bdev: device to get the superblock for
- *	
- *	Scans the superblock list and finds the superblock of the file system
- *	mounted on the device given. %NULL is returned if no match is found.
- */
-
-struct super_block *get_super(struct block_device *bdev)
+static struct super_block *__get_super(struct block_device *bdev, bool thawed)
 {
 	struct super_block *sb;
 
@@ -618,9 +610,13 @@ rescan:
 			spin_unlock(&sb_lock);
 			down_read(&sb->s_umount);
 			/* still alive? */
-			if (sb->s_root && (sb->s_flags & MS_BORN))
-				return sb;
-			up_read(&sb->s_umount);
+			if (sb->s_root && (sb->s_flags & MS_BORN)) {
+				if (!thawed || sb->s_frozen == SB_UNFROZEN)
+					return sb;
+				up_read(&sb->s_umount);
+				vfs_check_frozen(sb, SB_FREEZE_WRITE);
+			} else
+				up_read(&sb->s_umount);
 			/* nope, got unmounted */
 			spin_lock(&sb_lock);
 			__put_super(sb);
@@ -631,9 +627,36 @@ rescan:
 	return NULL;
 }
 
+/**
+ *	get_super - get the superblock of a device
+ *	@bdev: device to get the superblock for
+ *
+ *	Scans the superblock list and finds the superblock of the file system
+ *	mounted on the device given. %NULL is returned if no match is found.
+ */
+
+struct super_block *get_super(struct block_device *bdev)
+{
+	return __get_super(bdev, false);
+}
 EXPORT_SYMBOL(get_super);
 
 /**
+ *	get_super_thawed - get thawed superblock of a device
+ *	@bdev: device to get the superblock for
+ *
+ *	Scans the superblock list and finds the superblock of the file system
+ *	mounted on the device given once the superblock is thawed. %NULL is
+ *	returned if no match is found.
+ */
+
+struct super_block *get_super_thawed(struct block_device *bdev)
+{
+	return __get_super(bdev, true);
+}
+EXPORT_SYMBOL(get_super_thawed);
+
+/**
  * get_active_super - get an active reference to the superblock of a device
  * @bdev: device to get the superblock for
  *
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 386da09..69cd5bb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2496,6 +2496,7 @@ extern void get_filesystem(struct file_system_type *fs);
 extern void put_filesystem(struct file_system_type *fs);
 extern struct file_system_type *get_fs_type(const char *name);
 extern struct super_block *get_super(struct block_device *);
+extern struct super_block *get_super_thawed(struct block_device *);
 extern struct super_block *get_active_super(struct block_device *bdev);
 extern void drop_super(struct super_block *sb);
 extern void iterate_supers(void (*)(struct super_block *, void *), void *);
-- 
1.7.1


--vGgW1X5XWziG23Ko--
