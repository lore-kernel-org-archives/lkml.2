Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab1CPGvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 02:51:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38371 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab1CPGvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 02:51:10 -0400
Date: Wed, 16 Mar 2011 06:51:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] VFS - the first pile
Message-ID: <20110316065103.GP22723@ZenIV.linux.org.uk>
References: <20110315213248.GL22723@ZenIV.linux.org.uk>
 <20110316061917.GA30195@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110316061917.GA30195@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 05:19:17PM +1100, Dave Chinner wrote:
> I think there's something not quite right in this tree. xfstests 005
> (nested symlink test) fails on both ext4 and XFS with the following:

Yeah...  Brown paperbag time - it's actually a missing piece that
got glued with a commit a bit later in queue ;-/  I've dropped it
into for-linus for the morning push; in the meanwhile, the patch is
below.

diff --git a/fs/namei.c b/fs/namei.c
index 0a601ca..b912b7a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -753,9 +753,11 @@ follow_link(struct path *link, struct nameidata *nd, void **p)
 
 	BUG_ON(nd->flags & LOOKUP_RCU);
 
+	if (link->mnt == nd->path.mnt)
+		mntget(link->mnt);
+
 	if (unlikely(current->total_link_count >= 40)) {
 		*p = ERR_PTR(-ELOOP); /* no ->put_link(), please */
-		path_put_conditional(link, nd);
 		path_put(&nd->path);
 		return -ELOOP;
 	}
@@ -765,9 +767,6 @@ follow_link(struct path *link, struct nameidata *nd, void **p)
 	touch_atime(link->mnt, dentry);
 	nd_set_link(nd, NULL);
 
-	if (link->mnt == nd->path.mnt)
-		mntget(link->mnt);
-
 	error = security_inode_follow_link(link->dentry, nd);
 	if (error) {
 		*p = ERR_PTR(error); /* no ->put_link(), please */
