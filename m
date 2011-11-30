Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab1K3GuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 01:50:18 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55232 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab1K3GuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 01:50:15 -0500
Date: Wed, 30 Nov 2011 06:50:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/28] namespace: checkpatch wanking
Message-ID: <20111130065014.GU2203@ZenIV.linux.org.uk>
References: <cover.1322609672.git.joe@perches.com>
 <a3527806b3af190204da9de1df1bfe4421ed6101.1322609673.git.joe@perches.com>
 <20111130022245.GS2203@ZenIV.linux.org.uk>
 <1322624351.17214.5.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322624351.17214.5.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 07:39:11PM -0800, Joe Perches wrote:

> No worries.
> 
> I think patches 1 thru 14 are reasonable though
> and do apply with a few offsets to vfsmount-guts.

OK...  BTW, speaking of this one:

-static int mnt_id_start = 0;
+static int mnt_id_start;
 static int mnt_group_start = 1;

this deserves a separate NAK; explicit init here is actually more clear -
the variable is more or less analogous to mnt_group_start and it's less
distracting to have initializers spelled out in similar way as well.

-	if ((child_mnt = __lookup_mnt(path->mnt, path->dentry, 1)))
+	child_mnt = __lookup_mnt(path->mnt, path->dentry, 1);
+	if (child_mnt)
 		mntget(child_mnt);
 	br_read_unlock(&vfsmount_lock);
 	return child_mnt;

Maybe, maybe not; in the #vfsmount-guts I seriously pondered turning that
into
	child_mnt = ...;
	if (child_mnt) {
		mnt_add_count(child_mnt);
		br_read_unlock(...);
		return &child_mnt->mnt;
	} else {
		br_read_unlock(...);
		return NULL;
	}
Hell knows...  Since __lookup_mnt() returns struct mount now *and* lookup_mnt()
returns struct vfsmount (much shrunk subset of the original; almost nothing
in there is needed for anything outside of core VFS code) we need if or ?:
after unlock as well.  So it might make sense to split the codepaths once...

-	if (flags & MNT_FORCE && sb->s_op->umount_begin) {
+	if (flags & MNT_FORCE && sb->s_op->umount_begin)
 		sb->s_op->umount_begin(sb);
-	}

Probably.  It used to be just a method call, then it had grown lock/unlock
around it, then lock went down into the method instances and the compound
statement stayed.
 
-static int do_add_mount(struct vfsmount *newmnt, struct path *path, int mnt_flags)
+static int
+do_add_mount(struct vfsmount *newmnt, struct path *path, int mnt_flags)

I don't mind BSD style like that, but again, check #vfsmount-guts; this
one takes struct mount * now, so that line happens to be below 80 cols.

-static int select_submounts(struct vfsmount *parent, struct list_head *graveyard)
+static int
+select_submounts(struct vfsmount *parent, struct list_head *graveyard)

Ditto.

-		struct vfsmount *mnt = list_entry(tmp, struct vfsmount, mnt_child);
+		struct vfsmount *mnt = list_entry(tmp, struct vfsmount,
+						  mnt_child);

Ditto (mnt_child moved into struct mount now)
 
-	if (!(page = __get_free_page(GFP_KERNEL)))
+	page = __get_free_page(GFP_KERNEL);
+	if (!page)
 		return -ENOMEM;

Not sure...  In general I'd agree, but in this case...
