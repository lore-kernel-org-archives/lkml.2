Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162273Ab2GLWpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:45:01 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:33763 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162192Ab2GLWow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:44:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 160/187] NFS: hard-code init_net for NFS callback transports
Date: Thu, 12 Jul 2012 15:35:16 -0700
Message-Id: <20120712191538.185903641@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Stanislav Kinsbursky <skinsbursky@parallels.com>

upstream commit 12918b10d59e975fd5241eef03ef9e6d5ea3dcfe.

In case of destroying mount namespace on child reaper exit, nsproxy is zeroed
to the point already. So, dereferencing of it is invalid.
This patch hard-code "init_net" for all network namespace references for NFS
callback services. This will be fixed with proper NFS callback
containerization.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/callback.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -17,7 +17,6 @@
 #include <linux/kthread.h>
 #include <linux/sunrpc/svcauth_gss.h>
 #include <linux/sunrpc/bc_xprt.h>
-#include <linux/nsproxy.h>
 
 #include <net/inet_sock.h>
 
@@ -107,7 +106,7 @@ nfs4_callback_up(struct svc_serv *serv,
 {
 	int ret;
 
-	ret = svc_create_xprt(serv, "tcp", xprt->xprt_net, PF_INET,
+	ret = svc_create_xprt(serv, "tcp", &init_net, PF_INET,
 				nfs_callback_set_tcpport, SVC_SOCK_ANONYMOUS);
 	if (ret <= 0)
 		goto out_err;
@@ -115,7 +114,7 @@ nfs4_callback_up(struct svc_serv *serv,
 	dprintk("NFS: Callback listener port = %u (af %u)\n",
 			nfs_callback_tcpport, PF_INET);
 
-	ret = svc_create_xprt(serv, "tcp", xprt->xprt_net, PF_INET6,
+	ret = svc_create_xprt(serv, "tcp", &init_net, PF_INET6,
 				nfs_callback_set_tcpport, SVC_SOCK_ANONYMOUS);
 	if (ret > 0) {
 		nfs_callback_tcpport6 = ret;
@@ -184,7 +183,7 @@ nfs41_callback_up(struct svc_serv *serv,
 	 * fore channel connection.
 	 * Returns the input port (0) and sets the svc_serv bc_xprt on success
 	 */
-	ret = svc_create_xprt(serv, "tcp-bc", xprt->xprt_net, PF_INET, 0,
+	ret = svc_create_xprt(serv, "tcp-bc", &init_net, PF_INET, 0,
 			      SVC_SOCK_ANONYMOUS);
 	if (ret < 0) {
 		rqstp = ERR_PTR(ret);
@@ -254,7 +253,7 @@ int nfs_callback_up(u32 minorversion, st
 	char svc_name[12];
 	int ret = 0;
 	int minorversion_setup;
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = &init_net;
 
 	mutex_lock(&nfs_callback_mutex);
 	if (cb_info->users++ || cb_info->task != NULL) {
@@ -330,7 +329,7 @@ void nfs_callback_down(int minorversion)
 	cb_info->users--;
 	if (cb_info->users == 0 && cb_info->task != NULL) {
 		kthread_stop(cb_info->task);
-		svc_shutdown_net(cb_info->serv, current->nsproxy->net_ns);
+		svc_shutdown_net(cb_info->serv, &init_net);
 		svc_exit_thread(cb_info->rqst);
 		cb_info->serv = NULL;
 		cb_info->rqst = NULL;


