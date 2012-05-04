Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab2EDTJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:09:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51674 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab2EDTJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:09:46 -0400
Date: Fri, 4 May 2012 12:09:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Timo Warns <warns@pre-sense.de>
Cc: WANG Cong <amwang@redhat.com>, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Miklos Szeredi <mszeredi@suse.cz>, Sage Weil <sage@newdream.net>,
        Eugene Teo <eteo@redhat.com>, Roman Zippel <zippel@linux-m68k.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Dave Anderson <anderson@redhat.com>, stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] hfsplus: Fix potential buffer overflows
Message-ID: <20120504190939.GA12976@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ec81aecb29668ad71f699f4e7b96ec46691895b6 (hfs: fix a potential
buffer overflow) fixed a few potential buffer overflows in the hfs
filesystem.  But as Timo Warns pointed out, these changes also need to
be made on the hfsplus filesystem as well.

Reported-by: Timo Warns <warns@pre-sense.de>
Cc: WANG Cong <amwang@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Cong Wang <amwang@redhat.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Sage Weil <sage@newdream.net>
Cc: Eugene Teo <eteo@redhat.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dave Anderson <anderson@redhat.com>
Cc: stable <stable@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/hfsplus/catalog.c |    4 ++++
 fs/hfsplus/dir.c     |   11 +++++++++++
 2 files changed, 15 insertions(+)

--- a/fs/hfsplus/catalog.c
+++ b/fs/hfsplus/catalog.c
@@ -366,6 +366,10 @@ int hfsplus_rename_cat(u32 cnid,
 	err = hfs_brec_find(&src_fd);
 	if (err)
 		goto out;
+	if (src_fd.entrylength > sizeof(entry) || src_fd.entrylength < 0) {
+		err = -EIO;
+		goto out;
+	}
 
 	hfs_bnode_read(src_fd.bnode, &entry, src_fd.entryoffset,
 				src_fd.entrylength);
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -150,6 +150,11 @@ static int hfsplus_readdir(struct file *
 		filp->f_pos++;
 		/* fall through */
 	case 1:
+		if (fd.entrylength > sizeof(entry) || fd.entrylength < 0) {
+			err = -EIO;
+			goto out;
+		}
+
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset,
 			fd.entrylength);
 		if (be16_to_cpu(entry.type) != HFSPLUS_FOLDER_THREAD) {
@@ -181,6 +186,12 @@ static int hfsplus_readdir(struct file *
 			err = -EIO;
 			goto out;
 		}
+
+		if (fd.entrylength > sizeof(entry) || fd.entrylength < 0) {
+			err = -EIO;
+			goto out;
+		}
+
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset,
 			fd.entrylength);
 		type = be16_to_cpu(entry.type);
