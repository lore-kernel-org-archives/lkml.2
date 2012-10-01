Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab2JAXDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:03:13 -0400
Received: from 1wt.eu ([62.212.114.60]:35628 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933252Ab2JAXDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:03:04 -0400
Message-Id: <20121001225158.761761711@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:24 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tyler Hicks <tyhicks@canonical.com>,
        Colin Ian King <colin.king@canonical.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Andy Whitcroft <apw@canonical.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 027/180] eCryptfs: Clear ECRYPTFS_NEW_FILE flag during truncate
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.king@canonical.com>

BugLink: http://bugs.launchpad.net/bugs/745836

The ECRYPTFS_NEW_FILE crypt_stat flag is set upon creation of a new
eCryptfs file. When the flag is set, eCryptfs reads directly from the
lower filesystem when bringing a page up to date. This means that no
offset translation (for the eCryptfs file metadata in the lower file)
and no decryption is performed. The flag is cleared just before the
first write is completed (at the beginning of ecryptfs_write_begin()).

It was discovered that if a new file was created and then extended with
truncate, the ECRYPTFS_NEW_FILE flag was not cleared. If pages
corresponding to this file are ever reclaimed, any subsequent reads
would result in userspace seeing eCryptfs file metadata and encrypted
file contents instead of the expected decrypted file contents.

Data corruption is possible if the file is written to before the
eCryptfs directory is unmounted. The data written will be copied into
pages which have been read directly from the lower file rather than
zeroed pages, as would be expected after extending the file with
truncate.

This flag, and the functionality that used it, was removed in upstream
kernels in 2.6.39 with the following commits:

bd4f0fe8bb7c73c738e1e11bc90d6e2cf9c6e20e
fed8859b3ab94274c986cbdf7d27130e0545f02c

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/ecryptfs/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 645da17..3c1dbc0 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -777,6 +777,9 @@ static int truncate_upper(struct dentry *dentry, struct iattr *ia,
 		goto out;
 	}
 	crypt_stat = &ecryptfs_inode_to_private(dentry->d_inode)->crypt_stat;
+	if (crypt_stat->flags & ECRYPTFS_NEW_FILE)
+		crypt_stat->flags &= ~(ECRYPTFS_NEW_FILE);
+
 	/* Set up a fake ecryptfs file, this is used to interface with
 	 * the file in the underlying filesystem so that the
 	 * truncation has an effect there as well. */
-- 
1.7.2.1.45.g54fbc



