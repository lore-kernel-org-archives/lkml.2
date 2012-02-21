Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab2BUSH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:07:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab2BUSHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:07:50 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 43/73] union-mount: Process negative dentries in
 __lookup_union() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:02:53 +0000
Message-ID: <20120221180253.25235.57193.stgit@warthog.procyon.org.uk>
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

Whiteouts end a union lookup.  So do opaque directories, unless
specific fallthru entry exists for this name.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 8caed86..009d9b5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1163,11 +1163,31 @@ static int __lookup_union(struct nameidata *nd, struct qstr *name,
 			err = PTR_ERR(lower.dentry);
 			goto out_err;
 		}
-		/* XXX - do nothing, lookup rule processing in later patches */
+
+		/* A negative dentry can mean several things: a plain negative
+		 * dentry is ignored and lookup continues to the next layer,
+		 * but a whiteout or a non-fallthru in an opaque dir covers
+		 * everything below it.
+		 */
+		if (!lower.dentry->d_inode) {
+			if (d_is_whiteout(lower.dentry))
+				goto out_lookup_done;
+			if (IS_OPAQUE(nd->path.dentry->d_inode) &&
+			    !d_is_fallthru(lower.dentry))
+				goto out_lookup_done;
+			path_put(&lower);
+			continue;
+		}
+
+		/* XXX - do nothing, more in later patches */
 		path_put(&lower);
 	}
 	return 0;
 
+out_lookup_done:
+	path_put(&lower);
+	return 0;
+
 out_err:
 	d_free_unions(topmost->dentry);
 	path_put(&lower);

