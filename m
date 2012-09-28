Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030876Ab2I1TKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:10:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030765Ab2I1TGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:06:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 249/262] NFSd: set nfsd_serv to NULL after service destruction
Date: Fri, 28 Sep 2012 11:52:58 -0700
Message-Id: <20120928183027.866053213@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsbursky <skinsbursky@parallels.com>

commit 57c8b13e3cd0f94944c9691ce7f58e5fcef8a12d upstream.

In nfsd_destroy():

	if (destroy)
		svc_shutdown_net(nfsd_serv, net);
	svc_destroy(nfsd_server);

svc_shutdown_net(nfsd_serv, net) calls nfsd_last_thread(), which sets
nfsd_serv to NULL, causing a NULL dereference on the following line.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfsd.h   |    2 ++
 fs/nfsd/nfssvc.c |   10 +++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -80,6 +80,8 @@ static inline void nfsd_destroy(struct n
 	if (destroy)
 		svc_shutdown_net(nfsd_serv, net);
 	svc_destroy(nfsd_serv);
+	if (destroy)
+		nfsd_serv = NULL;
 }
 
 #if defined(CONFIG_NFSD_V2_ACL) || defined(CONFIG_NFSD_V3_ACL)
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -254,8 +254,6 @@ static void nfsd_shutdown(void)
 
 static void nfsd_last_thread(struct svc_serv *serv, struct net *net)
 {
-	/* When last nfsd thread exits we need to do some clean-up */
-	nfsd_serv = NULL;
 	nfsd_shutdown();
 
 	svc_rpcb_cleanup(serv, net);
@@ -332,6 +330,7 @@ static int nfsd_get_default_max_blksize(
 int nfsd_create_serv(void)
 {
 	int error;
+	struct net *net = current->nsproxy->net_ns;
 
 	WARN_ON(!mutex_is_locked(&nfsd_mutex));
 	if (nfsd_serv) {
@@ -346,7 +345,7 @@ int nfsd_create_serv(void)
 	if (nfsd_serv == NULL)
 		return -ENOMEM;
 
-	error = svc_bind(nfsd_serv, current->nsproxy->net_ns);
+	error = svc_bind(nfsd_serv, net);
 	if (error < 0) {
 		svc_destroy(nfsd_serv);
 		return error;
@@ -557,12 +556,13 @@ nfsd(void *vrqstp)
 	nfsdstats.th_cnt --;
 
 out:
-	if (rqstp->rq_server->sv_nrthreads == 1)
-		svc_shutdown_net(rqstp->rq_server, &init_net);
+	rqstp->rq_server = NULL;
 
 	/* Release the thread */
 	svc_exit_thread(rqstp);
 
+	nfsd_destroy(&init_net);
+
 	/* Release module */
 	mutex_unlock(&nfsd_mutex);
 	module_put_and_exit(0);


