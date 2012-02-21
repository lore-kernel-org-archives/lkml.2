Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab2BUSR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:17:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab2BUSRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:17:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 52/73] union-mount: Set opaque flag on new directories in
 unioned file systems [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, Jan Blunck <jblunck@suse.de>,
        Valerie Aurora <vaurora@redhat.com>,
        David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:03:58 +0000
Message-ID: <20120221180358.25235.32044.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

If we mkdir() a directory on the top layer of a union, we don't want
entries from a matching directory on the lower layer to "show through"
suddenly.  To prevent this, we set the opaque flag on a directory in a
union mount if there is no matching directory on the lower layers.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f9e0d68..d52377d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2946,8 +2946,17 @@ int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 		return error;
 
 	error = dir->i_op->mkdir(dir, dentry, mode);
-	if (!error)
-		fsnotify_mkdir(dir, dentry);
+	if (error)
+		return error;
+
+	/* XXX racy - crash now and dir isn't opaque */
+	if (IS_DIR_UNIONED(dentry->d_parent)) {
+		dentry->d_inode->i_flags |= S_OPAQUE;
+		mark_inode_dirty(dentry->d_inode);
+	}
+
+	fsnotify_mkdir(dir, dentry);
+
 	return error;
 }
 

