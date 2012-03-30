Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936472Ab2C3WH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:07:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965345Ab2C3VPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:15:54 -0400
Message-Id: <20120330194901.854267285@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 131/149] NFSv4.1: Fix layoutcommit error handling
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit e59d27e05a6435f8c04d5ad843f37fa795f2eaaa upstream.

Firstly, task->tk_status will always return negative error values,
so the current tests for 'NFS4ERR_DELEG_REVOKED' etc. are all being
ignored.
Secondly, clean up the code so that we only need to test
task->tk_status once!

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5983,21 +5983,22 @@ nfs4_layoutcommit_done(struct rpc_task *
 		return;
 
 	switch (task->tk_status) { /* Just ignore these failures */
-	case NFS4ERR_DELEG_REVOKED: /* layout was recalled */
-	case NFS4ERR_BADIOMODE:     /* no IOMODE_RW layout for range */
-	case NFS4ERR_BADLAYOUT:     /* no layout */
-	case NFS4ERR_GRACE:	    /* loca_recalim always false */
+	case -NFS4ERR_DELEG_REVOKED: /* layout was recalled */
+	case -NFS4ERR_BADIOMODE:     /* no IOMODE_RW layout for range */
+	case -NFS4ERR_BADLAYOUT:     /* no layout */
+	case -NFS4ERR_GRACE:	    /* loca_recalim always false */
 		task->tk_status = 0;
-	}
-
-	if (nfs4_async_handle_error(task, server, NULL) == -EAGAIN) {
-		rpc_restart_call_prepare(task);
-		return;
-	}
-
-	if (task->tk_status == 0)
+		break;
+	case 0:
 		nfs_post_op_update_inode_force_wcc(data->args.inode,
 						   data->res.fattr);
+		break;
+	default:
+		if (nfs4_async_handle_error(task, server, NULL) == -EAGAIN) {
+			rpc_restart_call_prepare(task);
+			return;
+		}
+	}
 }
 
 static void nfs4_layoutcommit_release(void *calldata)


