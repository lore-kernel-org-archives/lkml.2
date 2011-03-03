Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab1CCQ54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 11:57:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758494Ab1CCQ5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 11:57:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/3] Update the automount document to reflect the new VFS
 automounting hook
To: viro@ZenIV.linux.org.uk, hch@infradead.org, raven@themaw.net
Cc: linux-devel@vger.kernel.org, autofs@linux.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Thu, 03 Mar 2011 16:57:38 +0000
Message-ID: <20110303165738.9550.2251.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the automount document to reflect the new VFS automounting hook
(d_automount()).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/automount-support.txt |  150 ++++++++++++++++-------
 Documentation/filesystems/vfs.txt               |    3 
 fs/namei.c                                      |    1 
 3 files changed, 109 insertions(+), 45 deletions(-)

diff --git a/Documentation/filesystems/automount-support.txt b/Documentation/filesystems/automount-support.txt
index 7cac200..c0512b7 100644
--- a/Documentation/filesystems/automount-support.txt
+++ b/Documentation/filesystems/automount-support.txt
@@ -1,59 +1,117 @@
-Support is available for filesystems that wish to do automounting support (such
-as kAFS which can be found in fs/afs/). This facility includes allowing
-in-kernel mounts to be performed and mountpoint degradation to be
-requested. The latter can also be requested by userspace.
+			 ============================
+			 VFS SUPPORT FOR AUTOMOUNTING
+			 ============================
+
+Support is available for filesystems that wish to do automounting (such as AFS,
+CIFS, NFS and autofs).  This facility includes allowing in-kernel mounts to be
+performed and mountpoint expiry to be requested.
+
+An automount point is a dentry that has DCACHE_NEED_AUTOMOUNT set upon it.  It
+must also be furnished with a d_automount() dentry operation.
+
+A d_automount() dentry op can be given to any directory or other file type.  It
+will be ignored unless the flag is also set.  This means that the dentry op
+table can be shared with non-automount point objects.
+
+An S_AUTOMOUNT inode flag is also defined that can be used to mark an inode as
+being an automount point.  This is automatically propagated to the dentry by
+__d_instantiate(), and thus those dcache functions that call it, such as
+d_add().
+
+
+==============================
+THE AUTOMOUNT DENTRY OPERATION
+==============================
+
+The automount dentry operation must be a function matching the following
+prototype:
+
+	struct vfsmount *foo_d_automount(struct path *mountpoint);
+
+It is passed a pointer to a path node describing the directory to be mounted
+upon.  It is assumed that the data associated with this directory will be
+sufficient to detail the volume or device that should be mounted on this
+mountpoint.
+
+This function will be called from pathwalk in refwalk mode with no locks held,
+so it is safe to sleep here (it is assumed that you will need to sleep to get
+the new superblock and root directory).
+
+On return, under normal successful conditions, the function should return the
+new vfsmount and the caller will mount it.  If the mount should expire at some
+future date, it should be placed on the expiry list with mnt_set_expiry()
+before returning and the expiry procedure started.  The new vfsmount should be
+returned with at least two references upon so that if it is on an expiry list,
+mark_mounts_for_expiry() won't delete it if the caller has to sleep.
+
+The function may return NULL if it managed to mount on the mountpoint itself
+(say by invoking a userspace daemon).  It should not use mountpoint->mnt to do
+this.  In this case, the caller will loop around and simply check for a new
+mount having appeared on this dentry in this namespace.
+
+The function may return -EISDIR to indicate it wants the caller to ignore the
+automount flag and let the user see the underlying directory.  This is needed
+to have a userspace daemon perform the mount.
+
+Otherwise the function should return an error code to terminate pathwalk with
+that error.
+
+If a new vfsmount is returned, but the caller fails to perform do_add_mount()
+upon it, then then the vfsmount will be unlinked from the expiry list and both
+the refs upon it will be released.
+
+Note that if this function is called more than 40 times in a given pathwalk,
+-ELOOP will be given instead of calling this again.  The check makes use of the
+symbolic link handling variables, so any symbolic links traversed will reduce
+this number.
 
 
 ======================
 IN-KERNEL AUTOMOUNTING
 ======================
 
-A filesystem can now mount another filesystem on one of its directories by the
-following procedure:
+A filesystem will now normally mount another filesystem on one of its
+directories by the following procedure:
 
- (1) Give the directory a follow_link() operation.
+ (1) Set the S_AUTOMOUNT flag on the inode for an automount directory.  If the
+     filesystem's automount points are not directories (e.g. AFS), they must be
+     converted to be so.
 
-     When the directory is accessed, the follow_link op will be called, and
-     it will be provided with the location of the mountpoint in the nameidata
-     structure (vfsmount and dentry).
+ (2) Give dentries of such directories a d_automount() dentry operation.  When
+     an attempt is made to traverse the directory, the d_automount() op will be
+     called, and it will be provided with the location of the mountpoint in the
+     VFS directory tree.
 
- (2) Have the follow_link() op do the following steps:
+ (2) Have the d_automount() op do the following steps:
 
      (a) Call vfs_kern_mount() to call the appropriate filesystem to set up a
          superblock and gain a vfsmount structure representing it.
 
-     (b) Copy the nameidata provided as an argument and substitute the dentry
-	 argument into it the copy.
-
-     (c) Call do_add_mount() to install the new vfsmount into the namespace's
-	 mountpoint tree, thus making it accessible to userspace. Use the
-	 nameidata set up in (b) as the destination.
+     (b) The ref count of the vfsmount must be incremented.  This will prevent
+     	 automatic expiry if that is used.  The increment is mandatory either
+     	 way.
 
-	 If the mountpoint will be automatically expired, then do_add_mount()
-	 should also be given the location of an expiration list (see further
-	 down).
+     (c) If the new vfsmount will be automatically expired, then
+     	 mnt_set_expiry() should be called for it and the expiry procedure
+     	 started.
 
-     (d) Release the path in the nameidata argument and substitute in the new
-	 vfsmount and its root dentry. The ref counts on these will need
-	 incrementing.
+     (d) Return the vfsmount to the caller to be added into the mount tree.
 
 Then from userspace, you can just do something like:
 
-	[root@andromeda root]# mount -t afs \#root.afs. /afs
-	[root@andromeda root]# ls /afs
-	asd  cambridge  cambridge.redhat.com  grand.central.org
-	[root@andromeda root]# ls /afs/cambridge
-	afsdoc
-	[root@andromeda root]# ls /afs/cambridge/afsdoc/
-	ChangeLog  html  LICENSE  pdf  RELNOTES-1.2.2
+	root# mount -t afs "#grand.central.org:root.cell." /afs -o autocell
+	root# ls /afs
+	archive/  cvs/  doc/  local/  project/  service/  software/  user/  www/
+	root# ls /afs/archive/linuxdev/fedora9/i386/repodata/
+	filelists.xml.gz  other.xml.gz  primary.xml.gz  repomd.xml
 
 And then if you look in the mountpoint catalogue, you'll see something like:
 
 	[root@andromeda root]# cat /proc/mounts
 	...
-	#root.afs. /afs afs rw 0 0
-	#root.cell. /afs/cambridge.redhat.com afs rw 0 0
-	#afsdoc. /afs/cambridge.redhat.com/afsdoc afs rw 0 0
+	#grand.central.org:root.cell. /afs afs rw,relatime,autocell 0 0
+	#root.archive. /afs/archive afs rw,relatime,cell=grand.central.org 0 0
+	#a.linuxdev. /afs/archive/linuxdev afs rw,relatime,cell=grand.central.org 0 0
 
 
 ===========================
@@ -65,28 +123,30 @@ mountpoint to be expired in the automounting procedure outlined above.
 
 To do expiration, you need to follow these steps:
 
- (3) Create at least one list off which the vfsmounts to be expired can be
-     hung. Access to this list will be governed by the vfsmount_lock.
+ (1) Create at least one list off which the vfsmounts to be expired can be
+     hung.  Access to this list will be governed by namespace_sem and
+     vfsmount_lock.
 
- (4) In step (2c) above, the call to do_add_mount() should be provided with a
-     pointer to this list. It will hang the vfsmount off of it if it succeeds.
+ (2) In step (2c) above, mnt_set_expiry() should be called with a pointer to
+     this list. It will add the vfsmount to the list with the appropriate locks
+     held.
 
- (5) When you want mountpoints to be expired, call mark_mounts_for_expiry()
-     with a pointer to this list. This will process the list, marking every
-     vfsmount thereon for potential expiry on the next call.
+ (3) To cause mountpoints to expire, call mark_mounts_for_expiry() with a
+     pointer to this list.  This will process the list, marking every vfsmount
+     thereon for potential expiry on the next call.
 
      If a vfsmount was already flagged for expiry, and if its usage count is 1
-     (it's only referenced by its parent vfsmount), then it will be deleted
+     (ie. it's only referenced by its parent vfsmount), then it will be deleted
      from the namespace and thrown away (effectively unmounted).
 
      It may prove simplest to simply call this at regular intervals, using
      some sort of timed event to drive it.
 
-The expiration flag is cleared by calls to mntput. This means that expiration
+The expiration flag is cleared by calls to mntput.  This means that expiration
 will only happen on the second expiration request after the last time the
 mountpoint was accessed.
 
-If a mountpoint is moved, it gets removed from the expiration list. If a bind
+If a mountpoint is moved, it gets removed from the expiration list.  If a bind
 mount is made on an expirable mount, the new vfsmount will not be on the
 expiration list and will not expire.
 
@@ -101,8 +161,8 @@ USERSPACE DRIVEN EXPIRY
 
 As an alternative, it is possible for userspace to request expiry of any
 mountpoint (though some will be rejected - the current process's idea of the
-rootfs for example). It does this by passing the MNT_EXPIRE flag to
-umount(). This flag is considered incompatible with MNT_FORCE and MNT_DETACH.
+rootfs for example).  It does this by passing the MNT_EXPIRE flag to umount().
+This flag is considered incompatible with MNT_FORCE and MNT_DETACH.
 
 If the mountpoint in question is in referenced by something other than
 umount() or its parent mountpoint, an EBUSY error will be returned and the
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 94cf97b..c6878a0 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -952,6 +952,9 @@ struct dentry_operations {
 	dentry.  This is set by __d_instantiate() if S_AUTOMOUNT is set on the
 	inode being added.
 
+	See Documentation/filesystems/automount-support.txt for more
+	information.
+
   d_manage: called to allow the filesystem to manage the transition from a
 	dentry (optional).  This allows autofs, for example, to hold up clients
 	waiting to explore behind a 'mountpoint' whilst letting the daemon go
diff --git a/fs/namei.c b/fs/namei.c
index 0087cf9..97c92a2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -869,6 +869,7 @@ int follow_up(struct path *path)
  * Perform an automount
  * - return -EISDIR to tell follow_managed() to stop and return the path we
  *   were called with.
+ * - see Documentation/filesystems/automount-support.txt.
  */
 static int follow_automount(struct path *path, unsigned flags,
 			    bool *need_mntput)

