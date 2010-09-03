Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab0ICNmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:42:09 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58615 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab0ICNmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:42:06 -0400
Message-Id: <20100903134159.824920212@szeredi.hu>
References: <20100903134116.039612691@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Fri, 03 Sep 2010 15:41:22 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk
Subject: [PATCH 6/6] overlay: overlay filesystem documentation
Content-Disposition: inline; filename=overlayfs-documentation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Brown <neilb@suse.de>

Document the overlay filesystem.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 Documentation/filesystems/overlayfs.txt |  162 ++++++++++++++++++++++++++++++++
 1 file changed, 162 insertions(+)

Index: linux-2.6/Documentation/filesystems/overlayfs.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/Documentation/filesystems/overlayfs.txt	2010-08-31 18:41:33.000000000 +0200
@@ -0,0 +1,162 @@
+Written by: Neil Brown <neilb@suse.de>
+
+Overlay Filesystem
+==================
+
+This document describes a prototype for a new approach to providing
+union-filesystem functionality in Linux.  A union-filesystem tries to
+present the union of two different filesystems as though it were a
+single filesystem.  The result will inevitably fail to look exactly
+like a normal filesystem for various technical reasons.  The
+expectation is that many use cases will be able to ignore these
+differences.
+
+This approach is 'hybrid' because the objects that appear in the
+filesystem do not all appear to belong to that filesystem.  In many
+case an object accessed in the union will be indistinguishable
+from accessing the corresponding object from the original filesystem.
+This is most obvious from the 'st_dev' field returned by stat(2).
+Some objects will report an st_dev from one original filesystem, some
+from the other, directories will report an st_dev from the union
+itself.  Similarly st_ino will only be unique when combined with
+st_dev, and both of these can change over the lifetime of a
+non-directory object.  Many applications and tools ignore these values
+and will not be affected.
+
+Upper and Lower
+---------------
+
+An overlay filesystem combines two filesystems - an 'upper' filesystem
+and a 'lower' filesystem.  Note that while in set theory, 'union' is a
+commutative operation, in filesystems it is not - the two filesystems
+are treated differently.  When a name exists in both filesystems, the
+object in the 'upper' filesystem is visible while the object in the
+'lower' filesystem is either hidden or, in the case of directories,
+merged with the 'upper' object.
+
+It would be more correct to refer to an upper and lower 'directory
+tree' rather than 'filesystem' as it is quite possible for both
+directory trees to be in the same filesystem and there is no
+requirement that the root of a filesystem be given for either upper or
+lower.
+
+The lower filesystem can be any filesystem supported by Linux and does
+not need to be writable.  Theoretically it could even be another
+overlayfs, but this is not yet supported.  The upper filesystem will
+normally be writeable and if it is it must support the creation of
+trusted.* extended attributes, and must provide valid d_type in
+readdir responses, at least for symbolic links - so NFS is not
+suitable.
+
+A read-only union of two read-only filesystems may use any filesystem
+type.
+
+Directories
+-----------
+
+Unioning mainly involved directories.  If a given name appears in both
+upper ad lower filesystems and refers to a non-directory in either,
+then the lower object is hidden - the name refers only to the upper
+object.
+
+Where both upper and lower objects are directories, a merged directory
+is formed.
+
+At mount time, the two directories given as mount options are combined
+into a merged directory.  Then whenever a lookup is requested in such
+a merged directory, the lookup is performed in each actual directory
+and the combined result is cached in the dentry belonging to the overlay
+filesystem.  If both actual lookups find directories, both are stored
+and a merged directory is create, otherwise only one is stored: the
+upper if it exists, else the lower.
+
+Only the lists of names from directories are merged.  Other content
+such as metadata and extended attributes are reported for the upper
+directory only.  These attributes of the lower directory are hidden.
+
+whiteouts and opaque directories
+--------------------------------
+
+In order to support rm and rmdir without changing the lower
+filesystem, an overlay filesystem needs to record in the upper filesystem
+that files have been removed.  This is done using whiteouts and opaque
+directories (non-directories are always opaque).
+
+The overlay filesystem uses extended attributes with a
+"trusted.overlay."  prefix to record these details.
+
+A whiteout is created as a symbolic link with target
+"(overlay-whiteout)" and with xattr "trusted.overlay.whiteout" set to "y".
+When a whiteout is found in the upper level of a merged directory, any
+matching name in the lower level is ignored, and the whiteout itself
+is also hidden.
+
+A directory is made opaque by setting the xattr "trusted.overlay.opaque"
+to "y".  Where the upper filesystem contains an opaque directory, any
+directory in the lower filesystem with the same name is ignored.
+
+readdir
+-------
+
+When a 'readdir' request is made on a merged directory, the upper and
+lower directories are each read and the name lists merged in the
+obvious way (upper is read first, then lower - entries that already
+exist are not re-added).  This merged name list is cached in the
+'struct file' and so remains as long as the file is kept open.  If the
+directory is opened and read by two processes at the same time, they
+will each have separate caches.  A seekdir to the start of the
+directory (offset 0) followed by a readdir will cause the cache to be
+discarded and rebuilt.
+
+This means that changes to the merged directory do not appear while a
+directory is being read.  This is unlikely to be noticed by many
+programs.
+
+seek offsets are assigned sequentially when the directories are read.
+Thus if
+  - read part of a directory
+  - remember an offset, and close the directory
+  - re-open the directory some time later
+  - seek to the remembered offset
+
+there may be little correlation between the old and new locations in
+the list of filenames, particularly if anything has changed in the
+directory.
+
+Readdir on directories that are not merged is simply handled by the
+underlying directory (upper or lower).
+
+
+Non-directories
+---------------
+
+Objects that are not directories (files, symlinks, device-special
+files etc) are presented either from the upper or lower filesystem as
+appropriate.  When a file in the lower filesystem is accessed in a way
+the requires write-access; such as opening for write access, changing
+some metadata etc, the file is first copied from the lower filesystem
+to the upper filesystem (copy_up).  Note that creating a hard-link
+also requires copy-up, though of course creation of a symlink does
+not.
+
+The copy_up process first makes sure that the containing directory
+exists in the upper filesystem - creating it and any parents as
+necessary.  It then creates the object with the same metadata (owner,
+mode, mtime, symlink-target etc) and then if the object is a file, the
+data is copied from the lower to the upper filesystem.  Finally any
+extended attributes are copied up.
+
+Once the copy_up is complete, the overlay filesystem simply
+provides direct access to the newly created file in the upper
+filesystem - future operations on the file are barely noticed by the
+overlay filesystem (though an operation on the name of the file such as
+rename or unlink will of course be noticed and handled).
+
+Changes to underlying filesystems
+---------------------------------
+
+Offline changes, when the overlay is not mounted, are allowed to either
+the upper or the lower trees.
+
+Changes to the underlying filesystems while part of a mounted overlay
+filesystem are not allowed.  This is not yet enforced, but will be in

-- 
