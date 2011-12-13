Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab1LMBpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 20:45:01 -0500
Received: from numidia.opendz.org ([98.142.220.152]:35251 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab1LMBpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 20:45:00 -0500
Date: Tue, 13 Dec 2011 02:47:29 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fs/ncpfs: fix error paths and goto statements in
 ncp_fill_super()
Message-ID: <20111213014729.GA7693@dztty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The label 'out_bdi' should be followed by bdi_destroy() instead of
fput() which should be after the 'out_fput' label.

If bdi_setup_and_register() fails then jump to the 'out_fput' label
instead of the 'out_bdi' one.

If fget(data.info_fd) fails then jump to the previously fixed 'out_bdi'
label to call bdi_destroy() otherwise the bdi object will not be
destroyed.

Compile tested only.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/ncpfs/inode.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index 5b5fa33..cbd1a61 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -548,7 +548,7 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 
 	error = bdi_setup_and_register(&server->bdi, "ncpfs", BDI_CAP_MAP_COPY);
 	if (error)
-		goto out_bdi;
+		goto out_fput;
 
 	server->ncp_filp = ncp_filp;
 	server->ncp_sock = sock;
@@ -559,7 +559,7 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 		error = -EBADF;
 		server->info_filp = fget(data.info_fd);
 		if (!server->info_filp)
-			goto out_fput;
+			goto out_bdi;
 		error = -ENOTSOCK;
 		sock_inode = server->info_filp->f_path.dentry->d_inode;
 		if (!S_ISSOCK(sock_inode->i_mode))
@@ -746,9 +746,9 @@ out_nls:
 out_fput2:
 	if (server->info_filp)
 		fput(server->info_filp);
-out_fput:
-	bdi_destroy(&server->bdi);
 out_bdi:
+	bdi_destroy(&server->bdi);
+out_fput:
 	/* 23/12/1998 Marcin Dalecki <dalecki@cs.net.pl>:
 	 * 
 	 * The previously used put_filp(ncp_filp); was bogus, since
-- 
1.7.1
