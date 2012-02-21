Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2BUTyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:54:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160Ab2BUTyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:54:06 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 55/73] fallthru: tmpfs support for lookup of d_type/d_ino in
 fallthrus [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org
Date: Tue, 21 Feb 2012 18:04:22 +0000
Message-ID: <20120221180422.25235.59500.stgit@warthog.procyon.org.uk>
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
Cc: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org
---

 fs/libfs.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 43f1ac2..bd9388f 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -143,6 +143,7 @@ int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	ino_t ino;
 	char d_type;
 	int i = filp->f_pos;
+	int err = 0;
 
 	switch (i) {
 		case 0:
@@ -177,9 +178,13 @@ int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
 				spin_unlock(&next->d_lock);
 				spin_unlock(&dentry->d_lock);
 				if (d_is_fallthru(next)) {
-					/* XXX placeholder until generic_readdir_fallthru() arrives */
-					ino = 1;
-					d_type = DT_UNKNOWN;
+					/* On tmpfs, should only fail with ENOMEM, EIO, etc. */
+					err = generic_readdir_fallthru(filp->f_path.dentry,
+								       next->d_name.name,
+								       next->d_name.len,
+								       &ino, &d_type);
+					if (err)
+						return err;
 				} else {
 					ino = next->d_inode->i_ino;
 					d_type = dt_type(next->d_inode);

