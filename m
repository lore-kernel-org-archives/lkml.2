Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab1KGPCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:02:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab1KGPCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:02:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] VFS: Log the fact that we've given ELOOP rather than creating
 a loop
To: torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Sachin Prabhu <sprabhu@redhat.com>
Date: Mon, 07 Nov 2011 15:00:42 +0000
Message-ID: <20111107150042.21862.44437.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prevent an NFS server from being used to create a directory loop in an NFS
superblock on the client, the following patch was committed:

	commit 1836750115f20b774e55c032a3893e8c5bdf41ed
	Author: Al Viro <viro@zeniv.linux.org.uk>
	Date:   Tue Jul 12 21:42:24 2011 -0400
	Subject: fix loop checks in d_materialise_unique()

This causes ELOOP to be reported to anyone trying to access the dentry that
would otherwise cause the kernel to complete the loop.

However, no indication is given to the caller as to why an operation that ought
to work doesn't.  The fault is with the kernel, which doesn't want to try and
solve the problem as it gets horrendously messy if there's another mountpoint
somewhere in the trees being spliced that can't be moved[*].

[*] The real problem is that we don't handle the excision of a subtree that
gets moved _out_ of what we can see.  This can happen on the server where a
directory is merely moved between two other dirs on the same filesystem, but
where destination dir is not accessible by the client.

So, given the choice to return ELOOP rather than trying to reconfigure the
dentry tree, we should give the caller some indication of why they aren't being
allowed to make what should be a legitimate request and log a message.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Sachin Prabhu <sprabhu@redhat.com>
---

 fs/dcache.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index a88948b..349792f 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -36,6 +36,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/rculist_bl.h>
 #include <linux/prefetch.h>
+#include <linux/ratelimit.h>
 #include "internal.h"
 
 /*
@@ -2351,8 +2352,16 @@ struct dentry *d_materialise_unique(struct dentry *dentry, struct inode *inode)
 				actual = __d_unalias(inode, dentry, alias);
 			}
 			write_sequnlock(&rename_lock);
-			if (IS_ERR(actual))
+			if (IS_ERR(actual)) {
+				if (PTR_ERR(actual) == -ELOOP)
+					pr_warn_ratelimited(
+						"VFS: Lookup of '%s' in %s %s"
+						" would have caused loop\n",
+						dentry->d_name.name,
+						inode->i_sb->s_type->name,
+						inode->i_sb->s_id);
 				dput(alias);
+			}
 			goto out_nolock;
 		}
 	}

