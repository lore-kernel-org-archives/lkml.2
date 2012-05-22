Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab2EVUcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 16:32:54 -0400
Received: from mx2.netapp.com ([216.240.18.37]:38955 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921Ab2EVUcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 16:32:52 -0400
X-IronPort-AV: E=Sophos;i="4.75,640,1330934400"; 
   d="scan'208";a="649546604"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH] NFS: init client before declaration
Thread-Topic: [PATCH] NFS: init client before declaration
Thread-Index: AQHNOBgchN+45TnxmEuX3jdeWgHLc5bWU9EAgAAIiACAAAgtgIAABjUAgAAHbgCAAAb8AIAAQCGA
Date: Tue, 22 May 2012 20:32:51 +0000
Message-ID: <1337718771.4269.29.camel@lade.trondhjem.org>
References: <20120522124018.338.20817.stgit@localhost.localdomain>
	 <1337696984.4269.4.camel@lade.trondhjem.org>
	 <1337698816.4269.15.camel@lade.trondhjem.org>
	 <4FBBB0DB.6050708@parallels.com>
	 <1337701904.4269.16.camel@lade.trondhjem.org>
	 <4FBBBC4C.5010103@parallels.com>
	 <1337705000.4269.23.camel@lade.trondhjem.org>
In-Reply-To: <1337705000.4269.23.camel@lade.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E62AFCB2BB9D643B62F15DC0E480065@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4MKX2jE019768

On Tue, 2012-05-22 at 12:43 -0400, Trond Myklebust wrote:
> On Tue, 2012-05-22 at 20:18 +0400, Stanislav Kinsbursky wrote:
> > We have another problem here.
> > nfs4_init_client() will try to create pipe dentries prior to set of NFS_CS_READY 
> > to the client. And dentries will be created since semaphore is dropped and 
> > per-net superblock variable is initialized already.
> > But __rpc_pipefs_event() relays on the fact, that no dentries present.
> > Looks like the problem was introduced by me in aad9487c...
> > So maybe we should not call "continue" instead "__rpc_pipefs_event()", when 
> > client becomes ready?
> > Looks like this will allow us to handle such races.
> 
> Let me rework this patch a bit...

The following is ugly, but it should be demonstrably correct, and will
ensure that __rpc_pipefs_event() will only be called for fully
initialised nfs_clients...

8<---------------------------------------------------------------------
>From 90c3b9fe9faeae32c8f629e8b6cbf5f50bb9b295 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Tue, 22 May 2012 16:22:50 -0400
Subject: [PATCH 1/2] NFSv4: Fix a race in the net namespace mount
 notification

Since the struct nfs_client gets added to the global nfs_client_list
before it is initialised, it is possible that rpc_pipefs_event can
end up trying to create idmapper entries on such a thing.

The solution is to have the mount notification wait for the
initialisation of each nfs_client to complete, and then to
skip any entries for which the it failed.

Reported-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/client.c   |   10 ++++++++++
 fs/nfs/idmap.c    |   15 +++++++++++++++
 fs/nfs/internal.h |    1 +
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 60f7e4e..d3c8553 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -583,6 +583,16 @@ found_client:
 	return clp;
 }
 
+static bool nfs_client_ready(const struct nfs_client *clp)
+{
+	return clp->cl_cons_state <= NFS_CS_READY;
+}
+
+int nfs_wait_client_ready(const struct nfs_client *clp)
+{
+	return wait_event_killable(nfs_client_active_wq, nfs_client_ready(clp));
+}
+
 /*
  * Mark a server as ready or failed
  */
diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
index 3e8edbe..c0753c5 100644
--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -530,9 +530,24 @@ static struct nfs_client *nfs_get_client_for_event(struct net *net, int event)
 	struct nfs_net *nn = net_generic(net, nfs_net_id);
 	struct dentry *cl_dentry;
 	struct nfs_client *clp;
+	int err;
 
+restart:
 	spin_lock(&nn->nfs_client_lock);
 	list_for_each_entry(clp, &nn->nfs_client_list, cl_share_link) {
+		/* Wait for initialisation to finish */
+		if (clp->cl_cons_state > NFS_CS_READY) {
+			atomic_inc(&clp->cl_count);
+			spin_unlock(&nn->nfs_client_lock);
+			err = nfs_wait_client_ready(clp);
+			nfs_put_client(clp);
+			if (err)
+				return NULL;
+			goto restart;
+		}
+		/* Skip nfs_clients that failed to initialise */
+		if (clp->cl_cons_state < 0)
+			continue;
 		if (clp->rpc_ops != &nfs_v4_clientops)
 			continue;
 		cl_dentry = clp->cl_idmap->idmap_pipe->dentry;
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index b777bda..3ee4040 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -168,6 +168,7 @@ extern struct nfs_server *nfs_clone_server(struct nfs_server *,
 					   struct nfs_fattr *,
 					   rpc_authflavor_t);
 extern void nfs_mark_client_ready(struct nfs_client *clp, int state);
+extern int nfs_wait_client_ready(const struct nfs_client *clp);
 extern int nfs4_check_client_ready(struct nfs_client *clp);
 extern struct nfs_client *nfs4_set_ds_client(struct nfs_client* mds_clp,
 					     const struct sockaddr *ds_addr,
-- 
1.7.7.6


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
