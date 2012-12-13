Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab2LMOCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:02:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44104 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab2LMOCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:02:51 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 034/241] NFS: Wait for session recovery to finish before returning
Date: Thu, 13 Dec 2012 11:56:39 -0200
Message-Id: <1355407206-17100-35-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan Schumaker <bjschuma@netapp.com>

commit 399f11c3d872bd748e1575574de265a6304c7c43 upstream.

Currently, we will schedule session recovery and then return to the
caller of nfs4_handle_exception.  This works for most cases, but causes
a hang on the following test case:

	Client				Server
	------				------
	Open file over NFS v4.1
	Write to file
					Expire client
	Try to lock file

The server will return NFS4ERR_BADSESSION, prompting the client to
schedule recovery.  However, the client will continue placing lock
attempts and the open recovery never seems to be scheduled.  The
simplest solution is to wait for session recovery to run before retrying
the lock.

Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfs/nfs4proc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index dd372e2..aa321ac 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -329,8 +329,7 @@ static int nfs4_handle_exception(struct nfs_server *server, int errorcode, struc
 			dprintk("%s ERROR: %d Reset session\n", __func__,
 				errorcode);
 			nfs4_schedule_session_recovery(clp->cl_session, errorcode);
-			exception->retry = 1;
-			break;
+			goto wait_on_recovery;
 #endif /* defined(CONFIG_NFS_V4_1) */
 		case -NFS4ERR_FILE_OPEN:
 			if (exception->timeout > HZ) {
-- 
1.7.9.5

