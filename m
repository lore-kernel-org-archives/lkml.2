Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab2KVWIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:08:48 -0500
Received: from mail.kernel.org ([198.145.19.201]:49627 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab2KVSkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 31/38] NFS: Wait for session recovery to finish before returning
Date: Wed, 21 Nov 2012 16:40:14 -0800
Message-Id: <20121122003907.735774129@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122003904.262382971@linuxfoundation.org>
References: <20121122003904.262382971@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -300,8 +300,7 @@ static int nfs4_handle_exception(struct
 			dprintk("%s ERROR: %d Reset session\n", __func__,
 				errorcode);
 			nfs4_schedule_session_recovery(clp->cl_session);
-			exception->retry = 1;
-			break;
+			goto wait_on_recovery;
 #endif /* defined(CONFIG_NFS_V4_1) */
 		case -NFS4ERR_FILE_OPEN:
 			if (exception->timeout > HZ) {


