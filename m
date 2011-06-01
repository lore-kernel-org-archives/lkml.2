Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163197Ab1FAI2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:28:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163151Ab1FAI2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:28:44 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:24 2011
Message-Id: <20110601081223.850352530@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:12:04 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [154/165] NFSv4: Handle expired stateids when the lease is still valid
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1764
Lines: 53

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 0ced63d1a245ac11241a5d37932e6d04d9c8040d upstream.

Currently, if the server returns NFS4ERR_EXPIRED in reply to a READ or
WRITE, but the RENEW test determines that the lease is still active, we
fail to recover and end up looping forever in a READ/WRITE + RENEW death
spiral.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/nfs4proc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -267,9 +267,11 @@ static int nfs4_handle_exception(struct
 				break;
 			nfs4_schedule_stateid_recovery(server, state);
 			goto wait_on_recovery;
+		case -NFS4ERR_EXPIRED:
+			if (state != NULL)
+				nfs4_schedule_stateid_recovery(server, state);
 		case -NFS4ERR_STALE_STATEID:
 		case -NFS4ERR_STALE_CLIENTID:
-		case -NFS4ERR_EXPIRED:
 			nfs4_schedule_lease_recovery(clp);
 			goto wait_on_recovery;
 #if defined(CONFIG_NFS_V4_1)
@@ -3670,9 +3672,11 @@ nfs4_async_handle_error(struct rpc_task
 				break;
 			nfs4_schedule_stateid_recovery(server, state);
 			goto wait_on_recovery;
+		case -NFS4ERR_EXPIRED:
+			if (state != NULL)
+				nfs4_schedule_stateid_recovery(server, state);
 		case -NFS4ERR_STALE_STATEID:
 		case -NFS4ERR_STALE_CLIENTID:
-		case -NFS4ERR_EXPIRED:
 			nfs4_schedule_lease_recovery(clp);
 			goto wait_on_recovery;
 #if defined(CONFIG_NFS_V4_1)
@@ -4543,6 +4547,7 @@ int nfs4_lock_delegation_recall(struct n
 			case -ESTALE:
 				goto out;
 			case -NFS4ERR_EXPIRED:
+				nfs4_schedule_stateid_recovery(server, state);
 			case -NFS4ERR_STALE_CLIENTID:
 			case -NFS4ERR_STALE_STATEID:
 				nfs4_schedule_lease_recovery(server->nfs_client);


