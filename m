Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab2KNF67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:58:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55186 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756355Ab2KNFuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:50 -0500
Message-Id: <20121114053940.371231509@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:20 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Scott Mayhew <smayhew@redhat.com>, Steve Dickson <steved@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 47/82] nfsv3: Make v3 mounts fail with ETIMEDOUTs instead EIO on mountd
 timeouts
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

commit acce94e68a0f346115fd41cdc298197d2d5a59ad upstream.

In very busy v3 environment, rpc.mountd can respond to the NULL
procedure but not the MNT procedure in a timely manner causing
the MNT procedure to time out. The problem is the mount system
call returns EIO which causes the mount to fail, instead of
ETIMEDOUT, which would cause the mount to be retried.

This patch sets the RPC_TASK_SOFT|RPC_TASK_TIMEOUT flags to
the rpc_call_sync() call in nfs_mount() which causes
ETIMEDOUT to be returned on timed out connections.

Signed-off-by: Steve Dickson <steved@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/mount_clnt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/mount_clnt.c b/fs/nfs/mount_clnt.c
index 8e65c7f..015f71f 100644
--- a/fs/nfs/mount_clnt.c
+++ b/fs/nfs/mount_clnt.c
@@ -181,7 +181,7 @@ int nfs_mount(struct nfs_mount_request *info)
 	else
 		msg.rpc_proc = &mnt_clnt->cl_procinfo[MOUNTPROC_MNT];
 
-	status = rpc_call_sync(mnt_clnt, &msg, 0);
+	status = rpc_call_sync(mnt_clnt, &msg, RPC_TASK_SOFT|RPC_TASK_TIMEOUT);
 	rpc_shutdown_client(mnt_clnt);
 
 	if (status < 0)


