Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1EQMbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:31:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63946 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab1EQMbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:31:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=haCIDexqUoaKZYBBhMt+CaC/nLEE7uWp8QV7xpWioq/9P9iTnpKbcCfjvf31DmNx18
         LBpej3gr7CPJCPFPs5d8CXRKzY63Vt+vdhrzNw9121+XDnP4riOqhmFCxpBfKSYt4Lab
         /g+0sr2a/b9900/hLlJViocdnZ7COYW2GtVS0=
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        mszeredi@suse.cz
Subject: [PATCH 7/7] overlay: overlay filesystem documentation
Date: Tue, 17 May 2011 14:30:52 +0200
Message-Id: <1305635452-14835-8-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Brown <neilb@suse.de>

Document the overlay filesystem.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 Documentation/filesystems/overlayfs.txt |  167 +++++++++++++++++++++++++++++++
 MAINTAINERS                             |    7 ++
 2 files changed, 174 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/overlayfs.txt

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
new file mode 100644
index 0000000..4bc0b34
--- /dev/null
+++ b/Documentation/filesystems/overlayfs.txt
@@ -0,0 +1,167 @@
+Written by: Neil Brown <neilb@suse.de>
+
+Overlay Filesystem
+==================
+
+This document describes a prototype for a new approach to providing
+overlay-filesystem functionality in Linux (sometimes referred to as
+union-filesystems).  An overlay-filesystem tries to present a
+filesystem which is the result over overlaying one filesystem on top
+of the other.
+
+The result will inevitably fail to look exactly like a normal
+filesystem for various technical reasons.  The expectation is that
+many use cases will be able to ignore these differences.
+
+This approach is 'hybrid' because the objects that appear in the
+filesystem do not all appear to belong to that filesystem.  In many
+cases an object accessed in the union will be indistinguishable
+from accessing the corresponding object from the original filesystem.
+This is most obvious from the 'st_dev' field returned by stat(2).
+
+While directories will report an st_dev from the overlay-filesystem,
+all non-directory objects will report an st_dev from the lower or
+upper filesystem that is providing the object.  Similarly st_ino will
+only be unique when combined with st_dev, and both of these can change
+over the lifetime of a non-directory object.  Many applications and
+tools ignore these values and will not be affected.
+
+Upper and Lower
+---------------
+
+An overlay filesystem combines two filesystems - an 'upper' filesystem
+and a 'lower' filesystem.  When a name exists in both filesystems, the
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
+not need to be writable.  The lower filesystem can even be another
+overlayfs.  The upper filesystem will normally be writable and if it
+is it must support the creation of trusted.* extended attributes, and
+must provide valid d_type in readdir responses, at least for symbolic
+links - so NFS is not suitable.
+
+A read-only overlay of two read-only filesystems may use any
+filesystem type.
+
+Directories
+-----------
+
+Overlaying mainly involved directories.  If a given name appears in both
+upper and lower filesystems and refers to a non-directory in either,
+then the lower object is hidden - the name refers only to the upper
+object.
+
+Where both upper and lower objects are directories, a merged directory
+is formed.
+
+At mount time, the two directories given as mount options are combined
+into a merged directory:
+
+  mount -t overlayfs overlayfs -olowerdir=/lower,upperdir=/upper /overlay
+
+Then whenever a lookup is requested in such a merged directory, the
+lookup is performed in each actual directory and the combined result
+is cached in the dentry belonging to the overlay filesystem.  If both
+actual lookups find directories, both are stored and a merged
+directory is created, otherwise only one is stored: the upper if it
+exists, else the lower.
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
+files etc.) are presented either from the upper or lower filesystem as
+appropriate.  When a file in the lower filesystem is accessed in a way
+the requires write-access, such as opening for write access, changing
+some metadata etc., the file is first copied from the lower filesystem
+to the upper filesystem (copy_up).  Note that creating a hard-link
+also requires copy_up, though of course creation of a symlink does
+not.
+
+The copy_up process first makes sure that the containing directory
+exists in the upper filesystem - creating it and any parents as
+necessary.  It then creates the object with the same metadata (owner,
+mode, mtime, symlink-target etc.) and then if the object is a file, the
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
+the future.
diff --git a/MAINTAINERS b/MAINTAINERS
index 16a5c5f..a3bf3ec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4682,6 +4682,13 @@ F:	drivers/scsi/osd/
 F:	include/scsi/osd_*
 F:	fs/exofs/
 
+OVERLAYFS FILESYSTEM
+M:	Miklos Szeredi <miklos@szeredi.hu>
+L:	linux-fsdevel@vger.kernel.org
+S:	Supported
+F:	fs/overlayfs/*
+F:	Documentation/filesystems/overlayfs.txt
+
 P54 WIRELESS DRIVER
 M:	Christian Lamparter <chunkeey@googlemail.com>
 L:	linux-wireless@vger.kernel.org
-- 
1.7.3.4

