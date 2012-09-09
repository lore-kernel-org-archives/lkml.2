Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab2IIX11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:27:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51314 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755421Ab2IIXQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:36 -0400
Message-Id: <20120909224159.481750809@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Yuanming Chen <hikvision_linux@163.com>
Subject: [ 64/95] NFSv3: Ensure that do_proc_get_root() reports errors correctly
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 086600430493e04b802bee6e5b3ce0458e4eb77f upstream.

If the rpc call to NFS3PROC_FSINFO fails, then we need to report that
error so that the mount fails. Otherwise we can end up with a
superblock with completely unusable values for block sizes, maxfilesize,
etc.

Reported-by: Yuanming Chen <hikvision_linux@163.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs3proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index 0952c79..d6b3b5f 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -69,7 +69,7 @@ do_proc_get_root(struct rpc_clnt *client, struct nfs_fh *fhandle,
 	nfs_fattr_init(info->fattr);
 	status = rpc_call_sync(client, &msg, 0);
 	dprintk("%s: reply fsinfo: %d\n", __func__, status);
-	if (!(info->fattr->valid & NFS_ATTR_FATTR)) {
+	if (status == 0 && !(info->fattr->valid & NFS_ATTR_FATTR)) {
 		msg.rpc_proc = &nfs3_procedures[NFS3PROC_GETATTR];
 		msg.rpc_resp = info->fattr;
 		status = rpc_call_sync(client, &msg, 0);


