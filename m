Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab2BUTx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:53:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981Ab2BUTxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 36/73] union-mount: Prevent improper union-related remounts
 [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:02:01 +0000
Message-ID: <20120221180201.25235.32109.stgit@warthog.procyon.org.uk>
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

A remount request must not (a) convert a union to a non-union (or vice
versa), or (b) make the topmost layer of a union read-only.

Note that we only have to worry about attempts to remount the vfsmount
of the topmost read-write of the union (the one with MNT_UNION set).
The vfsmounts of the read-only layers are hidden in a cloned tree
hanging of the superblock of the topmost layer and aren't visible to
userspace.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namespace.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 261944d..aa6b1ef 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1907,6 +1907,18 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 	if (!check_mnt(mnt))
 		return -EINVAL;
 
+	if ((path->mnt->mnt_flags & MNT_UNION) &&
+	    !(mnt_flags & MNT_UNION))
+		return -EINVAL;
+
+	if ((mnt_flags & MNT_UNION) &&
+	    !(path->mnt->mnt_flags & MNT_UNION))
+		return -EINVAL;
+
+	if ((path->mnt->mnt_flags & MNT_UNION) &&
+	    (mnt_flags & MNT_READONLY))
+		return -EINVAL;
+
 	if (path->dentry != path->mnt->mnt_root)
 		return -EINVAL;
 

