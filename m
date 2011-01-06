Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab1AFBBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 20:01:38 -0500
Received: from kroah.org ([198.145.64.141]:35428 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab1AFA3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:00 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:58 2011
Message-Id: <20110106002258.308946879@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:21:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [017/152] NFS: Fix panic after nfs_umount()
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 fs/nfs/mount_clnt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfs/mount_clnt.c
+++ b/fs/nfs/mount_clnt.c
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
 


