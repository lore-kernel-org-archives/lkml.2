Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab0HZUDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 16:03:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414Ab0HZUDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 16:03:21 -0400
Date: Thu, 26 Aug 2010 16:03:18 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Karel Zak <kzak@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] VFS: Sanity check mount flags passed to change_mnt_propagation()
Message-ID: <20100826200318.GA13636@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_change_type() is buggy when passed multiple MS_* flags.  Discovered
because mount(8) incorrectly adds MS_RDONLY flag to
shared/slave/private/unbindable mounts.  Karel Zak will fix the
mount(8) bug shortly.

A test program is attached.  Against Viro's #untested branch.

-VAL

commit 208ca52f69ea53cf0723b8492fe54ebf9a3bf36a
Author: Valerie Aurora <vaurora@redhat.com>
Date:   Thu Aug 26 11:07:22 2010 -0700

    VFS: Sanity check mount flags passed to change_mnt_propagation()
    
    Sanity check the flags passed to change_mnt_propagation().  Exactly
    one flag should be set.  Return EINVAL otherwise.
    
    Userspace can pass in arbitrary combinations of MS_* flags to mount().
    do_change_type() is called if any of MS_SHARED, MS_PRIVATE, MS_SLAVE,
    or MS_UNBINDABLE is set.  do_change_type() clears MS_REC and then
    calls change_mnt_propagation() with the rest of the user-supplied
    flags.  change_mnt_propagation() clearly assumes only one flag is set
    but do_change_type() does not check that this is true.  For example,
    mount() with flags MS_SHARED | MS_RDONLY does not actually make the
    mount shared or read-only but does clear MNT_UNBINDABLE.
    
    Signed-off-by: Valerie Aurora <vaurora@redhat.com>

diff --git a/fs/namespace.c b/fs/namespace.c
index de402eb..4987c4c 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1484,13 +1484,32 @@ out_unlock:
 }
 
 /*
+ * Sanity check the flags to change_mnt_propagation.
+ */
+
+static int flags_to_propagation_type(int flags) {
+	int type = flags & ~MS_REC;
+
+	/* Fail if any non-propagation flags are set */
+	if (type & ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
+		return 0;
+	/* Only one propagation flag should be set */
+	if (((type & (MS_SHARED)) && (type & ~MS_SHARED)) ||
+	    ((type & (MS_PRIVATE)) && (type & ~MS_PRIVATE)) ||
+	    ((type & (MS_SLAVE)) && (type & ~MS_SLAVE)) ||
+	    ((type & (MS_UNBINDABLE)) && (type & ~MS_UNBINDABLE)))
+		return 0;
+	return type;
+}
+
+/*
  * recursively change the type of the mountpoint.
  */
 static int do_change_type(struct path *path, int flag)
 {
 	struct vfsmount *m, *mnt = path->mnt;
 	int recurse = flag & MS_REC;
-	int type = flag & ~MS_REC;
+	int type;
 	int err = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -1499,6 +1518,10 @@ static int do_change_type(struct path *path, int flag)
 	if (path->dentry != path->mnt->mnt_root)
 		return -EINVAL;
 
+	type = flags_to_propagation_type(flag);
+	if (!type)
+		return -EINVAL;
+
 	down_write(&namespace_sem);
 	if (type == MS_SHARED) {
 		err = invent_group_ids(mnt, recurse);

