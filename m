Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283Ab2BJWwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:52:35 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53942 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933265Ab2BJWuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:50:24 -0500
MIME-Version: 1.0
Message-Id: <20120210224851.347965874@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:47:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [06/21] NFSv4: Handle NFS4ERR_GRACE when recovering an expired lease.
In-Reply-To: <20120210224858.GA30752@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit a9ed2e2583747fb3139a764c317fac58893b968f upstream.

If our lease expires, and the server reboots while we're recovering, we
need to be able to wait until the grace period is over.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1490,7 +1490,7 @@ static int _nfs4_open_expired(struct nfs
 	return ret;
 }
 
-static inline int nfs4_do_open_expired(struct nfs_open_context *ctx, struct nfs4_state *state)
+static int nfs4_do_open_expired(struct nfs_open_context *ctx, struct nfs4_state *state)
 {
 	struct nfs_server *server = NFS_SERVER(state->inode);
 	struct nfs4_exception exception = { };
@@ -1498,10 +1498,16 @@ static inline int nfs4_do_open_expired(s
 
 	do {
 		err = _nfs4_open_expired(ctx, state);
-		if (err != -NFS4ERR_DELAY)
-			break;
-		nfs4_handle_exception(server, err, &exception);
+		switch (err) {
+		default:
+			goto out;
+		case -NFS4ERR_GRACE:
+		case -NFS4ERR_DELAY:
+			nfs4_handle_exception(server, err, &exception);
+			err = 0;
+		}
 	} while (exception.retry);
+out:
 	return err;
 }
 
@@ -4111,10 +4117,16 @@ static int nfs4_lock_expired(struct nfs4
 		if (test_bit(NFS_DELEGATED_STATE, &state->flags) != 0)
 			return 0;
 		err = _nfs4_do_setlk(state, F_SETLK, request, 0);
-		if (err != -NFS4ERR_DELAY)
-			break;
-		nfs4_handle_exception(server, err, &exception);
+		switch (err) {
+		default:
+			goto out;
+		case -NFS4ERR_GRACE:
+		case -NFS4ERR_DELAY:
+			nfs4_handle_exception(server, err, &exception);
+			err = 0;
+		}
 	} while (exception.retry);
+out:
 	return err;
 }
 


