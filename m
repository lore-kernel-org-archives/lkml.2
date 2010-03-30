Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab0CaAgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:36:53 -0400
Received: from kroah.org ([198.145.64.141]:48573 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931Ab0C3XJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:16 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:50:02 2010
Message-Id: <20100330225001.595812327@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [33/45] fix LOOKUP_FOLLOW on automount "symlinks"
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit ac278a9c505092dd82077a2446af8f9fc0d9c095 upstream.

Make sure that automount "symlinks" are followed regardless of LOOKUP_FOLLOW;
it should have no effect on them.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namei.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -841,6 +841,17 @@ fail:
 }
 
 /*
+ * This is a temporary kludge to deal with "automount" symlinks; proper
+ * solution is to trigger them on follow_mount(), so that do_lookup()
+ * would DTRT.  To be killed before 2.6.34-final.
+ */
+static inline int follow_on_final(struct inode *inode, unsigned lookup_flags)
+{
+	return inode && unlikely(inode->i_op->follow_link) &&
+		((lookup_flags & LOOKUP_FOLLOW) || S_ISDIR(inode->i_mode));
+}
+
+/*
  * Name resolution.
  * This is the basic name resolution function, turning a pathname into
  * the final dentry. We expect 'base' to be positive and a directory.
@@ -984,8 +995,7 @@ last_component:
 		if (err)
 			break;
 		inode = next.dentry->d_inode;
-		if ((lookup_flags & LOOKUP_FOLLOW)
-		    && inode && inode->i_op && inode->i_op->follow_link) {
+		if (follow_on_final(inode, lookup_flags)) {
 			err = do_follow_link(&next, nd);
 			if (err)
 				goto return_err;


