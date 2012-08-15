Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab2HOUe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:34:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:36416 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab2HOTtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:21 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Miklos Szeredi <mszeredi@suse.cz>, Sage Weil <sage@newdream.net>,
        Eugene Teo <eteo@redhat.com>, Roman Zippel <zippel@linux-m68k.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Dave Anderson <anderson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 012/165] hfsplus: Fix potential buffer overflows
Date: Wed, 15 Aug 2012 15:45:56 -0400
Message-ID: <1345060109-9187-13-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6f24f892871acc47b40dd594c63606a17c714f77 upstream.

Commit ec81aecb2966 ("hfs: fix a potential buffer overflow") fixed a few
potential buffer overflows in the hfs filesystem.  But as Timo Warns
pointed out, these changes also need to be made on the hfsplus
filesystem as well.

Reported-by: Timo Warns <warns@pre-sense.de>
Acked-by: WANG Cong <amwang@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Sage Weil <sage@newdream.net>
Cc: Eugene Teo <eteo@redhat.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dave Anderson <anderson@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/hfsplus/catalog.c |  4 ++++
 fs/hfsplus/dir.c     | 11 +++++++++++
 2 files changed, 15 insertions(+)

diff --git a/fs/hfsplus/catalog.c b/fs/hfsplus/catalog.c
index f6874ac..a0786c6 100644
--- a/fs/hfsplus/catalog.c
+++ b/fs/hfsplus/catalog.c
@@ -329,6 +329,10 @@ int hfsplus_rename_cat(u32 cnid,
 	err = hfs_brec_find(&src_fd);
 	if (err)
 		goto out;
+	if (src_fd.entrylength > sizeof(entry) || src_fd.entrylength < 0) {
+		err = -EIO;
+		goto out;
+	}
 
 	hfs_bnode_read(src_fd.bnode, &entry, src_fd.entryoffset,
 				src_fd.entrylength);
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 5f40236..f4300ff7 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -138,6 +138,11 @@ static int hfsplus_readdir(struct file *filp, void *dirent, filldir_t filldir)
 		filp->f_pos++;
 		/* fall through */
 	case 1:
+		if (fd.entrylength > sizeof(entry) || fd.entrylength < 0) {
+			err = -EIO;
+			goto out;
+		}
+
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset, fd.entrylength);
 		if (be16_to_cpu(entry.type) != HFSPLUS_FOLDER_THREAD) {
 			printk(KERN_ERR "hfs: bad catalog folder thread\n");
@@ -168,6 +173,12 @@ static int hfsplus_readdir(struct file *filp, void *dirent, filldir_t filldir)
 			err = -EIO;
 			goto out;
 		}
+
+		if (fd.entrylength > sizeof(entry) || fd.entrylength < 0) {
+			err = -EIO;
+			goto out;
+		}
+
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset, fd.entrylength);
 		type = be16_to_cpu(entry.type);
 		len = HFSPLUS_MAX_STRLEN;
-- 
1.7.12.rc2

