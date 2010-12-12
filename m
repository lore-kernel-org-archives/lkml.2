Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab0LMAZw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:25:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44792 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab0LLXpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:39 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: Trond.Myklebust@netapp.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [41/223] NFSv4: Don't call nfs4_state_mark_reclaim_reboot() from error handlers
Message-Id: <20101212234538.085ACB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit ae1007d37e00144b72906a4bdc47d517ae91bcc1 upstream.

In the case of a server reboot, the state recovery thread starts by calling
nfs4_state_end_reclaim_reboot() in order to avoid edge conditions when
the server reboots while the client is in the middle of recovery.

However, if the client has already marked the nfs4_state as requiring
reboot recovery, then the above behaviour will cause the recovery thread to
treat the open as if it was part of such an edge condition: the open will
be recovered as if it was part of a lease expiration (and all the locks
will be lost).
Fix is to remove the call to nfs4_state_mark_reclaim_reboot from
nfs4_async_handle_error(), and nfs4_handle_exception(). Instead we leave it
to the recovery thread to do this for us.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfs/nfs4proc.c |    6 ------
 1 file changed, 6 deletions(-)

Index: linux/fs/nfs/nfs4proc.c
===================================================================
--- linux.orig/fs/nfs/nfs4proc.c
+++ linux/fs/nfs/nfs4proc.c
@@ -255,9 +255,6 @@ static int nfs4_handle_exception(const s
 			nfs4_state_mark_reclaim_nograce(clp, state);
 			goto do_state_recovery;
 		case -NFS4ERR_STALE_STATEID:
-			if (state == NULL)
-				break;
-			nfs4_state_mark_reclaim_reboot(clp, state);
 		case -NFS4ERR_STALE_CLIENTID:
 		case -NFS4ERR_EXPIRED:
 			goto do_state_recovery;
@@ -3479,9 +3476,6 @@ _nfs4_async_handle_error(struct rpc_task
 			nfs4_state_mark_reclaim_nograce(clp, state);
 			goto do_state_recovery;
 		case -NFS4ERR_STALE_STATEID:
-			if (state == NULL)
-				break;
-			nfs4_state_mark_reclaim_reboot(clp, state);
 		case -NFS4ERR_STALE_CLIENTID:
 		case -NFS4ERR_EXPIRED:
 			goto do_state_recovery;
