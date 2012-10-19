Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965012Ab2JSDGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:06:39 -0400
Received: from mail.kernel.org ([198.145.19.201]:51932 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713Ab2JSCs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Peng Tao <tao.peng@emc.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 03/76] NFS41: fix error of setting blocklayoutdriver
Date: Thu, 18 Oct 2012 19:46:27 -0700
Message-Id: <20121019024350.627636854@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Tao <bergwolf@gmail.com>

commit dc182549d439f60c332bf74d7f220a1bccf37da6 upstream.

After commit e38eb650 (NFS: set_pnfs_layoutdriver() from
nfs4_proc_fsinfo()), set_pnfs_layoutdriver() is called inside
nfs4_proc_fsinfo(), but pnfs_blksize is not set. It causes setting
blocklayoutdriver failure and pnfsblock mount failure.

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/client.c   |    1 -
 fs/nfs/nfs4proc.c |    5 ++++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -855,7 +855,6 @@ static void nfs_server_set_fsinfo(struct
 	if (server->wsize > NFS_MAX_FILE_IO_SIZE)
 		server->wsize = NFS_MAX_FILE_IO_SIZE;
 	server->wpages = (server->wsize + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	server->pnfs_blksize = fsinfo->blksize;
 
 	server->wtmult = nfs_block_bits(fsinfo->wtmult, NULL);
 
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3362,8 +3362,11 @@ static int nfs4_proc_fsinfo(struct nfs_s
 
 	nfs_fattr_init(fsinfo->fattr);
 	error = nfs4_do_fsinfo(server, fhandle, fsinfo);
-	if (error == 0)
+	if (error == 0) {
+		/* block layout checks this! */
+		server->pnfs_blksize = fsinfo->blksize;
 		set_pnfs_layoutdriver(server, fhandle, fsinfo->layouttype);
+	}
 
 	return error;
 }


