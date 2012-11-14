Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab2KNF5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:57:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55222 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756400Ab2KNFu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:58 -0500
Message-Id: <20121114053939.826289935@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:16 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 43/82] NFS: Wait for session recovery to finish before returning
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4proc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -303,8 +303,7 @@ static int nfs4_handle_exception(struct
 			dprintk("%s ERROR: %d Reset session\n", __func__,
 				errorcode);
 			nfs4_schedule_session_recovery(clp->cl_session);
-			exception->retry = 1;
-			break;
+			goto wait_on_recovery;
 #endif /* defined(CONFIG_NFS_V4_1) */
 		case -NFS4ERR_FILE_OPEN:
 			if (exception->timeout > HZ) {


