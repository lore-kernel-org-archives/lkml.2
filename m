Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966190Ab2C3V3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:29:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966088Ab2C3VWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:22:00 -0400
Message-Id: <20120330194846.086053783@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Miklos Szeredi <miklos@szeredi.hu>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 103/175] NFSv4: Return the delegation if the server returns NFS4ERR_OPENMODE
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 3114ea7a24d3264c090556a2444fc6d2c06176d4 upstream.

If a setattr() fails because of an NFS4ERR_OPENMODE error, it is
probably due to us holding a read delegation. Ensure that the
recovery routines return that delegation in this case.

Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4_fs.h  |    1 +
 fs/nfs/nfs4proc.c |   13 ++++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -193,6 +193,7 @@ struct nfs4_exception {
 	long timeout;
 	int retry;
 	struct nfs4_state *state;
+	struct inode *inode;
 };
 
 struct nfs4_state_recovery_ops {
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -259,18 +259,28 @@ static int nfs4_handle_exception(struct
 {
 	struct nfs_client *clp = server->nfs_client;
 	struct nfs4_state *state = exception->state;
+	struct inode *inode = exception->inode;
 	int ret = errorcode;
 
 	exception->retry = 0;
 	switch(errorcode) {
 		case 0:
 			return 0;
+		case -NFS4ERR_OPENMODE:
+			if (nfs_have_delegation(inode, FMODE_READ)) {
+				nfs_inode_return_delegation(inode);
+				exception->retry = 1;
+				return 0;
+			}
+			if (state == NULL)
+				break;
+			nfs4_schedule_stateid_recovery(server, state);
+			goto wait_on_recovery;
 		case -NFS4ERR_DELEG_REVOKED:
 		case -NFS4ERR_ADMIN_REVOKED:
 		case -NFS4ERR_BAD_STATEID:
 			if (state != NULL)
 				nfs_remove_bad_delegation(state->inode);
-		case -NFS4ERR_OPENMODE:
 			if (state == NULL)
 				break;
 			nfs4_schedule_stateid_recovery(server, state);
@@ -1908,6 +1918,7 @@ static int nfs4_do_setattr(struct inode
 	struct nfs_server *server = NFS_SERVER(inode);
 	struct nfs4_exception exception = {
 		.state = state,
+		.inode = inode,
 	};
 	int err;
 	do {


