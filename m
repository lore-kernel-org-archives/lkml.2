Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab0IRTPu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:15:50 -0400
Received: from kroah.org ([198.145.64.141]:43674 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab0IRTPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:48 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:04 2010
Message-Id: <20100918191304.542135345@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zoltan Menyhart <Zoltan.Menyhart@bull.net>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [084/129] statfs() gives ESTALE error
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Menyhart Zoltan <Zoltan.Menyhart@bull.net>

commit fbf3fdd2443965d9ba6fb4b5fecd1f6e0847218f upstream.

Hi,

An NFS client executes a statfs("file", &buff) call.
"file" exists / existed, the client has read / written it,
but it has already closed it.

user_path(pathname, &path) looks up "file" successfully in the
directory-cache  and restarts the aging timer of the directory-entry.
Even if "file" has already been removed from the server, because the
lookupcache=positive option I use, keeps the entries valid for a while.

nfs_statfs() returns ESTALE if "file" has already been removed from the
server.

If the user application repeats the statfs("file", &buff) call, we
are stuck: "file" remains young forever in the directory-cache.

Signed-off-by: Zoltan Menyhart  <Zoltan.Menyhart@bull.net>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/super.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -431,7 +431,15 @@ static int nfs_statfs(struct dentry *den
 		goto out_err;
 
 	error = server->nfs_client->rpc_ops->statfs(server, fh, &res);
+	if (unlikely(error == -ESTALE)) {
+		struct dentry *pd_dentry;
 
+		pd_dentry = dget_parent(dentry);
+		if (pd_dentry != NULL) {
+			nfs_zap_caches(pd_dentry->d_inode);
+			dput(pd_dentry);
+		}
+	}
 	nfs_free_fattr(res.fattr);
 	if (error < 0)
 		goto out_err;


