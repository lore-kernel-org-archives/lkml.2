Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab2BUTx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:53:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922Ab2BUTxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 37/73] union-mount: Prevent topmost file system from being
 mounted elsewhere [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:02:09 +0000
Message-ID: <20120221180209.25235.48782.stgit@warthog.procyon.org.uk>
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

The device underlying the topmost read-write layer of a file system
cannot be mounted anywhere else on the system.  We keep a pointer to
the union stack in the dentry of the topmost directory, so that dentry
can't be part of a different mount, since dentries are shared between
different mounts of the same device.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namespace.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index aa6b1ef..3c950fa 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2091,6 +2091,11 @@ static int do_add_mount(struct mount *newmnt, struct path *path, int mnt_flags)
 	if (S_ISLNK(newmnt->mnt.mnt_root->d_inode->i_mode))
 		goto unlock;
 
+	/* Top layers of union mounts can't be mounted elsewhere */
+	err = -EBUSY;
+	if (newmnt->mnt.mnt_sb->s_union_lower_mnts)
+		goto unlock;
+
 	newmnt->mnt.mnt_flags = mnt_flags;
 	err = graft_tree(newmnt, path);
 

