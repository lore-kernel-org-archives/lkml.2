Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933833Ab1DNSJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:09:35 -0400
Received: from mail.windriver.com ([147.11.1.11]:42140 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964890Ab1DNR6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 162/209] NFS: Fix panic after nfs_umount()
Date: Thu, 14 Apr 2011 13:55:20 -0400
Message-Id: <1302803767-9715-49-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 5b362ac3799ff4225c40935500f520cad4d7ed66 upstream.

After a few unsuccessful NFS mount attempts in which the client and
server cannot agree on an authentication flavor both support, the
client panics.  nfs_umount() is invoked in the kernel in this case.

Turns out nfs_umount()'s UMNT RPC invocation causes the RPC client to
write off the end of the rpc_clnt's iostat array.  This is because the
mount client's nrprocs field is initialized with the count of defined
procedures (two: MNT and UMNT), rather than the size of the client's
proc array (four).

The fix is to use the same initialization technique used by most other
upper layer clients in the kernel.

Introduced by commit 0b524123, which failed to update nrprocs when
support was added for UMNT in the kernel.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=24302
BugLink: http://bugs.launchpad.net/bugs/683938

Reported-by: Stefan Bader <stefan.bader@canonical.com>
Tested-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfs/mount_clnt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/mount_clnt.c b/fs/nfs/mount_clnt.c
index 59047f8..3dde50c 100644
--- a/fs/nfs/mount_clnt.c
+++ b/fs/nfs/mount_clnt.c
@@ -503,13 +503,13 @@ static struct rpc_procinfo mnt3_procedures[] = {
 
 static struct rpc_version mnt_version1 = {
 	.number		= 1,
-	.nrprocs	= 2,
+	.nrprocs	= ARRAY_SIZE(mnt_procedures),
 	.procs		= mnt_procedures,
 };
 
 static struct rpc_version mnt_version3 = {
 	.number		= 3,
-	.nrprocs	= 2,
+	.nrprocs	= ARRAY_SIZE(mnt3_procedures),
 	.procs		= mnt3_procedures,
 };
 
-- 
1.7.4.4

