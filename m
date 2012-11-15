Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993034Ab2KOEgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:36:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:48987 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992965Ab2KOELW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Steve Dickson <steved@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 27/66] nfsv3: Make v3 mounts fail with ETIMEDOUTs instead EIO on mountd timeouts
Date: Wed, 14 Nov 2012 20:10:32 -0800
Message-Id: <20121115040940.966788145@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/mount_clnt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/mount_clnt.c
+++ b/fs/nfs/mount_clnt.c
@@ -181,7 +181,7 @@ int nfs_mount(struct nfs_mount_request *
 	else
 		msg.rpc_proc = &mnt_clnt->cl_procinfo[MOUNTPROC_MNT];
 
-	status = rpc_call_sync(mnt_clnt, &msg, 0);
+	status = rpc_call_sync(mnt_clnt, &msg, RPC_TASK_SOFT|RPC_TASK_TIMEOUT);
 	rpc_shutdown_client(mnt_clnt);
 
 	if (status < 0)


