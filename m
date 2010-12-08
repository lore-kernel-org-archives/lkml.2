Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab0LHBqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:46:47 -0500
Received: from kroah.org ([198.145.64.141]:48725 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190Ab0LHBAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:10 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:29 2010
Message-Id: <20101208005729.129182668@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [078/289] NFSv4: Dont call nfs4_state_mark_reclaim_reboot() from error handlers
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 fs/nfs/nfs4proc.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
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
@@ -3490,9 +3487,6 @@ nfs4_async_handle_error(struct rpc_task
 			nfs4_state_mark_reclaim_nograce(clp, state);
 			goto do_state_recovery;
 		case -NFS4ERR_STALE_STATEID:
-			if (state == NULL)
-				break;
-			nfs4_state_mark_reclaim_reboot(clp, state);
 		case -NFS4ERR_STALE_CLIENTID:
 		case -NFS4ERR_EXPIRED:
 			goto do_state_recovery;


