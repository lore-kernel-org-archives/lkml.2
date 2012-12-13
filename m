Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab2LMPEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:04:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44122 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab2LMODE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:03:04 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve Dickson <steved@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 038/241] nfsv3: Make v3 mounts fail with ETIMEDOUTs instead EIO on mountd timeouts
Date: Thu, 13 Dec 2012 11:56:43 -0200
Message-Id: <1355407206-17100-39-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
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
-- 
1.7.9.5

