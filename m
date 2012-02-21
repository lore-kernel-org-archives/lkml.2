Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab2BUTyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:54:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695Ab2BUTxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 70/73] fallthru: ext2 support for lookup of d_type/d_ino in
 fallthrus [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com> (Further development)
Date: Tue, 21 Feb 2012 18:06:21 +0000
Message-ID: <20120221180621.25235.41641.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have full union lookup support, lookup the true d_type and
d_ino of a fallthru.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com> (Further development)
---

 fs/ext2/dir.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 5fd6bbe..a509096 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -366,15 +366,21 @@ ext2_readdir (struct file * filp, void * dirent, filldir_t filldir)
 				}
 			} else if (de->file_type == EXT2_FT_FALLTHRU) {
 				int over;
+				unsigned char d_type = DT_UNKNOWN;
+				ino_t ino;
+				int err;
 
 				offset = (char *)de - kaddr;
-				/* XXX placeholder until generic_readdir_fallthru() arrives */
-				over = filldir(dirent, de->name, de->name_len,
-					       (n<<PAGE_CACHE_SHIFT) | offset,
-					       1, DT_UNKNOWN); /* XXX */
-				if (over) {
-					ext2_put_page(page);
-					return 0;
+				err = generic_readdir_fallthru(filp->f_path.dentry, de->name,
+							       de->name_len, &ino, &d_type);
+				if (!err) {
+					over = filldir(dirent, de->name, de->name_len,
+						       (n<<PAGE_CACHE_SHIFT) | offset,
+						       ino, d_type);
+					if (over) {
+						ext2_put_page(page);
+						return 0;
+					}
 				}
 			}
 			filp->f_pos += ext2_rec_len_from_disk(de->rec_len);

