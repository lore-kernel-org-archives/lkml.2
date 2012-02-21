Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab2BUSHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:07:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab2BUSHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:07:50 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 49/73] union-mount: Call union lookup functions in lookup path
 [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:03:37 +0000
Message-ID: <20120221180337.25235.66724.stgit@warthog.procyon.org.uk>
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

Union mounts hook into the lookup path in two places: do_lookup() and
lookup_hash().

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c0adf4c..586913f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1587,6 +1587,14 @@ retry:
 	}
 	if (err)
 		nd->flags |= LOOKUP_JUMPED;
+
+	if (needs_lookup_union(&nd->path, path)) {
+		int err = lookup_union(nd, name, path);
+		if (err < 0)
+			return err;
+#warning which inode?
+	}
+
 	*inode = path->dentry->d_inode;
 	return 0;
 }
@@ -2135,8 +2143,12 @@ static int lookup_hash(struct nameidata *nd, struct qstr *name,
 		path->dentry = NULL;
 		return PTR_ERR(result);
 	}
+
 	path->mnt = nd->path.mnt;
 	path->dentry = result;
+
+	if (needs_lookup_union(&nd->path, path))
+		return lookup_union_locked(nd, name, path);
 	return 0;
 }
 

