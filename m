Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab2I1Ujy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:39:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51950 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759404Ab2I1Ujr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:39:47 -0400
X-Sasl-enc: l662T888Xybx6oc+IVkqevVck2cJpBmFMlbHLnA4Qnjx 1348864786
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 206/218] NFSd: introduce nfsd_destroy() helper
Date: Fri, 28 Sep 2012 13:17:03 -0700
Message-Id: <20120928201525.229154147@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsbursky <skinsbursky@parallels.com>

commit 19f7e2ca44dfc3c1b3f499fc46801f98d403500f upstream.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfsctl.c |    8 ++------
 fs/nfsd/nfsd.h   |    9 +++++++++
 fs/nfsd/nfssvc.c |   14 +++-----------
 3 files changed, 14 insertions(+), 17 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -663,9 +663,7 @@ static ssize_t __write_ports_addfd(char
 
 	err = svc_addsock(nfsd_serv, fd, buf, SIMPLE_TRANSACTION_LIMIT);
 	if (err < 0) {
-		if (nfsd_serv->sv_nrthreads == 1)
-			svc_shutdown_net(nfsd_serv, net);
-		svc_destroy(nfsd_serv);
+		nfsd_destroy(net);
 		return err;
 	}
 
@@ -734,9 +732,7 @@ out_close:
 		svc_xprt_put(xprt);
 	}
 out_err:
-	if (nfsd_serv->sv_nrthreads == 1)
-		svc_shutdown_net(nfsd_serv, net);
-	svc_destroy(nfsd_serv);
+	nfsd_destroy(net);
 	return err;
 }
 
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -73,6 +73,15 @@ int		nfsd_nrpools(void);
 int		nfsd_get_nrthreads(int n, int *);
 int		nfsd_set_nrthreads(int n, int *);
 
+static inline void nfsd_destroy(struct net *net)
+{
+	int destroy = (nfsd_serv->sv_nrthreads == 1);
+
+	if (destroy)
+		svc_shutdown_net(nfsd_serv, net);
+	svc_destroy(nfsd_serv);
+}
+
 #if defined(CONFIG_NFSD_V2_ACL) || defined(CONFIG_NFSD_V3_ACL)
 #ifdef CONFIG_NFSD_V2_ACL
 extern struct svc_version nfsd_acl_version2;
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -427,11 +427,7 @@ int nfsd_set_nrthreads(int n, int *nthre
 		if (err)
 			break;
 	}
-
-	if (nfsd_serv->sv_nrthreads == 1)
-		svc_shutdown_net(nfsd_serv, net);
-	svc_destroy(nfsd_serv);
-
+	nfsd_destroy(net);
 	return err;
 }
 
@@ -478,9 +474,7 @@ out_shutdown:
 	if (error < 0 && !nfsd_up_before)
 		nfsd_shutdown();
 out_destroy:
-	if (nfsd_serv->sv_nrthreads == 1)
-		svc_shutdown_net(nfsd_serv, net);
-	svc_destroy(nfsd_serv);		/* Release server */
+	nfsd_destroy(net);		/* Release server */
 out:
 	mutex_unlock(&nfsd_mutex);
 	return error;
@@ -682,9 +676,7 @@ int nfsd_pool_stats_release(struct inode
 
 	mutex_lock(&nfsd_mutex);
 	/* this function really, really should have been called svc_put() */
-	if (nfsd_serv->sv_nrthreads == 1)
-		svc_shutdown_net(nfsd_serv, net);
-	svc_destroy(nfsd_serv);
+	nfsd_destroy(net);
 	mutex_unlock(&nfsd_mutex);
 	return ret;
 }


