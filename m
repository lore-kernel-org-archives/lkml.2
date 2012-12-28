Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab2L1Trm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:47:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55172 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754656Ab2L1TSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:01 -0500
Message-Id: <20121228190356.817518151@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 128/173] NFS: avoid NULL dereference in nfs_destroy_server
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/client.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index c285e0a..9f3c664 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -615,8 +615,7 @@ EXPORT_SYMBOL_GPL(nfs_create_rpc_client);
  */
 static void nfs_destroy_server(struct nfs_server *server)
 {
-	if (!(server->flags & NFS_MOUNT_LOCAL_FLOCK) ||
-			!(server->flags & NFS_MOUNT_LOCAL_FCNTL))
+	if (server->nlm_host)
 		nlmclnt_done(server->nlm_host);
 }
 


