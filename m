Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab3AIWBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 17:01:46 -0500
Received: from mail.kernel.org ([198.145.19.201]:41018 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932766Ab3AIUgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:36:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 20/47] NFS: avoid NULL dereference in nfs_destroy_server
Date: Wed,  9 Jan 2013 12:35:15 -0800
Message-Id: <20130109201731.834799774@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201729.435233560@linuxfoundation.org>
References: <20130109201729.435233560@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit f259613a1e4b44a0cf85a5dafd931be96ee7c9e5 upstream.

In rare circumstances, nfs_clone_server() of a v2 or v3 server can get
an error between setting server->destory (to nfs_destroy_server), and
calling nfs_start_lockd (which will set server->nlm_host).

If this happens, nfs_clone_server will call nfs_free_server which
will call nfs_destroy_server and thence nlmclnt_done(NULL).  This
causes the NULL to be dereferenced.

So add a guard to only call nlmclnt_done() if ->nlm_host is not NULL.

The other guards there are irrelevant as nlm_host can only be non-NULL
if one of these flags are set - so remove those tests.  (Thanks to Trond
for this suggestion).

This is suitable for any stable kernel since 2.6.25.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/client.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -673,8 +673,7 @@ static int nfs_create_rpc_client(struct
  */
 static void nfs_destroy_server(struct nfs_server *server)
 {
-	if (!(server->flags & NFS_MOUNT_LOCAL_FLOCK) ||
-			!(server->flags & NFS_MOUNT_LOCAL_FCNTL))
+	if (server->nlm_host)
 		nlmclnt_done(server->nlm_host);
 }
 


