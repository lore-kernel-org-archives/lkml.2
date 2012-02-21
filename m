Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab2BUTwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:52:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab2BUTww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:52:52 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 45/73] union-mount: Build union stack in __lookup_union() [ver
 #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:03:07 +0000
Message-ID: <20120221180307.25235.95832.stgit@warthog.procyon.org.uk>
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

Build the union stack for directories as we look them up.  Create the
topmost directory if it doesn't exist.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f81f24e..3ac07be 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1190,8 +1190,21 @@ static int __lookup_union(struct nameidata *nd, struct qstr *name,
 			goto out_found_file;
 		}
 
-		/* XXX - do nothing, more in later patches */
-		path_put(&lower);
+		/* Now we know the target is a directory.  Create a matching
+		 * topmost directory if one doesn't already exist, and add this
+		 * layer's directory to the union stack for the topmost
+		 * directory.
+		 */
+		if (!topmost->dentry->d_inode) {
+			err = union_create_topmost_dir(&parent, name, topmost,
+						       &lower);
+			if (err)
+				goto out_err;
+		}
+
+		err = union_add_dir(topmost, &lower, i);
+		if (err)
+			goto out_err;
 	}
 	return 0;
 

