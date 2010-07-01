Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab0GAVEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:04:11 -0400
Received: from kroah.org ([198.145.64.141]:47857 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932832Ab0GAUvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:13 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:37 2010
Message-Id: <20100701173437.774876135@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [patch 130/164] GFS2: Fix permissions checking for setflags ioctl()
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Whitehouse <swhiteho@redhat.com>

commit 7df0e0397b9a18358573274db9fdab991941062f upstream.

We should be checking for the ownership of the file for which
flags are being set, rather than just for write access.

Reported-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/gfs2/file.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -218,6 +218,11 @@ static int do_gfs2_set_flags(struct file
 	if (error)
 		goto out_drop_write;
 
+	error = -EACCES;
+	if (!is_owner_or_cap(inode))
+		goto out;
+
+	error = 0;
 	flags = ip->i_diskflags;
 	new_flags = (flags & ~mask) | (reqflags & mask);
 	if ((new_flags ^ flags) == 0)
@@ -275,8 +280,10 @@ static int gfs2_set_flags(struct file *f
 {
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	u32 fsflags, gfsflags;
+
 	if (get_user(fsflags, ptr))
 		return -EFAULT;
+
 	gfsflags = fsflags_cvt(fsflags_to_gfs2, fsflags);
 	if (!S_ISDIR(inode->i_mode)) {
 		if (gfsflags & GFS2_DIF_INHERIT_JDATA)


