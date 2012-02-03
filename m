Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2BCN02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 08:26:28 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44920 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab2BCN01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 08:26:27 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <josef@redhat.com>
Subject: [PATCH (untested)] vfs: fix d_inode_lookup() dentry ref leak
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 03 Feb 2012 14:25:18 +0100
Message-ID: <87ehuc6och.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

d_inode_lookup() appears to leak a dentry reference on IS_DEADDIR().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: stable@vger.kernel.org
---
 fs/namei.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2012-02-03 14:14:52.000000000 +0100
+++ linux-2.6/fs/namei.c	2012-02-03 14:15:48.000000000 +0100
@@ -1095,8 +1095,10 @@ static struct dentry *d_inode_lookup(str
 	struct dentry *old;
 
 	/* Don't create child dentry for a dead directory. */
-	if (unlikely(IS_DEADDIR(inode)))
+	if (unlikely(IS_DEADDIR(inode))) {
+		dput(dentry);
 		return ERR_PTR(-ENOENT);
+	}
 
 	old = inode->i_op->lookup(inode, dentry, nd);
 	if (unlikely(old)) {
