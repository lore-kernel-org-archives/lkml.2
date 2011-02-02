Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1BBBLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:11:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:14330 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab1BBAnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="598622246"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: chuck.lever@oracle.com, stefan.bader@canonical.com,
        Trond.Myklebust@netapp.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [12/139] NFS: Fix panic after nfs_umount()
Message-Id: <20110202004326.4C3CA3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Chuck Lever <chuck.lever@oracle.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfs/mount_clnt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/fs/nfs/mount_clnt.c
===================================================================
--- linux-2.6.35.y.orig/fs/nfs/mount_clnt.c
+++ linux-2.6.35.y/fs/nfs/mount_clnt.c
@@ -503,13 +503,13 @@ static struct rpc_procinfo mnt3_procedur
 
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
 
