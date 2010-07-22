Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab0GVR7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 13:59:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab0GVR7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 13:59:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/6] Remove the automount through follow_link() kludge code
	from pathwalk
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Thu, 22 Jul 2010 18:59:08 +0100
Message-ID: <20100722175907.5552.34758.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100722175847.5552.11520.stgit@warthog.procyon.org.uk>
References: <20100722175847.5552.11520.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the automount through follow_link() kludge code from pathwalk in favour
of using d_automount().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index fcec3c6..86068a2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -845,17 +845,6 @@ fail:
 }
 
 /*
- * This is a temporary kludge to deal with "automount" symlinks; proper
- * solution is to trigger them on follow_mount(), so that do_lookup()
- * would DTRT.  To be killed before 2.6.34-final.
- */
-static inline int follow_on_final(struct inode *inode, unsigned lookup_flags)
-{
-	return inode && unlikely(inode->i_op->follow_link) &&
-		((lookup_flags & LOOKUP_FOLLOW) || S_ISDIR(inode->i_mode));
-}
-
-/*
  * Name resolution.
  * This is the basic name resolution function, turning a pathname into
  * the final dentry. We expect 'base' to be positive and a directory.
@@ -975,7 +964,8 @@ last_component:
 		if (err)
 			break;
 		inode = next.dentry->d_inode;
-		if (follow_on_final(inode, lookup_flags)) {
+		if (inode && unlikely(inode->i_op->follow_link) &&
+		    (lookup_flags & LOOKUP_FOLLOW)) {
 			err = do_follow_link(&next, nd);
 			if (err)
 				goto return_err;
@@ -1888,8 +1878,7 @@ reval:
 		struct inode *inode = path.dentry->d_inode;
 		void *cookie;
 		error = -ELOOP;
-		/* S_ISDIR part is a temporary automount kludge */
-		if (!(nd.flags & LOOKUP_FOLLOW) && !S_ISDIR(inode->i_mode))
+		if (!(nd.flags & LOOKUP_FOLLOW))
 			goto exit_dput;
 		if (count++ == 32)
 			goto exit_dput;

