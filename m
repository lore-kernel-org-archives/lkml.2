Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab2BUTw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:52:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab2BUTww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:52:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 44/73] union-mount: Return files found in lower layers in
 __lookup_union() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:03:00 +0000
Message-ID: <20120221180300.25235.63345.stgit@warthog.procyon.org.uk>
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

If we find a file during union lookup, don't look in any lower layers
and replace the topmost path with the file's path.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 009d9b5..f81f24e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1179,11 +1179,31 @@ static int __lookup_union(struct nameidata *nd, struct qstr *name,
 			continue;
 		}
 
+		/* Files block everything below them.  Special case: If we find
+		 * a file below a directory (which makes no sense), just ignore
+		 * the file and return the directory above it.
+		 */
+		if (!S_ISDIR(lower.dentry->d_inode->i_mode)) {
+			if (topmost->dentry->d_inode &&
+			    S_ISDIR(topmost->dentry->d_inode->i_mode))
+				goto out_lookup_done;
+			goto out_found_file;
+		}
+
 		/* XXX - do nothing, more in later patches */
 		path_put(&lower);
 	}
 	return 0;
 
+out_found_file:
+	/* Swap out the positive lower dentry with the negative upper
+	 * dentry for this file.  Note that the matching mntput() is done
+	 * in link_path_walk().
+	 */
+	dput(topmost->dentry);
+	*topmost = lower;
+	return 0;
+
 out_lookup_done:
 	path_put(&lower);
 	return 0;

