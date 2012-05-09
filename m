Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab2EIFyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:54:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39209 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755869Ab2EIFx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:57 -0400
Message-Id: <20120509055050.276245344@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Timo Warns <warns@pre-sense.de>, WANG Cong <amwang@redhat.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Miklos Szeredi <mszeredi@suse.cz>, Sage Weil <sage@newdream.net>,
        Eugene Teo <eteo@redhat.com>, Roman Zippel <zippel@linux-m68k.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Dave Anderson <anderson@redhat.com>
Subject: [ 150/167] [PATCH] hfsplus: Fix potential buffer overflows
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/hfsplus/catalog.c |    4 ++++
 fs/hfsplus/dir.c     |   11 +++++++++++
 2 files changed, 15 insertions(+)

diff --git a/fs/hfsplus/catalog.c b/fs/hfsplus/catalog.c
index 4dfbfec..ec2a9c2 100644
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
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 88e155f..26b53fb 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -150,6 +150,11 @@ static int hfsplus_readdir(struct file *filp, void *dirent, filldir_t filldir)
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
@@ -181,6 +186,12 @@ static int hfsplus_readdir(struct file *filp, void *dirent, filldir_t filldir)
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
-- 
1.7.10



