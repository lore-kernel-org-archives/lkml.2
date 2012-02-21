Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2BUSRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:17:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab2BUSRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:17:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 73/73] fallthru: jffs2 support for lookup of d_type/d_ino in
 fallthrus [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:06:47 +0000
Message-ID: <20120221180647.25235.25348.stgit@warthog.procyon.org.uk>
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

Now that we have full union lookup support, lookup the true d_type and
d_ino of a fallthru.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/jffs2/dir.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index e294f1d..ce4c393 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -168,9 +168,14 @@ static int jffs2_readdir(struct file *filp, void *dirent, filldir_t filldir)
 			continue;
 		}
 		if (fd->type == JFFS2_DT_FALLTHRU) {
-			/* XXX placeholder until generic_readdir_fallthru() arrives */
-			ino = 1;
-			d_type = DT_UNKNOWN;
+			int err;
+			err = generic_readdir_fallthru(filp->f_path.dentry, fd->name, strlen(fd->name),
+						       &ino, &d_type);
+			if (err) {
+				D2(printk(KERN_DEBUG "Skipping fallthru dirent \"%s\"\n", fd->name));
+				offset++;
+				continue;
+			}
 		} else if (!fd->ino && (fd->type != DT_WHT)) {
 			D2(printk(KERN_DEBUG "Skipping deletion dirent \"%s\"\n", fd->name));
 			offset++;

